#' SObject Basic Information
#' 
#' @description
#' `r lifecycle::badge("maturing")`
#' 
#' Describes the individual metadata for the specified object.
#' 
#' @importFrom methods as
#' @importFrom dplyr filter tibble
#' @importFrom httr content
#' @importFrom xml2 xml_find_all xml_ns_strip as_list
#' @template object_names
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return \code{list}
#' @seealso \href{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_sobject_describe.htm}{REST API Documentation}, \href{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_describe.htm}{REST API Example}
#' @examples
#' \dontrun{
#' account_metadata <- sf_describe_objects("Account")
#' account_metadata_SOAP <- sf_describe_objects("Account", api_type="SOAP")
#' multiple_objs_metadata <- sf_describe_objects(c("Contact", "Lead"))
#' 
#' account_metadata_REST <- sf_describe_objects("Account", api_type="REST")
#' }
#' @export
sf_describe_objects <- function(object_names,
                                api_type = c("SOAP", "REST"),
                                control = list(...), ...,
                                verbose = FALSE){
  
  which_api <- match.arg(api_type)
  object_names <- tibble(sObjectType = unlist(object_names))
  
  listed_objects <- sf_list_objects()
  valid_object_names <- sapply(listed_objects$sobjects, FUN=function(x){x$name})
  not_matched_objs <- setdiff(object_names$sObjectType, valid_object_names)
  if(length(not_matched_objs) > 0){
    message_w_errors_listed(main_text = paste0("Skipping the following object(s) ", 
                                               "for not matching the name of an ", 
                                               "existing object:"), 
                            not_matched_objs)
  }

  object_names <- as.data.frame(
    object_names[object_names$sObjectType %in% valid_object_names, , drop=FALSE]
  )
  
  if(which_api == "REST"){
    resultset <- list()
    for(i in 1:nrow(object_names)){
      describe_object_url <- make_rest_describe_url(object_names[i, "sObjectType"])
      httr_response <- rGET(url = describe_object_url)
      if(verbose){
        make_verbose_httr_message(httr_response$request$method,
                                  httr_response$request$url, 
                                  httr_response$request$headers)
      }
      catch_errors(httr_response)
      response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
      resultset[[i]] <- response_parsed
    }
  } else if(which_api == "SOAP"){
    api_type <- match.arg(api_type)
    # determine how to pass along the control args 
    all_args <- list(...)
    control_args <- return_matching_controls(control)
    control_args$api_type <- "SOAP"
    control_args$operation <- "describeSObjects"
    control <- filter_valid_controls(control)
    
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = object_names$sObjectType,
                                        operation = "describeSObjects",
                                        root = r)
    base_soap_url <- make_base_soap_url()
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="describeSObjects",
                                       "Content-Type"="text/xml"),
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    
    invisible(capture.output(
      resultset <- response_parsed %>%
        xml_ns_strip() %>%
        xml_find_all('.//result') %>%
        # we must use XML because character elements are not automatically unboxed
        # see https://github.com/r-lib/xml2/issues/215
        map(.f=function(x){
          xmlToList(xmlParse(as(object=x, Class="character")))
        })
    ))
  } else {
    catch_unknown_api(api_type, supported=c("REST", "SOAP"))
  }
  return(resultset)
}
