#' Perform SOQL Query
#' 
#' Executes a query against the specified object and returns data that matches 
#' the specified criteria.
#' 
#' @template soql
#' @template object_name
#' @param queryall logical; indicating if the query recordset should include 
#' deleted and archived records (available only when querying Task and Event records)
#' @param page_size numeric; a number between 200 and 2000 indicating the number of 
#' records per page that are returned. Speed benchmarks should be done to better 
#' understand the speed implications of choosing high or low values of this argument.
#' @template api_type
#' @param next_records_url character (leave as NULL); a string used internally 
#' by the function to paginate through to more records until complete
#' @param ... Other arguments passed on to \code{\link{sf_query_bulk}}.
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
#' sf_query("SELECT Id, Email FROM Contact LIMIT 10", verbose = TRUE)
#' }
#' @export
sf_query <- function(soql,
                     object_name,
                     queryall=FALSE,
                     page_size=1000,
                     api_type=c("REST", "SOAP", "Bulk 1.0"),
                     next_records_url=NULL,
                     ...,
                     verbose=FALSE){
  
  api_type <- match.arg(api_type)
  if(api_type == "REST"){
    resultset <- sf_query_rest(soql=soql,
                               object_name=object_name,
                               queryall=queryall,
                               page_size=page_size,
                               next_records_url=next_records_url,
                               verbose=verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_query_soap(soql=soql,
                               object_name=object_name,
                               queryall=queryall,
                               page_size=page_size,
                               next_records_url=next_records_url,
                               verbose=verbose)
  } else if(api_type == "Bulk 1.0"){
    if(missing(object_name)){
      stop("object_name is missing. This argument must be provided when using the Bulk API.")
    }
    resultset <- sf_query_bulk(soql=soql, object_name=object_name, verbose=verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}


#' @importFrom dplyr bind_rows as_tibble select matches
#' @importFrom httr content
#' @importFrom jsonlite toJSON
#' @importFrom readr type_convert cols
sf_query_rest <- function(soql,
                          object_name,
                          queryall=FALSE,
                          page_size=1000,
                          api_type=c("REST", "SOAP", "Bulk 1.0"),
                          next_records_url=NULL,
                          ...,
                          verbose=FALSE){
  
  query_url <- make_query_url(soql, queryall, next_records_url)
  if(verbose) message(query_url)
  
  # GET the url with the q (query) parameter set to the escaped SOQL string
  httr_response <- rGET(url = query_url,
                        headers = c("Accept"="application/json", 
                                    "Content-Type"="application/json",
                                    "Sforce-Query-Options"=sprintf("batchSize=%.0f", page_size)))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, "text", encoding="UTF-8")
  response_parsed <- fromJSON(response_parsed, flatten=TRUE)
  if(length(response_parsed$records) > 0){
    resultset <- response_parsed$records %>% 
      select(-matches("^attributes\\.")) %>%
      select(-matches("\\.attributes\\.")) %>%
      type_convert(col_types = cols()) %>%
      as_tibble()
  } else {
    resultset <- NULL
  }
  
  if(!response_parsed$done){
    next_records_url <- response_parsed$nextRecordsUrl
  }
  
  # check whether it has next record
  if(!is.null(next_records_url)){
    next_records <- sf_query_rest(next_records_url=next_records_url)
    resultset <- bind_rows(resultset, next_records)
  }
  
  return(resultset)
}


#' @importFrom dplyr bind_rows as_tibble select matches contains rename_at
#' @importFrom httr content
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @importFrom xml2 xml_find_first xml_find_all xml_text xml_ns_strip
sf_query_soap <- function(soql,
                          object_name,
                          queryall=FALSE,
                          page_size=1000,
                          next_records_url=NULL,
                          ...,
                          verbose=FALSE){
  
  if(!is.null(next_records_url)){
    soap_action <- "queryMore"
    r <- make_soap_xml_skeleton()
    xml_dat <- build_soap_xml_from_list(input_data = next_records_url,
                                        operation = "queryMore",
                                        root=r)
  } else {
    soap_action <- "query"
    r <- make_soap_xml_skeleton(soap_headers=list(QueryOptions=list(batchSize=page_size)))
    xml_dat <- build_soap_xml_from_list(input_data = soql,
                                        operation = "query",
                                        root=r)
  }
  
  base_soap_url <- make_base_soap_url()
  if(verbose) {
    message(base_soap_url)
    message(xml_dat)
  }
  httr_response <- rPOST(url = base_soap_url,
                         headers = c("SOAPAction"=soap_action,
                                     "Content-Type"="text/xml"),
                         body = as(xml_dat, "character"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//records')
  
  if(length(resultset) > 0){
    resultset <- resultset %>%
      map_df(xml_nodeset_to_df) %>%
      select(-matches("sf:type$|sf:Id$")) %>%
      rename_at(.vars = vars(contains("sf:")), 
                .funs = funs(gsub("sf:", "", .))) %>%
      rename_at(.vars = vars(contains("Id1")), 
                .funs = funs(gsub("Id1", "Id", .))) %>%
      type_convert(col_types = cols()) %>%
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
    next_records <- sf_query_soap(next_records_url=query_locator)
    resultset <- bind_rows(resultset, next_records)      
  }
  
  return(resultset)
}

# async-queries/
# https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/async_query_running_queries.htm
