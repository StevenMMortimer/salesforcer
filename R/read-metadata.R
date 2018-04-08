#' Read Object or Field Metadata from Salesforce
#' 
#' This function takes a a request of named elements in Salesforce and 
#' returns their metadata
#'
#' @importFrom XML newXMLNode addChildren xmlParse xmlToList
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/}
#' @template metadata_type
#' @param object_names a character vector of names that we wish to read metadata for
#' @template verbose
#' @return A \code{list} containing a response for each requested object
#' @examples
#' \dontrun{
#' metadata_info <- sf_read_metadata(metadata_type='CustomObject', 
#'                                   object_names=c('Account'))
#' }
#' @export
sf_read_metadata <- function(metadata_type, object_names, verbose=FALSE){
    
  stopifnot(all(is.character(object_names)))
  stopifnot(metadata_type %in% names(valid_metadata_list()))

  # format names into list
  object_list <- as.list(object_names)
  names(object_list) <- rep('fullNames', length(object_list))

  which_operation <- "readMetadata"
  # define the operation
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  type_node <- newXMLNode("type", metadata_type, parent=operation_node)
  # and add the metadata to it
  xml_dat <- build_metadata_xml_from_list(input_data=object_list, metatype=NULL, root=operation_node)
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(metadata_ns=TRUE)
  body_node <- newXMLNode("soapenv:Body", parent=root)  
  body_node <- addChildren(body_node, xml_dat)
  
  if(verbose) {
    print(base_metadata_url)
    print(root)
  }
  
  httr_response <- rPOST(url = base_metadata_url,
                         headers = c("SOAPAction"=which_operation,
                                     "Content-Type"="text/xml"),
                         body = as(root, "character"))
  catch_errors(httr_response)
  response_parsed <- content(httr_response, encoding="UTF-8")
  invisible(capture.output(
    # capture any xmlToList grumblings about Namespace prefix
    resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//records') %>%
    # we must use XML because character elements are not automatically unboxed
    # see https://github.com/r-lib/xml2/issues/215
    map(.f=function(x){
      xmlToList(xmlParse(as(object=x, Class="character")))
    })
  ))
    
  return(resultset)
}
