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
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_bulk_query_intro.htm}{Bulk 1.0 documentation}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 1000"
#' job_info <- sf_create_job_bulk(operation = 'query', object = 'Account')
#' query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = my_query)
#' }
#' @export
sf_submit_query_bulk <- function(job_id, 
                                 soql, 
                                 api_type = c("Bulk 1.0"), 
                                 verbose = FALSE){
  
  api_type <- match.arg(api_type)
  bulk_query_url <- make_bulk_query_url(job_id, api_type = api_type)
  f <- tempfile()
  cat(soql, file=f)
  httr_response <- rPOST(url = bulk_query_url,
                         headers = c("Content-Type"="text/csv; charset=UTF-8"),
                         body = upload_file(path=f, type='text/txt'))
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              sprintf("Uploaded TXT file: %s", f))
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('//batchInfo') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Retrieve the results of a completed bulk query
#' 
#' This function returns the recordset of a bulk query which has already been 
#' submitted to the Bulk 1.0 or Bulk 2.0 API and has completed.
#' 
#' @template job_id
#' @template batch_id
#' @param result_id \code{character}; a string returned from 
#' \link{sf_batch_details_bulk} when a query has completed and specifies how to 
#' get the recordset
#' @template guess_types
#' @template bind_using_character_cols
#' @template batch_size
#' @template api_type
#' @template verbose
#' @return \code{tbl_df}, formatted by Salesforce, containing query results
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_bulk_query_intro.htm}{Bulk 1.0 documentation} and \href{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/queries.htm}{Bulk 2.0 documentation}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 1000"
#' job_info <- sf_create_job_bulk(operation = 'query', object = 'Account')
#' query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = my_query)
#' result <- sf_batch_details_bulk(job_id = query_info$jobId,
#'                                 batch_id = query_info$id)
#' recordset <- sf_query_result_bulk(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_close_job_bulk(job_info$id)
#' }
#' @export
sf_query_result_bulk <- function(job_id,
                                 batch_id = NULL, 
                                 result_id = NULL,
                                 guess_types = TRUE,
                                 bind_using_character_cols = FALSE,
                                 batch_size = 50000,
                                 api_type = c("Bulk 1.0", "Bulk 2.0"), 
                                 verbose = FALSE){
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    resultset <- sf_query_result_bulk_v2(job_id = job_id, 
                                         guess_types = guess_types,
                                         bind_using_character_cols = bind_using_character_cols,
                                         batch_size = batch_size,
                                         locator = NULL,
                                         api_type = api_type,
                                         verbose = verbose)      
  } else {
    resultset <- sf_query_result_bulk_v1(job_id = job_id, 
                                         batch_id = batch_id, 
                                         result_id = result_id,
                                         guess_types = guess_types,
                                         bind_using_character_cols = bind_using_character_cols,
                                         api_type = api_type,
                                         verbose = verbose)    
  }
  return(resultset)
}


