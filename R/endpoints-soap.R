#' Login URL Generator
#' 
#' @param login_url \code{character}; the package default login URL is 
#' https://login.salesforce.com, but other URLs can be used. For example, if you 
#' are logging into a sandbox environment, then the login URL should be set to 
#' https://test.salesforce.com. 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' login to. This string is specific to your environment (production, sandbox, 
#' etc.) and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging. 
#' You should set the login URL globally as one of the package options: 
#' \code{options(salesforcer.login_url="https://test.salesforce.com")}.
#' @keywords internal
#' @export
make_login_url <- function(login_url){
  sprintf('%s/services/Soap/u/%s', 
          login_url, 
          getOption("salesforcer.api_version"))
}

#' Base SOAP API URL Generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send SOAP API calls to. This URL is specific to your instance and the API 
#' version being used.
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
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Metadata API calls to. This URL is specific to your instance and the API 
#' version being used.
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