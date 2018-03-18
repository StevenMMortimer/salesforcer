#' SObject Basic Information
#' 
#' Describes the individual metadata for the specified object.
#' 
#' @importFrom methods as
#' @importFrom dplyr filter
#' @importFrom httr content
#' @importFrom xml2 xml_find_all xml_ns_strip as_list
#' @param objects character; the name of one or more Salesforcer objects that the 
#' function is operating against (e.g. "Account", "Contact", "CustomObject__c")
#' @template api_type
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' account_metadata <- sf_describe_objects("Account")
#' account_metadata_SOAP <- sf_describe_objects("Account", api_type="SOAP")
#' multiple_objs_metadata <- sf_describe_objects(c("Contact", "Lead"))
#' }
#' @export
sf_describe_objects <- function(objects,
                                api_type = c("SOAP", "REST", "Bulk"),
                                verbose = FALSE){

  which_api <- match.arg(api_type)
  objects <- data.frame(sObjectType=unlist(objects), stringsAsFactors = FALSE)
  
  listed_objects <- sf_list_objects()
  valid_object_names <- sapply(listed_objects$sobjects, FUN=function(x){x$name})

  not_matched_objs <- setdiff(objects$sObjectType, valid_object_names)
  if(length(not_matched_objs) > 0){
    message(sprintf("Skipping the following object(s) for not matching the name of an existing object: %s", paste0(not_matched_objs, collapse=", ")))
  }

  objects <- objects %>%
    filter(sObjectType %in% valid_object_names)
  
  # REST implementation
  if(which_api == "REST"){
    
    resultset <- list()
    for(i in 1:length(objects)){
      describe_object_url <- make_describe_objects_url(objects[i,"sObjectType"])
      if(verbose) message(describe_object_url)
      httr_response <- rGET(url = describe_object_url)
      catch_errors(httr_response)
      response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
      resultset[[i]] <- response_parsed$objectDescribe
    }

  } else if(which_api == "SOAP"){
    # SOAP implementation
    r <- make_soap_xml_skeleton()
    xml_dat <- build_soap_xml_from_list(input_data = objects,
                                        operation = "describeSObjects",
                                        root=r)
    base_soap_url <- make_base_soap_url()
    if(verbose) {
      message(base_soap_url)
    }
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="describeSObjects",
                                       "Content-Type"="text/xml"),
                           body = as(xml_dat, "character"))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, encoding="UTF-8")
    resultset <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>%
      as_list()
  } else {
    stop("Describe SObject is not available for the Bulk API, use REST or SOAP APIs.")
  }
  return(resultset)
}