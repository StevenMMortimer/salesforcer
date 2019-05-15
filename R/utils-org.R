#' Return Current User Info
#' 
#' Retrieves personal information for the user associated with the current session.
#' 
#' @importFrom httr content
#' @importFrom XML newXMLNode
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @template api_type
#' @template verbose
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_user_info()
#' }
#' @export
sf_user_info <- function(api_type=c("SOAP", "Chatter"), verbose=FALSE){
  
  api_type <- match.arg(api_type)
  
  if(api_type == "SOAP"){
    
    base_soap_url <- make_base_soap_url()
    if(verbose) {
      message(base_soap_url)
    }
    
    # build the body
    xml_dat <- make_soap_xml_skeleton()
    body_node <- newXMLNode("soapenv:Body", parent=xml_dat)
    operation_node <- newXMLNode(sprintf("urn:%s", "getUserInfo"), parent=body_node)
    
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="create",
                                       "Content-Type"="text/xml"),
                           body = as(xml_dat, "character"))
    
    catch_errors(httr_response)
    response_parsed <- content(httr_response, encoding='UTF-8')
    
    this_res <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>%
      map_df(xml_nodeset_to_df) %>% 
      as.list()
    
  } else if(api_type == "Chatter"){ 
    
    chatter_url <- make_chatter_users_url()
    this_url <- sprintf("%s%s", chatter_url, "me")
    if(verbose) {
      message(this_url)
    }
    
    httr_response <- rGET(this_url)
    catch_errors(httr_response)
    this_res <- content(httr_response, encoding='UTF-8')
    
  } else {
    stop("Unknown API type")
  }
  return(this_res)
}

#' Set User Password
#' 
#' Sets the specified user’s password to the specified value.
#' 
#' @param user_id character; the unique Salesforce Id assigned to the User
#' @param password character; a new password that you would like to set for the 
#' supplied user that complies to your organizations password requirements
#' @template verbose
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_set_password(user_id = "0056A000000ZZZaaBBB", password="password123")
#' }
#' @export
sf_set_password <- function(user_id, password, verbose=FALSE){
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
  # build the body
  r <- make_soap_xml_skeleton()
  xml_dat <- build_soap_xml_from_list(input_data = list(userId=user_id, 
                                                        password=password),
                                      operation = "setPassword",
                                      root=r)
  
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="create",
                                     "Content-Type"="text/xml"),
                         body = as(xml_dat, "character"))
  catch_errors(httr_response)
  return(TRUE)
}

