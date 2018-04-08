#' Retrieve Records By Id
#' 
#' Retrieves one or more new records to your organization’s data.
#' 
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @importFrom dplyr select as_tibble everything
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
#' @param fields character; one or more strings indicating the fields to be returned 
#' on the records
#' @template object_name
#' @template api_type
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
                        api_type = c("REST", "SOAP", "Bulk"),
                        verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  
  which_api <- match.arg(api_type)
  ids <- sf_input_data_validation(ids, operation='retrieve')
  
  # REST implementation
  if(which_api == "REST"){
    
    # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections_retrieve.htm?search_text=retrieve%20multiple
    # this type of request can only handle 2000 records at a time
    batch_size <- 2000
    composite_url <- paste0(make_composite_url(), "/", object_name)
    
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
      httr_response <- rPOST(url = composite_url,
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json"),
                             body = toJSON(list(ids=ids$Id, 
                                                fields=fields),
                                           auto_unbox = FALSE))
      catch_errors(httr_response)
      response_parsed <- content(httr_response, "text", encoding="UTF-8")
      resultset <- bind_rows(resultset, fromJSON(response_parsed) %>% select_(.dots =  unique(c("Id", fields))))
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
                                          operation = "retrieve",
                                          object_name = object_name,
                                          fields = fields,
                                          root=r)
      if(verbose) {
        message(base_soap_url)
      }
      httr_response <- rPOST(url = base_soap_url,
                             headers = c("SOAPAction"="retrieve",
                                         "Content-Type"="text/xml"),
                             body = as(xml_dat, "character"))
      catch_errors(httr_response)
      response_parsed <- content(httr_response, encoding="UTF-8")
      this_set <- response_parsed %>%
        xml_ns_strip() %>%
        xml_find_all('.//result')
      if(length(this_set) > 0){
        suppressMessages(
          this_set <- this_set %>%
            map_df(xml_nodeset_to_df) %>%
            select(-matches("sf:type")) %>%
            rename_at(.vars = vars(starts_with("sf:")), 
                      .funs = funs(sub("^sf:", "", .))) %>%
            select(-matches("Id1"))
        )
      } else {
        this_set <- NULL
      }
      resultset <- bind_rows(resultset, this_set)
    }
    suppressWarnings(suppressMessages(resultset <- type_convert(resultset)))
  } else if(which_api == "Bulk"){
    stop("Retrieve is not supported in Bulk API. For retrieving a large number of records use SOQL (queries) instead.")
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}