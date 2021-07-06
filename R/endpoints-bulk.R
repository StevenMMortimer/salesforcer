#' Bulk Create Job URL Generator
#' 
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @param query_operation \code{logical}; an indicator of whether the call is 
#' for a query or another operation, such as, CRUD operations.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_create_job_url <- function(api_type=c("Bulk 1.0", "Bulk 2.0"), 
                                     query_operation=FALSE){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    if(query_operation){
      sprintf("%s/services/data/v%s/jobs/query",
              salesforcer_state()$instance_url,
              getOption("salesforcer.api_version"))      
    } else {
      sprintf("%s/services/data/v%s/jobs/ingest",
              salesforcer_state()$instance_url,
              getOption("salesforcer.api_version"))
    }
  } else {
    sprintf("%s/services/async/%s/job",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"))
  }
}

#' Bulk Get Job Generic URL Generator
#' 
#' @template job_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @param query_operation \code{logical}; an indicator of whether the call is 
#' for a query or another operation, such as, CRUD operations.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_get_job_url <- function(job_id, 
                                  api_type=c("Bulk 1.0", "Bulk 2.0"), 
                                  query_operation=NULL){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    if(!is.null(query_operation) && query_operation){
      sprintf("%s/services/data/v%s/jobs/query/%s",
              salesforcer_state()$instance_url,
              getOption("salesforcer.api_version"), 
              job_id)       
    } else {
      sprintf("%s/services/data/v%s/jobs/ingest/%s",
              salesforcer_state()$instance_url,
              getOption("salesforcer.api_version"), 
              job_id)       
    }
  } else {
    sprintf("%s/services/async/%s/job/%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)
  }
}

#' Bulk Get All Jobs Generic URL Generator
#' 
#' @param parameterized_search_list \code{list}; a list of search options to locate 
#' Bulk API jobs.
#' @param next_records_url \code{character}; a string returned by a Salesforce 
#' query from where to find subsequent records returned by a paginated query.
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) to send a request 
#' to in order to retrieve queried jobs.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_get_all_jobs_url <- function(parameterized_search_list = list(isPkChunkingEnabled=NULL, 
                                                                        jobType=NULL), 
                                       next_records_url=NULL, 
                                       api_type=c("Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  final_url <- ''
  if(api_type == "Bulk 2.0"){
    parameterized_search_list <- validate_get_all_jobs_params(parameterized_search_list, type='all')
    if(!is.null(next_records_url)){
      parsed_url <- parse_url(sprintf('%s%s', salesforcer_state()$instance_url, next_records_url))
      for (n in names(parameterized_search_list)){
        parsed_url$query[[n]] <- parameterized_search_list[[n]]
      }
    } else {
      parsed_url <- parse_url(sprintf("%s/services/data/v%s/jobs/ingest",
                                      salesforcer_state()$instance_url,
                                      getOption("salesforcer.api_version")))
      parsed_url$query <- list()
      for (n in names(parameterized_search_list)){
        parsed_url$query[[n]] <- parameterized_search_list[[n]]
      }
    }
  }
  final_url <- build_url(parsed_url)
  return(final_url)
}

#' Bulk Get All Query Jobs Generic URL Generator
#' 
#' @param parameterized_search_list \code{list}; a list of search options to locate 
#' Bulk API query jobs.
#' @param next_records_url \code{character}; a string returned by a Salesforce 
#' query from where to find subsequent records returned by a paginated query.
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) to send a request 
#' to in order to retrieve queried jobs.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_get_all_query_jobs_url <- function(parameterized_search_list = list(isPkChunkingEnabled=NULL, 
                                                                              jobType=NULL, 
                                                                              concurrencyMode=NULL), 
                                             next_records_url=NULL, 
                                             api_type=c("Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  final_url <- ''
  if(api_type == "Bulk 2.0"){
    parameterized_search_list <- validate_get_all_jobs_params(parameterized_search_list, type='query')
    if(!is.null(next_records_url)){
      parsed_url <- parse_url(sprintf('%s%s', salesforcer_state()$instance_url, next_records_url))
      for (n in names(parameterized_search_list)){
        parsed_url$query[[n]] <- parameterized_search_list[[n]]
      }
    } else {
      parsed_url <- parse_url(sprintf("%s/services/data/v%s/jobs/query",
                                      salesforcer_state()$instance_url,
                                      getOption("salesforcer.api_version")))
      parsed_url$query <- list()
      for (n in names(parameterized_search_list)){
        parsed_url$query[[n]] <- parameterized_search_list[[n]]
      }
    }
  }
  final_url <- build_url(parsed_url)
  return(final_url)
}

