#' Bulk Create Job URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_create_job_url <- function(api_type=c("Bulk 1.0", "Bulk 2.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 2.0"){
    sprintf("%s/services/data/v%s/jobs/ingest",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"))    
  } else {
    sprintf("%s/services/async/%s/job",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"))
  }
}

#' Bulk Delete Job Generic URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_get_job_url <- function(job_id, api_type=c("Bulk 1.0", "Bulk 2.0")){
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

#' Bulk End Job Generic URL Generator
#' 
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
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_query_url <- function(job_id, api_type=c("Bulk 1.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){  
    sprintf("%s/services/async/%s/job/%s/batch",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id)
  }
}

#' Bulk Batch Status URL Generator
#' 
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
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_query_result_url <- function(job_id, batch_id, result_id, api_type=c("Bulk 1.0")){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  api_type <- match.arg(api_type)
  if(api_type == "Bulk 1.0"){
    sprintf("%s/services/async/%s/job/%s/batch/%s/result/%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            job_id, batch_id, result_id)
  }
}

#' Bulk Job Records URL Generator
#' 
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
