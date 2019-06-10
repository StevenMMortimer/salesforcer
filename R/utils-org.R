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
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return \code{list}
#' @examples
#' \dontrun{
#' # reset a user's password and ensure that an email is triggered to them
#' sf_reset_password(user_id = "0056A000000ZZZaaBBB", 
#'                   EmailHeader = list(triggerAutoResponseEmail = FALSE, 
#'                                      triggerOtherEmail = FALSE, 
#'                                      triggerUserEmail = TRUE))
#' }
#' @export
sf_reset_password <- function(user_id, 
                              control = list(...), ...,
                              verbose = FALSE){
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
  }
  
  # build the body
  control_args <- return_matching_controls(control)
  control_args$api_type <- "SOAP"
  control_args$operation <- "resetPassword"
  control <- do.call("sf_control", control_args)
  r <- make_soap_xml_skeleton(soap_headers = control)
  xml_dat <- build_soap_xml_from_list(input_data = list(userId = user_id),
                                      operation = "resetPassword",
                                      root = r)
  
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
#' @importFrom utils head
#' @importFrom dplyr select rename_at rename everything matches as_tibble tibble
#' @importFrom readr cols type_convert col_guess
#' @importFrom purrr map_df 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom httr content
#' @param search_criteria \code{list}; a list of fields and their values that would 
#' constitute a match. For example, list(FirstName="Marc", Company="Salesforce")
#' @template object_name
#' @template include_record_details
#' @template guess_types
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
                               guess_types = TRUE,
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
    xml_find_all('.//duplicateResults//matchResults//matchRecords//record') 
  
  if(length(this_res) > 0){
    this_res <- this_res %>%
      map_df(xml_nodeset_to_df) %>% 
      rename(sObject = `sf:type`) %>% 
      remove_empty_linked_object_cols() %>% 
      # remove redundant linked entity object types.type
      select(-matches("\\.sf:type")) %>% 
      rename_at(.vars = vars(starts_with("sf:")), 
                .funs = list(~sub("^sf:", "", .))) %>%
      rename_at(.vars = vars(matches("\\.sf:")), 
                .funs = list(~sub("sf:", "", .))) %>%
      # move columns without dot up since those are related entities
      select(-matches("\\."), everything())
  } else {
    this_res <- tibble()
  }
  
  if(guess_types){
    this_res <- this_res %>% 
      type_convert(col_types = cols(.default = col_guess()))
  }
  
  return(this_res)
}

#' Find Duplicate Records By Id
#' 
#' Performs rule-based searches for duplicate records.
#' 
#' @importFrom utils head
#' @importFrom dplyr select rename_at rename everything matches as_tibble tibble
#' @importFrom readr cols type_convert col_guess
#' @importFrom purrr map_df 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom httr content
#' @template sf_id
#' @template include_record_details
#' @template guess_types
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
                                     guess_types = TRUE,
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
    xml_find_all('.//duplicateResults//matchResults//matchRecords//record')
  
  if(length(this_res) > 0){
    this_res <- this_res %>%
      map_df(xml_nodeset_to_df) %>%
      rename(sObject = `sf:type`) %>% 
      remove_empty_linked_object_cols() %>% 
      # remove redundant linked entity object types.type
      select(-matches("\\.sf:type")) %>% 
      rename_at(.vars = vars(starts_with("sf:")), 
                .funs = list(~sub("^sf:", "", .))) %>%
      rename_at(.vars = vars(matches("\\.sf:")), 
                .funs = list(~sub("sf:", "", .))) %>%
      # move columns without dot up since those are related entities
      select(-matches("\\."), everything())
  } else {
    this_res <- tibble()
  }
  
  if(guess_types){
    this_res <- this_res %>% 
      type_convert(col_types = cols(.default = col_guess()))
  }
  
  return(this_res)
}

