#' Create Bulk API Job 
#' 
#' This function initializes a Job in the Salesforce Bulk API
#'
#' @template operation
#' @template object_name
#' @template external_id_fieldname
#' @template api_type
#' @param content_type character; being one of 'CSV', 'ZIP_CSV', 'ZIP_XML', or 'ZIP_JSON' to 
#' indicate the type of data being passed to the Bulk API
#' @param concurrency_mode character; either "Parallel" or "Serial" that specifies whether batches should be completed
#' sequentially or in parallel. Use "Serial" only if Lock contentions persist with in "Parallel" mode.
#' @param line_ending character; indicating the The line ending used for CSV job data, 
#' marking the end of a data row. The default is NULL and determined by the operating system using 
#' "CRLF" for Windows machines and "LF" for Unix machines
#' @param column_delimiter character; indicating the column delimiter used for CSV job data. 
#' The default value is COMMA. Valid values are: "BACKQUOTE", "CARET", "COMMA", "PIPE", 
#' "SEMICOLON", and "TAB".
#' @template verbose
#' @return A \code{tbl_df} parameters defining the created job, including id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' # insert into Account
#' job_info <- sf_create_job_bulk(operation='insert', object_name='Account')
#' 
#' # delete from Account
#' job_info <- sf_create_job_bulk(operation='delete', object_name='Account')
#' 
#' # update into Account
#' job_info <- sf_create_job_bulk(operation='update', object_name='Account')
#' 
#' # upsert into Account
#' job_info <- sf_create_job_bulk(operation='upsert',
#'                                externalIdFieldName='My_External_Id__c',
#'                                object_name='Account')
#' # insert attachments
#' job_info <- sf_create_job_bulk(operation='insert', object_name='Attachment')
#' 
#' # query leads
#' job_info <- sf_create_job_bulk(operation='query', object_name='Lead')
#' }
#' @export
sf_create_job_bulk <- function(operation = c("insert", "delete", "upsert", "update", 
                                             "hardDelete", "query"), 
                               object_name,
                               external_id_fieldname = NULL,
                               api_type = c("Bulk 1.0", "Bulk 2.0"),
                               content_type=c('CSV', 'ZIP_CSV', 'ZIP_XML', 'ZIP_JSON'),
                               concurrency_mode=c("Parallel", "Serial"),
                               line_ending = NULL,
                               column_delimiter = c('COMMA', 'TAB', 'PIPE', 'SEMICOLON', 
                                                    'CARET', 'BACKQUOTE'), 
                               verbose=FALSE){

  api_type <- match.arg(api_type)
  operation <- match.arg(operation)
  content_type <- match.arg(content_type)
  if(api_type == "Bulk 1.0"){
    job_response <- sf_create_job_bulk_v1(operation=operation,
                                          object_name=object_name,
                                          external_id_fieldname=external_id_fieldname,
                                          content_type=content_type,
                                          concurrency_mode=concurrency_mode,
                                          verbose=verbose)
  } else if(api_type == "Bulk 2.0"){
    if(!(operation %in% c("insert", "delete", "upsert", "update"))){
      stop('Bulk 2.0 only supports the following operations: "insert", "delete", "upsert", and "update"')
    }
    if(!(content_type %in% c("CSV"))){
      stop('Bulk 2.0 only supports the "CSV" content type.')
    }
    job_response <- sf_create_job_bulk_v2(operation=operation,
                                          object_name=object_name,
                                          external_id_fieldname=external_id_fieldname,
                                          content_type=content_type,
                                          line_ending=line_ending,
                                          column_delimiter=column_delimiter,
                                          verbose=verbose)
  } else {
    stop("Unknown API type")
  }
  return(job_response)
}

