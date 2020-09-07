#' Update Records
#' 
#' @description
#' `r lifecycle::badge("maturing")`
#' 
#' Updates one or more records to your organization’s data.
#' 
#' @importFrom lifecycle deprecate_warn is_present deprecated
#' @template input_data
#' @template object_name
#' @template api_type
#' @template guess_types
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
#' @template all_or_none
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
#' new_records <- sf_create(new_contacts, "Contact")
#' updated_contacts <- tibble(FirstName = rep("TestTest", n),
#'                            LastName = paste0("Contact", 1:n),
#'                            Id = new_records$id)
#' # update and allow fields to be truncated if they are too long
#' update <- sf_update(input_data = updated_contacts, object_name = "Contact",
#'                     AllowFieldTruncationHeader=list(allowFieldTruncation=TRUE))
#' }
#' @export
sf_update <- function(input_data,
                      object_name,
                      api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                      guess_types = TRUE,
                      control = list(...), ...,
                      all_or_none = deprecated(),
                      verbose = FALSE){
  
  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "update"
  
  if(is_present(all_or_none)) {
    deprecate_warn("0.1.3", "salesforcer::sf_update(all_or_none = )", 
                   "sf_update(AllOrNoneHeader = )", 
                   details = paste0("You can pass the all or none header directly ", 
                                    "as shown above or via the `control` argument."))
    control_args$AllOrNoneHeader <- list(allOrNone = tolower(all_or_none))
  }    
  
  if("AssignmentRuleHeader" %in% names(control_args)){
    if(!object_name %in% c("Account", "Case", "Lead")){
      stop("The AssignmentRuleHeader can only be used when creating, updating, or upserting an Account, Case, or Lead")
    }
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_update_soap(input_data = input_data,
                                object_name = object_name,
                                guess_types = guess_types,
                                control = control_args, 
                                verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_update_rest(input_data = input_data,
                                object_name = object_name,
                                guess_types = guess_types,
                                control = control_args, 
                                verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_update_bulk_v1(input_data, 
                                   object_name = object_name,
                                   guess_types = guess_types,
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    resultset <- sf_update_bulk_v2(input_data, 
                                   object_name = object_name, 
                                   guess_types = guess_types,
                                   control = control_args, 
                                   verbose = verbose, ...)
  } else {
    catch_unknown_api(api_type)
  }
  return(resultset)
}

#' Update Records using SOAP API
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
sf_update_soap <- function(input_data, 
                           object_name,
                           guess_types = TRUE,
                           control, ...,
                           verbose = FALSE){
  
  input_data <- sf_input_data_validation(operation='update', input_data)
  control <- do.call("sf_control", control)
  
  base_soap_url <- make_base_soap_url()
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(input_data)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id)+1, " Batches")
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
                                        operation = "update",
                                        object_name = object_name,
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction" = "update",
                                       "Content-Type" = "text/xml"),
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    this_set <- response_parsed %>%
      xml_ns_strip() %>%
      xml_find_all('.//result') %>% 
      map_df(extract_records_from_xml_node)
    resultset <- safe_bind_rows(list(resultset, this_set))
  }
  
  resultset <- resultset %>% 
    sf_reorder_cols() %>% 
    sf_guess_cols(guess_types)
  
  return(resultset)
}

#' Update Records using REST API
#' 
#' @importFrom purrr map_df
#' @importFrom readr cols type_convert col_guess
#' @importFrom stats quantile
#' @importFrom utils head
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_update_rest <- function(input_data, 
                           object_name, 
                           guess_types = TRUE,
                           control, ...,
                           verbose = FALSE){
  
  # This resource is available in API version 42.0 and later.
  stopifnot(as.numeric(getOption("salesforcer.api_version")) >= 42.0)
  input_data <- sf_input_data_validation(operation='update', input_data)
  
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
  
  input_data$attributes <- lapply(1:nrow(input_data), FUN=function(x, obj){list(type=obj, referenceId=paste0("ref" ,x))}, obj=object_name)
  #input_data$attributes <- list(rep(list(type=object_name), nrow(input_data)))[[1]]
  input_data <- input_data %>% select(attributes, everything())
  
  composite_url <- make_composite_url()
  # add attributes to insert multiple records at a time
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections.htm?search_text=update%20multiple
  # this type of request can only handle 200 records at a time
  # so break up larger datasets, batch the data
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
    request_body <- list(allOrNone = all_or_none, records = batched_data)
    httr_response <- rPATCH(url = composite_url,
                            headers = request_headers,
                            body = request_body, 
                            encode = "json")
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                request_body)
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
    resultset <- c(resultset, response_parsed)
  }

  resultset <- resultset %>% 
    map_df(flatten_tbl_df) %>%
    sf_reorder_cols() %>% 
    sf_guess_cols(guess_types)
  
  return(resultset)
}

#' Update Records using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_update_bulk_v1 <- function(input_data, 
                              object_name,
                              guess_types = TRUE,
                              control, ...,
                              verbose = FALSE){
  input_data <- sf_input_data_validation(operation = "update", input_data)
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = input_data, 
                                 object_name = object_name, 
                                 guess_types = guess_types,
                                 operation = "update",
                                 api_type = "Bulk 1.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}

#' Update Records using Bulk 2.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_update_bulk_v2 <- function(input_data, 
                              object_name,
                              guess_types = TRUE,
                              control, ...,
                              verbose = FALSE){
  # The order of records in the response is not guaranteed to match the ordering of
  # records in the original job data.
  input_data <- sf_input_data_validation(operation = "update", input_data)
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = input_data, 
                                 object_name = object_name, 
                                 guess_types = guess_types,
                                 operation = "update", 
                                 api_type = "Bulk 2.0",
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}
