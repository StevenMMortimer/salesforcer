#' Perform SOQL Query
#' 
#' Executes a query against the specified object and returns data that matches 
#' the specified criteria.
#' 
#' @importFrom dplyr bind_rows
#' @importFrom httr content
#' @importFrom purrr map_df
#' @importFrom readr type_convert
#' @importFrom dplyr as_tibble
#' @importFrom xml2 xml_find_first xml_find_all xml_text xml_ns_strip
#' @template soql
#' @template object
#' @param queryall logical; indicating if the query recordset should include 
#' deleted and archived records (available only when querying Task and Event records)
#' @param batch_size numeric; a number between 200 and 2000 indicating the number of 
#' records per page that are returned. Speed benchmarks should be done to better 
#' understand the speed implications of choosing either endpoint.
#' @template api_type
#' @param next_records_url character (leave as NULL); a string used internally 
#' by the function to paginate through to more records until complete
#' @param ... Other arguments passed on to \code{\link{sf_bulk_query}}.
#' @template verbose
#' @return \code{tibble}
#'@references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
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
                     object=NULL,
                     queryall=FALSE,
                     batch_size=1000,
                     api_type=c("REST", "SOAP", "Bulk", "Async"),
                     next_records_url=NULL,
                     ...,
                     verbose=FALSE){
  
  which_api <- match.arg(api_type)
  
  # REST implementation
  if(which_api == "REST"){
    
    query_url <- make_query_url(soql, queryall, next_records_url)
    if(verbose) message(query_url)
    
    # GET the url with the q (query) parameter set to the escaped SOQL string
    httr_response <- rGET(url = query_url,
                          headers = c("Accept"="application/xml", 
                                      "Sforce-Query-Options"=sprintf("batchSize=%.0f", batch_size)))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    resultset <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//records') %>%
      map_df(xml_nodeset_to_df)
    suppressWarnings(suppressMessages(resultset <- type_convert(resultset)))
    
    next_records_url <- response_parsed %>% 
      xml_find_first('.//nextRecordsUrl') %>%
      xml_text()
    
    # check whether it has next record
    if(!is.na(next_records_url)){
      next_records <- sf_query(next_records_url=next_records_url)
      resultset <- bind_rows(resultset, next_records)
    }
  } else if(which_api == "Bulk"){
    resultset <- sf_bulk_query(soql=soql, object=object, verbose=verbose, ...)
  } else {
    # SOAP?? 
    # https://developer.salesforce.com/page/Enterprise_Query
    stop("Queries using the SOAP and Aysnc APIs has not yet been implemented, use REST or Bulk")
  }
  
  return(resultset)
}

# async-queries/
# https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/async_query_running_queries.htm