#' Create Job using Bulk 1.0 API
#' 
#' @importFrom xml2 xml_new_document xml_add_child xml_add_sibling
#' @importFrom httr content
#' @importFrom XML xmlToList
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_job_bulk_v1 <- function(operation = c("insert", "delete", "upsert", "update", 
                                                "hardDelete", "query"), 
                                  object_name,
                                  external_id_fieldname=NULL,
                                  content_type=c('CSV', 'ZIP_CSV', 'ZIP_XML', 'ZIP_JSON'),
                                  concurrency_mode=c("Parallel", "Serial"),
                                  verbose=FALSE){
  
  operation <- match.arg(operation)
  content_type <- match.arg(content_type)
  concurrency_mode <- match.arg(concurrency_mode)
  
  # build xml for Bulk 1.0 request
  body <- xml_new_document()
  body %>%
    xml_add_child("jobInfo",
                  "xmlns" = "http://www.force.com/2009/06/asyncapi/dataload") %>%
    xml_add_child("operation", operation) %>%
    xml_add_sibling("object", object_name)
  
  if(operation == "upsert"){
    stopifnot(!is.null(external_id_fieldname))
    body %>% 
      xml_add_child("externalIdFieldName", external_id_fieldname)
  }
  
  body %>% 
    xml_add_child("concurrencyMode", concurrency_mode) %>%
    xml_add_child("contentType", content_type)
  
  body <- as.character(body)  
  
  bulk_create_job_url <- make_bulk_create_job_url(api_type="Bulk 1.0")
  if (verbose){
    message(bulk_create_job_url)
    message(body)
  }
  httr_response <- rPOST(url = bulk_create_job_url,
                         headers = c("Accept"="application/xml",
                                     "Content-Type"="application/xml"), 
                         body = body)
  catch_errors(httr_response)  
  response_parsed <- content(httr_response, encoding="UTF-8")
  job_info <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('//jobInfo') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  return(job_info)
}

#' Create Job using Bulk 2.0 API
#' 
#' @importFrom xml2 xml_new_document xml_add_child xml_add_sibling
#' @importFrom httr content
#' @importFrom jsonlite toJSON
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_job_bulk_v2 <- function(operation = c("insert", "delete", "upsert", "update"),
                                  object_name,
                                  external_id_fieldname=NULL,
                                  content_type = 'CSV',
                                  line_ending = NULL,
                                  column_delimiter = c('COMMA', 'TAB', 'PIPE', 'SEMICOLON', 
                                                       'CARET', 'BACKQUOTE'), 
                                  verbose=FALSE){
  
  operation <- match.arg(operation)
  content_type <- match.arg(content_type)
  line_ending <- match.arg(line_ending)
  column_delimiter <- match.arg(column_delimiter)
  if(column_delimiter != "COMMA"){
    stop("column_delimiter = 'COMMA' is currently the only supported file delimiter")
  }
  
  if(operation == 'upsert'){
    stopifnot(!is.null(external_id_fieldname))
  }  
  # form body from arguments
  request_body <- list(operation = operation, 
                       object = object_name, 
                       contentType = content_type, 
                       externalIdFieldName = external_id_fieldname,
                       lineEnding = line_ending, 
                       columnDelimiter = column_delimiter)
  request_body[sapply(request_body, is.null)] <- NULL
   
  if(is.null(line_ending)){
    if(get_os()=='windows'){
      request_body$lineEnding <- "CRLF"
    } else {
      request_body$lineEnding <- "LF"
    }
  }
  stopifnot(request_body$lineEnding %in% c("LF", "CRLF"))
  body <- toJSON(request_body, auto_unbox=TRUE, pretty=TRUE)
  
  bulk_create_job_url <- make_bulk_create_job_url(api_type="Bulk 2.0")
  if (verbose){
    message(bulk_create_job_url)
    message(body)
  }
  httr_response <- rPOST(url = bulk_create_job_url,
                         headers = c("Accept"="application/json",
                                     "Content-Type"="application/json"), 
                         body = body)
  catch_errors(httr_response)    
  response_parsed <- content(httr_response, encoding="UTF-8")
  job_info <- as_tibble(response_parsed)
  return(job_info)
}

