#' Update Records
#' 
#' Updates one or more new records to your organization’s data.
#' 
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @importFrom dplyr select as_tibble everything
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into a \code{data.frame} and there must be 
#' a column called Id (case-insensitive) that can be passed in the request
#' @template object_name
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
#' new_contacts_result <- sf_create(new_contacts, "Contact")
#' 
#' update_contacts <- tibble(FirstName = rep("TestTest", n),
#'                           LastName = paste0("Contact", 1:n), 
#'                           Id = new_contacts_result$id)
#' updated_contacts_result1 <- sf_update(update_contacts, "Contact")
#' updated_contacts_result2 <- sf_update(update_contacts, "Contact", 
#'                                       api_type="Bulk")                          
#' }
#' @export
sf_update <- function(input_data,
                      object_name,
                      all_or_none = FALSE,
                      api_type = c("SOAP", "Rest", "Bulk"),
                      ...,
                      verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  
  # check that the input data is named (we need to know the fields)
  stopifnot(!is.null(names(input_data)))
  which_api <- match.arg(api_type)
  input_data <- sf_input_data_validation(operation='update', input_data)
  
  # REST implementation
  if(which_api == "REST"){
    
    # add attributes to insert multiple records at a time
    # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections.htm?search_text=update%20multiple
    # this type of request can only handle 200 records at a time
    batch_size <- 200
    input_data$attributes <- lapply(1:nrow(input_data), FUN=function(x, obj){list(type=obj, referenceId=paste0("ref" ,x))}, obj=object_name)
    #input_data$attributes <- list(rep(list(type=object_name), nrow(input_data)))[[1]]
    input_data <- input_data %>% select(attributes, everything())
    composite_url <- make_composite_url()
    
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
      if(verbose) message(composite_url)
      httr_response <- rPATCH(url = composite_url,
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json"),
                             body = toJSON(list(allOrNone=tolower(all_or_none), 
                                                records=temp), 
                                           auto_unbox = TRUE))
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
                                          operation = "update",
                                          object_name = object_name,
                                          root=r)
      if(verbose) {
        message(base_soap_url)
      }
      httr_response <- rPOST(url = base_soap_url,
                             headers = c("SOAPAction"="update",
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
    resultset <- sf_bulk_operation(input_data, object_name = object_name, 
                                   operation = "update", verbose = verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}