#' Retrieve the results of a Bulk 1.0 query
#' 
#' This function returns the row-level recordset of a Bulk 1.0 query
#' which has already been submitted to Bulk API Job and has Completed state
#' 
#' @importFrom readr col_guess col_character
#' @importFrom httr content
#' @importFrom XML xmlToList
#' @importFrom dplyr is.tbl as_tibble tibble select any_of matches everything
#' @template job_id
#' @template batch_id
#' @param result_id \code{character}; a string returned from 
#' \link{sf_batch_details_bulk} when a query has completed and specifies how to 
#' get the recordset
#' @template guess_types
#' @template bind_using_character_cols
#' @template api_type
#' @template verbose
#' @return \code{tbl_df}, formatted by Salesforce, containing query results
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_bulk_query_intro.htm}{Bulk 1.0 documentation}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 1000"
#' job_info <- sf_create_job_bulk(operation = 'query', object = 'Account', api_type="Bulk 1.0")
#' query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = my_query, api_type="Bulk 1.0")
#' result <- sf_batch_details_bulk(job_id = query_info$jobId,
#'                                 batch_id = query_info$id)
#' recordset <- sf_query_result_bulk(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_close_job_bulk(job_info$id, api_type="Bulk 1.0")
#' }
#' @export
sf_query_result_bulk_v1 <- function(job_id, 
                                    batch_id = NULL, 
                                    result_id = NULL,                                    
                                    guess_types = TRUE,
                                    bind_using_character_cols = FALSE,
                                    api_type = c("Bulk 1.0"), 
                                    verbose = FALSE){
  api_type <- match.arg(api_type)
  bulk_query_result_url <- make_bulk_query_result_url(job_id, batch_id, result_id, api_type)
  httr_response <- rGET(url = bulk_query_result_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_text <- content(httr_response, type="text/plain", encoding="UTF-8")
  
  content_type <- httr_response$headers$`content-type`
  if (grepl('xml', content_type)) {
    resultset <- as_tibble(xmlToList(response_text))
  } else if(grepl('text/csv', content_type)) {
    if(response_text == "Records not found for this query"){
      resultset <- tibble()
    } else {
      cols_default <- if(bind_using_character_cols | 
                         !guess_types) col_character() else col_guess()
      resultset <- content(httr_response, as="parsed", encoding="UTF-8", 
                           col_types = cols(.default=cols_default))
    }
  } else {
    message(sprintf("Unhandled content-type: %s", content_type))
    resultset <- content(httr_response, as="parsed", encoding="UTF-8")
  }

  if(is.tbl(resultset)){
    resultset <- resultset %>% 
      sf_reorder_cols() %>% 
      sf_guess_cols(guess_types)
  }
  
  return(resultset)
}


#' Retrieve the results of a Bulk 2.0 query
#' 
#' This function returns the row-level recordset of a Bulk 2.0 query
#' which has already been submitted as a Bulk 2.0 API job and has a JobComplete
#' state.
#' 
#' @importFrom readr col_guess col_character type_convert
#' @importFrom httr content parse_url build_url
#' @importFrom dplyr is.tbl select any_of contains
#' @template job_id
#' @template guess_types
#' @template bind_using_character_cols
#' @template batch_size
#' @param locator \code{character}; a string returned found in the API response 
#' header of a prior iteration of \link{sf_query_result_bulk_v2} that is included 
#' in the query string of the next call to paginate through all records returned 
#' by the query.
#' @template api_type
#' @template verbose
#' @return \code{tbl_df}, formatted by Salesforce, containing query results
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/queries.htm}{Bulk 2.0 documentation}
#' @examples
#' \dontrun{
#' my_query <- "SELECT Id, Name FROM Account LIMIT 1000"
#' job_info <- sf_create_job_bulk(operation = 'query', object = 'Account', api_type="Bulk 2.0")
#' query_info <- sf_submit_query_bulk(job_id = job_info$id, soql = my_query, api_type="Bulk 2.0")
#' result <- sf_batch_details_bulk(job_id = query_info$jobId,
#'                                 batch_id = query_info$id)
#' recordset <- sf_query_result_bulk(job_id = query_info$jobId,
#'                                   batch_id = query_info$id,
#'                                   result_id = result$result)
#' sf_close_job_bulk(job_info$id, api_type="Bulk 2.0")
#' }
#' @export
sf_query_result_bulk_v2 <- function(job_id, 
                                    guess_types = TRUE,
                                    bind_using_character_cols = FALSE,
                                    batch_size = 50000,
                                    locator = NULL,
                                    api_type = c("Bulk 2.0"), 
                                    verbose = FALSE){  
  
  api_type <- match.arg(api_type)

  # construct the url for requesting the records
  bulk_query_result_url <- make_bulk_query_result_url(job_id, api_type=api_type)
  query_params <- list(locator=locator, maxRecords=batch_size)
  bulk_query_result_url <- parse_url(bulk_query_result_url)
  bulk_query_result_url$query <- query_params
  bulk_query_result_url <- build_url(bulk_query_result_url)
  
  httr_response <- rGET(url = bulk_query_result_url, headers = c("Accept"="text/csv"))
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  
  content_type <- httr_response$headers$`content-type`
  if(grepl('text/csv', content_type)) {
    cols_default <- if(bind_using_character_cols | 
                       !guess_types) col_character() else col_guess()
    resultset <- content(httr_response, as="parsed", encoding="UTF-8", 
                         col_types = cols(.default=cols_default))
  } else {
    message(sprintf("Unexpected content-type: %s", content_type))
    resultset <- content(httr_response, as="parsed", encoding="UTF-8")
  }
  
  # check whether the query has more results to pull via pagination
  locator <- httr_response$headers$`sforce-locator`
  if(!is.null(locator) && locator != "null"){
    next_records <- sf_query_result_bulk_v2(job_id = job_id, 
                                            guess_types = guess_types,
                                            bind_using_character_cols = bind_using_character_cols,
                                            batch_size = batch_size,
                                            locator = locator,
                                            api_type = api_type,
                                            verbose = verbose)
    resultset <- safe_bind_rows(list(resultset, next_records))
  }
  
  if(is.tbl(resultset)){
    resultset <- resultset %>% 
      sf_reorder_cols() %>% 
      sf_guess_cols(guess_types)
  }
  
  return(resultset)  
}