#' Get Bulk API Job 
#' 
#' This function retrieves details about a Job in the Salesforce Bulk API
#'
#'
#' @template job_id
#' @template api_type
#' @template verbose
#' @return A \code{list} of parameters defining the details of the specified job id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' refreshed_job_info <- sf_get_job_bulk(job_info$id)
#' sf_abort_job_bulk(refreshed_job_info$id)
#' }
#' @export
sf_get_job_bulk <- function(job_id, api_type=c("Bulk 1.0", "Bulk 2.0"), verbose=FALSE){
  api_type <- match.arg(api_type)
  bulk_get_job_url <- make_bulk_get_job_url(job_id, api_type=api_type)
  if(verbose){
    message(bulk_get_job_url)
  }
  httr_response <- rGET(url = bulk_get_job_url)
  catch_errors(httr_response)
  if(api_type == "Bulk 1.0"){
    response_parsed <- content(httr_response, encoding="UTF-8")
    job_info <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('//jobInfo') %>%
      map_df(xml_nodeset_to_df) %>%
      type_convert(col_types = cols())
  } else if(api_type == "Bulk 2.0"){
    response_parsed <- content(httr_response, encoding="UTF-8")
    job_info <- as_tibble(response_parsed)
  } else {
    stop("Unknown API type")
  }
  return(job_info)
}

