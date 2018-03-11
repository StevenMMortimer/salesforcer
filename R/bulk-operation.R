#' Create Bulk API Job 
#' 
#' This function initializes a Job in the Salesforce Bulk API
#'
#' @param operation a character string defining the type of operation being performed
#' @template object
#' @param contentType a character string being one of 'CSV','ZIP_CSV','ZIP_XML', or 'ZIP_JSON'
#' @param externalIdFieldName a character string identifying a custom field that has the "External ID" attribute on the target object. 
#' This field is only used when performing upserts. It will be ignored for all other operations.
#' @param concurrencyMode a character string either "Parallel" or "Serial" that specifies whether batches should be completed
#' sequentially or in parallel. Use "Serial" only if Lock contentions persist with in "Parallel" mode.
#' @param lineEnding a character string indicating the The line ending used for CSV job data, 
#' marking the end of a data row. The default is "LF", but could be "CRLF" for Windows created files. 
#' @param columnDelimiter a character string indicating the column delimiter used for CSV job data. 
#' The default value is COMMA. Valid values are: "BACKQUOTE", "CARET", "COMMA", "PIPE", 
#' "SEMICOLON", and "TAB".
#' @return A \code{list} parameters defining the created job, including id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' # insert into Account
#' job_info <- sf_bulk_create_job(operation='insert', object='Account')
#' 
#' # delete from Account
#' job_info <- sf_bulk_create_job(operation='delete', object='Account')
#' 
#' # update into Account
#' job_info <- sf_bulk_create_job(operation='update', object='Account')
#' 
#' # upsert into Account
#' job_info <- sf_bulk_create_job(operation='upsert',
#'                                externalIdFieldName='My_External_Id__c',
#'                                object='Account')
#' 
#' # insert attachments
#' job_info <- sf_bulk_create_job(operation='insert', object='Attachment')
#' }
#' @export
sf_bulk_create_job <- function(operation=c("insert", "delete", "upsert", "update", 
                                           "hardDelete", "query"), 
                               object,
                               contentType=c('CSV', 'ZIP_CSV', 'ZIP_XML', 'ZIP_JSON'),
                               externalIdFieldName=NULL,
                               concurrencyMode=c("Parallel", "Serial"),
                               lineEnding = NULL,
                               columnDelimiter = NULL){

  # validate inputs
  operation <- match.arg(operation)
  contentType <- match.arg(contentType)
  concurrencyMode <- match.arg(concurrencyMode)
  
  if(operation == 'upsert'){
    stopifnot(!is.null(externalIdFieldName))
  }
  
  # form body from arugments
  request_body <- as.list(environment())
  
  if(operation %in% c("insert", "delete", "upsert", "update")){
    # Bulk 2.0 only supports "insert", "delete", "upsert", "update", not "hardDelete" or "query"
    bulk_version <- "2.0"  
    if(is.null(lineEnding)){
      if(get_os()=='windows'){
        request_body$lineEnding <- "CRLF"
      } else {
        request_body$lineEnding <- "LF"
      }
    }
    request_body$concurrencyMode <- NULL
  } else {
    bulk_version <- "1.0"
  }

  # send request
  bulk_create_job_url <- make_bulk_create_job_url(bulk_version)
  httr_response <- rPOST(url = bulk_create_job_url,
                         headers = c("Accept"="application/json", 
                                     "Content-Type"="application/json"), 
                         body = request_body, 
                         encode = "json")
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  return(response_parsed)
}

#' Get Bulk API Job 
#' 
#' This function retrieves details about a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @return A \code{list} of parameters defining the details of the specified job id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' job_info <- sf_bulk_create_job('insert', 'Account')
#' refreshed_job_info <- sf_bulk_get_job(job_info$id)
#' sf_bulk_abort_job(refreshed_job_info$id)
#' }
#' @export
sf_bulk_get_job <- function(job_id){
  bulk_get_job_url <- make_bulk_get_job_url(job_id)
  httr_response <- rGET(url = bulk_get_job_url)
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  return(response_parsed)
}

