# Adapted from RForcecom package https://github.com/hiratake55/RForcecom

# Modifications:
#  The function documentation and arguments are similar to RForcecom source code 
#  in order to provide users with a familiar, backwards compatible interface with 
#  the RForcecom library, but the function internals are original work that 
#  reference other functions in the salesforcer library

# Copyright (c) 2012-2015 Takekatsu Hiramura
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.login}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @param username Your username for login to the Salesforce.com. In many cases, username is your E-mail address.
#' @param password Your password for login to the Salesforce.com. Note: DO NOT FORGET your Security Token. (Ex.) If your password is "Pass1234" and your security token is "XYZXYZXYZXYZ", you should set "Pass1234XYZXYZXYZXYZ".
#' @param loginURL (optional) Login URL. If your environment is sandbox specify (ex:) "https://test.salesforce.com".
#' @param apiVersion (optional) Version of the REST API and SOAP API that you want to use. (ex:) "35.0" Supported versions from v20.0 and up.
#' @return 
#' \item{sessionID}{Session ID.}
#' \item{instanceURL}{Instance URL.}
#' \item{apiVersion}{API Version.}
#' @export
rforcecom.login <- function(username, password, loginURL="https://login.salesforce.com/", apiVersion="35.0"){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.login()", "sf_auth()")  
  
  if(!is.null(loginURL)){
    options(salesforcer.login_url = loginURL)
    # message("Ignoring loginURL. If needed, set in options like so: options(salesforcer.login_url = \"https://login.salesforce.com\")")
  }
  if(!is.null(apiVersion)){
    options(salesforcer.api_version = apiVersion)
    # message("Ignoring apiVersion. If needed, set in options like so: options(salesforcer.api_version = \"42.0\")")
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

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.getServerTimestamp}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session
#' @export
rforcecom.getServerTimestamp <- function(session){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.getServerTimestamp()", "sf_server_timestamp()")  
  
  result <- sf_server_timestamp()
  # format like rforcecom.getServerTimestamp()
  result <- as.POSIXlt(result, tz="GMT")
  return(result)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.getObjectDescription}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @importFrom purrr map_df
#' @template session 
#' @template objectName
#' @return Object descriptions
#' @note This function returns a data.frame with one row per field for an object.
#' @export
rforcecom.getObjectDescription <- function(session, objectName){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.getObjectDescription()", "sf_describe_objects()")
  
  obj_dat <- sf_describe_objects(object_names = objectName, 
                                 api_type="SOAP")[[1]]
  
  obj_fields <- map_df(obj_dat[names(obj_dat) == "fields"], 
                       as.data.frame, 
                       stringsAsFactors=FALSE)
  return(obj_fields)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.create}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @importFrom dplyr select mutate
#' @template session
#' @template objectName
#' @param fields Field names and values. (ex: Name="CompanyName", Phone="000-000-000" )
#' @return \code{data.frame} containing the id and success indicator of the record creation process
#' @export
rforcecom.create <- function(session, objectName, fields){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.create()", "sf_create()")
  
  fields <- as.data.frame(as.list(fields), stringsAsFactors = FALSE)
  created_records <- sf_create(input_data = fields, object_name = objectName)
  
  result <- created_records %>% 
    select(any_of(c("id", "success"))) %>%
    as.data.frame()
  
  return(result)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.retrieve}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session 
#' @template objectName
#' @param fields A List of field names. (ex: c("Id", "Name", "Industry", 
#' "AnnualRevenue)"))
#' @param limit Number of the records to retrieve. (ex: 5)
#' @param id Record ID to retrieve. (ex: "999x000000xxxxxZZZ")
#' @param offset Specifies the starting row offset. (ex: "100")
#' @param order A list for controlling the order of query results. 
#' (ex: "c("Industry","Name")")
#' @param inverse If it is TRUE, the results are ordered in descending order. 
#' This parameter works when order parameter has been set. (Default: FALSE)
#' @param nullsLast If it is TRUE, null records list in last. If not null records 
#' list in first. This parameter works when order parameter has been set. 
#' (Default: FALSE)
#' @export
rforcecom.retrieve <- function(session, objectName,
                               fields, limit=NULL, id=NULL,
                               offset=NULL, order=NULL,
                               inverse=NULL, nullsLast=NULL){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.retrieve()", "sf_retrieve()")
  
  # Make SOQL
  fieldList <- paste(fields, collapse=", ")
  soqlQuery <- paste("SELECT", fieldList, "FROM", objectName, sep=" ")
  
  # Add an id
  if(!is.null(id)){
    soqlQuery <- paste(soqlQuery, " WHERE Id ='", id, "'", sep="")
  }
  
  # Add order phrase
  if(!is.null(order)){
    if(is.list(order)){ orderList <- paste(order, collapse=", ") }
    else{ orderList <- order }
    soqlQuery <- paste(soqlQuery, " ORDER BY ", orderList, sep="")
    if(!is.null(inverse) && inverse == T){
      soqlQuery <- paste(soqlQuery, " DESC", sep="")
    }
    if(!is.null(nullsLast) && nullsLast == T){
      soqlQuery <- paste(soqlQuery, " NULLS LAST", sep="")
    }
  }
  
  # Add limit phrase
  if(!is.null(limit)){
    soqlQuery <- paste(soqlQuery, " LIMIT ",limit, sep="")
  }
  
  # Add offset phrase
  if(!is.null(offset)){
    soqlQuery <- paste(soqlQuery, " OFFSET ",offset, sep="")
  }
  
  # Send a query
  resultSet <- sf_query(soql=soqlQuery)
  return(resultSet)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.update}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session
#' @template objectName
#' @param id Record ID to update. (ex: "999x000000xxxxxZZZ")
#' @param fields Field names and values. (ex: Name="CompanyName", Phone="000-000-000" )
#' @return \code{NULL} if successful otherwise the function errors out
#' @export
rforcecom.update <- function(session, objectName, id, fields){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.update()", "sf_update()")

  fields <- as.data.frame(as.list(fields), stringsAsFactors = FALSE)
  fields$id <- id
  updated_records <- sf_update(fields, object_name = objectName)
  # rforcecom.update returns NULL if successful??
  return(NULL)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.delete}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session
#' @template objectName
#' @param id Record ID to delete. (ex: "999x000000xxxxxZZZ")
#' @return \code{NULL} if successful otherwise the function errors out
#' @export
rforcecom.delete <- function(session, objectName, id){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.delete()", "sf_delete()")
  
  invisible(sf_delete(id, object_name = objectName))
  # rforcecom.delete returns NULL if successful??
  return(NULL)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.upsert}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session
#' @template objectName
#' @param externalIdField An external Key's field name. (ex: "AccountMaster__c")
#' @param externalId An external Key's ID. (ex: "999x000000xxxxxZZZ")
#' @param fields Field names and values. (ex: Name="CompanyName", Phone="000-000-000" )
#' @return \code{NULL} if successful otherwise the function errors out
#' @export
rforcecom.upsert <- function(session, objectName, 
                             externalIdField, externalId, 
                             fields){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.upsert()", "sf_upsert()")

  fields[externalIdField] <- externalId
  fields <- as.data.frame(as.list(fields), stringsAsFactors = FALSE)
  upserted_records <- sf_upsert(input_data = fields, 
                                object_name = objectName, 
                                external_id_fieldname = externalIdField)
  res <- as.data.frame(upserted_records, stringsAsFactors = FALSE)
  return(res)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.search}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session 
#' @param queryString Query strings to search. (ex: "United", "Electoronics")
#' @export
rforcecom.search <- function(session, queryString){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.search()", "sf_search()")
  
  queryString <- paste0("FIND {", queryString, "}", sep="")
  resultset <- sf_search(search_string = queryString, is_sosl=TRUE)
  return(resultset)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.query}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session
#' @template soqlQuery
#' @param queryAll  \code{logical}; indicating if the query recordset should include 
#' deleted and archived records (available only when querying Task and Event records)
#' @return Result dataset.
#' @export
rforcecom.query <- function(session, soqlQuery, queryAll=FALSE){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.query()", "sf_query()")  
  
  sf_query(soql=soqlQuery, queryall=queryAll)
}

#' The \code{salesforcer} backwards compatible version of 
#' \code{RForcecom::rforcecom.bulkQuery}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' @template session
#' @template soqlQuery
#' @param object \code{character}; the name of one Salesforce objects that the 
#' function is operating against (e.g. "Account", "Contact", "CustomObject__c")
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
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.bulkQuery()", "sf_query()")  
  
  sf_query(soql = soqlQuery, 
           object_name = object,
           api_type = "Bulk 1.0", 
           interval_seconds = 5,
           max_attempts = 100)
}

