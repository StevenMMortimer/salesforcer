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
#' @template object
#' @param all_or_none logical; allows a call to roll back all changes unless all 
#' records are processed successfully.
#' @template api_type
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
                      object,
                      all_or_none = FALSE,
                      api_type = c("REST", "SOAP", "Bulk", "Async"),
                      verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  
  # check that the input data is named (we need to know the fields)
  stopifnot(!is.null(names(input_data)))
  which_api <- match.arg(api_type)
  
  # REST implementation
  if(which_api == "REST"){
    if(!is.data.frame(input_data)){
      input_data <- as.data.frame(as.list(input_data), stringsAsFactors = FALSE)
    }
    if(any(grepl("ID|Id", names(input_data), ignore.case=FALSE))){
      idx <- grep("ID|Id", names(input_data))
      names(input_data)[idx] <- "id"
    }
    stopifnot("id" %in% names(input_data))
    
    # add attributes to insert multiple records at a time
    # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections.htm?search_text=update%20multiple
    # this type of request can only handle 200 records at a time
    batch_size <- 200
    input_data$attributes <- lapply(1:nrow(input_data), FUN=function(x, obj){list(type=obj, referenceId=paste0("ref" ,x))}, obj=object)
    #input_data$attributes <- list(rep(list(type=object), nrow(input_data)))[[1]]
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
  } else if(which_api == "Bulk"){
    resultset <- sf_bulk_operation(input_data, object, operation="update", verbose=verbose)
  } else {
    stop("Queries using the SOAP and Aysnc APIs has not yet been implemented, use REST or Bulk")
  }
  
  return(resultset)
}