#' Perform SOSL Search
#' 
#' Searches for records in your organization’s data.
#' 
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom dplyr as_tibble rename rename_at select matches starts_with vars everything tibble
#' @importFrom readr cols type_convert col_guess
#' @importFrom purrr map_df 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom httr content
#' @param search_string character; string to search using parameterized search 
#' or SOSL. Note that is_sosl must be set to TRUE and the string valid in order 
#' to perform a search using SOSL.
#' @param is_sosl logical; indicating whether or not to try the string as SOSL
#' @template guess_types
#' @template api_type
#' @param parameterized_search_options \code{list}; a list of parameters for 
#' controlling the search if not using SOSL. If using SOSL this argument is ignored.
#' @template verbose
#' @param ... arguments to be used to form the parameterized search options argument 
#' if it is not supplied directly.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_sosl.htm}
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' # free text search
#' area_code_search_string <- "(336)"
#' search_result <- sf_search(area_code_search_string)
#' 
#' # free text search with parameters
#' search_result <- sf_search(area_code_search_string,
#'                            fields_scope = "PHONE",
#'                            objects = "Lead",
#'                            fields = c("id", "phone", "firstname", "lastname"))
#' 
#' # using SOSL
#' my_sosl_search <- paste("FIND {(336)} in phone fields returning",
#'                         "contact(id, phone, firstname, lastname),",
#'                         "lead(id, phone, firstname, lastname)")
#' sosl_search_result <- sf_search(my_sosl_search, is_sosl=TRUE)
#' }
#' @export
sf_search <- function(search_string,
                      is_sosl = FALSE,
                      guess_types = TRUE,
                      api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                      parameterized_search_options = list(...),
                      verbose = FALSE, 
                      ...){
  
  which_api <- match.arg(api_type)
  
  # REST implementation
  if(which_api == "REST"){
    if(is_sosl){
      target_url <- make_search_url(search_string)
      httr_response <- rGET(url = target_url,
                            headers = c("Accept"="application/json", 
                                        "Content-Type"="application/json"))
    } else {
      parameterized_search_control <- do.call("parameterized_search_control",
                                              parameterized_search_options)
      parameterized_search_control <- c(list(q=search_string), parameterized_search_control)
      target_url <- make_parameterized_search_url()
      request_body <- toJSON(parameterized_search_control,
                             auto_unbox = TRUE)
      httr_response <- rPOST(url = target_url,
                             headers = c("Accept"="application/json", 
                                         "Content-Type"="application/json"),
                             body = request_body)
    }
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                prettify(request_body))
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    resultset <- fromJSON(response_parsed, flatten=TRUE)$searchRecords
    if(length(resultset) > 0){
      suppressMessages(
        resultset <- resultset %>% 
          rename(sObject = `attributes.type`) %>%
          select(-matches("^attributes\\."))
      ) 
    } else {
      resultset <- tibble()
    }
  } else if(which_api == "SOAP"){
    # TODO: should SOAP only take SOSL?
    if(!is_sosl){
      stop(paste("The SOAP API only takes SOSL formatted search strings.", 
                 "Set is_sosl=TRUE or set api_type='REST' if trying to do a free text search"))
    }
    r <- make_soap_xml_skeleton()
    xml_dat <- build_soap_xml_from_list(input_data = search_string,
                                        operation = "search",
                                        root = r)
    request_body <- as(xml_dat, "character")
    base_soap_url <- make_base_soap_url()
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="search",
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
    resultset <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//record')
    if(length(resultset) > 0){
      suppressMessages(
        resultset <- resultset %>%
          map_df(xml_nodeset_to_df) %>%
          rename(sObject = `sf:type`) %>%
          rename_at(.vars = vars(starts_with("sf:")), 
                    .funs = list(~sub("^sf:", "", .)))
      )
    } else {
      resultset <- tibble()
    }
  } else if(which_api == "Bulk 1.0"){
    stop("SOSL is not supported in Bulk API. For retrieving a large number of records use SOQL (queries) instead.")
  } else if(which_api == "Bulk 2.0"){
    stop("SOSL is not supported in Bulk API. For retrieving a large number of records use SOQL (queries) instead.")
  } else {
    stop("Unknown API type")
  }
  if(nrow(resultset) > 0){
    resultset <- resultset %>% 
      as_tibble() %>%
      # reorder because the REST API does it differently
      select(sObject, everything())
      if(guess_types){
        resultset <- resultset %>%
          type_convert(col_types = cols(.default = col_guess()))
      }
  }
  return(resultset)
}

#' Auxiliary for Controlling Parametrized Searches
#' 
#' A function for allowing finer grained control over how a search is performed
#' when not using SOSL
#' 
#' @param objects character; objects to search and return in the response. Multiple 
#' objects can be provided as a character vector
#' @param fields_scope character; scope of fields to search in order to limit the resources 
#' used and improve performance
#' @param fields character; one or more fields to return in the response for each 
#' sobject specified. If no fields are specified only the Ids of the matching records 
#' are returned.
#' @param overall_limit numeric; the maximum number of results to return across 
#' all sobject parameters specified.
#' @param spell_correction logical; specifies whether spell correction should be
#' enabled for a user’s search.
#' @return \code{list} of parameters passed onto sf_search
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_search_parameterized.htm#resources_search_parameterized}
#' @examples
#' \dontrun{
#' # free text search only on Contact record Phone fields
#' # this will improve the performance of the search
#' my_phone_search <- "(336)"
#' search_result <- sf_search(my_phone_search,
#'                            objects = c("Contact", "Lead"),
#'                            fields_scope = "PHONE",
#'                            fields = c("Id", "FirstName", "LastName"))
#' }
#' @export
parameterized_search_control <- function(objects = NULL,
                                         fields_scope = c("ALL", "NAME", "EMAIL", "PHONE" ,"SIDEBAR"),
                                         fields = NULL,
                                         overall_limit = 2000,
                                         spell_correction = TRUE){
  
  which_fields_scope <- match.arg(fields_scope)
  
  if(!is.null(fields) & is.null(objects)){
    stop("You must specify the objects if you are limiting the fields to return.")
  }
  result <- list()
  result$`in` <- which_fields_scope
  if(!is.null(fields)) result$fields <- fields
  if(!is.null(objects)) result$sobjects <- lapply(objects, FUN=function(x){list(name=x)})
  result$overallLimit <- as.integer(overall_limit)
  result$spellCorrection <- tolower(spell_correction)
  return(result)
}
