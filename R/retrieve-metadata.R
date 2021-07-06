#' Make A Request to Retrieve the Metadata
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function makes a request to retrieve metadata 
#' as a package XML files that can be modified and later
#' deployed into an environment 
#' 
#' @importFrom XML newXMLNode addChildren
#' @importFrom readr type_convert cols
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_retrieve.htm}
#' @param retrieve_request a \code{list} of parameters defining what XML file representations
#' should be returned
#' @param filename a file path to save the zip file in the event that it is downloaded. The 
#' name must have a .zip extension. The default behavior will be to save in the current 
#' working directory as "package.zip"
#' @param check_interval \code{numeric}; specifying the seconds to wait between retrieve 
#' status requests to check if complete
#' @param max_tries \code{numeric}; specifying the maximum number of times to check 
#' whether the retrieve package.zip is complete before the function times out
#' @template verbose
#' @return A \code{list} of details from the created retrieve request
#' @note See the Salesforce documentation for the proper arguments to create a 
#' retrieveRequest. Here is a link to that documentation: 
#' \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_retrieve_request.htm}
#' @examples
#' \dontrun{
#' retrieve_request <- list(unpackaged=list(types=list(members='*',
#'                                                     name='CustomObject')))
#' retrieve_info <- sf_retrieve_metadata(retrieve_request)
#' }
#' @export
sf_retrieve_metadata <- function(retrieve_request, 
                                 filename='package.zip',
                                 check_interval=3, 
                                 max_tries=20, 
                                 verbose=FALSE){
  
  which_operation <- "retrieve"
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  request_root <- newXMLNode('retrieveRequest', 
                             attrs = c(`xsi:type`='RetrieveRequest'), 
                             suppressNamespaceWarning=TRUE)
  
  if(typeof(retrieve_request[[1]]) != "list"){
    retrieve_request <- list(retrieve_request)
  }
  
  # and add the metadata to it
  xml_dat <- build_metadata_xml_from_list(input_data=retrieve_request, metatype=NULL, root=request_root)
  operation_node <- addChildren(operation_node, xml_dat)
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(metadata_ns=TRUE)
  body_node <- newXMLNode("soapenv:Body", parent=root)
  body_node <- addChildren(body_node, operation_node)
  
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
  
  # continually check status until complete
  counter <- 0
  retrieve_status <- list(done="false")
  while(retrieve_status$done != 'true' & counter < max_tries){
    # this will automatically download the contents to package.zip when ready
    retrieve_status <- sf_retrieve_metadata_check_status(id = resultset$id,
                                                         include_zip = TRUE,
                                                         filename = filename, 
                                                         verbose = verbose)
    Sys.sleep(check_interval)
    counter <- counter + 1
  }
  
  return(retrieve_status)
}

#' Check on Retrieve Calls and Get Contents If Available
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function returns details about an initiated retrieveMetadata request
#' and saves the results into a zip file
#' 
#' @importFrom jsonlite base64_dec
#' @importFrom XML newXMLNode addChildren
#' @importFrom readr type_convert cols
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all as_list read_xml
#' @importFrom purrr map_df map_dfc
#' @importFrom dplyr as_tibble
#' @param id \code{character}; string id returned from \link{sf_retrieve_metadata}
#' @param include_zip \code{logical}; Set to false to check the status of the retrieval without 
#' attempting to retrieve the zip file. If omitted, this argument defaults to true.
#' @param filename a file path to save the zip file in the event that it is downloaded. The 
#' name must have a .zip extension. The default behavior will be to save in the current 
#' working directory as package.zip
#' @template verbose
#' @return A \code{list} of the response
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_checkretrievestatus.htm}
#' @examples
#' \dontrun{
#' retrieve_request <- list(unpackaged=list(types=list(members='*', name='CustomObject')))
#' retrieve_info <- sf_retrieve_metadata(retrieve_request)
#' 
#' # check on status, this will automatically download the contents to package.zip when ready
#' retrieve_status <- sf_retrieve_metadata_check_status(retrieve_info$id)
#' }
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_retrieve_metadata_check_status <- function(id,
                                              include_zip=TRUE,
                                              filename='package.zip', 
                                              verbose=FALSE){
  
  stopifnot(grepl('\\.zip$', filename))

  which_operation <- "checkRetrieveStatus"
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions=c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  addChildren(operation_node, newXMLNode('asyncProcessId', id))
  addChildren(operation_node, newXMLNode('includeZip', tolower(include_zip)))
  
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
  file_properties <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//fileProperties') %>%
    map_df(xml_nodeset_to_df) %>%
    type_convert(col_types = cols())  
    
  summary_elements <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//result/id|.//result/status|.//result/success|.//result/done') %>%
    map_dfc(.f=function(x){
      as_tibble(t(unlist(as_list(read_xml(as(object=x, Class="character"))))))
    })
  summary_elements$fileProperties <- list(file_properties)
  
  zip_result <- response_parsed %>%
    xml_ns_strip() %>%
    xml_find_all('.//zipFile') %>%
    xml_text()
  
  if(summary_elements$done == 'true' & summary_elements$status == 'Succeeded' & 
     summary_elements$success == 'true' & length(zip_result) == 1 & 
     tolower(include_zip) == 'true'){
    # save the zip file
    decoded_dat <- base64_dec(zip_result)
    writeBin(decoded_dat, filename)
    message(paste0('Package Manifest Files Saved at: ', filename))
  }

  return(summary_elements)
}