#' End Bulk API Job 
#' 
#' @template job_id
#' @param end_type character; taking a value of "Closed" or "Aborted" indicating 
#' how the bulk job should be ended
#' @template api_type
#' @template verbose
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_end_job_bulk <- function(job_id,
                            end_type = c("Closed", "UploadComplete", "Aborted"), 
                            api_type = c("Bulk 1.0", "Bulk 2.0"), 
                            verbose = FALSE){
  
  end_type <- match.arg(end_type)
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0" & end_type == "Closed"){
    end_typ <- "UploadComplete"
  }
  request_body <- list(state=end_type)
  bulk_end_job_url <- make_bulk_end_job_generic_url(job_id, api_type)
  if (verbose){
    message(bulk_end_job_url)
  }
  if(api_type == "Bulk 2.0"){
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
#' @template api_type
#' @template verbose
#' @return A \code{list} of parameters defining the now closed job
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is a legacy function used only with Bulk 1.0.
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 10"
#' job_info <- sf_create_job_bulk(operation='query', object='Account')
#' query_info <- sf_submit_query_bulk(job_id=job_info$id, soql=my_query)
#' recordset <- sf_query_result_bulk(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_close_job_bulk(job_info$id)
#' }
#' @export
sf_close_job_bulk <- function(job_id, api_type=c("Bulk 1.0", "Bulk 2.0"), verbose = FALSE){
  api_type <- match.arg(api_type)
  job_info <- sf_get_job_bulk(job_id, api_type = api_type, verbose = verbose)
  sf_end_job_bulk(job_id, end_type = "Closed", api_type = api_type, verbose=verbose)
}

#' Signal Upload Complete to Bulk API Job 
#' 
#' This function signals that uploads are complete to a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @template api_type
#' @template verbose
#' @return A \code{list} of parameters defining the job after signaling a completed upload
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This function is typically not used directly. It is used in \code{sf_create_batches_bulk()} 
#' right after submitting the batches to signal to Salesforce that the batches should 
#' no longer be queued.
#' @examples
#' \dontrun{
#' upload_info <- sf_upload_complete_bulk(job_id=job_info$id)
#' }
#' @export
sf_upload_complete_bulk <- function(job_id, api_type=c("Bulk 2.0"), 
                                    verbose = FALSE){
  api_type <- match.arg(api_type)
  sf_end_job_bulk(job_id, end_type = "UploadComplete", api_type = api_type, verbose=verbose)
}

#' Abort Bulk API Job 
#' 
#' This function aborts a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @template api_type
#' @template verbose
#' @return A \code{list} of parameters defining the now aborted job
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' sf_abort_job_bulk(job_info$id)
#' }
#' @export
sf_abort_job_bulk <- function(job_id, api_type=c("Bulk 2.0"), 
                              verbose = FALSE){
  api_type <- match.arg(api_type)
  sf_end_job_bulk(job_id, end_type = "Aborted", api_type = api_type, verbose=verbose)
}

#' Delete Bulk API Job 
#' 
#' @template job_id
#' @template api_type
#' @template verbose
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' sf_abort_job_bulk(job_info$id)
#' sf_delete_job_bulk(job_info$id)
#' }
#' @export
sf_delete_job_bulk <- function(job_id, api_type=c("Bulk 2.0"), 
                               verbose=FALSE){
  api_type <- match.arg(api_type)
  bulk_delete_job_url <- make_bulk_delete_job_url(job_id, api_type=api_type)
  if(verbose){
    message(bulk_delete_job_url)
  }
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
#' @template api_type
#' @template verbose
#' @return a \code{tbl_df} containing details of each batch
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' # NOTE THAT YOU MUST FIRST CREATE AN EXTERNAL ID FIELD CALLED My_External_Id 
#' # BEFORE RUNNING THIS EXAMPLE
#' # inserting 2 records
#' my_data <- tibble(Name=c('New Record 1', 'New Record 2'),
#'                   My_External_Id__c=c('11111','22222'))
#' job_info <- sf_create_job_bulk(operation='insert',
#'                                object='Account')
#' batches_ind <- sf_create_batches_bulk(job_id = job_info$id,
#'                                       input_data = my_data)
#' # upserting 3 records
#' my_data2 <- tibble(My_External_Id__c=c('11111','22222', '99999'), 
#'                   Name=c('Updated_Name1', 'Updated_Name2', 'Upserted_Record')) 
#' job_info <- sf_create_job_bulk(operation='upsert',
#'                                externalIdFieldName='My_External_Id__c',
#'                                object='Account')
#' batches_ind <- sf_create_batches_bulk(job_id = job_info$id,
#'                                       input_data = my_data2)
#' sf_get_job_bulk(job_info$id)                                     
#' }
#' @export
sf_create_batches_bulk <- function(job_id, 
                                   input_data, 
                                   api_type=c("Bulk 1.0", "Bulk 2.0"), 
                                   verbose = FALSE){
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){
    created_batches <- sf_create_batches_bulk_v1(job_id, input_data, verbose=verbose)
  } else if(api_type == "Bulk 2.0"){
    created_batches <- sf_create_batches_bulk_v2(job_id, input_data, verbose=verbose)
  } else { 
    stop("Unknown API type")
  }
  return(created_batches)
}
  
#' @importFrom utils head
#' @importFrom stats quantile
sf_create_batches_bulk_v1 <- function(job_id, 
                                      input_data, 
                                      verbose = FALSE){
  
  job_status <- sf_get_job_bulk(job_id, api_type="Bulk 1.0", 
                                verbose = verbose)
  stopifnot(job_status$state == "Open")
  input_data <- sf_input_data_validation(operation=job_status$operation, 
                                         input_data)
  
  # Batch sizes should be adjusted based on processing times. Start with 5000 
  # records and adjust the batch size based on processing time. If it takes more 
  # than five minutes to process a batch, it may be beneficial to reduce the batch size. 
  # If it takes a few seconds, the batch size should be increased. If you get a 
  # timeout error when processing a batch, split your batch into smaller batches, 
  # and try again.
  # https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_batches_intro.htm
  batch_size <- 5000
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose){
    message("Submitting data in ", max(batch_id)+1, " Batches")
  }
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  bulk_batches_url <- make_bulk_batches_url(job_id, api_type="Bulk 1.0")
  if(verbose) {
    message(bulk_batches_url)
  }
  batches_response <- list()
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- input_data[batch_id == batch, , drop=FALSE]   
    f <- tempfile()
    sf_write_csv(batched_data, f)
    httr_response <- rPOST(url = bulk_batches_url,
                          headers = c("Content-Type"="text/csv", 
                                      "Accept"="application/xml"),
                          body = upload_file(path=f, type="text/csv"))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, encoding="UTF-8")
    this_batch_info <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('//batchInfo') %>%
      map_df(xml_nodeset_to_df) %>%
      type_convert(col_types = cols())
    batches_response[[batch+1]] <- this_batch_info
  }
  batches_response <- bind_rows(batches_response)
  return(batches_response)
}

