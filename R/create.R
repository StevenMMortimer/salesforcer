#' Create Records
#' 
#' Adds one or more new records to your organization’s data.
#' 
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into a \code{data.frame}
#' @template object_name
#' @template all_or_none
#' @template api_type
#' @param ... Other arguments passed on to \code{\link{sf_bulk_operation}}.
#' @template verbose
#' @return \code{tbl_df} of records with success indicator
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_contacts_result <- sf_create(new_contacts, object_name="Contact")
#' new_contacts_result <- sf_create(new_contacts, object_name="Contact", api_type="REST")
#' }
#' @export
sf_create <- function(input_data,
                      object_name,
                      all_or_none = FALSE,
                      api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                      ...,
                      verbose = FALSE){
  
  api_type <- match.arg(api_type)
  if(api_type == "REST"){
    resultset <- sf_create_rest(input_data=input_data,
                                object_name=object_name,
                                all_or_none=all_or_none, 
                                verbose=verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_create_soap(input_data=input_data,
                                object_name=object_name,
                                all_or_none=all_or_none, 
                                verbose=verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_create_bulk_v1(input_data, object_name = object_name, verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_create_bulk_v2(input_data, object_name = object_name, verbose = verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}


#' Create Records using SOAP API
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
sf_create_soap <- function(input_data, object_name, all_or_none = FALSE,
                           verbose = FALSE){
  
  input_data <- sf_input_data_validation(operation='create', input_data)
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size  
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
    batched_data <- input_data[batch_id == batch, , drop=FALSE]  
    r <- make_soap_xml_skeleton(soap_headers=list(AllorNoneHeader = tolower(all_or_none)))
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "create",
                                        object_name = object_name,
                                        root = r)
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="create",
                                       "Content-Type"="text/xml"),
                           body = as(xml_dat, "character"))
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


#' Create Records using REST API
#' 
#' @importFrom readr cols type_convert
#' @importFrom dplyr everything as_tibble bind_rows select
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_rest <- function(input_data, object_name, all_or_none = FALSE,
                           verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  input_data <- sf_input_data_validation(operation='create', input_data)
  # add attributes to insert multiple records at a time
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections.htm?search_text=update%20multiple
  input_data$attributes <- lapply(1:nrow(input_data), FUN=function(x, obj){list(type=obj, referenceId=paste0("ref" ,x))}, obj=object_name)
  #input_data$attributes <- list(rep(list(type=object_name), nrow(input_data)))[[1]]
  input_data <- input_data %>% select(attributes, everything())
  
  composite_url <- make_composite_url()
  if(verbose){
    message(composite_url)
  }
  
  # this type of request can only handle 200 records at a time
  batch_size <- 200
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) {
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
    batched_data <- input_data[batch_id == batch, , drop=FALSE]
    httr_response <- rPOST(url = composite_url,
                           headers = c("Accept"="application/json", 
                                       "Content-Type"="application/json"),
                           body = toJSON(list(allOrNone = tolower(all_or_none), 
                                              records = batched_data), 
                                         auto_unbox = TRUE))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    resultset <- bind_rows(resultset, fromJSON(response_parsed))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    type_convert(col_types = cols())
  return(resultset)
}


#' Create Records using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_bulk_v1 <- function(input_data, object_name, all_or_none = FALSE,
                              ...,
                              verbose = FALSE){
  # allor none?
  input_data <- sf_input_data_validation(operation="create", input_data)
  resultset <- sf_bulk_operation(input_data=input_data, 
                                 object_name=object_name, 
                                 operation="insert", 
                                 api_type = "Bulk 1.0",
                                 verbose=verbose, ...)
  return(resultset)
}


#' Create Records using Bulk 2.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_bulk_v2 <- function(input_data, object_name, all_or_none = FALSE,
                              ...,
                              verbose = FALSE){
  # allor none?
  #The order of records in the response is not guaranteed to match the ordering of records in the original job data.
  input_data <- sf_input_data_validation(operation="create", input_data)
  resultset <- sf_bulk_operation(input_data=input_data, 
                                 object_name=object_name, 
                                 operation="insert", 
                                 api_type = "Bulk 2.0",
                                 verbose=verbose, ...)
  return(resultset)
}


