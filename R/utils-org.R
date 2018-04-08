#' Return Current User Info
#' 
#' Retrieves personal information for the user associated with the current session.
#' 
#' @importFrom httr content
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_user_info()
#' }
#' @export
sf_user_info <- function(){
  # ensure we are authenticated first so the url can be formed
  chatter_url <- make_chatter_users_url()
  httr_response <- rGET(sprintf("%s%s", chatter_url, "me"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  return(response_parsed)
}

#' Salesforce Server Timestamp
#' 
#' Retrieves the current system timestamp from the API.
#' 
#' @importFrom httr headers 
#' @importFrom lubridate dmy_hms
#' @return \code{POSIXct} formatted timestamp
#' @examples
#' \dontrun{
#' sf_server_timestamp()
#' }
#' @export
sf_server_timestamp <- function(){
  base_rest_url <- make_base_rest_url()
  httr_response <- rGET(base_rest_url, 
                        headers = c("Accept"="application/xml", 
                                    "X-PrettyPrint"="1"))
  catch_errors(httr_response)
  response_parsed <- headers(httr_response)$date
  timestamp <- dmy_hms(response_parsed)
  return(timestamp)
}

#' List REST API Versions
#' 
#' Lists summary information about each Salesforce version currently available, 
#' including the version, label, and a link to each version\'s root
#' 
#' @importFrom httr content
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_list_rest_api_versions()
#' }
#' @export
sf_list_rest_api_versions <- function(){
  sf_auth_check()
  httr_response <- rGET(sprintf("%s/services/data/", salesforcer_state()$instance_url))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  return(response_parsed)
}

#' List the Resources for an API
#' 
#' Lists available resources for the specified API version, including resource 
#' name and URI.
#' 
#' @importFrom httr content
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_list_resources()
#' }
#' @export
sf_list_resources <- function(){
  base_rest_url <- make_base_rest_url()
  httr_response <- rGET(base_rest_url)
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  return(response_parsed)
}

#' List the Limits for an API
#' 
#' Lists information about limits in your org.
#' 
#' @importFrom httr content
#' @note This resource is available in REST API version 29.0 and later for API 
#' users with the View Setup and Configuration permission. The resource returns 
#' these limits:
#' \itemize{
#'   \item Daily API calls
#'   \item Daily asynchronous Apex method executions (batch Apex, future methods, queueable Apex, and scheduled Apex)
#'   \item Daily Bulk API calls
#'   \item Daily Streaming API events (API version 36.0 and earlier)
#'   \item Daily durable Streaming API events (API version 37.0 and later)
#'   \item Streaming API concurrent clients (API version 36.0 and earlier)
#'   \item Durable Streaming API concurrent clients (API version 37.0 and later)
#'   \item Daily generic streaming events (API version 36.0 and earlier)
#'   \item Daily durable generic streaming events (API version 37.0 and later)
#'   \item Daily number of mass emails that are sent to external email addresses by using Apex or APIs
#'   \item Daily number of single emails that are sent to external email addresses by using Apex or APIs
#'   \item Concurrent REST API requests for results of asynchronous report runs
#'   \item Concurrent synchronous report runs via REST API
#'   \item Hourly asynchronous report runs via REST API
#'   \item Hourly synchronous report runs via REST API
#'   \item Hourly dashboard refreshes via REST API
#'   \item Hourly REST API requests for dashboard results
#'   \item Hourly dashboard status requests via REST API
#'   \item Daily workflow emails
#'   \item Hourly workflow time triggers
#'   \item Hourly OData callouts
#'   \item Daily and active scratch org counts
#'   \item Data storage (MB)
#'   \item File storage (MB)
#' }
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_list_api_limits()
#' }
#' @export
sf_list_api_limits <- function(){
  base_rest_url <- make_base_rest_url()
  httr_response <- rGET(sprintf("%s%s", base_rest_url, "limits/"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  return(response_parsed)
}

#' List Organization Objects and their Metadata
#' 
#' Lists the available objects and their metadata for your organization’s data.
#' 
#' @importFrom httr content
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_list_objects()
#' }
#' @export
sf_list_objects <- function(){
  base_rest_url <- make_base_rest_url()
  httr_response <- rGET(sprintf("%s%s", base_rest_url, "sobjects/"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  return(response_parsed)
}

#' #' Delete from Recycle Bin
#' #' 
#' #' Delete records from the recycle bin immediately.
#' #' 
#' #' @importFrom httr content
#' #' @return \code{list}
#' #' @examples
#' #' \dontrun{
#' #' sf_empty_trash()
#' #' }
#' #' @export
#' sf_empty_trash <- function(){
#'   httr_response <- rGET("https://login.salesforce.com/services/oauth2/userinfo")
#'   catch_errors(httr_response)
#'   response_parsed <- content(httr_response, encoding='UTF-8')
#'   return(response_parsed)
#' }