#' @importFrom utils object.size head
#' @importFrom stats quantile
sf_create_batches_bulk_v2 <- function(job_id, 
                                      input_data, 
                                      verbose=FALSE){
  
  job_status <- sf_get_job_bulk(job_id, api_type="Bulk 2.0", 
                                verbose = verbose)
  input_data <- sf_input_data_validation(operation=job_status$operation, 
                                         input_data)
  
  # A request can provide CSV data that does not in total exceed 150 MB of base64 
  # encoded content. When job data is uploaded, it is converted to base64. This 
  # conversion can increase the data size by approximately 50%. To account for 
  # the base64 conversion increase, upload data that does not exceed 100 MB. 
  # https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/upload_job_data.htm
  data_size <- object.size(input_data)
  numb_batches <- ceiling((as.numeric(data_size)/(1024^2))/100) # 100MB / (size converted to MB)
  batch_size <- ceiling(nrow(input_data) / numb_batches)
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose){
    message("Submitting data in ", max(batch_id)+1, " Batches")
  }
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  bulk_batches_url <- make_bulk_batches_url(job_id, api_type="Bulk 2.0")
  if(verbose) {
    message(bulk_batches_url)
  }
  
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- input_data[batch_id == batch, , drop=FALSE]   
    f <- tempfile()
    sf_write_csv(batched_data, f)
    httr_response <- rPUT(url = bulk_batches_url,
                          headers = c("Content-Type"="text/csv", 
                                      "Accept"="application/json"),
                          body = upload_file(path=f, type="text/csv"))
    catch_errors(httr_response)
  }
  # the batches will not start processing (move out of Queued state) until you signal "Upload Complete"
  upload_details <- sf_upload_complete_bulk(job_id, verbose = verbose)
  return(upload_details)
}

