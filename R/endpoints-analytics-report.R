#' Report Type List URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_types_list_url <- function(){
  # ensure we are authenticated first so the URL can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reportTypes",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))      
}

#' Reports List URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_reports_list_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))      
}

#' Report Type Describe URL generator
#' 
#' @param type \code{character}; The API name of a report type.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_type_describe_url <- function(type){
  # ensure we are authenticated first so the URL can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reportTypes/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          type)
}

#' Report Filter Operator List URL generator
#' 
#' @param for_dashboards \code{logical}; an indicator of whether the filter is 
#' in reference to dashboards or not.
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_filter_operators_list_url <- function(for_dashboards=FALSE){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/filteroperators?forDashboards=%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          tolower(for_dashboards))   
}

#' Report Fields URL generator
#' 
#' @template report_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_fields_url <- function(report_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports/%s/fields",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_id)   
}

#' Report Describe URL generator
#' 
#' @template report_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_describe_url <- function(report_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports/%s/describe",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_id)   
}

#' Report Execute URL generator
#' 
#' @template report_id
#' @template async
#' @template include_details
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_execute_url <- function(report_id, async=TRUE, include_details=FALSE){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  if(async){
    sprintf("%s/services/data/v%s/analytics/reports/%s/instances",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            report_id)   
  } else {
    sprintf("%s/services/data/v%s/analytics/reports/%s?includeDetails=%s",
            salesforcer_state()$instance_url,
            getOption("salesforcer.api_version"), 
            report_id, 
            tolower(include_details)) 
  }
}

#' Report Instances List URL generator
#' 
#' @template report_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_instances_list_url <- function(report_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports/%s/instances",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_id)
}

#' Report Instance URL generator
#' 
#' @template report_id
#' @template report_instance_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_instance_url <- function(report_id, report_instance_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports/%s/instances/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_id, 
          report_instance_id)
}

#' Report Query URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_query_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports/query",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Report Create URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_create_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))      
}

#' Report URL generator
#' 
#' @template report_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_url <- function(report_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_id)      
}

#' Report Copy URL generator
#' 
#' @template report_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Reports and Dashboards API calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_report_copy_url <- function(report_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/reports?cloneId=%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_id)      
}
