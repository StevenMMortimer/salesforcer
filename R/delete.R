#' Delete Records
#' 
#' Deletes one or more records to your organization’s data.
#' 
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
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
#' new_contacts_result1 <- sf_create(new_contacts, object_name="Contact")
#' deleted_contacts_result1 <- sf_delete(new_contacts_result1$id, 
#'                                       object_name="Contact")   
#' 
#' new_contacts_result2 <- sf_create(new_contacts, "Contact")
#' deleted_contacts_result2 <- sf_delete(new_contacts_result2$id, 
#'                                       object_name="Contact", 
#'                                       api_type="Bulk")                             
#' }
#' @export
sf_delete <- function(ids,
                      object_name,
                      all_or_none = FALSE,
                      api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                      ...,
                      verbose = FALSE){

  api_type <- match.arg(api_type)
  if(api_type == "REST"){
    resultset <- sf_delete_rest(ids=ids, object_name=object_name,
                                all_or_none=all_or_none, verbose=verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_delete_soap(ids=ids, object_name=object_name,
                                all_or_none=all_or_none, verbose=verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_delete_bulk_v1(ids=ids, object_name=object_name, verbose=verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_delete_bulk_v2(ids=ids, object_name=object_name, verbose=verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}


sf_delete_soap <- function(ids, object_name, all_or_none = FALSE,
                           verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='delete')
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
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
    r <- make_soap_xml_skeleton(soap_headers=list(AllorNoneHeader = tolower(all_or_none)))
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "delete",
                                        object_name = object_name,
                                        root=r)
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="delete",
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

sf_delete_rest <- function(ids, object_name, all_or_none = FALSE,
                           verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='delete')
  
  composite_url <- make_composite_url()
  if(verbose) {
    message(composite_url)
  }
  
  # this type of request can only handle 200 records at a time
  # so break up larger datasets, batch the data
  batch_size <- 200
  row_num <- nrow(ids)
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
    batched_data <- ids[batch_id == batch, , drop=FALSE]
    httr_response <- rDELETE(url = composite_url, 
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json"),
                             query = list(allOrNone = tolower(all_or_none), 
                                          ids = paste0(batched_data$Id, collapse=",")))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    resultset <- bind_rows(resultset, fromJSON(response_parsed))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    type_convert(col_types = cols())
  return(resultset)
}

sf_delete_bulk_v1 <- function(ids, object_name,
                              ...,
                              verbose = FALSE){
  # allor none?
  ids <- sf_input_data_validation(ids, operation='delete')  
  resultset <- sf_bulk_operation(input_data=ids, object_name=object_name,
                                 operation="delete",
                                 api_type = "Bulk 1.0",
                                 verbose=verbose, ...)
  return(resultset)  
}

sf_delete_bulk_v2 <- function(ids, object_name,
                              ...,
                              verbose = FALSE){
  # allor none?
  ids <- sf_input_data_validation(ids, operation='delete')  
  resultset <- sf_bulk_operation(input_data=ids, object_name=object_name, 
                                 operation="delete", 
                                 api_type = "Bulk 2.0",
                                 verbose=verbose, ...)
  return(resultset)
}