#' Merge Records
#' 
#' This function combines records of the same object type into one of the records, 
#' known as the master record. The other records, known as the victim records, will
#' be deleted. If a victim record has related records the master record the new 
#' parent of the related records.
#' 
#' @importFrom httr content
#' @importFrom readr type_convert cols
#' @importFrom xml2 xml_ns_strip xml_find_all as_list
#' @importFrom purrr map_df
#' @importFrom dplyr tibble
#' @param master_id character; a Salesforce generated Id that identifies the master record, 
#' which is the record to which the victim records will be merged into
#' @param victim_ids character; one or two Salesforce Ids of records to be merged into 
#' the master record. Up to three records can be merged in a single request, including 
#' the master record. This limit is the same as the limit enforced by the Salesforce user 
#' interface. To merge more than 3 records, successively merge records by running 
#' \code{\link{sf_merge}} repeatedly.
#' @template object_name
#' @param master_fields \code{named vector}; a vector of field names and values to 
#' supersede the master record values. Otherwise, the field values on the master record 
#' will prevail.
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return \code{tbl_df} of records with success indicator
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n),
#'                        Description = paste0("Description", 1:n))
#' new_recs1 <- sf_create(new_contacts, object_name = "Contact")
#' 
#' # merge the second and third into the first record, but set the
#' # description field equal to the description of the second. All other fields
#' # will from the first record or, if blank, from the other records
#' merge_res <- sf_merge(master_id = new_recs1$id[1],
#'                       victim_ids = new_recs1$id[2:3],
#'                       object_name = "Contact",
#'                       master_fields = tibble("Description" = new_contacts$Description[2]))
#' # check the second and third records now have the same Master Record Id as the first
#' merge_check <- sf_query(sprintf("SELECT Id, MasterRecordId, Description 
#'                                  FROM Contact WHERE Id IN ('%s')", 
#'                                  paste0(new_recs1$id, collapse="','")), 
#'                         queryall = TRUE)
#' }
#' @export
sf_merge <- function(master_id,
                     victim_ids,
                     object_name,
                     master_fields = character(0),
                     api_type = c("SOAP"), 
                     control = list(...), ...,
                     verbose = FALSE){
  
  master_fields <- unlist(master_fields)
  master_fields["Id"] <- master_id
  master_fields <- c(master_fields["Id"], master_fields[names(master_fields) != 'Id'])

  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "merge"
  control <- do.call("sf_control", control)

  base_soap_url <- make_base_soap_url()
  r <- make_soap_xml_skeleton(soap_headers = control)
  xml_dat <- build_soap_xml_from_list(input_data = list(victim_ids = victim_ids, 
                                                        master_fields = master_fields),
                                      operation = "merge",
                                      object_name = object_name,
                                      root = r)
  request_body <- as(xml_dat, "character")
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="merge",
                                     "Content-Type"="text/xml"),
                         body = request_body)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url,
                              httr_response$request$headers,
                              request_body)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  this_set <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    # we must use XML because character elements are not automatically unboxed
    # see https://github.com/r-lib/xml2/issues/215
    map(.f=function(x){
      xmlToList(xmlParse(as(object=x, Class="character")))
    }) %>% .[[1]]
  
  res <- tibble(id = merge_null_to_na(this_set$id), 
                success = merge_null_to_na(this_set$success),
                mergedRecordIds = merge_null_to_na(list(unname(unlist(this_set[names(this_set) == "mergedRecordIds"])))),
                updatedRelatedIds = merge_null_to_na(list(unname(unlist(this_set[names(this_set) == "updatedRelatedIds"])))),
                errors = merge_null_to_na(list(this_set$errors))) %>%
    type_convert(col_types = cols())
  
  return(res)
}

