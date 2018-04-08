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
#' @template object_name
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
                      api_type = c("SOAP", "REST", "Bulk"),
                      ...,
                      verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  # stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  
  # check that the input data is named (we need to know the fields)
  stopifnot(!is.null(names(input_data)))
  which_api <- match.arg(api_type)
  input_data <- sf_input_data_validation(operation='upsert', input_data)
  
  # SOAP implementation
  if(which_api == "SOAP"){
    
    # limit this type of request to only 200 records at a time to prevent 
    # the XML from exceeding a size limit
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
      r <- make_soap_xml_skeleton(soap_headers=list(AllorNoneHeader = tolower(all_or_none)))
      xml_dat <- build_soap_xml_from_list(input_data = temp,
                                          operation = "upsert",
                                          object_name = object_name,
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
  } else if(which_api == "REST"){
    
    batch_size <- 25
    composite_batch_url <- make_composite_batch_url()
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
      inner_requests <- list()
      for(i in 1:nrow(temp)){
        this_id <- temp[i,external_id_fieldname]
        temptemp <- temp[,-(which(names(temp) == external_id_fieldname))]
        temptemp <- temptemp[,!grepl("^ID$|^IDS$", names(temptemp), ignore.case=TRUE)]
        inner_requests[[i]] <- list(method="PATCH", 
                                    url=paste0("v", getOption("salesforcer.api_version"), 
                                               "/sobjects/", object_name, "/", 
                                               external_id_fieldname, "/", this_id), 
                                    richInput=as.list(temptemp[i,]))
      }
      request_body <- list(batchRequests=inner_requests)
      
      if(verbose) message(composite_batch_url)
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
    suppressWarnings(suppressMessages(resultset <- type_convert(resultset)))
  } else if(which_api == "Bulk"){
    resultset <- sf_bulk_operation(input_data, 
                                   object_name = object_name, 
                                   operation = "upsert", 
                                   external_id_fieldname = external_id_fieldname,
                                   verbose=verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}