#' Checking the Status of a Batch in a Bulk API Job 
#' 
#' This function checks on and returns status information on an existing batch
#' which has already been submitted to Bulk API Job
#'
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @template job_id
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of parameters defining the batch identified by the batch_id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is a legacy function used only with Bulk 1.0.
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk(operation = "query", object = "Account")
#' soql <- "SELECT Id, Name FROM Account LIMIT 10"
#' batch_query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = soql)
#' submitted_batches <- sf_job_batches_bulk(job_id=batch_query_info$jobId)
#' job_close_ind <- sf_close_job_bulk(job_info$id)
#' sf_get_job_bulk(job_info$id)                               
#' }
#' @export
sf_job_batches_bulk <- function(job_id, api_type=c("Bulk 1.0"), verbose=FALSE){
  api_type <- match.arg(api_type)
  bulk_batch_status_url <- make_bulk_batches_url(job_id, api_type=api_type)
  if(verbose){
    message(bulk_batch_status_url)
  }
  httr_response <- rGET(url = bulk_batch_status_url)
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//batchInfo') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Checking the Status of a Batch in a Bulk API Job 
#' 
#' This function checks on and returns status information on an existing batch
#' which has already been submitted to Bulk API Job
#'
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @template job_id
#' @template batch_id
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of parameters defining the batch identified by the batch_id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is a legacy function used only with Bulk 1.0.
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk(operation = "query", object = "Account")
#' soql <- "SELECT Id, Name FROM Account LIMIT 10"
#' batch_query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = soql)
#' batch_status <- sf_batch_status_bulk(job_id=batch_query_info$jobId,
#'                                      batch_id=batch_query_info$id)
#' job_close_ind <- sf_close_job_bulk(job_info$id)
#' sf_get_job_bulk(job_info$id)                               
#' }
#' @export
sf_batch_status_bulk <- function(job_id, batch_id, api_type=c("Bulk 1.0"), 
                                 verbose=FALSE){
  api_type <- match.arg(api_type)
  bulk_batch_status_url <- make_bulk_batch_status_url(job_id, batch_id, api_type=api_type)
  if(verbose){
    message(bulk_batch_status_url)
  }
  httr_response <- rGET(url = bulk_batch_status_url)
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('//batchInfo') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  return(resultset)
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
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df}, formatted by salesforce, with information containing the success or failure or certain rows in a submitted batch, 
#' unless the operation was query, then it is a data.frame containing the result_id for retrieving the recordset.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note This is a legacy function used only with Bulk 1.0.
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk(operation = "query", object = "Account")
#' soql <- "SELECT Id, Name FROM Account LIMIT 10"
#' batch_query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = soql)
#' batch_details <- sf_batch_details_bulk(job_id=batch_query_info$jobId,
#'                                        batch_id=batch_query_info$id)
#' sf_close_job_bulk(job_info$id)
#' }
#' @export
sf_batch_details_bulk <- function(job_id, batch_id, api_type=c("Bulk 1.0"), 
                                  verbose = FALSE){
  api_type <- match.arg(api_type)
  job_status <- sf_get_job_bulk(job_id, api_type=api_type, verbose=verbose)
  bulk_batch_details_url <- make_bulk_batch_details_url(job_id, batch_id, api_type)
  if(verbose){
    message(bulk_batch_details_url)
  }
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
#' This function returns detailed (row-level) information on a job
#' which has already been submitted completed (successfully or not).
#'
#' @template job_id
#' @template api_type
#' @param record_types character; one or more types of records to retrieve from 
#' the results of running the specified job
#' @param combine_record_types logical; indicating for Bulk 2.0 jobs whether the 
#' successfulResults, failedResults, and unprocessedRecords should be stacked together 
#' using \code{bind_rows}
#' @template verbose
#' @return A \code{tbl_df} or \code{list} of \code{tbl_df}, formatted by Salesforce, 
#' with information containing the success or failure or certain rows in a submitted job
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note With Bulk 2.0 the order of records in the response is not guaranteed to 
#' match the ordering of records in the original job data.
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' input_data <- tibble(Name=c("Test Account 1", "Test Account 2"))
#' batches_result <- sf_create_batches_bulk(job_info$id, input_data)
#' # pause a few seconds for operation to finish. Wait longer if job is not complete.
#' Sys.sleep(3)
#' # check status using - sf_get_job_bulk(job_info$id)
#' job_record_details <- sf_get_job_records_bulk(job_id=job_info$id)
#' }
#' @export
sf_get_job_records_bulk <- function(job_id,
                                    api_type = c("Bulk 1.0", "Bulk 2.0"),
                                    record_types = c("successfulResults", 
                                                     "failedResults", 
                                                     "unprocessedRecords"), 
                                    combine_record_types=TRUE, 
                                    verbose=FALSE){
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){
    batch_records <- sf_get_job_records_bulk_v1(job_id, verbose=verbose)
  } else if(api_type == "Bulk 2.0"){
    batch_records <- sf_get_job_records_bulk_v2(job_id, 
                                                record_types=record_types, 
                                                combine_record_types=combine_record_types, 
                                                verbose=verbose)
                                                
  } else { 
    stop("Unknown API type")
  }
  return(batch_records)
}

#' @importFrom dplyr bind_rows
sf_get_job_records_bulk_v1 <- function(job_id, verbose=FALSE){
  batches_info <- sf_job_batches_bulk(job_id, api_type="Bulk 1.0", verbose=verbose)
  # loop through all the batches
  resultset <- NULL
  for(i in 1:nrow(batches_info)){
    this_batch_resultset <- sf_batch_details_bulk(job_id = job_id,
                                                  batch_id = batches_info$id[i], 
                                                  api_type="Bulk 1.0",
                                                  verbose = verbose)
    resultset <- bind_rows(resultset, this_batch_resultset)
  }
  return(resultset)
}

#' @importFrom readr read_csv
#' @importFrom httr content
#' @importFrom dplyr bind_rows
sf_get_job_records_bulk_v2 <- function(job_id,
                                       record_types = c("successfulResults", 
                                                        "failedResults", 
                                                        "unprocessedRecords"), 
                                       combine_record_types=TRUE, 
                                       verbose=FALSE){
  
  record_types <- match.arg(record_types, several.ok = TRUE)
  records <- list()
  for(r in record_types){
    bulk_job_records_url <- make_bulk_job_records_url(job_id, record_type = r, api_type="Bulk 2.0")
    if(verbose){
      message(bulk_job_records_url)
    }
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
  if(combine_record_types){
    res <- bind_rows(records)
  } else {
    res <- records
  }
  return(res)
}

#' Run Bulk Operation
#'
#' This function is a convenience wrapper for submitting bulk API jobs
#'
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into .csv file for submitting as batch request
#' @template object_name
#' @param operation character; string defining the type of operation being performed
#' @template external_id_fieldname
#' @template api_type
#' @param wait_for_results logical; indicating whether to wait for the operation to complete 
#' so that the batch results of individual records can be obtained
#' @param interval_seconds integer; defines the seconds between attempts to check 
#' for job completion
#' @param max_attempts integer; defines then max number attempts to check for job 
#' completion before stopping
#' @template verbose
#' @return A \code{tbl_df} of the results of the bulk job
#' @note With Bulk 2.0 the order of records in the response is not guaranteed to 
#' match the ordering of records in the original job data.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' n <- 20
#' new_contacts <- tibble(FirstName = rep("Test", n), 
#'                        LastName = paste0("Contact", 1:n))
#' # insert new records into the Contact object
#' inserts <- sf_bulk_operation(input_data = new_contacts, 
#'                              object_name = "Contact", 
#'                              operation = "insert")
#' }
#' @export
sf_bulk_operation <- function(input_data,
                              object_name,
                              operation = c("insert", "delete", "upsert", 
                                            "update", "hardDelete"),
                              external_id_fieldname = NULL,
                              api_type = c("Bulk 1.0", "Bulk 2.0"),
                              wait_for_results = TRUE,
                              interval_seconds = 3,
                              max_attempts = 200,
                              verbose = FALSE){

  stopifnot(!missing(operation))
  api_type <- match.arg(api_type)
  
  job_info <- sf_create_job_bulk(operation, object_name=object_name, 
                                 external_id_fieldname=external_id_fieldname, 
                                 api_type=api_type, verbose=verbose)
  batches_info <- sf_create_batches_bulk(job_id = job_info$id, input_data, 
                                         api_type=api_type, verbose=verbose)
  
  if(wait_for_results){
    status_complete <- FALSE
    z <- 1
    Sys.sleep(interval_seconds)
    while (z < max_attempts & !status_complete){
      if (verbose){
        if(z %% 5 == 0){
          message(paste0("Attempt to retrieve records #", z))
        }
      }
      Sys.sleep(interval_seconds)
      job_status <- sf_get_job_bulk(job_info$id, api_type=api_type, verbose=verbose)
      if(api_type == "Bulk 1.0"){
        if(job_status$state == 'Failed' | job_status$state == 'Aborted'){
          stop(job_status$stateMessage) # what does this do if job is aborted?
        } else {
          # check that all batches have been completed before declaring the job done
          job_batches <- sf_job_batches_bulk(job_info$id, api_type=api_type, verbose=verbose)
          if(all(job_batches$state == "Completed")){
            status_complete <- TRUE
          } else {
            # continue checking the status until done or max attempts
            z <- z + 1
          }
        }        
      } else if(api_type == "Bulk 2.0"){
        if(job_status$state == 'Failed'){
          stop(job_status$errorMessage)
        } else if(job_status$state == "JobComplete"){
          status_complete <- TRUE
        } else {
          # continue checking the status until done or max attempts
          z <- z + 1
        }        
      } else { 
        stop("Unknown API type")
      }
    }
    if (!status_complete) {
      message("Function's Time Limit Exceeded. Aborting Job Now")
      res <- sf_abort_job_bulk(job_info$id, api_type=api_type, verbose=verbose)
    } else {
      res <- sf_get_job_records_bulk(job_info$id, api_type=api_type, verbose=verbose)
      # For Bulk 2.0 jobs -> INVALIDJOBSTATE: Closing already Completed Job not allowed
      if(api_type == "Bulk 1.0"){
        close_job_info <- sf_close_job_bulk(job_info$id, api_type=api_type, verbose=verbose) 
      }
    } 
  } else {
    res <- job_info # at least return the job info if not waiting for records
  }
  return(res)
}