#' Run Bulk 1.0 query 
#' 
#' This function is a convenience wrapper for submitting and retrieving 
#' query API jobs from the Bulk 1.0 API.
#'
#' @importFrom dplyr filter across any_of bind_rows is.tbl
#' @template soql
#' @template object_name
#' @template queryall
#' @template guess_types
#' @template bind_using_character_cols
#' @template interval_seconds
#' @template max_attempts
#' @template control
#' @param ... other arguments passed on to \code{\link{sf_control}} or \code{\link{sf_create_job_bulk}} 
#' to specify the \code{content_type}, \code{concurrency_mode}, and/or \code{column_delimiter}.
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of the recordset returned by the query
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_bulk_query_intro.htm}{Bulk 1.0 documentation}
#' @examples
#' \dontrun{
#' # select all Ids from Account object (up to 1000)
#' ids <- sf_query_bulk_v1(soql = 'SELECT Id FROM Account LIMIT 1000', 
#'                         object_name = 'Account')
#' # alternatively you can specify as 
#' ids <- sf_query(soql = 'SELECT Id FROM Account LIMIT 1000', 
#'                 object_name = 'Account', 
#'                 api_type="Bulk 1.0")
#' }
#' @export
sf_query_bulk_v1 <- function(soql,
                             object_name = NULL,
                             queryall = FALSE,
                             guess_types = TRUE,
                             bind_using_character_cols = FALSE,
                             interval_seconds = 3,
                             max_attempts = 200, 
                             control = list(...), ...,
                             api_type = "Bulk 1.0",
                             verbose = FALSE){
  
  if(is.null(object_name)){
    object_name <- guess_object_name_from_soql(soql)
  }
  listed_objects <- sf_list_objects()
  valid_object_names <- sapply(listed_objects$sobjects, FUN=function(x){x$name})
  if(!object_name %in% valid_object_names){
    stop(sprintf(paste0("The supplied object name (%s) does not exist or ", 
                        "the user does not have permission to view"), object_name), 
         call.=FALSE)
  }

  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  this_operation <- if(queryall) "queryall" else "query"
  control_args$operation <- this_operation
  
  job_info <- sf_create_job_bulk(operation = this_operation,
                                 object_name = object_name, 
                                 api_type = api_type, 
                                 control = control_args,
                                 verbose = verbose, ...)
  batch_query_info <- sf_submit_query_bulk(job_id = job_info$id, 
                                           soql = soql, 
                                           api_type = api_type, 
                                           verbose = verbose)
  status_complete <- FALSE
  z <- 1
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    if (verbose){
      message(paste0("Attempt #", z))
    }
    Sys.sleep(interval_seconds)
    batch_query_status <- sf_batch_status_bulk(job_id = batch_query_info$jobId,
                                               batch_id = batch_query_info$id, 
                                               api_type = api_type, 
                                               verbose = verbose)
    if(batch_query_status$state == 'Failed'){
      stop(batch_query_status$stateMessage)
    } else if(batch_query_status$state == "Completed"){
      status_complete <- TRUE
    } else if(batch_query_status$state == "NotProcessed") {
      # this means it was a successfully submitted PKChunked query, now check
      # for the child batches of this job (i.e. all others related to the job
      # that are not the initial batch query info record)
      # check that all batches have been completed before declaring the job done
      job_batches <- sf_job_batches_bulk(batch_query_status$jobId,
                                         api_type = api_type, 
                                         verbose = verbose)
      # remove the initial batch
      batch_query_info <- job_batches %>% 
        # ignore record ids that could not be matched
        filter(across(any_of("state"), ~(.x != 'NotProcessed')))
      
      if(all(batch_query_info$state == "Completed")){
        status_complete <- TRUE
      }
    } else {
      # continue checking the status until done or max attempts
      z <- z + 1
    }
  }
  if (!status_complete) {
    message("The query took too long to complete. Aborting job now.")
    message("Consider increasing the `max_attempts` and/or `interval_seconds` arguments.")
    resultset <- sf_abort_job_bulk(job_info$id, api_type=api_type, verbose=verbose)
  } else {
    resultset <- list()
    for(i in 1:nrow(batch_query_info)){
      batch_query_details <- sf_batch_details_bulk(job_id = batch_query_info$jobId[i],
                                                   batch_id = batch_query_info$id[i], 
                                                   api_type = api_type, 
                                                   verbose = verbose)
      resultset[[i]] <- sf_query_result_bulk(job_id = batch_query_info$jobId[i],
                                             batch_id = batch_query_info$id[i],
                                             result_id = batch_query_details$result,
                                             guess_types = guess_types,
                                             bind_using_character_cols = bind_using_character_cols,
                                             api_type = api_type,
                                             verbose = verbose)
    }
    resultset <- safe_bind_rows(resultset)
    close_job_info <- sf_close_job_bulk(job_info$id, 
                                        api_type = api_type, 
                                        verbose = verbose)
  }
  # needed in case the result was PKChunked which returns the records in multiple 
  # batches that we must bind
  if(is.tbl(resultset)){
    resultset <- resultset %>% 
      sf_reorder_cols() %>% 
      sf_guess_cols(guess_types)
  }
  
  return(resultset)
}