#' End Bulk API Job 
#' 
#' @template job_id
#' @param end_type character; taking a value of "Closed" or "Aborted" indicating 
#' how the bulk job should be ended
#' @template bulk_version
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_bulk_end_job_generic <- function(job_id,
                                    end_type = c("Closed", "UploadComplete", "Aborted"), 
                                    bulk_version = c("2.0", "1.0")){
  
  end_type <- match.arg(end_type)
  bulk_version <- match.arg(bulk_version)
  if(bulk_version == "2.0" & end_type == "Closed"){
    end_typ <- "UploadComplete"
  }
  # send request
  request_body <- list(state=end_type)
  bulk_end_job_url <- make_bulk_end_job_generic_url(job_id, bulk_version)
  if(bulk_version == "2.0"){
    httr_response <- rPATCH(url = bulk_end_job_url,
                            headers = c("Accept"="application/json", 
                                        "Content-Type"="application/json"), 
                            body = request_body, 
                            encode = "json")  
  } else {
    httr_response <- rPOST(url = bulk_end_job_url,
                           headers = c("Accept"="application/json", 
                                       "Content-Type"="application/json"), 
                           body = request_body, 
                           encode = "json")    
  }
  catch_errors(httr_response)
  return(TRUE)
}

#' Close Bulk API Job 
#' 
#' This function closes a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @return A \code{list} of parameters defining the now closed job
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is typically a legacy function used only with Bulk 1.0. It is used less 
#' frequently (only with bulk queries) since the operations insert, update, upsert, delete 
#' have all been moved to using Bulk 2.0.
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 10"
#' job_info <- sf_bulk_create_job(operation='query', object='Account')
#' query_info <- sf_bulk_submit_query(job_id=job_info$id, soql=my_query)
#' recordset <- sf_bulk_query_result(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_bulk_close_job(job_info$id)
#' }
#' @export
sf_bulk_close_job <- function(job_id){
  job_info <- sf_bulk_get_job(job_id)
  if(job_info$jobType == "V2Ingest"){
    stop(paste("Jobs created using Bulk 2.0 cannot be closed.", 
               "Use sf_bulk_abort_job() to cancel or sf_bulk_upload_complete() to signal processing"))
  }
  sf_bulk_end_job_generic(job_id, end_type = "Closed", bulk_version = "1.0")
}

#' Signal Upload Complete to Bulk API Job 
#' 
#' This function signals that uploads are complete to a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @return A \code{list} of parameters defining the job after signaling a completed upload
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This function is typically not used directly. It is used in \code{sf_bulk_create_batches()} 
#' right after submitting the batches to signal to Salesforce that the batches should 
#' no longer be queued.
#' @examples
#' \dontrun{
#' upload_info <- sf_bulk_upload_complete(job_id=job_info$id)
#' }
#' @export
sf_bulk_upload_complete <- function(job_id){
  sf_bulk_end_job_generic(job_id, end_type = "UploadComplete", bulk_version = "2.0")
}

#' Abort Bulk API Job 
#' 
#' This function aborts a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @return A \code{list} of parameters defining the now aborted job
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' job_info <- sf_bulk_create_job('insert', 'Account')
#' sf_bulk_abort_job(job_info$id)
#' }
#' @export
sf_bulk_abort_job <- function(job_id){
  sf_bulk_end_job_generic(job_id, end_type = "Aborted", bulk_version = "2.0")
}

#' Delete Bulk API Job 
#' 
#' @template job_id
#' @examples
#' \dontrun{
#' job_info <- sf_bulk_create_job('insert', 'Account')
#' sf_bulk_abort_job(job_info$id)
#' sf_bulk_delete_job(job_info$id)
#' }
#' @export
sf_bulk_delete_job <- function(job_id){
  bulk_delete_job_url <- make_bulk_delete_job_url(job_id)
  httr_response <- rDELETE(url = bulk_delete_job_url)
  catch_errors(httr_response)
  return(TRUE)
}