#' Get Deleted Records from a Timeframe
#' 
#' Retrieves the list of individual records that have been deleted within the given 
#' timespan for the specified object.
#' 
#' @importFrom lubridate as_datetime
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all xml_text
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @template object_name
#' @param start \code{date} or \code{datetime}; starting datetime of the timespan 
#' for which to retrieve the data.
#' @param end \code{date} or \code{datetime}; ending datetime of the timespan for
#' which to retrieve the data.
#' @template verbose
#' @examples 
#' \dontrun{
#' # get all deleted Contact records from midnight until now
#' deleted_recs <- sf_get_deleted("Contact", Sys.Date(), Sys.time())
#' }
#' @note This API ignores the seconds portion of the supplied datetime values.
#' @export
sf_get_deleted <- function(object_name, 
                           start, end, 
                           verbose = FALSE){
  stopifnot(any(class(start) %in% c("Date", "POSIXct", "POSIXt", "POSIXlt")))
  stopifnot(any(class(end) %in% c("Date", "POSIXct", "POSIXt", "POSIXlt")))
  base_soap_url <- make_base_soap_url()
  r <- make_soap_xml_skeleton()
  xml_dat <- build_soap_xml_from_list(input_data = list(start = start, 
                                                        end = end), 
                                      object_name = object_name,
                                      operation = "getDeleted",
                                      root = r)
  request_body <- as(xml_dat, "character")
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="getDeleted",
                                     "Content-Type"="text/xml"),
                         body = request_body)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              request_body)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  if(verbose){
    earliest <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result/earliestDateAvailable') %>%
      xml_text()
    latest <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result/latestDateCovered') %>%
      xml_text()
    message(sprintf("Earliest Date Available: %s UTC - Latest Date Covered: %s UTC", 
                    as_datetime(earliest), as_datetime(latest)))
  }
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result//deletedRecords') %>%
    map_df(xml_nodeset_to_df) %>% 
    type_convert(col_types = cols())
  
  return(resultset)
}

#' Get Updated Records from a Timeframe
#' 
#' Retrieves the list of individual records that have been inserted or updated 
#' within the given timespan in the specified object.
#' 
#' @importFrom lubridate as_datetime
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all xml_text as_list
#' @importFrom purrr map_df
#' @importFrom dplyr tibble
#' @importFrom readr type_convert cols
#' @template object_name
#' @param start \code{date} or \code{datetime}; starting datetime of the timespan 
#' for which to retrieve the data.
#' @param end \code{date} or \code{datetime}; ending datetime of the timespan for
#' which to retrieve the data.
#' @template verbose
#' @examples 
#' \dontrun{
#' # get all updated Contact records from midnight until now
#' updated_recs <- sf_get_updated("Contact", Sys.Date(), Sys.time())
#' }
#' @note This API ignores the seconds portion of the supplied datetime values.
#' @export
sf_get_updated <- function(object_name, 
                           start, end, 
                           verbose = FALSE){
  stopifnot(any(class(start) %in% c("Date", "POSIXct", "POSIXt", "POSIXlt")))
  stopifnot(any(class(end) %in% c("Date", "POSIXct", "POSIXt", "POSIXlt")))
  base_soap_url <- make_base_soap_url()
  r <- make_soap_xml_skeleton()
  xml_dat <- build_soap_xml_from_list(input_data = list(start = start, 
                                                        end = end), 
                                      object_name = object_name,
                                      operation = "getUpdated",
                                      root = r)
  request_body <- as(xml_dat, "character")
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"="getUpdated",
                                     "Content-Type"="text/xml"),
                         body = request_body)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers, 
                              request_body)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  if(verbose){
    latest <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result/latestDateCovered') %>%
      xml_text()
    message(sprintf("Latest Date Covered: %s UTC", as_datetime(latest)))
  }
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result/ids') %>% 
    as_list() %>% 
    unlist()
  
  if(length(resultset) > 0){
    resultset <- tibble(id = resultset)
  } else {
    resultset <- tibble()
  }
  
  return(resultset)
}

