#' Create Records
#' 
#' Adds one or more new records to your organization’s data.
#' 
#' @importFrom jsonlite toJSON
#' @importFrom stats quantile
#' @importFrom utils head
#' @param input_data data to create new records
#' @template object
#' @param all_or_none logical; allows a call to roll back all changes unless all 
#' records are processed successfully.
#' @template api_type
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' n <- 500
#' new_contacts <- data.frame(FirstName = rep("Test", n), 
#'                            LastName = paste0("Contact", 1:n))
#' sf_create(new_contacts, object="Contact")                            
#' }
#' @export
sf_create <- function(input_data,
                      object,
                      all_or_none = FALSE,
                      api_type = c("REST", "SOAP", "Bulk", "Async"),
                      verbose = FALSE){
  
  # check that the input data is named (we need to know the fields)
  stopifnot(!is.null(names(input_data)))
  which_api <- match.arg(api_type)
  
  # REST implementation
  if(which_api == "REST"){
    if(!is.data.frame(input_data)){
      input_data <- as.data.frame(as.list(input_data))
    }  
    # add attributes to insert multiple records at a time
    # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_composite_sobject_tree_flat.htm
    input_data$attributes <- lapply(1:nrow(input_data), FUN=function(x, obj){list(type=obj, referenceId=paste0("ref" ,x))}, obj=object)
    
    create_url <- make_create_url(object)
    
    # this type of request can only handle 200 records at a time
    batch_size <- 200
    
    # so break up larger datasets
    # batch the data
    row_num <- nrow(input_data)
    batch_id <- (seq.int(row_num)-1) %/% batch_size
    
    message("Splitting data into ", max(batch_id)+1, " Batches")
    message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
    resultset <- NULL
    for(batch in seq(0, max(batch_id))){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
      temp <- input_data[batch_id == batch, ]  
      
      httr_response <- rPOST(url = create_url,
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json", 
                                         "AllOrNoneHeader"=tolower(all_or_none)),
                             body = toJSON(list(records=temp), auto_unbox = TRUE))
      catch_errors(httr_response)
      response_parsed <- content(httr_response, encoding="UTF-8")
      resultset <- bind_rows(resultset, response_parsed$results) 
    }    
  } else if(which_api == "Bulk"){
    resultset <- sf_bulk_operation(input_data, object, operation="insert")
  } else {
    stop("Queries using the SOAP and Aysnc APIs has not yet been implemented, use REST or Bulk")
  }
  
  return(resultset)
}