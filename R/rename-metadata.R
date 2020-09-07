#' Rename Metadata Elements in Salesforce
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function takes an old and new name for a 
#' metadata element in Salesforce and applies the new name
#'
#' @importFrom XML newXMLNode addChildren
#' @importFrom readr type_convert cols
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/}
#' @template metadata_type
#' @param old_fullname \code{character}; string corresponding to the fullName of the element you would 
#' like to rename
#' @param new_fullname \code{character}; string corresponding to the new fullName you would like 
#' to apply the targeted element
#' @template verbose
#' @return A \code{data.frame} containing the creation result for each submitted metadata component
#' @examples
#' \dontrun{
#' renamed_custom_object <- sf_rename_metadata(metadata_type = 'CustomObject', 
#'                                             old_fullname = 'Custom_Account32__c', 
#'                                             new_fullname = 'Custom_Account99__c')
#' }
#' @export
sf_rename_metadata <- function(metadata_type, old_fullname, new_fullname, verbose=FALSE){
  
  which_operation <- "renameMetadata"
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  operation_node <- addChildren(operation_node, newXMLNode('type', metadata_type))
  operation_node <- addChildren(operation_node, newXMLNode('oldFullname', old_fullname))
  operation_node <- addChildren(operation_node, newXMLNode('newFullname', new_fullname)) 
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(metadata_ns=TRUE)
  body_node <- newXMLNode("soapenv:Body", parent=root)  
  body_node <- addChildren(body_node, operation_node) 
  
  request_body <- as(root, "character")
  httr_response <- rPOST(url = base_metadata_url,
                         headers = c("SOAPAction"=which_operation,
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
    xml_find_all('.//result') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())
  
  return(resultset)
}
