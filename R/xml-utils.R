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
  if (is.character(node)) {
    node <- xmlParse(node)
  }
  if (inherits(node, "XMLAbstractDocument")) {
    node <- xmlRoot(node)
  }
  if (any(inherits(node, c("XMLTextNode", "XMLInternalTextNode")))) {
    xmlValue(node)
  } else if (xmlSize(node) == 0) {
    x <- xmlAttrs(node)
    if(names(x) == "xsi:nil" & x == "true"){
      NA
    } else {
      x
    }
  } else {
    if (is.list(node)) {
      tmp = vals = xmlSApply(node, xmlToList2)
      tt = xmlSApply(node, inherits, c("XMLTextNode", "XMLInternalTextNode"))
    }
    else {
      tmp = vals = xmlApply(node, xmlToList2)
      tt = xmlSApply(node, inherits, c("XMLTextNode", "XMLInternalTextNode"))
    }
    vals[tt] = lapply(vals[tt], function(x) x[[1]])
    if (any(tt) && length(vals) == 1) {
      vals[[1]]
    } else {
      vals
    }
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
#' @param soap_headers \code{list}; any number of SOAP headers
#' @return a XML document
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/soap_headers.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' Any of the following SOAP headers are allowed:
#' \itemize{
#'    \item AllorNoneHeader
#'    \item AllowFieldTruncationHeader
#'    \item AssignmentRuleHeader
#'    \item CallOptions
#'    \item DisableFeedTrackingHeader
#'    \item EmailHeader
#'    \item LimitInfoHeader
#'    \item LocaleOptions
#'    \item LoginScopeHeader
#'    \item MruHeader
#'    \item OwnerChangeOptions
#'    \item PackageVersionHeader
#'    \item QueryOptions
#'    \item UserTerritoryDeleteHeader
#'    }
#' Additionally, Bulk API can't access or query compound address or compound geolocation fields.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/}
#' @keywords internal
#' @export
make_soap_xml_skeleton <- function(soap_headers=list()){
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
  
  if(length(soap_headers)>0){
    for(i in 1:length(soap_headers)){
      this_parent_node <- newXMLNode(paste0("urn:", names(soap_headers)[i]),
                                     parent=header_node)
      this_opt <- soap_headers[[i]]
      opt_node <- newXMLNode(paste0("urn:", names(this_opt)),
                             as.character(this_opt),
                             parent=this_parent_node)
    }
  }
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
#' @param fields character; one or more strings indicating the fields to be returned 
#' on the records
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
                                                   "query", "queryMore", 
                                                   "describeSObjects"),
                                     object=NULL,
                                     fields=NULL,
                                     external_id_fieldname=NULL,
                                     root_name = NULL, 
                                     ns = c(character(0)),
                                     root = NULL){
  
  # ensure that if root is NULL that root_name is not also NULL
  # this is so we have something to create the root node
  stopifnot(!is.null(root_name) | !is.null(root))
  which_operation <- match.arg(operation)
  input_data <- sf_input_data_validation(input_data, operation='retrieve')
  
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
  
  if(which_operation == "retrieve"){
    stopifnot(!is.null(object))
    stopifnot(!is.null(fields))
    field_list_node <- newXMLNode("urn:fieldList",
                                  paste0(fields, collapse=","),
                                  parent=operation_node)
    sobject_type_node <- newXMLNode("urn:sObjectType",
                                    object,
                                    parent=operation_node)
  }  
  
  if(which_operation %in% c("search", "query")){
    
    element_name <- if(which_operation == "search") "urn:searchString" else "urn:queryString"
    this_node <- newXMLNode(element_name, 
                            input_data[1,1],
                            parent=operation_node)
    
  } else if(which_operation == "queryMore"){
    
    this_node <- newXMLNode("urn:queryLocator", 
                            input_data[1,1],
                            parent=operation_node)
    
  } else if(which_operation %in% c("delete","retrieve")){
    
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