#' Delete Records
#' 
#' Deletes one or more records from your organization’s data.
#' 
#' @importFrom httr content
#' @importFrom readr type_convert cols
#' @importFrom dplyr bind_rows as_tibble
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
#' @template object_name
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
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
                      object_name,
                      api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                      control = list(...), ...,
                      verbose = FALSE){

  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "delete"
  if("all_or_none" %in% names(all_args)){
    # warn then set it in the control list
    warning(paste0("The `all_or_none` argument has been deprecated.\n", 
                   "Please pass AllOrNoneHeader argument or use the `sf_control` function."), 
            call. = FALSE)
    control_args$AllOrNoneHeader = list(allOrNone = tolower(all_args$all_or_none))
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_delete_soap(ids = ids, 
                                object_name = object_name,
                                control = control_args,
                                verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_delete_rest(ids = ids, 
                                object_name = object_name,
                                control = control_args,
                                verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_delete_bulk_v1(ids = ids, 
                                   object_name = object_name, 
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_delete_bulk_v2(ids=ids, 
                                   object_name = object_name, 
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else {
    stop("Unknown API type.")
  }
  return(resultset)
}

sf_delete_soap <- function(ids, 
                           object_name,
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
  resultset <- NULL
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
    response_parsed <- content(httr_response, encoding="UTF-8")
    this_set <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>%
      map_df(xml_nodeset_to_df)
    resultset <- bind_rows(resultset, this_set)
  }
  resultset <- resultset %>%
    type_convert(col_types = cols())
  return(resultset)
}

sf_delete_rest <- function(ids, 
                           object_name,
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
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    resultset <- bind_rows(resultset, fromJSON(response_parsed))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    type_convert(col_types = cols())
  return(resultset)
}

sf_delete_bulk_v1 <- function(ids, 
                              object_name,
                              control, ...,
                              verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation = 'delete')
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = ids, 
                                 object_name = object_name,
                                 operation = "delete",
                                 api_type = "Bulk 1.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)  
}

sf_delete_bulk_v2 <- function(ids, 
                              object_name,
                              control, ...,
                              verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation = 'delete')  
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = ids, 
                                 object_name = object_name, 
                                 operation = "delete", 
                                 api_type = "Bulk 2.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}
