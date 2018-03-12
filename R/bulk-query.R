#' Submit Bulk Query Batch to a Bulk API Job 
#' 
#' This function takes a SOQL text string and submits the query to 
#' an already existing Bulk API Job of operation "query"
#'
#' @importFrom httr upload_file content
#' @importFrom XML xmlToList
#' @template job_id
#' @param soql a character string defining a valid SOQL query on the Salesforce object associated with the job
#' @return A \code{list} parameters of the batch
#' @note Bulk API query doesn't support the following SOQL:
#' \itemize{
#'    \item COUNT
#'    \item ROLLUP
#'    \item SUM
#'    \item GROUP BY CUBE
#'    \item OFFSET
#'    \item Nested SOQL queries
#'    \item Relationship fields
#'    }
#' Additionally, Bulk API can't access or query compound address or compound geolocation fields.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 10"
#' job_info <- sf_bulk_create_job(operation='query', object='Account')
#' query_info <- sf_bulk_submit_query(job_id=job_info$id, soql=my_query)
#' }
#' @export
sf_bulk_submit_query <- function(job_id, soql){
  
  f <- tempfile()
  cat(soql, file=f)
  
  bulk_query_url <- make_bulk_query_url(job_id)
  httr_response <- rPOST(url = bulk_query_url,
                         headers = c("Content-Type"="text/csv; charset=UTF-8"),
                         body = upload_file(path=f, type='text/txt'))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="text", encoding="UTF-8")
  return(xmlToList(response_parsed))
}

#' Retrieving the Results of a Bulk Query Batch in a Bulk API Job 
#' 
#' This function returns the resultset of a Bulk Query batch
#' which has already been submitted to Bulk API Job and has Completed state
#' 
#' @importFrom readr read_csv
#' @importFrom httr content
#' @importFrom XML xmlToList
#' @importFrom dplyr as_tibble
#' @template job_id
#' @template batch_id
#' @param result_id a character string returned from \link{sf_bulk_batch_details} when a query has completed and specifies how to get the recordset
#' @return A \code{tbl_df}, formatted by salesforce, containing query results
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 10"
#' job_info <- sf_bulk_create_job(operation='query', object='Account')
#' query_info <- sf_bulk_submit_query(job_id=job_info$id, soql=my_query)
#' result <- sf_bulk_batch_details(job_id = query_info$jobId,
#'                                 batch_id = query_info$id)
#' recordset <- sf_bulk_query_result(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_bulk_close_job(job_info$id)
#' }
#' @export
sf_bulk_query_result <- function(job_id, batch_id, result_id){
    
  bulk_query_result_url <- make_bulk_query_result_url(job_id, batch_id, result_id)
  httr_response <- rGET(url = bulk_query_result_url)
  catch_errors(httr_response)
  response_text <- content(httr_response, as="text", encoding="UTF-8")
  
  content_type <- httr_response$headers$`content-type`
  if (grepl('xml', content_type)) {
    res <- as_tibble(xmlToList(response_text))
  } else if(grepl('text/csv', content_type)) {
    res <- read_csv(response_text)
  } else {
    message(sprintf("Unhandled content-type: %s", content_type))
    res <- content(httr_response, as="parsed", encoding="UTF-8")
  }
  
  return(res)
}

#' Run Bulk Query 
#' 
#' This function is a convenience wrapper for submitting and retrieving 
#' bulk query API jobs
#'
#' @template soql
#' @template object
#' @param interval_seconds an integer defining the seconds between attempts to check for job completion
#' @param max_attempts an integer defining then max number attempts to check for job completion before stopping
#' @template verbose
#' @return A \code{data.frame} of the recordset returned by query
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' # select all Ids from Account object
#' ids <- sf_bulk_query(soql='SELECT Id FROM Account', object='Account')
#' }
#' @export
sf_bulk_query <- function(soql,
                          object=NULL,
                          interval_seconds=5,
                          max_attempts=100, 
                          verbose=FALSE){
  if(is.null(object)){
    object <- gsub("(.*)from\\s+([A-Za-z_]+)\\b.*", "\\2", soql, ignore.case = TRUE, perl=TRUE)
    message(sprintf("Guessed target object from query string: %s", object))
  }
  
  job_info <- sf_bulk_create_job(operation = "query", object = object)
  batch_query_info <- sf_bulk_submit_query(job_id = job_info$id, 
                                           soql = soql)
  status_complete <- FALSE
  z <- 1
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    if (verbose){
      message(paste0("Attempt #", z))
    }
    Sys.sleep(interval_seconds)
    batch_query_status <- sf_bulk_batch_status(job_id=batch_query_info$jobId,
                                               batch_id=batch_query_info$id) 
    if(batch_query_status$state == 'Failed'){
      stop(batch_query_status$stateMessage)
    } else if(batch_query_status$state == "Completed"){
      status_complete <- TRUE
    } else {
      # continue checking the status until done or max attempts
      z <- z + 1
    }
  }
  if (!status_complete) {
    message('Issue with batches submitted.')
    batch_query_details <- NULL
    tryCatch({
      batch_query_details <- sf_bulk_batch_details(job_id = batch_query_info$jobId,
                                                   batch_id = batch_query_info$id)
    }, error=function(e){
    })
    # close the job
    close_job_info <- sf_bulk_close_job(job_info$id)
    return(batch_query_details)
  }
  batch_query_details <- sf_bulk_batch_details(job_id = batch_query_info$jobId,
                                               batch_id = batch_query_info$id)
  
  batch_query_recordset <- sf_bulk_query_result(job_id = batch_query_info$jobId,
                                                batch_id = batch_query_info$id,
                                                result_id = batch_query_details$result)
  close_job_info <- sf_bulk_close_job(job_info$id)
  
  return(batch_query_recordset)
}