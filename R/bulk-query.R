#' Submit Bulk Query Batch to a Bulk API Job 
#' 
#' This function takes a SOQL text string and submits the query to 
#' an already existing Bulk API Job of operation "query"
#'
#' @importFrom httr upload_file content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @template job_id
#' @template soql
#' @template api_type
#' @template verbose
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
#' job_info <- sf_create_job_bulk(operation='query', object='Account')
#' query_info <- sf_submit_query_bulk(job_id=job_info$id, soql=my_query)
#' }
#' @export
sf_submit_query_bulk <- function(job_id, soql, 
                                 api_type=c("Bulk 1.0"), 
                                 verbose=FALSE){
  
  api_type <- match.arg(api_type)
  bulk_query_url <- make_bulk_query_url(job_id, api_type=api_type)
  if(verbose){
    message(bulk_query_url)
  }
  f <- tempfile()
  cat(soql, file=f)
  httr_response <- rPOST(url = bulk_query_url,
                         headers = c("Content-Type"="text/csv; charset=UTF-8"),
                         body = upload_file(path=f, type='text/txt'))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('//batchInfo') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Retrieving the Results of a Bulk Query Batch in a Bulk API Job 
#' 
#' This function returns the row-level recordset of a bulk query
#' which has already been submitted to Bulk API Job and has Completed state
#' 
#' @importFrom readr read_csv
#' @importFrom httr content
#' @importFrom XML xmlToList
#' @importFrom dplyr as_tibble
#' @template job_id
#' @template batch_id
#' @param result_id a character string returned from \link{sf_batch_details_bulk} when a query has completed and specifies how to get the recordset
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df}, formatted by salesforce, containing query results
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 10"
#' job_info <- sf_create_job_bulk(operation='query', object='Account')
#' query_info <- sf_submit_query_bulk(job_id=job_info$id, soql=my_query)
#' result <- sf_batch_details_bulk(job_id = query_info$jobId,
#'                                 batch_id = query_info$id)
#' recordset <- sf_query_result_bulk(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_close_job_bulk(job_info$id)
#' }
#' @export
sf_query_result_bulk <- function(job_id, batch_id, result_id, 
                                 api_type = c("Bulk 1.0"), 
                                 verbose = FALSE){
    
  api_type <- match.arg(api_type)
  bulk_query_result_url <- make_bulk_query_result_url(job_id, batch_id, result_id, api_type)
  if(verbose){
    message(bulk_query_result_url)
  }  
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
#' @template object_name
#' @template api_type
#' @param interval_seconds integer; defines the seconds between attempts to check 
#' for job completion
#' @param max_attempts integer; defines then max number attempts to check for job 
#' completion before stopping
#' @template verbose
#' @return A \code{tbl_df} of the recordset returned by the query
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' # select all Ids from Account object
#' ids <- sf_query_bulk(soql='SELECT Id FROM Account', object_name='Account')
#' }
#' @export
sf_query_bulk <- function(soql,
                          object_name,
                          api_type = c("Bulk 1.0"),
                          interval_seconds=5,
                          max_attempts=100, 
                          verbose=FALSE){
  
  # if(is.null(object_name)){
  #   object_name <- gsub("(.*)from\\s+([A-Za-z_]+)\\b(.*)", "\\2", soql, ignore.case = TRUE, perl=TRUE)
  #   message(sprintf("Guessed target object_name from query string: %s", object_name))
  # }
  api_type <- match.arg(api_type)
  job_info <- sf_create_job_bulk(operation = "query", 
                                 object_name = object_name, 
                                 api_type = api_type, 
                                 verbose=verbose)
  batch_query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = soql, 
                                           api_type = api_type, 
                                           verbose=verbose)
  status_complete <- FALSE
  z <- 1
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    if (verbose){
      message(paste0("Attempt #", z))
    }
    Sys.sleep(interval_seconds)
    batch_query_status <- sf_batch_status_bulk(job_id=batch_query_info$jobId,
                                               batch_id=batch_query_info$id, 
                                               api_type = api_type, 
                                               verbose=verbose)
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
    message("Function's Time Limit Exceeded. Aborting Job Now")
    res <- sf_abort_job_bulk(job_info$id, api_type=api_type, 
                             verbose=verbose)
  } else {
    batch_query_details <- sf_batch_details_bulk(job_id = batch_query_info$jobId,
                                                 batch_id = batch_query_info$id, 
                                                 api_type = api_type, 
                                                 verbose = verbose)
    res <- sf_query_result_bulk(job_id = batch_query_info$jobId,
                                batch_id = batch_query_info$id,
                                result_id = batch_query_details$result,
                                api_type = "Bulk 1.0", 
                                verbose = verbose)
    close_job_info <- sf_close_job_bulk(job_info$id, api_type = api_type, 
                                        verbose = verbose)
  }
  return(res)
}
