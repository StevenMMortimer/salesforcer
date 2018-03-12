#' Perform SOQL Query
#' 
#' Executes a query against the specified object and returns data that matches 
#' the specified criteria.
#' 
#' @importFrom dplyr bind_rows
#' @importFrom httr content
#' @importFrom xml2 xml_find_first xml_text
#' @importFrom readr type_convert
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
    resultset <- query_parser(response_parsed)
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
    # Bulk implementation
    if(is.null(object) & which_api == "Bulk"){
      object <- gsub("(.*)from\\s+([A-Za-z_]+)\\b.*", "\\2", soql, ignore.case = TRUE, perl=TRUE)
      message(sprintf("Guessed target object from query string: %s", object))
      #stop("The Bulk API requires the object to be explicitly passed.")
    }
    resultset <- sf_bulk_query(soql=soql, object=object, verbose=verbose, ...)
  } else {
    # SOAP?? 
    # https://developer.salesforce.com/page/Enterprise_Query
    stop("Queries using the SOAP and Aysnc APIs has not yet been implemented, use REST or Bulk")
  }
  
  return(resultset)
}

#' xmlToList2
#' 
#' This function is an early and simple approach to converting an 
#' XML node or document into a more typical R list containing the data values. 
#' It differs from xmlToList by not including attributes at all in the output.
#' 
#' @importFrom XML xmlApply xmlSApply xmlValue xmlAttrs xmlParse xmlSize xmlRoot
#' @param node the XML node or document to be converted to an R list
#' @return \code{list} parsed from the supplied node
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
xmlToList2 <- function(node){
  if (is.character(node)) 
    node = xmlParse(node)
  if (inherits(node, "XMLAbstractDocument")) 
    node = xmlRoot(node)
  if (any(inherits(node, c("XMLTextNode", "XMLInternalTextNode")))) 
    xmlValue(node)
  else if (xmlSize(node) == 0) 
    xmlAttrs(node)
  else {
    if (is.list(node)) {
      tmp = vals = xmlSApply(node, xmlToList2)
      tt = xmlSApply(node, inherits, c("XMLTextNode", "XMLInternalTextNode"))
    }
    else {
      tmp = vals = xmlApply(node, xmlToList2)
      tt = xmlSApply(node, inherits, c("XMLTextNode", "XMLInternalTextNode"))
    }
    vals[tt] = lapply(vals[tt], function(x) x[[1]])
    if (any(tt) && length(vals) == 1) 
      vals[[1]]
    else vals
  }
}


#' query_parser
#' 
#' A function specifically for parsing SOQL query XML into data.frames
#' 
#' @importFrom xml2 xml_find_all
#' @importFrom purrr map_df
#' @importFrom utils capture.output
#' @param xml a \code{xml_document}
#' @return \code{data.frame} parsed from the supplied xml
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
query_parser <- function(xml){
  
  dat <- xml %>% 
    xml_find_all('records') %>%
    map_df(function(x){
      # capture any xmlToList grumblings about Namespace prefix
      invisible(capture.output(x_vals <- unlist(xmlToList2(as.character(x)))))
      return(as.data.frame(t(x_vals), stringsAsFactors=FALSE))
    }) %>% 
    as.data.frame()
  
  return(dat)
}

# async-queries/
# https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/async_query_running_queries.htm
