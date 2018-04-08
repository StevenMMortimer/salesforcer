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

#' Base SOAP API URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_base_soap_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()  
  sprintf('%s/services/Soap/u/%s', 
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Base Metadata API URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_base_metadata_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()  
  sprintf('%s/services/Soap/m/%s', 
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}