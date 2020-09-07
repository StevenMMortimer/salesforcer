#' Create Bulk API Job 
#' 
#' This function initializes a Job in the Salesforce Bulk API
#'
#' @importFrom lifecycle deprecate_warn is_present deprecated
#' @template operation
#' @template object_name
#' @template soql
#' @template external_id_fieldname
#' @template api_type
#' @param content_type \code{character}; being one of 'CSV', 'ZIP_CSV', 'ZIP_XML', or 'ZIP_JSON' to 
#' indicate the type of data being passed to the Bulk APIs. For the Bulk 2.0 API the only 
#' valid value (and the default) is 'CSV'.
#' @param concurrency_mode \code{character}; either "Parallel" or "Serial" that specifies 
#' whether batches should be completed sequentially or in parallel. Use "Serial" 
#' only if lock contentions persist with in "Parallel" mode. Note: this argument is 
#' only used in the Bulk 1.0 API and will be ignored in calls using the Bulk 2.0 API.
#' @param column_delimiter \code{character}; indicating the column delimiter used for CSV job data. 
#' The default value is COMMA. Valid values are: "BACKQUOTE", "CARET", "COMMA", "PIPE", 
#' "SEMICOLON", and "TAB", but this package only accepts and uses "COMMA". Also, 
#' note that this argument is only used in the Bulk 2.0 API and will be ignored 
#' in calls using the Bulk 1.0 API.
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template line_ending
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
                                             "hardDelete", "query", "queryall"), 
                               object_name,
                               soql=NULL,
                               external_id_fieldname = NULL,
                               api_type = c("Bulk 1.0", "Bulk 2.0"),
                               content_type = c('CSV', 'ZIP_CSV', 'ZIP_XML', 'ZIP_JSON'),
                               concurrency_mode = c("Parallel", "Serial"),
                               column_delimiter = c('COMMA', 'TAB', 'PIPE', 'SEMICOLON', 
                                                    'CARET', 'BACKQUOTE'), 
                               control = list(...), ...,
                               line_ending = deprecated(),
                               verbose = FALSE){

  api_type <- match.arg(api_type)
  operation <- match.arg(operation)
  content_type <- match.arg(content_type)
  
  # determine how to pass along the control args
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- operation
  
  if(is_present(line_ending)) {
    deprecate_warn("0.1.3", "salesforcer::sf_create_job_bulk(line_ending = )", 
                   "sf_create_job_bulk(LineEndingHeader = )", 
                   details = paste0("You can pass the line ending directly ", 
                                    "as shown above or via the `control` argument."))
    control_args$LineEndingHeader <- list(`Sforce-Line-Ending` = line_ending)
  }
  
  if(api_type == "Bulk 1.0"){
    if(!missing(column_delimiter)){
      warning(paste0("Ignoring the column_delimiter argument which isn't used when ", 
                     "calling the Bulk 1.0 API", call. = FALSE))
    }
    job_response <- sf_create_job_bulk_v1(operation = operation,
                                          object_name = object_name,
                                          external_id_fieldname = external_id_fieldname,
                                          content_type = content_type,
                                          concurrency_mode = concurrency_mode,
                                          control = control_args, ...,
                                          verbose = verbose)
  } else if(api_type == "Bulk 2.0"){
    bulk_v2_supported_operations <- c("insert", "delete", "upsert", 
                                      "update", "query", "queryall")
    if(!(operation %in% bulk_v2_supported_operations)){
      stop_w_errors_listed("Bulk 2.0 only supports the following operations:", 
                           bulk_v2_supported_operations)
    }
    bulk_v2_supported_content_type <- c("CSV")
    if(!(content_type %in% bulk_v2_supported_content_type)){
      stop_w_errors_listed("Bulk 2.0 only supports the following content types:", 
                           bulk_v2_supported_operations)
    }
    if(!missing(concurrency_mode)){
      warning(paste0("Ignoring the concurrency_mode argument which is not ", 
                     "used when calling the Bulk 2.0 API"), call. = FALSE)
    }
    job_response <- sf_create_job_bulk_v2(operation = operation,
                                          object_name = object_name,
                                          soql = soql,
                                          external_id_fieldname = external_id_fieldname,
                                          content_type = content_type,
                                          column_delimiter = column_delimiter,
                                          control = control_args, ...,
                                          verbose = verbose)
  } else {
    catch_unknown_api(api_type)
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
                                                "hardDelete", "query", "queryall"), 
                                  object_name,
                                  external_id_fieldname = NULL,
                                  content_type = c('CSV', 'ZIP_CSV', 'ZIP_XML', 'ZIP_JSON'),
                                  concurrency_mode = c("Parallel", "Serial"),
                                  control, ...,
                                  verbose = FALSE){
  
  operation <- match.arg(operation)
  content_type <- match.arg(content_type)
  concurrency_mode <- match.arg(concurrency_mode)
  
  control <- do.call("sf_control", control)
  request_headers <- c("Accept"="application/xml", 
                       "Content-Type"="application/xml")
  if("BatchRetryHeader" %in% names(control)){
    request_headers <- c(request_headers, c("Sforce-Disable-Batch-Retry" = control$BatchRetryHeader[[1]]))
  }
  if("LineEndingHeader" %in% names(control)){
    bulk_supported_line_ending_headers <- c("CRLF", "LF")
    if(!(control$LineEndingHeader[[1]] %in% bulk_supported_line_ending_headers)){
      stop_w_errors_listed("Bulk APIs only supports the following line ending headers:", 
                           bulk_supported_line_ending_headers)
    }
    request_headers <- c(request_headers, c("Sforce-Line-Ending" = control$LineEndingHeader[[1]]))
  }
  if("PKChunkingHeader" %in% names(control)){
    if(is.logical(control$PKChunkingHeader[[1]]) | 
       tolower(control$PKChunkingHeader[[1]]) %in% c("true", "false")){
      request_headers <- c(request_headers, 
                           c("Sforce-Enable-PKChunking" = toupper(control$PKChunkingHeader[[1]])))  
    } else {
      l <- control$PKChunkingHeader
      value <- paste0(paste(names(l), unlist(l), sep="="), collapse = "; ")
      request_headers <- c(request_headers, c("Sforce-Enable-PKChunking" = value))
    }
  }
  
  # build xml for Bulk 1.0 request
  body <- xml_new_document()
  body %>%
    xml_add_child("jobInfo",
                  "xmlns" = "http://www.force.com/2009/06/asyncapi/dataload") %>%
    xml_add_child("operation", operation) %>%
    xml_add_sibling("object", object_name)
  
  if(operation == 'upsert'){
    if(is.null(external_id_fieldname)){
       stop("All 'upsert' operations require an external id field. Please specify.", call.=FALSE)
    } else {
      body %>% xml_add_child("externalIdFieldName", external_id_fieldname)
    }
  }
  
  body %>% 
    xml_add_child("concurrencyMode", concurrency_mode) %>%
    xml_add_child("contentType", content_type)
  
  request_body <- as.character(body)
  bulk_create_job_url <- make_bulk_create_job_url(api_type="Bulk 1.0")
  httr_response <- rPOST(url = bulk_create_job_url,
                         headers = request_headers, 
                         body = request_body)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              request_body)
  }
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
#' @importFrom jsonlite toJSON prettify
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_job_bulk_v2 <- function(operation = c("insert", "delete", 
                                                "upsert", "update", 
                                                "query", "queryall"),
                                  object_name,
                                  soql = NULL,
                                  external_id_fieldname = NULL,
                                  content_type = 'CSV',
                                  column_delimiter = c('COMMA', 'TAB', 'PIPE', 'SEMICOLON', 
                                                       'CARET', 'BACKQUOTE'), 
                                  control, ...,
                                  verbose=FALSE){
  
  operation <- match.arg(operation)
  column_delimiter <- match.arg(column_delimiter)
  if(content_type != "CSV"){
    stop("content_type = 'CSV' is currently the only supported format of returned bulk content.")
  }
  bulk_v2_supported_column_delimiter <- c("COMMA")
  if(!(column_delimiter %in% bulk_v2_supported_column_delimiter)){
    stop_w_errors_listed("Bulk 2.0 API only supports the following file delimiter:", 
                         bulk_v2_supported_column_delimiter)
  }
  if(operation == 'upsert' & is.null(external_id_fieldname)){
    stop("All 'upsert' operations require an external id field. Please specify.", call.=FALSE)
  }
  query_operation <- FALSE
  if(tolower(operation) %in% c("query", "queryall")){
    stopifnot(!is.null(soql))
    if(tolower(operation) == "queryall"){
      operation <- "queryAll"
    } else {
      operation <- "query"
    }
    query_operation <- TRUE
    # set this to NULL because for V2 queries, the 'object' property is not settable
    object_name <- NULL
  }
  
  control <- do.call("sf_control", control)
  if("LineEndingHeader" %in% names(control)){
    stopifnot(control$LineEndingHeader[[1]] %in% c("CRLF", "LF"))
    line_ending <- control$LineEndingHeader$`Sforce-Line-Ending`
  } else {
    if(get_os() == 'windows'){
      # line_ending <- "CRLF"
      # readr::write_csv always uses LF as of 1.3.1, but in the next version 
      # will allow users to to specify CRLF, which we will do automatically if 
      # get_os() == 'windows'
      # https://github.com/tidyverse/readr/issues/857
      line_ending <- "LF"
    } else {
      line_ending <- "LF"
    }
  }

  # form body from arguments
  request_body <- list(operation = operation,
                       query = soql,
                       object = object_name, 
                       contentType = content_type, 
                       externalIdFieldName = external_id_fieldname,
                       lineEnding = line_ending, 
                       columnDelimiter = column_delimiter)
  request_body[sapply(request_body, is.null)] <- NULL
  request_body <- toJSON(request_body, auto_unbox = TRUE)
  bulk_create_job_url <- make_bulk_create_job_url(api_type = "Bulk 2.0", 
                                                  query_operation = query_operation)
  httr_response <- rPOST(url = bulk_create_job_url,
                         headers = c("Accept"="application/json",
                                     "Content-Type"="application/json"), 
                         body = request_body)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              prettify(request_body))
  }
  catch_errors(httr_response)    
  response_parsed <- content(httr_response, encoding="UTF-8")
  job_info <- as_tibble(response_parsed)
  return(job_info)
}

