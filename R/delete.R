#' Delete Records
#' 
#' @description
#' `r lifecycle::badge("stable")`
#' 
#' Deletes one or more records from your organization’s data.
#' 
#' @importFrom lifecycle deprecate_warn is_present deprecated
#' @importFrom httr content
#' @importFrom readr type_convert cols
#' @importFrom dplyr bind_rows as_tibble
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @template ids
#' @template object_name
#' @template api_type
#' @template guess_types
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
#' @template all_or_none
#' @template verbose
#' @return \code{tbl_df} of records with success indicator
#' @note Because the SOAP and REST calls chunk data into batches of 200 records 
#' the AllOrNoneHeader will only apply to the success or failure of every batch 
#' of records and not all records submitted to the function.
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_records <- sf_create(new_contacts, object_name="Contact")
#' deleted_first <- sf_delete(new_records$id[1], object_name = "Contact")  
#' 
#' # add the control to do an "All or None" deletion of the remaining records
#' deleted_rest <- sf_delete(new_records$id[2:3], object_name = "Contact", 
#'                           AllOrNoneHeader = list(allOrNone = TRUE))
#' }
#' @export
sf_delete <- function(ids,
                      object_name = NULL,
                      api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                      guess_types = TRUE,
                      control = list(...), ...,
                      all_or_none = deprecated(),
                      verbose = FALSE){

  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "delete"
  
  if(is_present(all_or_none)) {
    deprecate_warn("0.1.3", "salesforcer::sf_delete(all_or_none = )", 
                   "sf_delete(AllOrNoneHeader = )", 
                   details = paste0("You can pass the all or none header directly ", 
                                    "as shown above or via the `control` argument."))
    control_args$AllOrNoneHeader <- list(allOrNone = tolower(all_or_none))
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_delete_soap(ids = ids, 
                                object_name = object_name,
                                guess_types = guess_types,
                                control = control_args,
                                verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_delete_rest(ids = ids, 
                                object_name = object_name,
                                guess_types = guess_types,
                                control = control_args,
                                verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_delete_bulk_v1(ids = ids, 
                                   object_name = object_name, 
                                   guess_types = guess_types,
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_delete_bulk_v2(ids = ids, 
                                   object_name = object_name,
                                   guess_types = guess_types,
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else {
    catch_unknown_api(api_type)
  }
  return(resultset)
}


#' Delete records using SOAP API
#' 
#' @importFrom readr cols type_convert
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom dplyr bind_rows
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_delete_soap <- function(ids, 
                           object_name = NULL,
                           guess_types = TRUE,
                           control, ...,
                           verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='delete')
  control <- do.call("sf_control", control)
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  
  base_soap_url <- make_base_soap_url()
  if(verbose){
    message("Submitting data in ", max(batch_id)+1, " Batches")
  }
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  resultset <- tibble()
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]  
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "delete",
                                        object_name = object_name,
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="delete",
                                       "Content-Type"="text/xml"),
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    this_set <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>% 
      map_df(extract_records_from_xml_node)
    resultset <- safe_bind_rows(list(resultset, this_set))
  }
  
  resultset <- resultset %>% 
    sf_reorder_cols() %>% 
    sf_guess_cols(guess_types)
  
  return(resultset)
}

#' Delete records using REST API
#' 
#' @importFrom purrr map_df
#' @importFrom dplyr bind_rows
#' @importFrom readr cols type_convert col_guess
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_delete_rest <- function(ids, 
                           object_name = NULL,
                           guess_types = TRUE,
                           control, ...,
                           verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation='delete')
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    all_or_none <- control$AllOrNoneHeader$allOrNone
  } else {
    all_or_none <- FALSE
  }
  
  composite_url <- make_composite_url()
  # this type of request can only handle 200 records at a time
  # so break up larger datasets, batch the data
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]
    httr_response <- rDELETE(url = composite_url, 
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json"),
                             query = list(allOrNone = tolower(all_or_none), 
                                          ids = paste0(batched_data$Id, collapse=",")))
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    resultset <- c(resultset, response_parsed)
  }

  resultset <- resultset %>%
    map_df(flatten_tbl_df) %>%
    sf_reorder_cols() %>% 
    sf_guess_cols(guess_types)
  
  return(resultset)
}

#' Delete records using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_delete_bulk_v1 <- function(ids, 
                              object_name,
                              guess_types = TRUE,
                              control, ...,
                              verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation = 'delete')
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = ids, 
                                 object_name = object_name,
                                 guess_types = guess_types,
                                 operation = "delete",
                                 api_type = "Bulk 1.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)  
}

#' Delete records using Bulk 2.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_delete_bulk_v2 <- function(ids, 
                              object_name,
                              guess_types = TRUE,
                              control, ...,
                              verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation = 'delete')  
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = ids, 
                                 object_name = object_name, 
                                 guess_types = guess_types,
                                 operation = "delete", 
                                 api_type = "Bulk 2.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}
