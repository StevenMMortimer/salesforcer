#' Retrieve Records By Id
#' 
#' @description
#' `r lifecycle::badge("stable")`
#' 
#' Retrieves one or more new records to your organization’s data.
#' 
#' @template ids
#' @param fields \code{character}; one or more strings indicating the fields to be returned 
#' on the records
#' @template object_name
#' @template api_type
#' @template guess_types
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_contacts_result <- sf_create(new_contacts, object_name="Contact")
#' retrieved_records <- sf_retrieve(ids=new_contacts_result$id,
#'                                  fields=c("LastName"),
#'                                  object_name="Contact")
#' }
#' @export
sf_retrieve <- function(ids,
                        fields,
                        object_name,
                        api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                        guess_types = TRUE,
                        control = list(...), ...,
                        verbose = FALSE){
  
  api_type <- match.arg(api_type)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "retrieve"
  if(api_type == "REST"){
    resultset <- sf_retrieve_rest(ids = ids, 
                                  fields = fields, 
                                  object_name = object_name,
                                  guess_types = guess_types,
                                  control = control_args, ...,
                                  verbose = verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_retrieve_soap(ids = ids, 
                                  fields = fields, 
                                  object_name = object_name,
                                  guess_types = guess_types,
                                  control = control_args, ...,
                                  verbose = verbose) 
  } else if(api_type %in% c("Bulk 1.0", "Bulk 2.0")){
    stop(paste0("The retrieve method is not supported in the Bulk 1.0 or Bulk 2.0 ", 
                "APIs. For retrieving a large number of records use SOQL (queries) ", 
                "instead."), call. = FALSE)
  } else {
    catch_unknown_api(api_type, c("SOAP", "REST"))
  }
  return(resultset)
}

#' Retrieve records using SOAP API
#' 
 
#' @importFrom dplyr bind_rows filter if_all any_of
#' @importFrom httr content
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @importFrom xml2 xml_ns_strip xml_find_all 
#' @importFrom utils head 
#' @importFrom stats quantile
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_retrieve_soap <- function(ids,
                             fields,
                             object_name,
                             guess_types = TRUE,
                             control, ...,
                             verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='retrieve')
  control <- do.call("sf_control", control)
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id)+1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  base_soap_url <- make_base_soap_url()
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
                                        operation = "retrieve",
                                        object_name = object_name,
                                        fields = fields,
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="retrieve",
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
      map_df(extract_records_from_xml_node, 
             object_name_as_col = TRUE) %>% 
      # ignore record ids that could not be matched
      filter(if_all(any_of("Id"), ~!is.na(.x)))
    resultset <- safe_bind_rows(list(resultset, this_set))
  }
  
  resultset <- resultset %>% 
    sf_reorder_cols() %>% 
    sf_guess_cols(guess_types)
  
  return(resultset)
}

#' Retrieve records using REST API
#' 
#' @importFrom dplyr select any_of
#' @importFrom httr content
#' @importFrom readr type_convert cols col_guess
#' @importFrom utils head 
#' @importFrom stats quantile 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_retrieve_rest <- function(ids,
                             fields,
                             object_name,
                             guess_types = TRUE,
                             control, ...,
                             verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='retrieve')
  
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections_retrieve.htm?search_text=retrieve%20multiple
  # this type of request can only handle 2000 records at a time, but setting 
  # 1000 just to be cautiuos because size of data for an individual record may cause issues
  batch_size <- 1000
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id)+1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  composite_url <- paste0(make_composite_url(), "/", object_name)
  if(verbose) message(composite_url)
  
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]
    request_body <- list(ids = I(batched_data$Id), fields = I(fields))
    httr_response <- rPOST(url = composite_url,
                           headers = c("Accept"="application/json", 
                                       "Content-Type"="application/json"),
                           body = request_body, 
                           encode = "json")
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    resultset <- c(resultset, response_parsed)
  }
  
  resultset <- resultset %>%
    drop_attributes_recursively(object_name_as_col = TRUE) %>% 
    map_df(flatten_tbl_df) %>%
    sf_reorder_cols() %>% 
    sf_guess_cols(guess_types)
  
  return(resultset)
}
