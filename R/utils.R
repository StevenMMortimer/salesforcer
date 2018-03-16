#' Determine the host operating system
#' 
#' This function determines whether the system running the R code
#' is Windows, Mac, or Linux
#'
#' @return A character string
#' @examples
#' \dontrun{
#' get_os()
#' }
#' @seealso \url{http://conjugateprior.org/2015/06/identifying-the-os-from-r}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin'){
      os <- "osx"
    }
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os)){
      os <- "osx"
    }
    if (grepl("linux-gnu", R.version$os)){
      os <- "linux"
    }
  }
  unname(tolower(os))
}

#' Function to catch and print HTTP errors
#'
#' @importFrom httr content http_error
#' @importFrom xml2 as_list xml_find_first
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
catch_errors <- function(x){
  if(http_error(x)){
    response_parsed <- content(x, encoding='UTF-8')
    # convert to list if xml content type
    content_type <- x$headers$`content-type`
    if(grepl('xml', content_type)){
      response_parsed <- as_list(response_parsed)
    }
    if(status_code(x) < 500){
      if(!is.null(response_parsed$exceptionCode)){
        stop(sprintf("%s: %s", response_parsed$exceptionCode, response_parsed$exceptionMessage))
      } else if(!is.null(response_parsed$error$exceptionCode)){
        stop(sprintf("%s: %s", response_parsed$error$exceptionCode, response_parsed$error$exceptionMessage))
      } else if(!is.null(response_parsed[[1]]$Error$errorCode[[1]])){
        stop(sprintf("%s: %s", response_parsed[[1]]$Error$errorCode[[1]], response_parsed[[1]]$Error$message[[1]]))
      }  else {
        stop(sprintf("%s: %s", response_parsed[[1]]$errorCode, response_parsed[[1]]$message))  
      }
    } else {
      error_message <- response_parsed %>%
        xml_find_first('.//soapenv:Fault') %>%
        as_list()
      stop(error_message$faultstring[[1]][1])
    }
  }
  invisible(FALSE)
}

#' Generic implementation of HTTP methods with retries and authentication
#' 
#' @importFrom httr status_code config add_headers
#' @importFrom stats runif
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
VERB_n <- function(VERB, n = 5) {
  function(url, headers=character(0), ...) {
  
    current_state <- salesforcer_state()
    for (i in seq_len(n)) {
      
      if(is.null(current_state$auth_method)){
        out <- VERB(url = url, add_headers(headers), ...)
      } else if(current_state$auth_method=='OAuth'){
        if(grepl("/services/data/v[0-9]{2}.[0-9]{1}/jobs/ingest", url)){
          out <- VERB(url = url, add_headers(c(headers, "Authorization"=sprintf("Bearer %s", current_state$token$credentials$access_token))), ...)  
        } else if(grepl("/services/async", url)){
          out <- VERB(url = url, add_headers(c(headers, "X-SFDC-Session"=current_state$token$credentials$access_token)), ...)  
        } else {
          out <- VERB(url = url, config=config(token=current_state$token), add_headers(headers), ...)  
        }
      } else if (current_state$auth_method=='Basic') {
        out <- VERB(url = url, add_headers(c(headers, "Authorization"=sprintf("Bearer %s", current_state$session_id))), ...)
      }
      
      status <- status_code(out)
      if (status < 500 || i == n) break
      backoff <- runif(n = 1, min = 0, max = 2 ^ i - 1)
      ## TO DO: honor a verbose argument or option
      mess <- paste("HTTP error %s on attempt %d ...\n",
                    "  backing off %0.2f seconds, retrying")
      mpf(mess, status, i, backoff)
      Sys.sleep(backoff)
    }
    out
  }
}

#' GETs with retries and authentication
#' 
#' @importFrom httr GET
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rGET <- VERB_n(GET)

#' POSTs with retries and authentication
#' 
#' @importFrom httr POST
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPOST <- VERB_n(POST)

#' PATCHs with retries and authentication
#' 
#' @importFrom httr PATCH
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPATCH <- VERB_n(PATCH)

#' PUTs with retries and authentication
#' 
#' @importFrom httr PUT
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPUT <- VERB_n(PUT)

#' DELETEs with retries and authentication
#' 
#' @importFrom httr DELETE
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rDELETE <- VERB_n(DELETE)

## good news: these are handy and call. = FALSE is built-in
##  bad news: 'fmt' must be exactly 1 string, i.e. you've got to paste, iff
##             you're counting on sprintf() substitution
cpf <- function(...) cat(paste0(sprintf(...), "\n"))
mpf <- function(...) message(sprintf(...))
wpf <- function(...) warning(sprintf(...), call. = FALSE)
spf <- function(...) stop(sprintf(...), call. = FALSE)

#' Return the package's .state environment variable
#' 
#' @export
salesforcer_state <- function(){
  .state
}

