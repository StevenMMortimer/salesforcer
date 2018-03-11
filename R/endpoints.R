#' Login URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_login_url <- function(login_url){
  sprintf('%s/services/Soap/u/%s', 
          login_url, 
          getOption("salesforcer.api_version"))
}

#' Base REST API URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_base_rest_url <- function(){
  sprintf("%s/services/data/v%s/",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Base SOAP API URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_base_soap_url <- function(){
  sprintf('%s/services/Soap/u/%s', 
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Query URL Generator
#' 
#' @importFrom xml2 url_escape
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_query_url <- function(soql, queryall, next_records_url){
  if(!is.null(next_records_url)){
    # pull more records from a previous query
    query_url <- sprintf('%s%s', 
                         salesforcer_state()$instance_url, 
                         next_records_url)
  } else {
    # set the url based on the query
    query_url <- sprintf('%s/services/data/v%s/%s/?q=%s', 
                         salesforcer_state()$instance_url,
                         getOption("salesforcer.api_version"),
                         if(queryall) "queryAll" else "query",
                         url_escape(soql))
  }
  return(query_url)
}

#' Composite URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_composite_url <- function(){
  sprintf("%s/services/data/v%s/composite/sobjects",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Bulk Create Job URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_create_job_url <- function(bulk_version="1.0"){
  if(bulk_version == "2.0"){
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
make_bulk_get_job_url <- function(job_id){
  sprintf("%s/services/data/v%s/jobs/ingest/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id)
}

#' Bulk End Job Generic URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_end_job_generic_url <- function(job_id, bulk_version="2.0"){
  if(bulk_version == "2.0"){
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
make_bulk_delete_job_url <- function(job_id){
  sprintf("%s/services/data/v%s/jobs/ingest/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id)
}

#' Query URL Generator
#' 
#' @importFrom xml2 url_escape
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_batches_url <- function(job_id, bulk_version="2.0"){
  if(bulk_version == "2.0"){
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
make_bulk_query_url <- function(job_id){
  sprintf("%s/services/async/%s/job/%s/batch",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id)
}

#' Bulk Batch Status URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_batch_status_url <- function(job_id, batch_id){
  sprintf("%s/services/async/%s/job/%s/batch/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id, batch_id)
}

#' Bulk Batch Details URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_batch_details_url <- function(job_id, batch_id){
  sprintf("%s/services/async/%s/job/%s/batch/%s/result",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id, batch_id)
}

#' Bulk Query Result URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_query_result_url <- function(job_id, batch_id, result_id){
  sprintf("%s/services/async/%s/job/%s/batch/%s/result/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id, batch_id, result_id)
}

#' Bulk Job Records URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_bulk_job_records_url <- function(job_id, 
                                      record_type = c("successfulResults", 
                                                      "failedResults", 
                                                      "unprocessedRecords")){
  record_type <- match.arg(record_type)
  sprintf("%s/services/data/v%s/jobs/ingest/%s/%s/",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          job_id, 
          record_type)
}
