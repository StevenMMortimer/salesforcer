#' Upsert Records
#' 
#' Upserts one or more new records to your organization’s data.
#' 
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into a \code{data.frame}
#' @template object_name
#' @template external_id_fieldname
#' @template all_or_none
#' @template api_type
#' @param ... Other arguments passed on to \code{\link{sf_bulk_operation}}.
#' @template verbose
#' @return \code{tbl_df} of records with success indicator
#' @examples
#' \dontrun{
#' n <- 2
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact-Create-", 1:n),
#'                        My_External_Id__c=letters[1:n])
#' new_contacts_result <- sf_create(new_contacts, object_name="Contact")
#' 
#' upserted_contacts <- tibble(FirstName = rep("Test", n),
#'                             LastName = paste0("Contact-Upsert-", 1:n),
#'                             My_External_Id__c=letters[1:n])
#' new_record <- tibble(FirstName = "Test",
#'                      LastName = paste0("Contact-Upsert-", n+1),
#'                      My_External_Id__c=letters[n+1])
#' upserted_contacts <- bind_rows(upserted_contacts, new_record)
#' 
#' upserted_contacts_result1 <- sf_upsert(upserted_contacts, 
#'                                        object_name="Contact", 
#'                                        "My_External_Id__c")
#' }
#' @export
sf_upsert <- function(input_data,
                      object_name,
                      external_id_fieldname,
                      all_or_none = FALSE,
                      api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                      ...,
                      verbose = FALSE){
  
  api_type <- match.arg(api_type)
  if(api_type == "REST"){
    resultset <- sf_upsert_rest(input_data=input_data, object_name=object_name,
                                external_id_fieldname=external_id_fieldname,
                                all_or_none=all_or_none, verbose=verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_upsert_soap(input_data=input_data, object_name=object_name,
                                external_id_fieldname=external_id_fieldname,
                                all_or_none=all_or_none, verbose=verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_upsert_bulk_v1(input_data=input_data, object_name=object_name,
                                   external_id_fieldname=external_id_fieldname,
                                   verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_upsert_bulk_v2(input_data=input_data, object_name=object_name,
                                   external_id_fieldname=external_id_fieldname,
                                   verbose = verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}


#' Upsert Records using SOAP API
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
sf_upsert_soap <- function(input_data, object_name, 
                           external_id_fieldname,
                           all_or_none = FALSE,
                           verbose = FALSE){
  
  input_data <- sf_input_data_validation(operation='upsert', input_data)
  
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
                                        operation = "upsert",
                                        object_name = object_name,
                                        external_id_fieldname = external_id_fieldname,
                                        root = r)
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="upsert",
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


#' Upsert Records using REST API
#' 
#' @importFrom readr cols type_convert
#' @importFrom dplyr everything as_tibble bind_rows select
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_upsert_rest <- function(input_data, object_name, 
                           external_id_fieldname,
                           all_or_none = FALSE,
                           verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  input_data <- sf_input_data_validation(operation='upsert', input_data)
  
  composite_batch_url <- make_composite_batch_url()
  if(verbose) {
    message(composite_batch_url)
  }
  
  # limit this type of request to only 25 records, the max for this type of request
  batch_size <- 25
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
    inner_requests <- list()
    for(i in 1:nrow(batched_data)){
      this_id <- batched_data[i, external_id_fieldname]
      temp_batched_data <- batched_data[,-(which(names(batched_data) == external_id_fieldname))]
      temp_batched_data <- temp_batched_data[,!grepl("^ID$|^IDS$", names(temp_batched_data), ignore.case=TRUE)]
      inner_requests[[i]] <- list(method="PATCH", 
                                  url=paste0("v", getOption("salesforcer.api_version"), 
                                             "/sobjects/", object_name, "/", 
                                             external_id_fieldname, "/", this_id), 
                                  richInput=as.list(temp_batched_data[i,]))
    }
    request_body <- list(batchRequests=inner_requests)
    httr_response <- rPOST(url = composite_batch_url,
                           headers = c("Accept"="application/json", 
                                       "Content-Type"="application/json"),
                           body = toJSON(request_body,
                                         auto_unbox = TRUE))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    response_parsed <- fromJSON(response_parsed, flatten=TRUE)$results
    response_parsed <- response_parsed %>%
      rename_at(.vars = vars(starts_with("result.")), 
                .funs = funs(sub("^result\\.", "", .))) %>%
      select(-matches("statusCode")) %>%
      as_tibble()
    resultset <- bind_rows(resultset, response_parsed)
  }
  resultset <- resultset %>%
    type_convert(col_types = cols())
  return(resultset)
} 
  

#' Upsert Records using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_upsert_bulk_v1 <- function(input_data, object_name, 
                              external_id_fieldname,
                              all_or_none = FALSE,
                              ...,
                              verbose = FALSE){
  # allor none?
  input_data <- sf_input_data_validation(operation="upsert", input_data)
  resultset <- sf_bulk_operation(input_data=input_data, 
                                 object_name=object_name,
                                 external_id_fieldname=external_id_fieldname,
                                 operation="upsert", 
                                 api_type = "Bulk 1.0",
                                 verbose=verbose, ...)
  return(resultset)
}


#' Upsert Records using Bulk 2.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_upsert_bulk_v2 <- function(input_data, object_name, 
                              external_id_fieldname,
                              all_or_none = FALSE,
                              ...,
                              verbose = FALSE){
  # allor none?
  #The order of records in the response is not guaranteed to match the ordering of records in the original job data.
  input_data <- sf_input_data_validation(operation='upsert', input_data)
  resultset <- sf_bulk_operation(input_data=input_data, 
                                 object_name=object_name,
                                 external_id_fieldname=external_id_fieldname,
                                 operation="upsert", 
                                 api_type = "Bulk 2.0",
                                 verbose=verbose, ...)
  return(resultset)
}