#' Run Bulk 2.0 query 
#' 
#' This function is a convenience wrapper for submitting and retrieving 
#' query API jobs from the Bulk 2.0 API.
#'
#' @template soql
#' @template object_name
#' @template queryall
#' @template guess_types
#' @template bind_using_character_cols
#' @template interval_seconds
#' @template max_attempts
#' @template control
#' @param ... other arguments passed on to \code{\link{sf_control}} or \code{\link{sf_create_job_bulk}} 
#' to specify the \code{content_type}, \code{concurrency_mode}, and/or \code{column_delimiter}.
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of the recordset returned by the query
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/queries.htm}{Bulk 2.0 documentation}
#' @examples
#' \dontrun{
#' # select all Ids from Account object (up to 1000)
#' ids <- sf_query_bulk_v2(soql = 'SELECT Id FROM Account LIMIT 1000', 
#'                         object_name = 'Account')
#' # alternatively you can specify as 
#' ids <- sf_query(soql = 'SELECT Id FROM Account LIMIT 1000', 
#'                 object_name = 'Account', 
#'                 api_type="Bulk 2.0")
#' }
#' @export
sf_query_bulk_v2 <- function(soql,
                             object_name = NULL,
                             queryall = FALSE,
                             guess_types = TRUE,
                             bind_using_character_cols = FALSE,
                             interval_seconds = 3,
                             max_attempts = 200, 
                             control = list(...), ...,
                             api_type = "Bulk 2.0",
                             verbose = FALSE){
  
  # supplying an object name is not required in Bulk 2.0 queries, but if it has 
  # been provided, then check if the object exists to fail early in the event 
  # that a user has supplied the name of an object that does not exist or that 
  # they do not have access to
  if(!is.null(object_name)){
    listed_objects <- sf_list_objects()
    valid_object_names <- sapply(listed_objects$sobjects, FUN=function(x){x$name})
    if(!object_name %in% valid_object_names){
      stop(sprintf(paste0("The supplied object name (%s) does not exist or ", 
                          "the user does not have permission to view"), object_name), 
           call.=FALSE)
    }
  }
  
  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  this_operation <- if(queryall) "queryall" else "query"
  control_args$operation <- this_operation
  
  # save out the query batch size control because for the Bulk 2.0 API 
  # it is not a header argument, it's actually a query parameter and, 
  # thus, needs to be passed in differently
  if(!is.null(control_args$QueryOptions$batchSize)){
    batch_size <- control_args$QueryOptions$batchSize
    control_args$QueryOptions <- NULL
  } else {
    batch_size <- 50000
  }
  
  # submit the query
  job_info <- sf_create_job_bulk(operation = this_operation,
                                 soql = soql,
                                 object_name = object_name, 
                                 api_type = api_type, 
                                 control = control_args,
                                 verbose = verbose, ...)
  
  # continually check the status for JobComplete which indicates the recordset 
  # is ready to be pulled down
  status_complete <- FALSE
  z <- 1
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    if (verbose){
      message(paste0("Attempt #", z))
    }
    Sys.sleep(interval_seconds)
    query_status <- sf_get_job_bulk(job_info$id, api_type=api_type, query_operation=TRUE) 
    if(query_status$state == 'Failed'){
      stop(query_status$errorMessage)
    } else if(query_status$state == "JobComplete"){
      status_complete <- TRUE
    } else {
      # continue checking the status until done or max attempts
      z <- z + 1
    }
  }
  if (!status_complete) {
    message("The query took too long to complete. Aborting job now.")
    message("Consider increasing the `max_attempts` and/or `interval_seconds` arguments.")
    res <- sf_abort_job_bulk(job_info$id, api_type=api_type, verbose=verbose)
  } else {
    res <- sf_query_result_bulk(job_id = job_info$id,
                                guess_types = guess_types,
                                bind_using_character_cols = bind_using_character_cols,
                                batch_size = batch_size,
                                api_type = api_type,
                                verbose = verbose)
  }
  return(res)
}

