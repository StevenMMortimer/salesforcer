#' Analytics Notification list URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics notification calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_notifications_list_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/notifications",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Analytics Notification limits URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics notification calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_notifications_limits_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/notifications/limits",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Analytics Notification operations URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics notification calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_notification_operations_url <- function(notification_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/analytics/notifications/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          notification_id)      
}
