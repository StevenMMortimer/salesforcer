#' Delete Object or Field Metadata in Salesforce
#' 
#' This function takes a request of named elements in Salesforce and deletes them.
#'
#' @importFrom XML newXMLNode xmlInternalTreeParse xmlChildren
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/}
#' @template metadata_type
#' @param object_names a character vector of names that we wish to read metadata for
#' @template all_or_none
#' @template verbose
#' @return A \code{data.frame} containing the creation result for each submitted metadata component
#' @seealso \link{sf_list_metadata}
#' @examples
#' \dontrun{
#' metadata_info <- sf_delete_metadata(metadata_type = 'CustomObject', 
#'                                     object_names = c('Custom_Account25__c'))
#' }
#' @export
sf_delete_metadata <- function(metadata_type, object_names, all_or_none=FALSE, verbose=FALSE){
    
  stopifnot(all(is.character(object_names)))
  stopifnot(metadata_type %in% names(valid_metadata_list()))
  
  # format names into list
  object_list <- as.list(object_names)
  names(object_list) <- rep('fullNames', length(object_list))
  
  which_operation <- "deleteMetadata"
  # define the operation
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  type_node <- newXMLNode("type", metadata_type, parent=operation_node)
  # and add the metadata to it
  xml_dat <- build_metadata_xml_from_list(input_data=object_list, metatype=NULL, root=operation_node)
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(soap_headers=list(AllorNoneHeader = tolower(all_or_none)), metadata_ns=TRUE)
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
  resultset <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  
  return(resultset)
}