#' Reset User Password
#' 
#' Changes a user’s password to a temporary, system-generated value.
#' 
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all xml_text
#' @param user_id character; the unique Salesforce Id assigned to the User
#' @template verbose
#' @return \code{list}
#' @examples
#' \dontrun{
#' sf_reset_password(user_id = "0056A000000ZZZaaBBB")
#' }
#' @export
sf_reset_password <- function(user_id, verbose=FALSE){
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
  # build the body
  r <- make_soap_xml_skeleton()
  xml_dat <- build_soap_xml_from_list(input_data = list(userId=user_id),
                                      operation = "resetPassword",
                                      root=r)
  
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="create",
                                     "Content-Type"="text/xml"),
                         body = as(xml_dat, "character"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  
  this_res <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_text()
  
  return(this_res)
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

#' Find Duplicate Records
#' 
#' Performs rule-based searches for duplicate records.
#' 
#' @importFrom dplyr select rename_at everything matches as_tibble
#' @importFrom readr cols type_convert
#' @importFrom purrr map_df 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom httr content
#' @param search_criteria \code{list}; a list of fields and their values that would 
#' constitute a match. For example, list(FirstName="Marc", Company="Salesforce")
#' @template object_name
#' @template include_record_details
#' @template verbose
#' @return \code{tbl_df} of records found to be duplicates by the match rules
#' @note You must have actived duplicate rules for the supplied object before running 
#' this function. The \code{object_name} argument refers to using that object's duplicate 
#' rules on the search criteria to determine which records in other objects are duplicates.
#' @examples
#' \dontrun{
#' # use the duplicate rules associated with the Lead object on the search 
#' # criteria (email) in order to find duplicates
#' found_dupes <- sf_find_duplicates(search_criteria = 
#'                                     list(Email="bond_john@@grandhotels.com"),
#'                                   object_name = "Lead")
#'                                   
#' # now look for duplicates on email using the Contact object's rules
#' found_dupes <- sf_find_duplicates(search_criteria = 
#'                                     list(Email="bond_john@@grandhotels.com"),
#'                                   object_name = "Contact")
#' }
#' @export
sf_find_duplicates <- function(search_criteria, 
                               object_name, 
                               include_record_details = FALSE,
                               verbose = FALSE){
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
  # build the body
  r <- make_soap_xml_skeleton(soap_headers=list(DuplicateRuleHeader = list(includeRecordDetails = tolower(include_record_details))))
  xml_dat <- build_soap_xml_from_list(input_data = search_criteria,
                                      operation = "findDuplicates",
                                      object_name = object_name,
                                      root = r)

  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="create",
                                     "Content-Type"="text/xml"),
                         body = as(xml_dat, "character"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  
  duplicate_entitytype <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_find_all('.//duplicateResults//duplicateRuleEntityType') %>%
    xml_text() %>% 
    head(1)
  
  which_rules <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_find_all('.//duplicateResults//duplicateRule') %>%
    map(xml_text) %>% 
    unlist() %>% 
    paste(collapse = ", ")
  
  message(sprintf("Using %s rules: %s", duplicate_entitytype, which_rules))
  
  this_res <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_find_all('.//duplicateResults//matchResults//matchRecords//record') %>% 
    map_df(xml_nodeset_to_df) %>%
    rename_at(.vars = vars(contains("sf:")), 
              .funs = list(~gsub("sf:", "", .))) %>%
    rename_at(.vars = vars(contains("Id1")), 
              .funs = list(~gsub("Id1", "Id", .))) %>%
    select(-matches("^V[0-9]+$")) %>%
    # move columns without dot up since those are related entities
    select(-matches("\\."), everything()) %>%
    type_convert(col_types = cols()) %>%
    as_tibble()
  
  # drop columns which are completely missing. This happens with this function whenever 
  # a linked object is null for a record, so a column is created "sf:EntityName" that 
  # is NA for that record and then NA for the other records since it is a non-null entity for them 
  this_res <- Filter(function(x) !all(is.na(x)), this_res)
  
  return(this_res)
}

#' Find Duplicate Records By Id
#' 
#' Performs rule-based searches for duplicate records.
#' 
#' @template sf_id
#' @template include_record_details
#' @template verbose
#' @return \code{tbl_df} of records found to be duplicates by the match rules
#' @note You must have actived duplicate rules for the supplied object before running 
#' this function. This function uses the duplicate rules for the object that has 
#' the same type as the input record IDs. For example, if the record Id represents 
#' an Account, this function uses the duplicate rules associated with the 
#' Account object.
#' @examples 
#' \dontrun{
#' # use the duplicate rules associated with the object that this record 
#' # belongs to in order to find duplicates
#' found_dupes <- sf_find_duplicates_by_id(sf_id = "00Q6A00000aABCnZZZ")
#' }
#' @export
sf_find_duplicates_by_id <- function(sf_id,
                                     include_record_details = FALSE, 
                                     verbose = FALSE){
  
  stopifnot(length(sf_id) == 1)
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
  # build the body
  r <- make_soap_xml_skeleton(soap_headers=list(DuplicateRuleHeader = list(includeRecordDetails = tolower(include_record_details))))
  xml_dat <- build_soap_xml_from_list(input_data = sf_id,
                                      operation = "findDuplicatesByIds",
                                      root = r)
  
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="create",
                                     "Content-Type"="text/xml"),
                         body = as(xml_dat, "character"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  
  duplicate_entitytype <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_find_all('.//duplicateResults//duplicateRuleEntityType') %>%
    xml_text() %>% 
    head(1)
  
  which_rules <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_find_all('.//duplicateResults//duplicateRule') %>%
    map(xml_text) %>% 
    unlist() %>% 
    paste(collapse = ", ")
  
  message(sprintf("Using %s rules: %s", duplicate_entitytype, which_rules))
  
  this_res <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    xml_find_all('.//duplicateResults//matchResults//matchRecords//record') %>% 
    map_df(xml_nodeset_to_df) %>%
    rename_at(.vars = vars(contains("sf:")), 
              .funs = list(~gsub("sf:", "", .))) %>%
    rename_at(.vars = vars(contains("Id1")), 
              .funs = list(~gsub("Id1", "Id", .))) %>%
    select(-matches("^V[0-9]+$")) %>%
    # move columns without dot up since those are related entities
    select(-matches("\\."), everything()) %>%
    type_convert(col_types = cols()) %>%
    as_tibble()
  
  # drop columns which are completely missing. This happens with this function whenever 
  # a linked object is null for a record, so a column is created "sf:EntityName" that 
  # is NA for that record and then NA for the other records since it is a non-null entity for them 
  this_res <- Filter(function(x) !all(is.na(x)), this_res)
  
  return(this_res)
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