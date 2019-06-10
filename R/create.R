#' Create Records
#' 
#' Adds one or more new records to your organization’s data.
#' 
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into a \code{data.frame}
#' @template object_name
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
#' @template verbose
#' @return \code{tbl_df} of records with success indicator
#' @note Because the SOAP and REST calls chunk data into batches of 200 records 
#' the AllOrNoneHeader will only apply to the success or failure of every batch 
#' of records and not all records submitted to the function.
#' @examples
#' \dontrun{
#' n <- 2
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_recs1 <- sf_create(new_contacts, object_name = "Contact")
#' 
#' # add control to allow the creation of records that violate a duplicate rules
#' new_recs2 <- sf_create(new_contacts, object_name = "Contact", 
#'                        DuplicateRuleHeader=list(allowSave=TRUE,
#'                                                 includeRecordDetails=FALSE,
#'                                                 runAsCurrentUser=TRUE))
#'                                                   
#' # example using the Bulk 1.0 API to insert records
#' new_recs3 <- sf_create(new_contacts, object_name = "Contact", 
#'                        api_type = "Bulk 1.0")
#' }
#' @export
sf_create <- function(input_data,
                      object_name,
                      api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                      control = list(...), ...,
                      verbose = FALSE){
  
  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "insert"
  if("all_or_none" %in% names(all_args)){
    # warn then set it in the control list
    warning(paste0("The `all_or_none` argument has been deprecated.\n", 
                   "Please pass AllOrNoneHeader argument or use the `sf_control` function."), 
            call. = FALSE)
    control_args$AllOrNoneHeader = list(allOrNone = tolower(all_args$all_or_none))
  }
  if("AssignmentRuleHeader" %in% names(control_args)){
    if(!object_name %in% c("Account", "Case", "Lead")){
      stop("The AssignmentRuleHeader can only be used when creating, updating, or upserting an Account, Case, or Lead")
    }
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_create_soap(input_data = input_data,
                                object_name = object_name,
                                control = control_args, 
                                verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_create_rest(input_data = input_data,
                                object_name = object_name,
                                control = control_args, 
                                verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_create_bulk_v1(input_data, 
                                   object_name = object_name, 
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_create_bulk_v2(input_data, 
                                   object_name = object_name, 
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}

#' Create Records using SOAP API
#' 
#' @importFrom readr cols type_convert
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom dplyr bind_rows
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_soap <- function(input_data, 
                           object_name,
                           control, ...,
                           verbose = FALSE){
  
  input_data <- sf_input_data_validation(operation = 'create', input_data)
  control <- do.call("sf_control", control)
  
  base_soap_url <- make_base_soap_url()
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size  
  if(verbose) message("Submitting data in ", max(batch_id) + 1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- input_data[batch_id == batch, , drop=FALSE]  
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "create",
                                        object_name = object_name,
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url, 
                           headers = c("SOAPAction"="create", 
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
    this_set <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>% 
      map_df(xml_nodeset_to_df)
    resultset <- bind_rows(resultset, this_set)
  }
  resultset <- resultset %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Create Records using REST API
#' 
#' @importFrom readr cols type_convert
#' @importFrom dplyr everything as_tibble bind_rows select
#' @importFrom jsonlite toJSON fromJSON prettify
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_rest <- function(input_data, 
                           object_name,
                           control, ..., 
                           verbose = FALSE){
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  input_data <- sf_input_data_validation(operation='create', input_data)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    all_or_none <- control$AllOrNoneHeader$allOrNone
  } else {
    all_or_none <- FALSE
  }
  request_headers <- c("Accept"="application/json", 
                       "Content-Type"="application/json")
  if("AssignmentRuleHeader" %in% names(control)){
    # take the first list element because it could be useDefaultRule (T/F) or assignmentRuleId
    request_headers <- c(request_headers, c("Sforce-Auto-Assign" = control$AssignmentRuleHeader[[1]]))
  }
  
  # add attributes to insert multiple records at a time
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections.htm?search_text=update%20multiple
  input_data$attributes <- lapply(1:nrow(input_data), FUN=function(x, obj){list(type=obj, referenceId=paste0("ref" ,x))}, obj=object_name)
  #input_data$attributes <- list(rep(list(type=object_name), nrow(input_data)))[[1]]
  input_data <- input_data %>% select(attributes, everything())
  
  composite_url <- make_composite_url()
  # this type of request can only handle 200 records at a time
  batch_size <- 200
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num) - 1) %/% batch_size
  if(verbose) {
    message("Submitting data in ", max(batch_id) + 1, " Batches")
  }
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25, 0.5, 0.75, 1))))
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- input_data[batch_id == batch, , drop=FALSE]
    request_body <- toJSON(list(allOrNone = tolower(all_or_none), 
                                records = batched_data), 
                           auto_unbox = TRUE)
    httr_response <- rPOST(url = composite_url,
                           headers = request_headers,
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                prettify(request_body))
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    resultset <- bind_rows(resultset, fromJSON(response_parsed))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Create Records using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_bulk_v1 <- function(input_data, 
                              object_name,
                              control, ...,
                              verbose = FALSE){
  input_data <- sf_input_data_validation(operation = "create", input_data)
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = input_data, 
                                 object_name = object_name, 
                                 operation = "insert", 
                                 api_type = "Bulk 1.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}


#' Create Records using Bulk 2.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_bulk_v2 <- function(input_data, 
                              object_name,
                              control, ...,
                              verbose = FALSE){
  # The order of records in the response is not guaranteed to match the ordering of
  # records in the original job data.
  input_data <- sf_input_data_validation(operation = "create", input_data)
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = input_data, 
                                 object_name = object_name, 
                                 operation = "insert", 
                                 api_type = "Bulk 2.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}
