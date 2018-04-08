#' List All Objects of a Certain Metadata Type in Salesforce
#' 
#' This function takes a query of metadata types and returns a 
#' summary of all objects in salesforce of the requested types
#'
#' @importFrom XML newXMLNode addChildren
#' @importFrom readr type_convert cols
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/}
#' @param queries a \code{list} of \code{list}s with each element consisting of 2 components: 1) 
#' the metadata type being requested and 2) the folder associated with the type that required for types 
#' that use folders, such as Dashboard, Document, EmailTemplate, or Report.
#' @template verbose
#' @return A \code{tbl_dfs} containing the queried metadata types
#' @note Only 3 queries can be specifed at one time, so the list length must not exceed 3.
#' @examples
#' \dontrun{
#' # pull back a list of all Custom Objects and Email Templates
#' my_queries <- list(list(type='CustomObject'),
#'                    list(folder='unfiled$public',
#'                         type='EmailTemplate'))
#' metadata_info <- sf_list_metadata(queries=my_queries)
#' }
#' @export
sf_list_metadata <- function(queries, verbose=FALSE){
  
  which_operation <- "listMetadata"
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  
  if(typeof(queries[[1]]) != "list"){
    queries <- list(queries)
  }
  
  # and add the metadata to it
  xml_dat <- build_metadata_xml_from_list(input_data=queries, metatype='ListMetadataQuery', root=operation_node)
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(metadata_ns=TRUE)
  body_node <- newXMLNode("soapenv:Body", parent=root)  
  api_node <- newXMLNode("asOfVersion", getOption("salesforcer.api_version"), parent=xml_dat)
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