#' Get Bulk API Job 
#' 
#' This function retrieves details about a Job in the Salesforce Bulk API
#'
#' @template job_id
#' @template api_type
#' @param query_operation \code{logical}; an indicator of whether the job is a query job, 
#' which is needed when using the Bulk 2.0 API because the URI endpoints are different 
#' for the "ingest" vs. the "query" jobs.
#' @template verbose
#' @return A \code{tbl_df} of parameters defining the details of the specified job id
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' refreshed_job_info <- sf_get_job_bulk(job_info$id)
#' sf_abort_job_bulk(refreshed_job_info$id)
#' }
#' @export
sf_get_job_bulk <- function(job_id, 
                            api_type = c("Bulk 1.0", "Bulk 2.0"), 
                            query_operation = FALSE,
                            verbose = FALSE){
  api_type <- match.arg(api_type)
  bulk_get_job_url <- make_bulk_get_job_url(job_id, 
                                            api_type=api_type, 
                                            query_operation=query_operation)
  httr_response <- rGET(url = bulk_get_job_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  if(api_type == "Bulk 1.0"){
    content_type <- httr_response$headers$`content-type`
    if (grepl('xml', content_type)){
      response_parsed <- content(httr_response, as='parsed', type="text/xml", encoding="UTF-8")
      job_info <- response_parsed %>%
        xml_ns_strip() %>%
        xml_find_all('//jobInfo') %>%
        map_df(xml_nodeset_to_df) %>%
        type_convert(col_types = cols())
    } else if(grepl('json', content_type)){
      response_parsed <- content(httr_response, as='parsed', type="application/json", encoding="UTF-8")
      response_parsed[sapply(response_parsed, is.null)] <- NA
      job_info <- as_tibble(response_parsed)
    } else {
      message(sprintf("Unhandled content-type: %s", content_type))
      job_info <- content(httr_response, as='parsed', encoding="UTF-8")
    }
  } else if(api_type == "Bulk 2.0"){
    response_parsed <- content(httr_response, encoding="UTF-8")
    job_info <- as_tibble(response_parsed)
  } else {
    catch_unknown_api(api_type, c("Bulk 1.0", "Bulk 2.0"))
  }
  return(job_info)
}

#' Get All Bulk API Jobs 
#' 
#' This function retrieves details about all Bulk jobs in the org.
#'
#' @importFrom httr content
#' @importFrom readr type_convert cols col_guess
#' @importFrom purrr map_df
#' @importFrom dplyr as_tibble bind_rows mutate_all
#' @param parameterized_search_list list; a list of parameters to be added as part 
#' of the URL query string (i.e. after a question mark ("?") so that the result 
#' only returns information about jobs that meet that specific criteria. For 
#' more information, read the note below and/or the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/get_all_jobs.htm}{here}.
#' @param next_records_url character (leave as NULL); a string used internally 
#' by the function to paginate through to more records until complete
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of parameters defining the details of all bulk jobs
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/get_all_jobs.htm}
#' @note parameterized_search_list elements that can be set to filter the results:
#' \itemize{
#'   \item{isPkChunkingEnabled}{A logical either TRUE or FALSE. TRUE only returns 
#'   information about jobs where PK Chunking has been enabled.}
#'   \item{jobType}{A character string to return jobs matching the specified type. 
#'   Must be one of: "BigObjectIngest", "Classic", "V2QIngest". Classic corresponds 
#'   to Bulk 1.0 API jobs and V2Ingest corresponds to the Bulk 2.0 API jobs.}
#' }
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' all_jobs_info <- sf_get_all_jobs_bulk()
#' # just the Bulk API 1.0 jobs
#' all_jobs_info <- sf_get_all_jobs_bulk(parameterized_search_list=list(jobType='Classic'))
#' }
#' @export
sf_get_all_jobs_bulk <- function(parameterized_search_list = 
                                   list(isPkChunkingEnabled=NULL, 
                                        jobType=NULL), 
                                 next_records_url = NULL, 
                                 api_type = c("Bulk 2.0"), 
                                 verbose = FALSE){
  api_type <- match.arg(api_type)
  this_url <- make_bulk_get_all_jobs_url(parameterized_search_list, 
                                         next_records_url, 
                                         api_type)
  httr_response <- rGET(url = this_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  
  if(length(response_parsed$records) > 0){
    resultset <- response_parsed$records %>% 
      map_df(as_tibble) %>% 
      mutate_all(as.character)
  } else {
    resultset <- tibble()
  }
  
  # check whether it has next record
  if(!response_parsed$done){
    next_records <- sf_get_all_jobs_bulk(parameterized_search_list = parameterized_search_list, 
                                         next_records_url = response_parsed$nextRecordsUrl,
                                         api_type = api_type, 
                                         verbose = verbose)
    resultset <- safe_bind_rows(list(resultset, next_records))
  }
  
  if(is.null(next_records_url) & (nrow(resultset) > 0)){
    resultset <- resultset %>%
      type_convert(col_types = cols(.default = col_guess()))
  }
  return(resultset)
}

#' Get All Bulk API Query Jobs 
#' 
#' This function retrieves details about all Bulk query jobs in the org.
#'
#' @importFrom httr content
#' @importFrom readr type_convert cols col_guess
#' @importFrom purrr map_df
#' @importFrom dplyr as_tibble bind_rows filter mutate_all across any_of
#' @param parameterized_search_list list; a list of parameters to be added as part 
#' of the URL query string (i.e. after a question mark ("?") so that the result 
#' only returns information about jobs that meet that specific criteria. For 
#' more information, read the note below and/or the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/query_get_all_jobs.htm}{here}.
#' @param next_records_url character (leave as NULL); a string used internally 
#' by the function to paginate through to more records until complete
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of parameters defining the details of all bulk jobs
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/get_all_jobs.htm}
#' @note parameterized_search_list elements that can be set to filter the results:
#' \itemize{
#'   \item{isPkChunkingEnabled}{A logical either TRUE or FALSE. TRUE only returns 
#'   information about jobs where PK Chunking has been enabled.}
#'   \item{jobType}{A character string to return jobs matching the specified type. 
#'   Must be one of: "BigObjectIngest", "Classic", "V2Query". Classic corresponds 
#'   to Bulk 1.0 API jobs and V2Query corresponds to the Bulk 2.0 API jobs.}
#'   \item{concurrencyMode}{A character string to return jobs matching the specified 
#'   concurrency mode. Must be one of: "serial" or "parallel", but only "serial" 
#'   is currently supported.}
#' }
#' @examples
#' \dontrun{
#' job_info <- sf_create_job_bulk('insert', 'Account')
#' all_query_jobs_info <- sf_get_all_query_jobs_bulk()
#' # just the Bulk API 2.0 query jobs
#' all_query_jobs_info <- sf_get_all_query_jobs_bulk(parameterized_search_list=list(jobType='V2Query'))
#' # just the Bulk API 1.0 query jobs
#' all_query_jobs_info <- sf_get_all_query_jobs_bulk(parameterized_search_list=list(jobType='Classic'))
#' }
#' @export
sf_get_all_query_jobs_bulk <- function(parameterized_search_list = 
                                         list(isPkChunkingEnabled=NULL,
                                              jobType=NULL, 
                                              concurrencyMode=NULL), 
                                       next_records_url = NULL, 
                                       api_type = c("Bulk 2.0"), 
                                       verbose = FALSE){
  api_type <- match.arg(api_type)
  this_url <- make_bulk_get_all_query_jobs_url(parameterized_search_list, 
                                               next_records_url, 
                                               api_type)
  httr_response <- rGET(url = this_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  
  if(length(response_parsed$records) > 0){
    resultset <- response_parsed$records %>% 
      map_df(as_tibble) %>% 
      mutate_all(as.character)
  } else {
    resultset <- tibble()
  }

  # check whether the query has more results to pull via pagination 
  if(!response_parsed$done){
    next_records <- sf_get_all_query_jobs_bulk(parameterized_search_list = parameterized_search_list, 
                                         next_records_url = response_parsed$nextRecordsUrl,
                                         api_type = api_type, 
                                         verbose = verbose)
    resultset <- safe_bind_rows(list(resultset, next_records))
  }
  
  # cast the data in the final iteration and remove Bulk 1.0 ingest operations
  # because as of 6/10/2020 the API will return both Bulk 1.0 query jobs and ingest 
  # jobs, for some reason, but to make it more straightforward for the user we 
  # will filter to only include the query jobs
  if(is.null(next_records_url) & (nrow(resultset) > 0)){
    # cast the data
    resultset <- resultset %>%
      type_convert(col_types = cols(.default = col_guess())) %>% 
      # ignore record ids that could not be matched
      filter(across(any_of("operation"), 
                    ~(.x %in% c('query', 'queryall')))) # is queryall an option?
  }
  return(resultset)
}

#' End Bulk API Job 
#' 
#' @importFrom jsonlite toJSON prettify
#' @template job_id
#' @param end_type \code{character}; taking a value of "Closed" or "Aborted" indicating 
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
  request_body <- toJSON(list(state=end_type), auto_unbox = TRUE)
  bulk_end_job_url <- make_bulk_end_job_generic_url(job_id, api_type)
  if(api_type == "Bulk 2.0"){
    httr_response <- rPATCH(url = bulk_end_job_url,
                            headers = c("Accept"="application/json", 
                                        "Content-Type"="application/json"), 
                            body = request_body)
  } else {
    httr_response <- rPOST(url = bulk_end_job_url,
                           headers = c("Accept"="application/json", 
                                       "Content-Type"="application/json"), 
                           body = request_body)  
  }
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              prettify(request_body))
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
sf_close_job_bulk <- function(job_id, 
                              api_type = c("Bulk 1.0", "Bulk 2.0"), 
                              verbose = FALSE){
  api_type <- match.arg(api_type)
  sf_end_job_bulk(job_id, end_type = "Closed", api_type = api_type, verbose = verbose)
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
sf_upload_complete_bulk <- function(job_id, 
                                    api_type = c("Bulk 2.0"), 
                                    verbose = FALSE){
  api_type <- match.arg(api_type)
  sf_end_job_bulk(job_id, end_type = "UploadComplete", api_type = api_type, verbose = verbose)
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
sf_abort_job_bulk <- function(job_id,
                              api_type = c("Bulk 1.0", "Bulk 2.0"), 
                              verbose = FALSE){
  api_type <- match.arg(api_type)
  sf_end_job_bulk(job_id, end_type = "Aborted", api_type = api_type, verbose = verbose)
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
sf_delete_job_bulk <- function(job_id, 
                               api_type = c("Bulk 2.0"), 
                               verbose = FALSE){
  api_type <- match.arg(api_type)
  bulk_delete_job_url <- make_bulk_delete_job_url(job_id, api_type = api_type)
  httr_response <- rDELETE(url = bulk_delete_job_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
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
#' \code{tbl_df}; data can be coerced into CSV file for submitting as batch request
#' @template batch_size
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
                                   batch_size = NULL,
                                   api_type = c("Bulk 1.0", "Bulk 2.0"),
                                   verbose = FALSE){
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){
    created_batches <- sf_create_batches_bulk_v1(job_id, input_data, 
                                                 batch_size = batch_size,
                                                 verbose = verbose)
  } else if(api_type == "Bulk 2.0"){
    created_batches <- sf_create_batches_bulk_v2(job_id, input_data, 
                                                 batch_size = batch_size,
                                                 verbose = verbose)
  } else { 
    catch_unknown_api(api_type, c("Bulk 1.0", "Bulk 2.0"))
  }
  return(created_batches)
}
  
#' @importFrom utils head
#' @importFrom stats quantile
#' @importFrom purrr transpose
#' @importFrom XML saveXML xmlDoc
#' @importFrom zip zipr
sf_create_batches_bulk_v1 <- function(job_id, 
                                      input_data,
                                      batch_size = NULL,
                                      verbose = FALSE){
  job_status <- sf_get_job_bulk(job_id, 
                                api_type = "Bulk 1.0", 
                                verbose = verbose)
  stopifnot(job_status$state == "Open")
  if(job_status$contentType %in% c("ZIP_CSV", "ZIP_XML", "ZIP_JSON")){
    binary_attachments <- TRUE
    input_data <- sf_input_data_validation(operation = sprintf("%s_%s", 
                                                               job_status$operation,
                                                               tolower(job_status$object)), 
                                           input_data)
    input_data <- check_and_encode_files(input_data, encode=FALSE)
  } else {
    binary_attachments <- FALSE
    input_data <- sf_input_data_validation(operation = job_status$operation, input_data)
  }
  
  if(binary_attachments){
    # Binary content Bulk API Limits: 
    #  - The length of any file name can’t exceed 512 bytes.
    #  - A zip file can’t exceed 10 MB.
    #  - The total size of the unzipped content can’t exceed 20 MB.
    #  - A maximum of 1,000 files can be contained in a zip file. Directories don’t 
    #    count toward this total.
    # https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_concepts_limits.htm#binary_content_title
    # TODO: Determine if we want to check the following for the user or allow Salesforce 
    # to return errors back to the user for them to correct 
    #  - Check that each Name and Body is unique?
    #  - Check file name < 512 bytes?
    #  - Check if the number of files in a batch is greater than 1000, if so, then repartition
    if(is.null(batch_size)){
      # use conservative approach and batch in 10MB unzipped, which will be < 10MB zipped
      file_sizes_mb <- sapply(input_data$Body, file.size, USE.NAMES = FALSE) / 1000000
      if(any(file_sizes_mb > 10)){
        stop_w_errors_listed(paste0("The max file size limit is 10MB. The following ", 
                                    "files exceed that limit:"), 
                                    input_data$Name[file_sizes_mb > 10])
      }
      batch_id <- floor(cumsum(file_sizes_mb) / 10)
    } else {
      if (batch_size > 10){
        message(sprintf("It appears that you have set `batch_size=%s` while uploading binary blob data.", batch_size))
        message("It is highly recommended to leave `batch_size=NULL` so that the batch sizes can be optimized for you.")
      }
      batch_id <- (seq.int(1:length(input_data$Body))-1) %/% batch_size
    }
    if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
    message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
    
    bulk_batches_url <- make_bulk_batches_url(job_id, api_type="Bulk 1.0")
    batches_response <- list()
    tmpdir <- tempdir(TRUE)
    for(batch in seq(0, max(batch_id))){
      if(verbose){
        batch_msg_flg <- batch %in% message_flag
        if(batch_msg_flg){
          message(paste0("Processing Batch # ", head(batch, 1) + 1))
        } 
      }
      # zip the lists of files from each batch
      batched_data <- input_data[batch_id == batch, , drop=FALSE]
      # create manifest of files in batched zip file
      # convert Body file references to relative within the zip file (i.e. add leading #)
      orig_paths <- batched_data$Body
      batched_data$Body <- paste0("#", basename(batched_data$Body))
      f1a <- tempfile(fileext = "_request.txt")
      if(job_status$contentType == "ZIP_CSV"){
        # make a unique file name and save the request txt file
        write_csv(batched_data, f1a)
      } else if(job_status$contentType == "ZIP_XML"){
        xml_manifest <- build_manifest_xml_from_list(transpose(batched_data, .names=rep("sObject", nrow(batched_data))))
        invisible(saveXML(xmlDoc(xml_manifest), file=f1a, indent=FALSE, 
                          prefix='<?xml version="1.0" encoding="UTF-8"?>\n'))
      } else if(job_status$contentType == "ZIP_JSON"){
        # stop if all Name column values are not equal to Body without "#"
        if(!all(batched_data$Name == gsub("^#", "", batched_data$Body))){
          stop("When using content_type='ZIP_JSON' the values in Name must match the base file name exactly. Fix or use content_type='ZIP_CSV'.")
        }
        write(toJSON(batched_data), f1a)
      } else {
        stop("Unsupported content type for binary attachments.")
      }
      # copy the file and rename the file because it is required to be called 
      # request.txt by Salesforce
      f1b <- file.path(tmpdir, "request.txt")
      invisible(file.copy(from = f1a, to = f1b, overwrite = TRUE))
      # create the batched zip file with the manifest inside
      f2 <- tempfile(fileext = ".zip")
      zipr(f2, c(f1b, orig_paths))
      
      # set content type to match the format of the zip file and its manifest
      zip_content_type <- gsub("_", "/", tolower(job_status$contentType))
      httr_response <- rPOST(url = bulk_batches_url,
                             headers = c("Content-Type"=zip_content_type, 
                                         "Accept"="application/xml"),
                             body = upload_file(path=f2, type=zip_content_type))
      if(verbose){
        make_verbose_httr_message(httr_response$request$method, 
                                  httr_response$request$url, 
                                  httr_response$request$headers, 
                                  sprintf("Uploaded ZIP file: %s\nWith manifest: %s", f2, f1a))
      }
      catch_errors(httr_response)
      content_type <- httr_response$headers$`content-type`
      if (grepl('xml', content_type)){
        response_parsed <- content(httr_response, as='parsed', type="text/xml", encoding="UTF-8")
        this_batch_info <- response_parsed %>%
          xml_ns_strip() %>%
          xml_find_all('//batchInfo') %>%
          map_df(xml_nodeset_to_df) %>%
          type_convert(col_types = cols())
      } else if(grepl('json', content_type)){
        response_parsed <- content(httr_response, as='parsed', type="application/json", encoding="UTF-8")
        response_parsed[sapply(response_parsed, is.null)] <- NA
        this_batch_info <- response_parsed
      } else {
        message(sprintf("Unhandled content-type: %s", content_type))
        this_batch_info <- content(httr_response, as='parsed', encoding="UTF-8")
      }
      batches_response[[batch+1]] <- this_batch_info
    }
  } else {
    # Batch sizes should be adjusted based on processing times. Start with 5000 
    # records and adjust the batch size based on processing time. If it takes more 
    # than five minutes to process a batch, it may be beneficial to reduce the batch size. 
    # If it takes a few seconds, the batch size should be increased. If you get a 
    # timeout error when processing a batch, split your batch into smaller batches, 
    # and try again.
    # https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_planning_guidelines.htm
    if(is.null(batch_size)){
      batch_size <- 5000
    }
    row_num <- nrow(input_data)
    batch_id <- (seq.int(row_num)-1) %/% batch_size
    if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
    message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
    
    bulk_batches_url <- make_bulk_batches_url(job_id, api_type="Bulk 1.0")
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
      if(verbose){
        make_verbose_httr_message(httr_response$request$method, 
                                  httr_response$request$url, 
                                  httr_response$request$headers, 
                                  sprintf("Uploaded CSV file: %s", f))
      }
      catch_errors(httr_response)
      response_parsed <- content(httr_response, encoding="UTF-8")
      this_batch_info <- response_parsed %>%
        xml_ns_strip() %>%
        xml_find_all('//batchInfo') %>%
        map_df(xml_nodeset_to_df) %>%
        type_convert(col_types = cols())
      batches_response[[batch+1]] <- this_batch_info
    }
  }
  batches_response <- safe_bind_rows(batches_response)
  return(batches_response)
}

#' @importFrom utils object.size head
#' @importFrom stats quantile
sf_create_batches_bulk_v2 <- function(job_id, 
                                      input_data,
                                      batch_size = NULL,
                                      verbose = FALSE){
  job_status <- sf_get_job_bulk(job_id, 
                                api_type = "Bulk 2.0", 
                                verbose = verbose)
  input_data <- sf_input_data_validation(operation = job_status$operation, 
                                         input_data)
  # A request can provide CSV data that does not in total exceed 150 MB of base64 
  # encoded content. When job data is uploaded, it is converted to base64. This 
  # conversion can increase the data size by approximately 50%. To account for 
  # the base64 conversion increase, upload data that does not exceed 100 MB. 
  # https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/upload_job_data.htm
  if(is.null(batch_size)){
    data_size <- object.size(input_data)
    numb_batches <- ceiling((as.numeric(data_size)/(1024^2))/100) # 100MB / (size converted to MB)
    batch_size <- ceiling(nrow(input_data) / numb_batches)
  }
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  bulk_batches_url <- make_bulk_batches_url(job_id, api_type="Bulk 2.0")
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
    if(verbose){
      make_verbose_httr_message(httr_response$request$method, 
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                sprintf("Uploaded CSV file: %s", f))
    }
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
sf_job_batches_bulk <- function(job_id, 
                                api_type = c("Bulk 1.0"), 
                                verbose = FALSE){
  api_type <- match.arg(api_type)
  bulk_batch_status_url <- make_bulk_batches_url(job_id, api_type = api_type)
  httr_response <- rGET(url = bulk_batch_status_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  content_type <- httr_response$headers$`content-type`
  if (grepl('xml', content_type)){
    response_parsed <- content(httr_response, as='parsed', type="text/xml", encoding="UTF-8")
    resultset <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//batchInfo') %>%
      map_df(xml_nodeset_to_df) %>%
      type_convert(col_types = cols())
  } else if(grepl('json', content_type)){
    response_parsed <- content(httr_response, as='parsed', type="application/json", encoding="UTF-8")
    response_parsed <- response_parsed$batchInfo %>% 
      map(function(x) map(x, function(y) ifelse(is.null(y), NA, y)))
    resultset <- safe_bind_rows(response_parsed) %>%
      type_convert(col_types = cols())
  } else {
    message(sprintf("Unhandled content-type: %s", content_type))
    resultset <- content(httr_response, as='parsed', encoding="UTF-8")
  }
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
#' batch_status <- sf_batch_status_bulk(job_id = batch_query_info$jobId,
#'                                      batch_id = batch_query_info$id)
#' job_close_ind <- sf_close_job_bulk(job_info$id)
#' sf_get_job_bulk(job_info$id)                               
#' }
#' @export
sf_batch_status_bulk <- function(job_id, batch_id, 
                                 api_type = c("Bulk 1.0"), 
                                 verbose = FALSE){
  api_type <- match.arg(api_type)
  bulk_batch_status_url <- make_bulk_batch_status_url(job_id, batch_id, api_type = api_type)
  httr_response <- rGET(url = bulk_batch_status_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  content_type <- httr_response$headers$`content-type`
  if (grepl('xml', content_type)){
    response_parsed <- content(httr_response, as='parsed', type="text/xml", encoding="UTF-8")
    resultset <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('//batchInfo') %>%
      map_df(xml_nodeset_to_df) %>%
      type_convert(col_types = cols())
  } else if(grepl('json', content_type)){
    response_parsed <- content(httr_response, as='parsed', type="application/json", encoding="UTF-8")
    response_parsed <- response_parsed$batchInfo %>% 
      map(function(x) map(x, function(y) ifelse(is.null(y), NA, y)))
    resultset <- safe_bind_rows(response_parsed) %>%
      type_convert(col_types = cols())
  } else {
    message(sprintf("Unhandled content-type: %s", content_type))
    resultset <- content(httr_response, as='parsed', encoding="UTF-8")
  }
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
#' @return A \code{tbl_df}, formatted by Salesforce, with information containing 
#' the success or failure or certain rows in a submitted batch, unless the operation 
#' was query, then it is a data.frame containing the result_id for retrieving the recordset.
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
sf_batch_details_bulk <- function(job_id, batch_id, 
                                  api_type = c("Bulk 1.0"), 
                                  verbose = FALSE){
  api_type <- match.arg(api_type)
  job_status <- sf_get_job_bulk(job_id, api_type = api_type, verbose = verbose)
  bulk_batch_details_url <- make_bulk_batch_details_url(job_id, batch_id, api_type)
  httr_response <- rGET(url = bulk_batch_details_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  content_type <- httr_response$headers$`content-type`
  if(content_type == 'text/csv' | content_type == 'zip/csv'){
    response_text <- content(httr_response, as="text", encoding="UTF-8")
    res <- read_csv(response_text)
  } else if(content_type == 'zip/xml'){
    response_parsed <- content(httr_response, as="parsed", type="text/xml", encoding="UTF-8")
    res <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>% 
      map_df(xml_nodeset_to_df)
  } else if(content_type == 'zip/json'){
    response_text <- content(httr_response, as="text", encoding="UTF-8")
    res <- fromJSON(response_text)
  } else if(grepl('xml', content_type)){
    response_text <- content(httr_response, as="text", encoding="UTF-8")
    res <- xmlToList(response_text)
  } else {
    message(sprintf("Unhandled content-type: %s", content_type))
    res <- content(httr_response, as="parsed", encoding="UTF-8")
  }
  
  res <- res %>%
    as_tibble() %>%
    sf_reorder_cols() %>% 
    sf_guess_cols(TRUE)
  
  return(res)
}

#' Returning the Details of a Bulk API Job 
#' 
#' This function returns detailed (row-level) information on a job
#' which has already been submitted completed (successfully or not).
#'
#' @template job_id
#' @template api_type
#' @param record_types \code{character}; one or more types of records to retrieve from 
#' the results of running the specified job
#' @param combine_record_types \code{logical}; indicating for Bulk 2.0 jobs whether the 
#' successfulResults, failedResults, and unprocessedRecords should be stacked 
#' together by binding the rows.
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
                                    combine_record_types = TRUE, 
                                    verbose = FALSE){
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){
    batch_records <- sf_get_job_records_bulk_v1(job_id, verbose = verbose)
  } else if(api_type == "Bulk 2.0"){
    batch_records <- sf_get_job_records_bulk_v2(job_id, 
                                                record_types = record_types, 
                                                combine_record_types = combine_record_types, 
                                                verbose = verbose)
  } else {
    catch_unknown_api(api_type, c("Bulk 1.0", "Bulk 2.0"))
  }
  return(batch_records)
}

sf_get_job_records_bulk_v1 <- function(job_id, verbose = FALSE){
  batches_info <- sf_job_batches_bulk(job_id, api_type = "Bulk 1.0", verbose = verbose)
  # loop through all the batches
  resultset <- NULL
  for(i in 1:nrow(batches_info)){
    this_batch_resultset <- sf_batch_details_bulk(job_id = job_id,
                                                  batch_id = batches_info$id[i], 
                                                  api_type = "Bulk 1.0",
                                                  verbose = verbose)
    resultset <- safe_bind_rows(list(resultset, this_batch_resultset))
  }
  return(resultset)
}

#' @importFrom readr read_csv
#' @importFrom httr content
sf_get_job_records_bulk_v2 <- function(job_id,
                                       record_types = c("successfulResults", 
                                                        "failedResults", 
                                                        "unprocessedRecords"), 
                                       combine_record_types = TRUE, 
                                       verbose = FALSE){
  
  record_types <- match.arg(record_types, several.ok = TRUE)
  records <- list()
  for(r in record_types){
    bulk_job_records_url <- make_bulk_job_records_url(job_id, record_type = r, api_type = "Bulk 2.0")
    httr_response <- rGET(url = bulk_job_records_url)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method, 
                                httr_response$request$url, 
                                httr_response$request$headers)
    }
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
    # Before combining, try to match the data types of each column in the dataset 
    # with recordsets having 0 records taking on the datatype of the one with 
    # the most records. Otherwise, we will receive an error such as: 
    #   Can't combine `test_number__c` <double> and `test_number__c` <character>.
    
    # First, determine the column datatypes from the data.frame with most rows
    base_class_df <- records[[head(which.max(sapply(records, nrow)), 1)]]
    # Second, convert the datatypes for any data.frames with zero rows
    for (i in 1:length(records)){
      if(nrow(records[[i]]) == 0){
        common <- names(records[[i]])[names(records[[i]]) %in% names(base_class_df)]
        records[[i]][common] <- lapply(common, function(x) {
          match.fun(paste0("as.", class(base_class_df[[x]])))(records[[i]][[x]])
        })
      }
    }
    # Third, now bind them together
    res <- safe_bind_rows(records)
  } else {
    res <- records
  }
  return(res)
}

#' Run Bulk Operation
#' 
#' @description
#' `r lifecycle::badge("maturing")`
#' 
#' This function is a convenience wrapper for submitting bulk API jobs
#'
#' @importFrom dplyr is.tbl
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into CSV file for submitting as batch request
#' @template object_name
#' @param operation \code{character}; string defining the type of operation being performed
#' @template external_id_fieldname
#' @template guess_types
#' @template api_type
#' @template batch_size
#' @template interval_seconds
#' @template max_attempts
#' @param wait_for_results \code{logical}; indicating whether to wait for the operation to complete 
#' so that the batch results of individual records can be obtained
#' @template control
#' @param ... other arguments passed on to \code{\link{sf_control}} or \code{\link{sf_create_job_bulk}} 
#' to specify the \code{content_type}, \code{concurrency_mode}, and/or \code{column_delimiter}.
#' @template verbose
#' @return A \code{tbl_df} of the results of the bulk job
#' @note With Bulk 2.0 the order of records in the response is not guaranteed to 
#' match the ordering of records in the original job data.
#' @seealso \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}{Salesforce Documentation}
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
sf_run_bulk_operation <- function(input_data,
                                  object_name,
                                  operation = c("insert", "delete", "upsert", 
                                                "update", "hardDelete"),
                                  external_id_fieldname = NULL,
                                  guess_types = TRUE,
                                  api_type = c("Bulk 1.0", "Bulk 2.0"),
                                  batch_size = NULL,
                                  interval_seconds = 3,
                                  max_attempts = 200,
                                  wait_for_results = TRUE,
                                  control = list(...), ...,
                                  verbose = FALSE){

  stopifnot(!missing(operation))
  api_type <- match.arg(api_type)
  
  # this code is redundant because it exists in the sf_create, sf_update, etc.
  # wrappers, but it is possible that some people are creating jobs with this
  # function instead of the others, so make sure that we do it here as well. It
  # should be a relatively small performance hit given its a bulk operation
  
  # determine how to pass along the control args
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- operation
  
  job_info <- sf_create_job_bulk(operation, 
                                 object_name = object_name, 
                                 external_id_fieldname = external_id_fieldname, 
                                 api_type = api_type,
                                 control = control_args, ...,
                                 verbose = verbose)
  
  batches_info <- sf_create_batches_bulk(job_id = job_info$id, 
                                         input_data,
                                         batch_size = batch_size,
                                         api_type = api_type,
                                         verbose = verbose)
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
      job_status <- sf_get_job_bulk(job_info$id, api_type = api_type, verbose = verbose)
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
        catch_unknown_api(api_type, c("Bulk 1.0", "Bulk 2.0"))
      }
    }
    if (!status_complete) {
      message("Function's Time Limit Exceeded. Aborting Job Now")
      res <- sf_abort_job_bulk(job_info$id, api_type = api_type, verbose = verbose)
    } else {
      res <- sf_get_job_records_bulk(job_info$id, api_type = api_type, verbose = verbose)
      # For Bulk 2.0 jobs -> INVALIDJOBSTATE: Closing already Completed Job not allowed
      if(api_type == "Bulk 1.0"){
        close_job_info <- sf_close_job_bulk(job_info$id, api_type = api_type, verbose = verbose) 
      }
    } 
  } else {
    res <- job_info # at least return the job info if not waiting for records
  }
  
  if(is.tbl(res)){
    res <- res %>% 
      sf_reorder_cols() %>% 
      sf_guess_cols(guess_types)
  }
  
  return(res)
}

# allows for the inclusion of sf_run version of the function for a consistent
# interface as other "run" functions provided by the package which are a wrapper
# around more complex data processing tasks in Salesforce
#' @export
#' @rdname sf_run_bulk_operation
sf_bulk_operation <- sf_run_bulk_operation