#' Run bulk query 
#' 
#' @description
#' `r lifecycle::badge("maturing")`
#' 
#' This function is a convenience wrapper for submitting and retrieving 
#' query API jobs from the Bulk 1.0 and Bulk 2.0 APIs.
#'
#' @template soql
#' @template object_name
#' @template queryall
#' @template guess_types
#' @template bind_using_character_cols
#' @template interval_seconds
#' @template max_attempts
#' @template control
#' @param ... other arguments passed on to \code{\link{sf_control}} or 
#' \code{\link{sf_create_job_bulk}} to specify the \code{content_type}, 
#' \code{concurrency_mode}, and/or \code{column_delimiter}.
#' @template api_type
#' @template verbose
#' @return A \code{tbl_df} of the recordset returned by the query
#' @references \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_bulk_query_intro.htm}{Bulk 1.0 documentation} and \href{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/queries.htm}{Bulk 2.0 documentation}
#' @examples
#' \dontrun{
#' # select all Ids from Account object (up to 1000)
#' ids <- sf_query_bulk(soql = 'SELECT Id FROM Account LIMIT 1000')
#' 
#' # note that, by default, bulk queries are executed using the Bulk 2.0 API, which 
#' # does not required the object name, but the Bulk 1.0 API can be still be invoked 
#' # for queries by setting api_type="Bulk 1.0".
#' 
#' # alternatively you can specify as:
#' ids <- sf_query(soql = 'SELECT Id FROM Account LIMIT 1000', 
#'                 api_type = "Bulk 2.0")
#' 
#' ids <- sf_query(soql = 'SELECT Id FROM Account LIMIT 1000', 
#'                 object_name = 'Account', 
#'                 api_type = "Bulk 1.0")
#' }
#' @export
sf_run_bulk_query <- function(soql,
                          object_name = NULL,
                          queryall = FALSE,
                          guess_types = TRUE,
                          bind_using_character_cols = FALSE,
                          interval_seconds = 3,
                          max_attempts = 200,
                          control = list(...), ...,
                          api_type = c("Bulk 2.0", "Bulk 1.0"),
                          verbose = FALSE){
  
  api_type <- match.arg(api_type)
  
  # this code is redundant because it exists in the sf_query wrapper, 
  # but it is possible that some people are creating jobs with this 
  # function instead of the others, so make sure that we do it here as well. 
  # It should be a relatively small performance hit given its a bulk operation.
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- if(queryall) "queryall" else "query"  
  
  if(api_type == "Bulk 2.0"){
    resultset <- sf_query_bulk_v2(soql = soql, 
                                  object_name = object_name,
                                  queryall = queryall,
                                  guess_types = guess_types,
                                  bind_using_character_cols = bind_using_character_cols,
                                  interval_seconds = interval_seconds,
                                  max_attempts = max_attempts, 
                                  control = control_args, ...,
                                  api_type = api_type,
                                  verbose = verbose)
  } else {
    resultset <- sf_query_bulk_v1(soql = soql, 
                                  object_name = object_name,
                                  queryall = queryall,
                                  guess_types = guess_types,
                                  interval_seconds = interval_seconds,
                                  max_attempts = max_attempts, 
                                  control = control_args, ...,
                                  api_type = api_type,
                                  verbose = verbose)
  }
  return(resultset)
}  

# allows for the inclusion of sf_run version of the function for a consistent
# interface as other "run" functions provided by the package which are a wrapper
# around more complex data processing tasks in Salesforce
#' @export
#' @rdname sf_run_bulk_query
sf_query_bulk <- sf_run_bulk_query
