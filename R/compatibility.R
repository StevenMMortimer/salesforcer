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
rforcecom.login <- function(username, password, loginURL="https://login.salesforce.com/", apiVersion="35.0"){
  
  .Deprecated("sf_auth")
  
  if(!is.null(loginURL)){
    options(salesforcer.login_url = loginURL)
    #message("Ignoring loginURL. If needed, set in options like so: options(salesforcer.login_url = \"https://login.salesforce.com\")")
  }
  if(!is.null(apiVersion)){
    options(salesforcer.api_version = apiVersion)
    #message("Ignoring apiVersion. If needed, set in options like so: options(salesforcer.api_version = \"42.0\")")
  }
  
  sf_auth(username=username, 
          password=password, 
          security_token = "")
  
  current_state <- salesforcer_state()
  session <- c("sessionID" = current_state$session_id, 
               "instanceURL" = paste0(current_state$instance_url, "/"), 
               "apiVersion" = getOption("salesforcer.api_version"))
  
  return(unlist(session))
}

#' salesforcer's backwards compatible version of rforcecom.query
#' 
#' @template session
#' @param soqlQuery character; a valid SOQL string
#' @param queryAll  logical; indicating if the query recordset should include 
#' deleted and archived records (available only when querying Task and Event records)
#' @return Result dataset.
#' @export
rforcecom.query <- function(session, soqlQuery, queryAll=FALSE){
  
  .Deprecated("sf_query")
 
  sf_query(soql=soqlQuery, queryall=queryAll)
}

#' salesforcer's backwards compatible version of rforcecom.bulkQuery
#' 
#' @template session
#' @param soqlQuery a character string defining a SOQL query. (ex: "SELECT Id, Name FROM Account")
#' @param object a character string defining the target salesforce object that the operation will be performed on. 
#' This must match the target object in the query
#' @param interval_seconds an integer defining the seconds between attempts to check for job completion
#' @param max_attempts an integer defining then max number attempts to check for job completion before stopping
#' @template verbose
#' @return A \code{data.frame} of the recordset returned by query
#' @export
rforcecom.bulkQuery <- function(session,
                                soqlQuery,
                                object,
                                interval_seconds=5,
                                max_attempts=100, 
                                verbose=FALSE){
  
  .Deprecated("sf_query")
  
  sf_query(soql = soqlQuery, 
           object = object,
           api_type = "Bulk", 
           interval_seconds = 5,
           max_attempts = 100)
}

#' salesforcer's backwards compatible version of rforcecom.getServerTimestamp
#' 
#' @template session
#' @export
rforcecom.getServerTimestamp <- function(session){
  .Deprecated("sf_server_timestamp")
  result <- sf_server_timestamp()
  # format like rforcecom.getServerTimestamp()
  result <- as.POSIXlt(result, tz="GMT")
  return(result)
}

#' salesforcer's backwards compatible version of rforcecom.create
#'
#' @importFrom dplyr select mutate
#' @template session
#' @param objectName An object name. (ex: "Account", "Contact", "CustomObject__c")
#' @param fields Field names and values. (ex: Name="CompanyName", Phone="000-000-000" )
#' @return \code{data.frame} containing the id and success indicator of the record creation process
#' @export
rforcecom.create <- function(session, objectName, fields){
  
  .Deprecated("sf_create")
  
  fields <- as.data.frame(as.list(fields), stringsAsFactors = FALSE)
  created_records <- sf_create(input_data=fields, object=objectName)
  
  result <- created_records %>% 
    select(id, success) %>%
    mutate(id = factor(id), 
           success = factor(success)) %>%
    as.data.frame()
  
  return(result)
}

#' salesforcer's backwards compatible version of rforcecom.update
#'
#' @template session
#' @param objectName An object name. (ex: "Account", "Contact", "CustomObject__c")
#' @param id Record ID to update. (ex: "999x000000xxxxxZZZ")
#' @param fields Field names and values. (ex: Name="CompanyName", Phone="000-000-000" )
#' @return \code{NULL} if successful otherwise the function errors out
#' @export
rforcecom.update <- function(session, objectName, id, fields){
  
  .Deprecated("sf_update")

  fields <- as.data.frame(as.list(fields), stringsAsFactors = FALSE)
  fields$id <- id
  updated_records <- sf_update(fields, objectName)
  
  # rforcecom.update returns NULL if successful??
  return(NULL)
}

#' salesforcer's backwards compatible version of rforcecom.delete
#'
#' @template session
#' @param objectName An object name. (ex: "Account", "Contact", "CustomObject__c")
#' @param id Record ID to delete. (ex: "999x000000xxxxxZZZ")
#' @return \code{NULL} if successful otherwise the function errors out
#' @export
rforcecom.delete <- function(session, objectName, id){
  
  .Deprecated("sf_delete")
  
  deleted_records <- sf_delete(id, objectName)
  
  # rforcecom.delete returns NULL if successful??
  return(NULL)
}





# functions waiting to be made compatible --------------------------------------

#' #' salesforcer's backwards compatible version of rforcecom.retrieve
#' #' 
#' #' @export
#' rforcecom.retrieve <- function(){
#'   .Deprecated("sf_retrieve")
#' }
#' 
#' #' salesforcer's backwards compatible version of rforcecom.upsert
#' #' 
#' #' @export
#' rforcecom.upsert <- function(){
#'   .Deprecated("sf_upsert")
#' }
#' 
#' #' salesforcer's backwards compatible version of rforcecom.search
#' #' 
#' #' @export
#' rforcecom.search <- function(){
#'   .Deprecated("sf_search")
#' }
#' 
#' #' salesforcer's backwards compatible version of rforcecom.bulkAction
#' #' 
#' #' @export
#' rforcecom.bulkAction <- function(){
#'   .Deprecated("sf_bulk_operation")
#' }