#' Add Batches to a Bulk API Job 
#' 
#' This function takes a data frame and submits it in batches to a 
#' an already existing Bulk API Job by chunking into temp files
#'
#' @importFrom httr upload_file
#' @template job_id
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into .csv file for submitting as batch request
#' @return A \code{list} of \code{list}s, one for each batch submitted, containing 10 parameters of the batch
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' # NOTE THAT YOU MUST FIRST CREATE AN EXTERNAL ID FIELD CALLED My_External_Id 
#' # BEFORE RUNNING THIS EXAMPLE
#' # inserting 2 records
#' my_data <- tibble(Name=c('New Record 1', 'New Record 2'),
#'                   My_External_Id__c=c('11111','22222'))
#' job_info <- sf_bulk_create_job(operation='insert',
#'                                object='Account')
#' batches_ind <- sf_bulk_create_batches(job_id = job_info$id,
#'                                       input_data = my_data)
#' # upserting 3 records
#' my_data2 <- tibble(My_External_Id__c=c('11111','22222', '99999'), 
#'                   Name=c('Updated_Name1', 'Updated_Name2', 'Upserted_Record')) 
#' job_info <- sf_bulk_create_job(operation='upsert',
#'                                externalIdFieldName='My_External_Id__c',
#'                                object='Account')
#' batches_ind <- sf_bulk_create_batches(job_id = job_info$id,
#'                                       input_data = my_data2)
#' sf_bulk_get_job(job_info$id)                                     
#' }
#' @export
sf_bulk_create_batches <- function(job_id, 
                                   input_data){

  f <- tempfile()
  if(!is.data.frame(input_data)){
    input_data <- as.data.frame(input_data)
  }
  sf_write_csv(input_data, f)
  
  job_status <- sf_bulk_get_job(job_id)
  if(job_status$jobType == "Classic"){
    bulk_version <- "1.0"
  } else {
    bulk_version <- "2.0"
  }
  bulk_batches_url <- make_bulk_batches_url(job_id, bulk_version)
  if(bulk_version == "2.0"){
    httr_response <- rPUT(url = bulk_batches_url,
                          headers = c("Content-Type"="text/csv", 
                                      "Accept"="application/json"),
                          body = upload_file(path=f, type="text/csv"))
    catch_errors(httr_response)
    # the batches will not start processing (move out of Queued state) until you signal "Upload Complete"
    upload_details <- sf_bulk_upload_complete(job_id)
    return(TRUE)
  } else {
    return(TRUE)
    # Bulk 1.0 are handled very differently (you batch on your side, not Salesforce batching for you)
    # sf_bulk_create_batches1.0 <-   
  }
}

#' Checking the Status of a Batch in a Bulk API Job 
#' 
#' This function checks on and returns status information on an existing batch
#' which has already been submitted to Bulk API Job
#'
#' @template job_id
#' @template batch_id
#' @return A \code{list} of parameters defining the batch identified by the batch_id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is typically a legacy function used only with Bulk 1.0, but many 
#' operations such as insert, update, upsert, delete have been moved to using Bulk 2.0. It 
#' is useful for checking whether a bulk query has errors or not while waiting for the 
#' results.
#' @examples
#' \dontrun{
#' job_info <- sf_bulk_create_job(operation = "query", object = "Account")
#' soql <- "SELECT Id, Name FROM Account LIMIT 10"
#' batch_query_info <- sf_bulk_submit_query(job_id = job_info$id, soql = soql)
#' batch_status <- sf_bulk_batch_status(job_id=batch_query_info$jobId,
#'                                      batch_id=batch_query_info$id)
#' job_close_ind <- sf_bulk_close_job(job_info$id)
#' sf_bulk_get_job(job_info$id)                               
#' }
#' @export
sf_bulk_batch_status <- function(job_id, batch_id){
  bulk_batch_status_url <- make_bulk_batch_status_url(job_id, batch_id)
  httr_response <- rGET(url = bulk_batch_status_url)
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="text", encoding="UTF-8")
  return(xmlToList(response_parsed))
}