#' Validate Query Parameters When Getting List of All Bulk Jobs
#' 
#' @param parameterized_search_list \code{list}; a list of search options to 
#' locate Bulk API jobs.
#' @param type \code{character}; a string indicating which type of jobs to 
#' include in the result.
#' @return \code{character}; a complete URL (as a string) to send a request 
#' to in order to retrieve queried jobs.
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/query_get_all_jobs.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
validate_get_all_jobs_params <- function(parameterized_search_list, type="all"){
  for (n in names(parameterized_search_list)){
    if(!is.null(parameterized_search_list[[n]])){
      if(n == "isPkChunkingEnabled"){
        stopifnot(is.logical(parameterized_search_list[[n]]))
        parameterized_search_list[[n]] <- tolower(parameterized_search_list[[n]])
      }
      if(n == "jobType"){
        if(tolower(type) != "query"){
          stopifnot(parameterized_search_list[[n]] %in% c("BigObjectIngest", "Classic", "V2Ingest"))
        } else {
          stopifnot(parameterized_search_list[[n]] %in% c("BigObjectIngest", "Classic", "V2Query"))
        }
      }
      if(n == "concurrencyMode"){
        if(tolower(type) != "query"){
          stop("Setting the `concurrencyMode` parameter is only allowed when pulling all Bulk query jobs not all Bulk jobs.")
        }
        # in the future this should support "parallel" as well
        stopifnot(parameterized_search_list[[n]] == "serial")
      }
    }
  }
  return(parameterized_search_list)
}

#' Bulk End Job Generic URL Generator
#' 
#' @template job_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_end_job_generic_url <- function(job_id, api_type=c("Bulk 1.0", "Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    sprintf("%s/services/data/v%s/jobs/ingest/%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)      
  } else {
  sprintf("%s/services/async/%s/job/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id)
  }
}

#' Bulk Delete Job Generic URL Generator
#' 
#' @template job_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_delete_job_url <- function(job_id, api_type=c("Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    # ensure we are authenticated first so the url can be formed
    sf_auth_check()
    sprintf("%s/services/data/v%s/jobs/ingest/%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)
  }
}

#' Bulk Batches URL Generator
#' 
#' @importFrom xml2 url_escape
#' @template job_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_batches_url <- function(job_id, api_type=c("Bulk 1.0", "Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    sprintf("%s/services/data/v%s/jobs/ingest/%s/batches/",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)      
  } else {
    sprintf("%s/services/async/%s/job/%s/batch",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)
  }
}

#' Bulk Query URL Generator
#' 
#' @template job_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_query_url <- function(job_id=NULL, 
                                api_type=c("Bulk 1.0", "Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    sprintf("%s/services/data/v%s/jobs/query",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"))
  } else{
    if(is.null(job_id)){
      stop("The `job_id` must be provided to create Bulk 1.0 query", call.=FALSE)
    }
    sprintf("%s/services/async/%s/job/%s/batch",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)
  }
}

#' Bulk Batch Status URL Generator
#' 
#' @template job_id
#' @template batch_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_batch_status_url <- function(job_id, batch_id, api_type=c("Bulk 1.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){  
    sprintf("%s/services/async/%s/job/%s/batch/%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id, batch_id)
  }
}

#' Bulk Batch Details URL Generator
#' 
#' @template job_id
#' @template batch_id
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_batch_details_url <- function(job_id, batch_id, api_type=c("Bulk 1.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){  
    sprintf("%s/services/async/%s/job/%s/batch/%s/result",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id, batch_id)
  }
}

#' Bulk Query Result URL Generator
#' 
#' @template job_id
#' @template batch_id
#' @param result_id \code{character}; the Salesforce Id assigned to a generated 
#' result for a bulk query batch.
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_query_result_url <- function(job_id, 
                                       batch_id=NULL, 
                                       result_id=NULL, 
                                       api_type=c("Bulk 1.0", "Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(is.null(job_id)){
    stop("The `job_id` must be provided to get query results", call.=FALSE)
  }
  if(api_type == "Bulk 2.0"){
    sprintf("%s/services/data/v%s/jobs/query/%s/results",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)
  } else{
    if(is.null(batch_id)){
      stop("The `batch_id` must be provided to get Bulk 1.0 query results", call.=FALSE)
    }    
    if(is.null(result_id)){
      stop("The `result_id` must be provided to get Bulk 1.0 query results", call.=FALSE)
    }        
    sprintf("%s/services/async/%s/job/%s/batch/%s/result/%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id, batch_id, result_id)
  }
}

#' Bulk Job Records URL Generator
#' 
#' @template job_id
#' @param record_type \code{character}; one of 'successfulResults', 'failedResults', 
#' or 'unprocessedRecords' indicating the type of records to retrieve.
#' @param api_type \code{character}; a string indicating which Bulk API to execute 
#' the call against.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send subsequent Bulk API calls to. This URL is specific to your instance and 
#' the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_job_records_url <- function(job_id, 
                                      record_type = c("successfulResults", 
                                                      "failedResults", 
                                                      "unprocessedRecords"), 
                                      api_type = c("Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  record_type <- match.arg(record_type)
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){  
    sprintf("%s/services/data/v%s/jobs/ingest/%s/%s/",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id, 
            record_type)
  }
}