#' The \code{salesforcer} backwards compatible version of the RForcecom function 
#' \code{rforcecom.bulkAction}
#' 
#' @description
#' `r lifecycle::badge("soft-deprecated")`
#' 
#' This function is a convenience wrapper for submitting bulk API jobs
#'
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @template session
#' @param operation a character string defining the type of operation being performed
#' @param data a matrix or data.frame that can be coerced into a CSV file for submitting as batch request
#' @param object a character string defining the target salesforce object that the operation will be performed on
#' @template external_id_fieldname
#' @param multiBatch a boolean value defining whether or not submit data in batches to the API
#' @param batchSize an integer value defining the number of records to submit if multiBatch is true.
#' The max value is 10,000 in accordance with Salesforce limits.
#' @param interval_seconds an integer defining the seconds between attempts to check for job completion
#' @param max_attempts an integer defining then max number attempts to check for job completion before stopping
#' @template verbose
#' @return A \code{tbl_df} of the results of the bulk job
#' @examples
#' \dontrun{
#' # update Account object
#' updates <- rforcecom.bulkAction(session, 
#'                                 operation = 'update', 
#'                                 data = my_data, 
#'                                 object = 'Account')
#' }
#' @export
rforcecom.bulkAction <- function(session, 
                                 operation=c('insert', 'delete', 'upsert',
                                                      'update', 'hardDelete'),
                                 data,
                                 object,
                                 external_id_fieldname=NULL,
                                 multiBatch=TRUE,
                                 batchSize=10000,
                                 interval_seconds=5,
                                 max_attempts=100,
                                 verbose=FALSE){
  
  deprecate_soft("0.1.0", "salesforcer::rforcecom.bulkAction()", "sf_bulk_operation()")
  
  operation <- match.arg(operation)
  res <- sf_bulk_operation(input_data = data, 
                           object_name = object, 
                           operation = operation, 
                           external_id_fieldname = external_id_fieldname, 
                           api_type = "Bulk 1.0", 
                           interval_seconds = interval_seconds,
                           max_attempts = max_attempts,
                           verbose = verbose)
  return(res)
}
