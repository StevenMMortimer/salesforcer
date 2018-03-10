
# async-queries/
# https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/async_query_running_queries.htm

#' SOQL Query
#' 
#' Query Salesforce
#' 
#' @importFrom RCurl curlEscape
#' @importFrom dplyr bind_rows
#' @importFrom httr content
#' @param soql placeholder
#' @param target_object placeholder
#' @param queryall placeholder
#' @param batch_size placeholder
#' @param api_type placeholder
#' @param next_records_url placeholder
#' @template verbose
#' @return \code{tibble}
#' @export
sf_query <- function(soql,
                     target_object=NULL,
                     queryall=FALSE,
                     batch_size=500,
                     api_type=c("REST", "SOAP", "Bulk", "Async"),
                     next_records_url=NULL, 
                     verbose=FALSE){
  
  which_api <- match.arg(api_type)
  
  if(which_api == "SOAP" | which_api == "Async"){
    stop("Queries using the SOAP and Aysnc APIs has not yet been implemented, use REST or Bulk")
  }
  
  #obj_name <- gsub("(.*)from\\s+([A-Za-z_]+)\\b.*", "\\2", soql, ignore.case = TRUE, perl=TRUE)
  if(is.null(target_object) & which_api == "Bulk"){
    stop("The Bulk API requires the object to be explicitly passed.")
  }
  
  # REST implementation
  if(!is.null(next_records_url)){
    # pull more records from a previous query
    query_url <- sprintf('%s%s', 
                         .state$instance_url, 
                         next_records_url)
  } else {
    # set the url based on the query
    query_url <- sprintf('%s/services/data/v%s/%s/?q=%s', 
                         .state$instance_url,
                         getOption("salesforcer.api_version"),
                         if(queryall) "queryAll" else "query",
                         curlEscape(soql))
  }
  
  # SOAP?? 
  # https://developer.salesforce.com/page/Enterprise_Query
  
  # Bulk??
  
  if(verbose) message(query_url)
  
  # GET the url with the q (query) parameter set to the escaped SOQL string
  httr_response <- rGET(url = query_url,
                        headers = c("Accept"="application/xml")) #,"Sforce-Query-Options"="batchSize=200")
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding='UTF-8')
  resultset <- query_parser(content(httr_response, as='parsed', encoding='UTF-8'))
  
  # check whether it has next record
  if(!is.null(response_parsed$nextRecordsUrl)){
    next_records <- sf_query(next_records_url=response_parsed$nextRecordsUrl)
    resultset <- bind_rows(resultset, next_records)
  }  
  
  return(resultset)

  # nested queries are not permitted using the Bulk API
  # stop()

  #batch_size 10, 2000 connection.setQueryOptions
  
  #return(paste("services/data/v", apiVersion, "/query/?q=", sep=""))
  #return(paste("services/data/v", apiVersion, "/queryAll/?q=", sep=""))
  #sf_query(soql = "SELECT Email FROM User")
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
#' @keywords internal
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
#' @keywords internal
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