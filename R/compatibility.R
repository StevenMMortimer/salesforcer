#' salesforcer's backwards compatible version of rforcecom.login
#' 
#' @param username Your username for login to the Salesforce.com. In many cases, username is your E-mail address.
#' @param password Your password for login to the Salesforce.com. Note: DO NOT FORGET your Security Token. (Ex.) If your password is "Pass1234" and your security token is "XYZXYZXYZXYZ", you should set "Pass1234XYZXYZXYZXYZ".
#' @param loginURL (optional) Login URL. If your environment is sandbox specify (ex:) "https://test.salesforce.com/".
#' @param apiVersion (optional) Version of the REST API and SOAP API that you want to use. (ex:) "35.0" Supported versions from v20.0 and up.
#' @return 
#' \item{sessionID}{Session ID.}
#' \item{instanceURL}{Instance URL.}
#' \item{apiVersion}{API Version.}
#' @export
rforcecom.login <- function(username, password, loginURL=NULL, apiVersion=NULL){
  
  #.Deprecated(new="sf_auth", msg="This function is strictly for backward-compatability to RForcecom and pipes into salesforcer::sf_auth()")
  
  if(!is.null(loginURL)){
    message("Ignoring loginURL. If needed, set in options like so: options(salesforcer.login_url = \"https://login.salesforce.com\")")
  }
  if(!is.null(apiVersion)){
    message("Ignoring apiVersion. If needed, set in options like so: options(salesforcer.api_version = \"42.0\")")
  }
  
  sf_auth(username=username, 
          password=password, 
          security_token = "")
  
  current_state <- salesforcer_state()
  
  return(c(sessionID = current_state$session_id, 
           instanceURL = current_state$instance_url, 
           apiVersion = getOption("salesforcer.api_version")))
}

#' salesforcer's backwards compatible version of rforcecom.query
#' 
#' @param session Session data
#' @param soqlQuery character; a valid SOQL string
#' @param queryAll  logical; indicating if the query recordset should include 
#' deleted and archived records (available only when querying Task and Event records)
#' @export
rforcecom.query <- function(session, soqlQuery, queryAll=FALSE){
  
  #.Deprecated(new="sf_query", msg="This function is strictly for backward-compatability to RForcecom and pipes into salesforcer::sf_auth()")
 
  sf_query(soql=soqlQuery, queryall=queryAll)
}

# functions waiting to be made compatible

#' salesforcer's backwards compatible version of rforcecom.create
#' 
#' @export
rforcecom.create <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.retrieve
#' 
#' @export
rforcecom.retrieve <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.update
#' 
#' @export
rforcecom.update <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.upsert
#' 
#' @export
rforcecom.upsert <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.delete
#' 
#' @export
rforcecom.delete <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.search
#' 
#' @export
rforcecom.search <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.getServerTimestamp
#' 
#' @export
rforcecom.getServerTimestamp <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.bulkAction
#' 
#' @export
rforcecom.bulkAction <- function(){TRUE}

#' salesforcer's backwards compatible version of rforcecom.bulkQuery
#' 
#' @export
rforcecom.bulkQuery <- function(){TRUE}