# sf_empty_trash() Delete records from the recycle bin immediately.
# sf_timestamp - getServerTimestamp()	Retrieves the current system timestamp from the API.
# limits??

#' Return Current User Info
#' 
#' Retrieves personal information for the user associated with the current session.
#' 
#' @importFrom httr content
#' @export
sf_user_info <- function(){
  httr_response <- rGET("https://login.salesforce.com/services/oauth2/userinfo")
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  return(response_parsed)
}