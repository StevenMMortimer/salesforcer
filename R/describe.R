#' SObject Basic Information
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
#' @examples
#' \dontrun{
#' account_metadata <- sf_describe_objects("Account")
#' account_metadata_SOAP <- sf_describe_objects("Account", api_type="SOAP")
#' multiple_objs_metadata <- sf_describe_objects(c("Contact", "Lead"))
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
    message(sprintf("Skipping the following object(s) for not matching the name of an existing object: %s", paste0(not_matched_objs, collapse=", ")))
  }

  object_names <- object_names %>%
    filter(sObjectType %in% valid_object_names) %>% 
    as.data.frame()
  
  if(which_api == "REST"){
    resultset <- list()
    for(i in 1:nrow(object_names)){
      describe_object_url <- make_describe_objects_url(object_names[i,"sObjectType"])
      httr_response <- rGET(url = describe_object_url)
      if(verbose){
        make_verbose_httr_message(httr_response$request$method,
                                  httr_response$request$url, 
                                  httr_response$request$headers)
      }
      catch_errors(httr_response)
      response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
      # TODO: Need to fix!!!!
      resultset[[i]] <- response_parsed$objectDescribe
    }
  } else if(which_api == "SOAP"){
    control_args <- return_matching_controls(control)
    control_args$api_type <- "SOAP"
    control_args$operation <- "describeSObjects"
    control <- do.call("sf_control", control_args)
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
    response_parsed <- content(httr_response, encoding="UTF-8")
    
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
    stop("Unknown API type")
  }
  return(resultset)
}