#' Returning the Details of a Batch in a Bulk API Job 
#' 
#' This function returns detailed (row-by-row) information on an existing batch
#' which has already been submitted to Bulk API Job
#'
#' @importFrom readr read_csv
#' @importFrom httr content
#' @importFrom XML xmlToList
#' @importFrom dplyr as_tibble
#' @template job_id
#' @template batch_id
#' @return A \code{tbl_df}, formatted by salesforce, with information containing the success or failure or certain rows in a submitted batch, 
#' unless the operation was query, then it is a data.frame containing the result_id for retrieving the recordset.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is typically a legacy function used only with Bulk 1.0, but many 
#' operations such as insert, update, upsert, delete have been moved to using Bulk 2.0.
#' @examples
#' \dontrun{
#' job_info <- sf_bulk_create_job(operation = "query", object = "Account")
#' soql <- "SELECT Id, Name FROM Account LIMIT 10"
#' batch_query_info <- sf_bulk_submit_query(job_id = job_info$id, soql = soql)
#' batch_details <- sf_bulk_batch_details(job_id=batch_query_info$jobId,
#'                                        batch_id=batch_query_info$id)
#' sf_bulk_close_job(job_info$id)
#' }
#' @export
sf_bulk_batch_details <- function(job_id, batch_id){
  
  job_status <- sf_bulk_get_job(job_id)
  if(job_status$jobType != "Classic"){
    stop("This function only works with Bulk 1.0 jobs")
  }
  
  bulk_batch_details_url <- make_bulk_batch_details_url(job_id, batch_id)
  httr_response <- rGET(url = bulk_batch_details_url)
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

#' Returning the Details of a Bulk API Job 
#' 
#' This function returns detailed (row-by-row) information on a job
#' which has already been submitted completed (successfully or not).
#'
#' @importFrom readr read_csv
#' @importFrom httr content
#' @template job_id
#' @param record_types character; one or more types of records to retrieve from 
#' the results of running the specified job
#' @return A \code{list} of \code{tbl_df}, formatted by Salesforce, with information 
#' containing the success or failure or certain rows in a submitted job
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' job_info <- sf_bulk_create_job('insert', 'Account')
#' input_data <- tibble(Name=c("Test Account 1", "Test Account 2"))
#' batches_result <- sf_bulk_create_batches(job_info$id, input_data)
#' # pause 1 second for operation to finish, wait longer if job is not complete
#' Sys.sleep(1)
#' job_status <- sf_bulk_get_job(job_info$id)
#' if(job_status$state == "JobComplete"){
#'   job_record_details <- sf_bulk_get_job_records(job_id=job_info$id)
#' }
#' }
#' @export
sf_bulk_get_job_records <- function(job_id, 
                                    record_types = c("successfulResults", 
                                                     "failedResults", 
                                                     "unprocessedRecords")){
  
  record_types <- match.arg(record_types, several.ok = TRUE)
  records <- list()
  
  for(r in record_types){
    bulk_job_records_url <- make_bulk_job_records_url(job_id, record_type = r)
    httr_response <- rGET(url = bulk_job_records_url)
    catch_errors(httr_response)
    response_text <- content(httr_response, as="text", encoding="UTF-8")
    
    content_type <- httr_response$headers$`content-type`
    if(grepl('text/csv', content_type)) {
      res <- read_csv(response_text)
    } else {
      message(sprintf("Unhandled content-type: %s", content_type))
      res <- content(httr_response, as="parsed", encoding="UTF-8")
    }
    records[[r]] <- res
  }
  return(records)
}

#' Run Bulk Operation
#'
#' This function is a convenience wrapper for submitting bulk API jobs
#'
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into .csv file for submitting as batch request
#' @template object
#' @param operation character string defining the type of operation being performed
#' @param wait_for_results logical; indicating whether to wait for the operation to complete 
#' so that the batch results of individual records can be obtained
#' @param interval_seconds an integer defining the seconds between attempts to check for job completion
#' @param max_attempts an integer defining then max number attempts to check for job completion before stopping
#' @template verbose
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' n <- 20
#' new_contacts <- data.frame(FirstName = rep("Test", n), 
#'                            LastName = paste0("Contact", 1:n))
#' # insert new records into the Contact object
#' inserts <- sf_bulk_operation(input_data=new_contacts, 
#'                              object="Contact", 
#'                              operation="insert")
#' }
#' @export
sf_bulk_operation <- function(input_data,
                              object,
                              operation = c("insert", "delete", "upsert", "update"),
                              wait_for_results = TRUE,
                              interval_seconds = 3,
                              max_attempts = 200,
                              verbose = FALSE){

  operation <- match.arg(operation)
  
  job_info <- sf_bulk_create_job(operation, object)
  batches_info <- sf_bulk_create_batches(job_info$id, input_data)
  
  if(wait_for_results){
    status_complete <- FALSE
    z <- 1
    Sys.sleep(interval_seconds)
    while (z < max_attempts & !status_complete){
      if (verbose){
        if(z %% 5 == 0){
          message(paste0("Attempt #", z))
        }
      }
      Sys.sleep(interval_seconds)
      job_status <- sf_bulk_get_job(job_info$id)
      if(job_status$state == 'Failed'){
        stop(job_status$stateMessage)
      } else if(job_status$state == "JobComplete"){
        status_complete <- TRUE
      } else {
        # continue checking the status until done or max attempts
        z <- z + 1
      }
    }
    if (!status_complete) {
      message("Function's Time Limit Exceeded. Aborting Job Now")
      abort_job_ind <- sf_bulk_abort_job(job_info$id)
    } 
    res <- sf_bulk_get_job_records(job_info$id)
  } else {
    res <- TRUE
  }
  return(res)
}