#' Update Object or Field Metadata in Salesforce
#' 
#' This function takes a list of Metadata components and sends them 
#' to Salesforce to update an object that already exists
#'
#' @importFrom XML newXMLNode addChildren
#' @importFrom readr type_convert cols
#' @importFrom httr content 
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/}
#' @template metadata_type
#' @template metadata
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return A \code{tbl_df} containing the creation result for each submitted metadata component
#' @note The update key is based on the fullName parameter of the metadata, so updates are triggered
#' when an existing Salesforce element matches the metadata type and fullName.
#' @examples
#' \dontrun{
#' # create an object that we can update
#' base_obj_name <- "Custom_Account1"
#' custom_object <- list()
#' custom_object$fullName <- paste0(base_obj_name, "__c")
#' custom_object$label <- paste0(gsub("_", " ", base_obj_name))
#' custom_object$pluralLabel <- paste0(base_obj_name, "s")
#' custom_object$nameField <- list(displayFormat = 'AN-{0000}', 
#'                                 label = paste0(base_obj_name, ' Number'), 
#'                                 type = 'AutoNumber')
#' custom_object$deploymentStatus <- 'Deployed'
#' custom_object$sharingModel <- 'ReadWrite'
#' custom_object$enableActivities <- 'true'
#' custom_object$description <- paste0(base_obj_name, " created by the Metadata API")
#' custom_object_result <- sf_create_metadata(metadata_type = 'CustomObject',
#'                                            metadata = custom_object)
#' # now update the object that was created
#' update_metadata <- custom_object 
#' update_metadata$fullName <- 'Custom_Account1__c'
#' update_metadata$label <- 'New Label Custom_Account1'
#' update_metadata$pluralLabel <- 'Custom_Account1s_new'
#' updated_custom_object_result <- sf_update_metadata(metadata_type = 'CustomObject',
#'                                                    metadata = update_metadata)
#' }
#' @export
sf_update_metadata <- function(metadata_type, 
                               metadata, 
                               control = list(...), ...,
                               verbose = FALSE){
  
  which_operation <- "updateMetadata"
  
  # run some basic validation on the metadata to see if it conforms to WSDL standards
  metadata <- metadata_type_validator(obj_type = metadata_type, obj_data = metadata)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- "Metadata"
  control_args$operation <- "update"
  if("all_or_none" %in% names(all_args)){
    # warn then set it in the control list
    warning(paste0("The `all_or_none` argument has been deprecated.\n", 
                   "Please pass AllOrNoneHeader argument or use the `sf_control` function."), 
            call. = FALSE)
    control_args$AllOrNoneHeader = list(allOrNone = tolower(all_args$all_or_none))
  }
  control <- do.call("sf_control", control_args)
  
  # define the operation
  operation_node <- newXMLNode(which_operation,
                               namespaceDefinitions = c('http://soap.sforce.com/2006/04/metadata'), 
                               suppressNamespaceWarning = TRUE)
  # and add the metadata to it
  xml_dat <- build_metadata_xml_from_list(input_data = metadata, metatype = metadata_type, root = operation_node)
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(soap_headers = control, metadata_ns = TRUE)
  body_node <- newXMLNode("soapenv:Body", parent=root)  
  body_node <- addChildren(body_node, xml_dat)
  
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