#' Upsert Records
#' 
#' Upserts one or more new records to your organization’s data.
#' 
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @importFrom methods as
#' @importFrom purrr map_df
#' @importFrom readr type_convert
#' @importFrom dplyr as_tibble
#' @importFrom xml2 xml_find_first xml_find_all xml_ns_strip
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into a \code{data.frame} and there must be 
#' a column called Id (case-insensitive) that can be passed in the request
#' @template object
#' @template external_id_fieldname
#' @template all_or_none
#' @template api_type
#' @param ... Other arguments passed on to \code{\link{sf_bulk_operation}}.
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' n <- 2
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact-Create-", 1:n), 
#'                        My_External_Id__c=letters[1:n])
#' new_contacts_result <- sf_create(new_contacts, "Contact")
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
#'                                        "Contact", 
#'                                        "My_External_Id__c")
#' }
#' @export
sf_upsert <- function(input_data,
                      object,
                      external_id_fieldname,
                      all_or_none = FALSE,
                      api_type = c("SOAP", "REST", "Bulk", "Async"),
                      ...,
                      verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  # stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  
  # check that the input data is named (we need to know the fields)
  stopifnot(!is.null(names(input_data)))
  which_api <- match.arg(api_type)
  
  # SOAP implementation
  if(which_api == "SOAP"){
    
    if(!is.data.frame(input_data)){
      input_data <- as.data.frame(as.list(input_data), stringsAsFactors = FALSE)
    }
    # assume that there is an external id on this, no way to know for sure
    
    # add attributes to insert multiple records at a time
    # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections.htm?search_text=update%20multiple
    # this type of request can only handle 200 records at a time
    batch_size <- 200
    base_soap_url <- make_base_soap_url()
    
    # break up larger datasets, batch the data
    row_num <- nrow(input_data)
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
      
      temp <- input_data[batch_id == batch, , drop=FALSE]  
      r <- make_soap_xml_skeleton()
      xml_dat <- build_soap_xml_from_list(input_data = temp,
                                          operation = "upsert",
                                          object = object,
                                          external_id_fieldname = external_id_fieldname,
                                          root=r)
      if(verbose) {
        message(base_soap_url)
      }
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
    suppressWarnings(suppressMessages(resultset <- type_convert(resultset)))
  } else if(which_api == "Bulk"){
    resultset <- sf_bulk_operation(input_data, object, 
                                   operation="upsert", 
                                   external_id_fieldname = external_id_fieldname,
                                   verbose=verbose, ...)
  } else {
    stop("Queries using the REST and Aysnc APIs has not yet been implemented, use SOAP or Bulk")
  }
  
  return(resultset)
}