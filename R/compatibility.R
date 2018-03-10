#' Backwards compatible version of rforcecom.login
#' 
#' @param username Your username for login to the Salesforce.com. In many cases, username is your E-mail address.
#' @param password Your password for login to the Salesforce.com. Note: DO NOT FORGET your Security Token. (Ex.) If your password is "Pass1234" and your security token is "XYZXYZXYZXYZ", you should set "Pass1234XYZXYZXYZXYZ".
#' @param loginURL (optional) Login URL. If your environment is sandbox specify (ex:) "https://test.salesforce.com/".
#' @param apiVersion (optional) Version of the REST API and SOAP API that you want to use. (ex:) "35.0" Supported versions from v20.0 and up.
#' @export
rforcecom.login <- function(username, password, loginURL=NULL, apiVersion=NULL){
  
  .Deprecated(new="sf_auth", msg="This function is strictly for backward-compatability to RForcecom and pipes into salesforcer::sf_auth()")
  
  if(!is.null(loginURL)){
    message("Ignoring loginURL. If needed, set in options like so: options(salesforcer.login_url = \"https://login.salesforce.com\")")
  }
  if(!is.null(apiVersion)){
    message("Ignoring apiVersion. If needed, set in options like so: options(salesforcer.api_version = \"42.0\")")
  }
  
  sf_auth(username=username, 
          password=password, 
          security_token = "")
}

#' Backwards compatible version of rforcecom.query
#' @export
rforcecom.query <- function(){
  TRUE
}