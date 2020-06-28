#' Dashboard filter operators list URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboard_filter_operators_list_url <- function(for_dashboards=FALSE){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/filteroperators?forDashboards=%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          tolower(for_dashboards))   
}

#' Dashboard list URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboards_list_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/dashboards",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))      
}

#' Dashboard status URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboard_status_url <- function(dashboard_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/dashboards/%s/status",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          dashboard_id)
}

#' Dashboard describe URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboard_describe_url <- function(dashboard_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/dashboards/%s/describe",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          dashboard_id)   
}

#' Dashboard filter options analysis URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboard_filter_options_analysis_url <- function(dashboard_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/dashboards/%s/filteroptionsanalysis",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          dashboard_id)      
}

#' Dashboard URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboard_url <- function(dashboard_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/dashboards/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          dashboard_id)      
}

#' Dashboard Copy URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_dashboard_copy_url <- function(dashboard_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/dashboards/?cloneId=%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          dashboard_id)      
}
