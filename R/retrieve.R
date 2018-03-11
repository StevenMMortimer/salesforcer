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
#' @template object
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_contacts_result <- sf_create(new_contacts, object="Contact")
#' retrieved_records <- sf_retrieve(ids=new_contacts_result$id,
#'                                  fields=c("LastName"),
#'                                  object="Contact")
#' }
#' @export
sf_retrieve <- function(ids,
                        fields,
                        object,
                        verbose = FALSE){
  
  which_api <- "REST"
  
  if(!is.data.frame(ids)){
    if(is.null(names(ids))){
      ids <- as.data.frame(list(ids), stringsAsFactors = FALSE)
      names(ids) <- "Id"
    } else {
      ids <- as.data.frame(as.list(ids), stringsAsFactors = FALSE)
    }
  }
  names(ids) <- tolower(names(ids))
  stopifnot("id" %in% names(ids))
  
  # REST implementation
  if(which_api == "REST"){
    
    # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections_retrieve.htm?search_text=retrieve%20multiple
    # this type of request can only handle 2000 records at a time
    batch_size <- 2000
    composite_url <- paste0(make_composite_url(), "/", object)
    
    # break up larger datasets, batch the data
    row_num <- nrow(ids)
    batch_id <- (seq.int(row_num)-1) %/% batch_size
    
    message("Splitting data into ", max(batch_id)+1, " Batches")
    message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
    resultset <- NULL
    for(batch in seq(0, max(batch_id))){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
      temp <- ids[batch_id == batch, , drop=FALSE]
      httr_response <- rPOST(url = composite_url,
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json"),
                             body = toJSON(list(ids=ids$id, 
                                                fields=fields),
                                           auto_unbox = FALSE))
      catch_errors(httr_response)
      response_parsed <- content(httr_response, "text", encoding="UTF-8")
      resultset <- bind_rows(resultset, fromJSON(response_parsed) %>% select_(.dots =  unique(c("Id", fields))))
    }
    resultset <- as_tibble(resultset)
  } else if(which_api == "Bulk"){
    #resultset <- sf_bulk_operation(input_data, object, operation="insert")
  } else {
    stop("Queries using the SOAP and Aysnc APIs has not yet been implemented, use REST or Bulk")
  }
  
  return(resultset)
}