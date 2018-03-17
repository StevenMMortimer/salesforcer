#' Delete Records
#' 
#' Deletes one or more new records to your organization’s data.
#' 
#' @importFrom jsonlite fromJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @importFrom dplyr select_ as_tibble
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
#' @template object
#' @template all_or_none
#' @template api_type
#' @param ... Other arguments passed on to \code{\link{sf_bulk_operation}}.
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_contacts_result1 <- sf_create(new_contacts, "Contact")
#' deleted_contacts_result1 <- sf_delete(new_contacts_result1$id, 
#'                                       object="Contact")   
#' 
#' new_contacts_result2 <- sf_create(new_contacts, "Contact")
#' deleted_contacts_result2 <- sf_delete(new_contacts_result2$id, 
#'                                       object="Contact", 
#'                                       api_type="Bulk")                             
#' }
#' @export
sf_delete <- function(ids,
                      object,
                      all_or_none = FALSE,
                      api_type = c("REST", "SOAP", "Bulk"),
                      ...,
                      verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  
  which_api <- match.arg(api_type)
  ids <- sf_input_data_validation(ids, operation='delete')
  
  # REST implementation
  if(which_api == "REST"){

    # this type of request can only handle 200 records at a time
    batch_size <- 200
    composite_url <- make_composite_url()
    
    # break up larger datasets, batch the data
    row_num <- nrow(ids)
    batch_id <- (seq.int(row_num)-1) %/% batch_size
    
    if(verbose) message("Splitting data into ", max(batch_id)+1, " Batches")
    message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
    resultset <- NULL
    for(batch in seq(0, max(batch_id))){
      
      if(verbose){
        batch_msg_flg <- batch %in% message_flag
        if(batch_msg_flg){
          message(paste0("Processing Batch # ", head(batch, 1) + 1))
        } 
      }
      
      temp <- ids[batch_id == batch, , drop=FALSE]
      if(verbose) message(composite_url)
      httr_response <- rDELETE(url = composite_url, 
                               headers = c("Accept"="application/json; charset=UTF-8"),
                               query = list(allOrNone = tolower(all_or_none), 
                                            ids = paste0(temp$Id, collapse=",")))
      catch_errors(httr_response)
      response_parsed <- content(httr_response, "text", encoding="UTF-8")
      resultset <- bind_rows(resultset, fromJSON(response_parsed))
    }
    resultset <- as_tibble(resultset)
  } else if(which_api == "SOAP"){
    
    # limit this type of request to only 200 records at a time to prevent 
    # the XML from exceeding a size limit
    batch_size <- 200
    base_soap_url <- make_base_soap_url()
    
    # break up larger datasets, batch the data
    row_num <- nrow(ids)
    batch_id <- (seq.int(row_num)-1) %/% batch_size
    
    if(verbose) message("Splitting data into ", max(batch_id)+1, " Batches")
    message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
    resultset <- NULL
    for(batch in seq(0, max(batch_id))){
      
      if(verbose){
        batch_msg_flg <- batch %in% message_flag
        if(batch_msg_flg){
          message(paste0("Processing Batch # ", head(batch, 1) + 1))
        } 
      }
      
      temp <- ids[batch_id == batch, , drop=FALSE]  
      r <- make_soap_xml_skeleton()
      xml_dat <- build_soap_xml_from_list(input_data = temp,
                                          operation = "delete",
                                          object = object,
                                          root=r)
      if(verbose) {
        message(base_soap_url)
      }
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
    suppressWarnings(suppressMessages(resultset <- type_convert(resultset)))
  } else if(which_api == "Bulk"){
    resultset <- sf_bulk_operation(ids, object, operation="delete", verbose=verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}