#' Undelete Records
#' 
#' Undeletes records from the Recycle Bin.
#' 
#' @importFrom httr content
#' @importFrom readr type_convert cols
#' @importFrom dplyr bind_rows
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return \code{tbl_df} of records with success indicator
#' @note Because the SOAP and REST calls chunk data into batches of 200 records 
#' the AllOrNoneHeader will only apply to the success or failure of every batch 
#' of records and not all records submitted to the function.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_undelete.htm}
#' @examples
#' \dontrun{
#' new_contact <- c(FirstName = "Test", LastName = "Contact")
#' new_records <- sf_create(new_contact, object_name = "Contact")
#' delete <- sf_delete(new_records$id[1],
#'                     AllOrNoneHeader = list(allOrNone = TRUE))
#' is_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
#'                        new_records$id[1]), 
#'                        queryall = TRUE)
#' undelete <- sf_undelete(new_records$id[1])
#' is_not_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
#'                            new_records$id[1]))
#' }
#' @export
sf_undelete <- function(ids,  
                        api_type = c("SOAP"), 
                        control = list(...), ...,
                        verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation='undelete')
  
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "undelete"
  control <- do.call("sf_control", control)
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  
  base_soap_url <- make_base_soap_url()
  if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]  
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "undelete",
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="undelete",
                                       "Content-Type"="text/xml"),
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, encoding="UTF-8")
    this_set <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>%
      map_df(xml_nodeset_to_df)
    resultset <- bind_rows(resultset, this_set)
  }
  resultset <- resultset %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Empty Recycle Bin
#'
#' Delete records from the recycle bin immediately and permanently.
#'
#' @importFrom httr content
#' @importFrom readr type_convert cols
#' @importFrom dplyr bind_rows
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
#' @template api_type
#' @template verbose
#' @details When emptying recycle bins, consider the following rules and guidelines:
#' \itemize{
#'   \item The logged in user can delete any record that he or she can query in their Recycle Bin, or the recycle bins of any subordinates. If the logged in user has Modify All Data permission, he or she can query and delete records from any Recycle Bin in the organization.
#'   \item Do not include the IDs of any records that will be cascade deleted, or an error will occur.
#'   \item Once records are deleted using this call, they cannot be undeleted using \code{link{sf_undelete}}
#'   \item After records are deleted from the Recycle Bin using this call, they can be queried using the \code{queryall} argument for some time. Typically this time is 24 hours, but may be shorter or longer.
#' }
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_calls_emptyrecyclebin.htm}
#' @return \code{tbl_df} of records with success indicator
#' @examples
#' \dontrun{
#' new_contact <- c(FirstName = "Test", LastName = "Contact")
#' new_records <- sf_create(new_contact, object_name = "Contact")
#' delete <- sf_delete(new_records$id[1],
#'                     AllOrNoneHeader = list(allOrNone = TRUE))
#' is_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
#'                        new_records$id[1]),
#'                        queryall = TRUE)
#' hard_deleted <- sf_empty_recycle_bin(new_records$id[1])
#' 
#' # confirm that the record really is gone (can't be deleted)
#' undelete <- sf_undelete(new_records$id[1])
#' # if you use queryall you still will find the record for ~24hrs
#' #is_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
#' #                               new_records$id[1]),
#' #                       queryall = TRUE)
#' }
#' @export
sf_empty_recycle_bin <- function(ids,  
                                 api_type = c("SOAP"), 
                                 verbose = FALSE){
  ids <- sf_input_data_validation(ids, operation='emptyRecycleBin')
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num) - 1) %/% batch_size
  
  base_soap_url <- make_base_soap_url()
  if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]  
    r <- make_soap_xml_skeleton()
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "emptyRecycleBin",
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="emptyRecycleBin",
                                       "Content-Type"="text/xml"),
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, encoding="UTF-8")
    this_set <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>%
      map_df(xml_nodeset_to_df)
    resultset <- bind_rows(resultset, this_set)
  }
  resultset <- resultset %>%
    type_convert(col_types = cols())
  return(resultset)
}