#' Write a CSV file in format acceptable to Salesforce APIs
#' 
#' @importFrom readr write_csv
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_write_csv <- function(x, path){
  write_csv(x=x, path=path, na="#N/A")
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

#' xml_nodeset_to_df
#' 
#' A function specifically for parsing an XML node into a \code{data.frame}
#' 
#' @importFrom dplyr as_tibble
#' @importFrom utils capture.output
#' @param this_node \code{xml_node}; to be parsed out
#' @return \code{data.frame} parsed from the supplied xml
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
xml_nodeset_to_df <- function(this_node){
  # capture any xmlToList grumblings about Namespace prefix
  invisible(capture.output(node_vals <- unlist(xmlToList2(as.character(this_node)))))
  return(as_tibble(t(node_vals)))
}

#' Make SOAP XML Request Skeleton
#' 
#' Create XML in preparate for sending to the SOAP API
#' 
#' @importFrom XML newXMLNode xmlValue<-
#' @param input_data a \code{data.frame} of data to fill the XML body
#' @param externalIDFieldName character; a string
#' @return a XML document
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_soap_xml_skeleton <- function(){
  sf_auth_check()
  root <- newXMLNode("soapenv:Envelope", 
                     namespaceDefinitions = c("soapenv" = "http://schemas.xmlsoap.org/soap/envelope/",
                                              "xsi" = "http://www.w3.org/2001/XMLSchema-instance",
                                              "urn" = "urn:partner.soap.sforce.com",
                                              "urn1" = "urn:sobject.partner.soap.sforce.com"))
  header_node <- newXMLNode("soapenv:Header", parent=root)
  sheader_node <- newXMLNode("urn:SessionHeader", parent=header_node)
  sid_node <- newXMLNode("urn:sessionId",
                         sf_access_token(),
                         parent=sheader_node)
  return(root)
}

#' Build XML Request Body
#' 
#' Parse data into XML format
#' 
#' @importFrom XML newXMLNode xmlValue<-
#' @param input_data a \code{data.frame} of data to fill the XML body
#' @template operation
#' @template object
#' @template external_id_fieldname
#' @param root_name character; the name of the root node if created
#' @param ns named vector; a collection of character strings indicating the namespace 
#' definitions of the root node if created
#' @param root \code{XMLNode}; a node to be used as the root
#' @return a XML document
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
build_soap_xml_from_list <- function(input_data,
                                     operation = c("create", "retrieve", 
                                                   "update", "upsert", 
                                                   "delete", "search", 
                                                   "query", "describeSObjects"),
                                     object=NULL,
                                     external_id_fieldname=NULL,
                                     root_name = NULL, 
                                     ns = c(character(0)),
                                     root = NULL){
  
  # ensure that if root is NULL that root_name is not also NULL
  # this is so we have something to create the root node
  stopifnot(!is.null(root_name) | !is.null(root))
  which_operation <- match.arg(operation)
  
  if (is.null(root))
    root <- newXMLNode(root_name, namespaceDefinitions = ns)
  
  body_node <- newXMLNode("soapenv:Body", parent=root)
  operation_node <- newXMLNode(sprintf("urn:%s", which_operation),
                               parent=body_node)
  
  if(which_operation == "upsert"){
    stopifnot(!is.null(external_id_fieldname))
    external_field_node <- newXMLNode("urn:externalIDFieldName",
                                      external_id_fieldname,
                                      parent=operation_node)
  }
  
  # put everything into a data.frame format if it's not already
  if(!is.data.frame(input_data)){
    input_data <- as.data.frame(as.list(input_data), stringsAsFactors = FALSE)
  }
  
  if(which_operation == "delete" & ncol(input_data) == 1){
    names(input_data) <- "Id"
  }
  
  if(which_operation %in% c("delete", "update")){
    if(any(grepl("^ID$|^IDS$", names(input_data), ignore.case=TRUE))){
      idx <- grep("^ID$|^IDS$", names(input_data), ignore.case=TRUE)
      names(input_data)[idx] <- "Id"
    }
    stopifnot("Id" %in% names(input_data))
  }
  
  if(which_operation %in% c("search", "query")){
    
    element_name <- if(which_operation == "search") "urn:searchString" else "urn:queryString"
    this_node <- newXMLNode(element_name, 
                            input_data[1,1],
                            parent=operation_node)
    
  } else if(which_operation == "delete"){
    
    for(i in 1:nrow(input_data)){
      this_node <- newXMLNode("urn:ids", 
                              input_data[i,"Id"],
                              parent=operation_node)
    }
    
  } else if(which_operation == "describeSObjects"){
    
    for(i in 1:nrow(input_data)){
      this_node <- newXMLNode("urn:sObjectType", 
                              input_data[i,"sObjectType"],
                              parent=operation_node)
    }
    
  } else {
    
    for(i in 1:nrow(input_data)){
      list <- as.list(input_data[i,,drop=FALSE])
      this_row_node <- newXMLNode("urn:sObjects", parent=operation_node)
      # if the body elements are objects we must list the type of object 
      # under each block of XML for the row
      type_node <- newXMLNode("urn1:type", parent=this_row_node)
      xmlValue(type_node) <- object
      
      if(length(list) > 0){
        for (i in 1:length(list)){
          if (typeof(list[[i]]) == "list") {
            this_node <- newXMLNode(names(list)[i], parent=this_row_node)
            build_soap_xml_from_list(list[[i]], 
                                     operation=operation,
                                     object=object,
                                     external_id_fieldname=external_id_fieldname,
                                     root=this_node)
          } else {
            if (!is.null(list[[i]])){
              this_node <- newXMLNode(names(list)[i], parent=this_row_node)
              xmlValue(this_node) <- list[[i]]
            }
          }
        }
      }
    }
  }
  return(root)
}