#' Perform SOQL Query
#' 
#' Executes a query against the specified object and returns data that matches 
#' the specified criteria.
#' 
#' @template soql
#' @template object_name
#' @template queryall
#' @template guess_types
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_query_bulk}}.
#' @param next_records_url character (leave as NULL); a string used internally 
#' by the function to paginate through to more records until complete
#' @template verbose
#' @return \code{tbl_df} of records
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @note Bulk API query doesn't support the following SOQL:
#' \itemize{
#'    \item COUNT
#'    \item ROLLUP
#'    \item SUM
#'    \item GROUP BY CUBE
#'    \item OFFSET
#'    \item Nested SOQL queries
#'    \item Relationship fields
#'    }
#' Additionally, Bulk API can't access or query compound address or compound geolocation fields.
#' @examples
#' \dontrun{
#' sf_query("SELECT Id, Account.Name, Email FROM Contact LIMIT 10")
#' }
#' @export
sf_query <- function(soql,
                     object_name,
                     queryall = FALSE,
                     guess_types = TRUE,
                     api_type = c("REST", "SOAP", "Bulk 1.0"),
                     control = list(...), ...,
                     next_records_url = NULL,
                     verbose = FALSE){
  
  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- if(queryall) "queryall" else "query"
  if("page_size" %in% names(all_args)){
    # warn then set it in the control list
    warning(paste0("The `page_size` argument has been deprecated.\n", 
                   "Please pass QueryOptions argument or use the `sf_control` function."), 
            call. = FALSE)
    control_args$QueryOptions = list(batchSize = as.integer(all_args$page_size))
  }
  
  if(api_type == "REST"){
    resultset <- sf_query_rest(soql = soql,
                               object_name = object_name,
                               queryall = queryall,
                               guess_types = guess_types,
                               control = control_args,
                               next_records_url = next_records_url,
                               verbose = verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_query_soap(soql = soql,
                               object_name = object_name,
                               queryall = queryall,
                               guess_types = guess_types,
                               control = control_args,
                               next_records_url = next_records_url,
                               verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    if(missing(object_name)){
      stop("object_name is missing. This argument must be provided when using the Bulk API.")
    }
    resultset <- sf_query_bulk(soql = soql,
                               object_name = object_name,
                               queryall = queryall,
                               guess_types = guess_types,
                               control = control_args,
                               verbose = verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}

#' @importFrom dplyr bind_rows as_tibble select matches tibble
#' @importFrom httr content
#' @importFrom jsonlite toJSON prettify
#' @importFrom readr type_convert cols col_guess
sf_query_rest <- function(soql,
                          object_name,
                          queryall = FALSE,
                          guess_types = TRUE,
                          control, ...,
                          next_records_url = NULL,
                          verbose = FALSE){
  
  query_url <- make_query_url(soql, queryall, next_records_url)
  request_headers <- c("Accept"="application/json", 
                       "Content-Type"="application/json")
  if("QueryOptions" %in% names(control)){
    # take the first list element because it could be useDefaultRule (T/F) or assignmentRuleId
    request_headers <- c(request_headers, c("Sforce-Query-Options" = control$QueryOptions$batchSize))
  }
  
  # GET the url with the q (query) parameter set to the escaped SOQL string
  httr_response <- rGET(url = query_url, headers = request_headers)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, "text", encoding="UTF-8")
  response_parsed <- fromJSON(response_parsed, flatten=TRUE)
  if(length(response_parsed$records) > 0){
    resultset <- response_parsed$records %>% 
      select(-matches("^attributes\\.")) %>%
      select(-matches("\\.attributes\\.")) %>%
      as_tibble()
  } else {
    resultset <- NULL
  }
  
  if(!response_parsed$done){
    next_records_url <- response_parsed$nextRecordsUrl
  }
  
  # check whether it has next record
  if(!is.null(next_records_url)){
    next_records <- sf_query_rest(next_records_url = next_records_url, control = control, 
                                  verbose = verbose, ...)
    resultset <- bind_rows(resultset, next_records)
  }
  
  if(is.null(resultset)){
    resultset <- tibble()
  }
  
  # cast if requested using type_convert
  if(guess_types & nrow(resultset) > 0){
    resultset <- resultset %>% 
      type_convert(col_types = cols(.default = col_guess()))
  }
  return(resultset)
}

#' @importFrom dplyr bind_rows as_tibble select matches contains rename_at rename tibble
#' @importFrom httr content
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols col_guess
#' @importFrom xml2 xml_find_first xml_find_all xml_text xml_ns_strip
sf_query_soap <- function(soql,
                          object_name,
                          queryall = FALSE,
                          guess_types = TRUE,
                          control, ...,
                          next_records_url = NULL,
                          verbose = FALSE){
  
  if(!is.null(next_records_url)){
    soap_action <- "queryMore"
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = next_records_url,
                                        operation = "queryMore",
                                        root = r)
  } else {
    soap_action <- "query"
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = soql,
                                        operation = "query",
                                        root = r)
  }
  
  base_soap_url <- make_base_soap_url()
  request_body <- as(xml_dat, "character") 
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"=soap_action,
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
    xml_find_all('.//records')
  if(length(resultset) > 0){
    resultset <- resultset %>%
      map_df(xml_nodeset_to_df) %>%
      remove_empty_linked_object_cols() %>% 
      # remove redundant linked entity object types.type
      select(-matches("sf:type")) %>% 
      rename_at(.vars = vars(starts_with("sf:")), 
                .funs = list(~sub("^sf:", "", .))) %>%
      rename_at(.vars = vars(matches("\\.sf:")), 
                .funs = list(~sub("sf:", "", .))) %>%
      # move columns without dot up since those are related entities
      select(-matches("\\."), everything())
      as_tibble()
  } else {
    resultset <- NULL
  }
  
  done_status <- response_parsed %>% 
    xml_ns_strip() %>%
    xml_find_first('.//done') %>%
    xml_text()
  
  if(done_status == "false"){
    query_locator <- response_parsed %>% 
      xml_ns_strip() %>%
      xml_find_first('.//queryLocator') %>%
      xml_text()
    next_records <- sf_query_soap(next_records_url = query_locator, control = control, 
                                  verbose = verbose, ...)
    resultset <- bind_rows(resultset, next_records)      
  }
  
  if(is.null(resultset)){
    resultset <- tibble()
  }
  
  # cast if requested using type_convert
  if(guess_types & nrow(resultset) > 0){
    resultset <- resultset %>% 
      type_convert(col_types = cols(.default = col_guess()))
  }
  return(resultset)
}
