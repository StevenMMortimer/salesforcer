#' Create Object or Field Metadata in Salesforce
#' 
#' This function takes a list of Metadata components and sends them 
#' to Salesforce for creation
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
#' @examples
#' \dontrun{
#' # read the metadata of the existing Account object
#' # we will use this object as a template to create a custom version
#' metadata_info <- sf_read_metadata(metadata_type='CustomObject',
#'                                   object_names=c('Account'))
#' custom_metadata <- metadata_info[[1]]
#' # remove default actionOverrides, this cannot be set during creation
#' custom_metadata[which(names(custom_metadata) %in% c("actionOverrides"))] <- NULL
#' # remove fields since its a custom object and the standard ones no longer exist
#' custom_metadata[which(names(custom_metadata) %in% c("fields"))] <- NULL
#' # remove views so that we get the Standard List Views
#' custom_metadata[which(names(custom_metadata) %in% c("listViews"))] <- NULL
#' # remove links so that we get the Standard Web Links
#' custom_metadata[which(names(custom_metadata) %in% c("webLinks"))] <- NULL
#' # now make some adjustments to customize the object
#' this_label <- 'Custom_Account43'
#' custom_metadata$fullName <- paste0(this_label, '__c')
#' custom_metadata$label <- this_label
#' custom_metadata$pluralLabel <- paste0(this_label, 's')
#' custom_metadata$nameField <- list(displayFormat='AN-{0000}',
#'                                   label='Account Number',
#'                                   type='AutoNumber')
#' custom_metadata$fields <- list(fullName="Phone__c",
#'                                label="Phone",
#'                                type="Phone")
#' # set the deployment status, this must be set before creation
#' custom_metadata$deploymentStatus <- 'Deployed'
#' # make a description to identify this easily in the UI setup tab
#' custom_metadata$description <- 'created by the Metadata API'
#' new_custom_object <- sf_create_metadata(metadata_type = 'CustomObject',
#'                                         metadata = custom_metadata, 
#'                                         verbose = TRUE)
#' 
#' # adding custom fields to our object 
#' # input formatted as a list
#' custom_fields <- list(list(fullName='Custom_Account43__c.CustomField66__c',
#'                            label='CustomField66',
#'                            length=100,
#'                            type='Text'),
#'                       list(fullName='Custom_Account43__c.CustomField77__c',
#'                            label='CustomField77',
#'                            length=100,
#'                            type='Text'))
#' # formatted as a data.frame
#' custom_fields <- data.frame(fullName=c('Custom_Account43__c.CustomField88__c',
#'                                        'Custom_Account43__c.CustomField99__c'),
#'                             label=c('Test Field1', 'Test Field2'),
#'                             length=c(44,45),
#'                             type=c('Text', 'Text'))
#' new_custom_fields <- sf_create_metadata(metadata_type = 'CustomField', 
#'                                         metadata = custom_fields)
#' }
#' @export
sf_create_metadata <- function(metadata_type, 
                               metadata,
                               control = list(...), ...,
                               verbose = FALSE){
  
  which_operation <- "createMetadata"
  # run some basic validation on the metadata to see if it conforms to WSDL standards
  metadata <- metadata_type_validator(obj_type=metadata_type, obj_data=metadata)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- "Metadata"
  control_args$operation <- "insert"
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
  xml_dat <- build_metadata_xml_from_list(input_data = metadata, 
                                          metatype = metadata_type, 
                                          root = operation_node)
  
  base_metadata_url <- make_base_metadata_url()
  root <- make_soap_xml_skeleton(soap_headers = control, metadata_ns = TRUE)
  body_node <- newXMLNode("soapenv:Body", parent = root)  
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
