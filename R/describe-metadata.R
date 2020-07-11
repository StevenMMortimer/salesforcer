#' Describe the Metadata in an Organization
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' This function returns details about the organization metadata
#' 
#' @importFrom XML newXMLNode addChildren
#' @importFrom readr type_convert cols
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all xml_text read_xml
#' @importFrom purrr map_df map_dfc
#' @importFrom dplyr as_tibble
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/}
#' @template verbose
#' @return A \code{tbl_df}
#' @examples
#' \dontrun{
#' # describe metadata for the organization associated with the session
#' metadata_info <- sf_describe_metadata()
#' }
#' @export
sf_describe_metadata <- function(verbose=FALSE){
  
  which_operation <- "describeMetadata"
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  api_node <- newXMLNode("apiVersion", getOption("salesforcer.api_version"), parent=operation_node)

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
  
  metadata_objects <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//metadataObjects') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols()) 

  summary_elements <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result/partialSaveAllowed|.//result/testRequired') %>%
    map_dfc(.f=function(x){
      as_tibble(t(unlist(as_list(read_xml(as(object=x, Class="character"))))))
    })
  # add the organizationNamespace separately since it may be null
  organization_namespace <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result/organizationNamespace') %>% 
    xml_text()
  organization_namespace <- if(organization_namespace == "") NA_character_ else organization_namespace
  
  summary_elements$organizationNamespace <- organization_namespace
  summary_elements$metadataObjects <- list(metadata_objects)    
  
  return(summary_elements)
}
