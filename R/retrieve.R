#' Retrieve Records By Id
#' 
#' Retrieves one or more new records to your organization’s data.
#' 
#' @param ids \code{vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; if not a vector, there must be a column called Id (case-insensitive) 
#' that can be passed in the request
#' @param fields character; one or more strings indicating the fields to be returned 
#' on the records
#' @template object_name
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}}
#' @template verbose
#' @return \code{tibble}
#' @examples
#' \dontrun{
#' n <- 3
#' new_contacts <- tibble(FirstName = rep("Test", n),
#'                        LastName = paste0("Contact", 1:n))
#' new_contacts_result <- sf_create(new_contacts, object_name="Contact")
#' retrieved_records <- sf_retrieve(ids=new_contacts_result$id,
#'                                  fields=c("LastName"),
#'                                  object_name="Contact")
#' }
#' @export
sf_retrieve <- function(ids,
                        fields,
                        object_name,
                        api_type = c("REST", "SOAP", "Bulk 1.0", "Bulk 2.0"),
                        control = list(...), ...,
                        verbose = FALSE){
  
  api_type <- match.arg(api_type)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "retrieve"
  if(api_type == "REST"){
    resultset <- sf_retrieve_rest(ids = ids, 
                                  fields = fields, 
                                  object_name = object_name,
                                  control = control_args, ...,
                                  verbose = verbose)
  } else if(api_type == "SOAP"){
    resultset <- sf_retrieve_soap(ids = ids, 
                                  fields = fields, 
                                  object_name = object_name,
                                  control = control_args, ...,
                                  verbose = verbose) 
  } else if(api_type == "Bulk 1.0"){
    stop("Retrieve is not supported in Bulk API. For retrieving a large number of records use SOQL (queries) instead.")
  } else if(api_type == "Bulk 2.0"){
    stop("Retrieve is not supported in Bulk API. For retrieving a large number of records use SOQL (queries) instead.")
  } else {
    stop("Unknown API type")
  }
  return(resultset)
}

#' @importFrom utils head 
#' @importFrom stats quantile 
#' @importFrom dplyr bind_rows as_tibble select matches rename_at starts_with
#' @importFrom httr content
#' @importFrom purrr map_df
#' @importFrom readr type_convert cols
#' @importFrom xml2 xml_find_first xml_find_all xml_text xml_ns_strip
sf_retrieve_soap <- function(ids,
                             fields,
                             object_name,
                             control, ...,
                             verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='retrieve')
  control <- do.call("sf_control", control)
  
  # limit this type of request to only 200 records at a time to prevent 
  # the XML from exceeding a size limit
  batch_size <- 200
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id)+1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  base_soap_url <- make_base_soap_url()
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]  
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = batched_data,
                                        operation = "retrieve",
                                        object_name = object_name,
                                        fields = fields,
                                        root = r)
    request_body <- as(xml_dat, "character")
    httr_response <- rPOST(url = base_soap_url,
                           headers = c("SOAPAction"="retrieve",
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
      xml_find_all('.//result')
    if(length(this_set) > 0){
      this_set <- this_set %>%
        map_df(xml_nodeset_to_df) %>%
        select(-matches("sf:type")) %>%
        rename_at(.vars = vars(starts_with("sf:")), 
                  .funs = list(~gsub("^sf:", "", .))) %>%
        select(-matches("Id1"))
    } else {
      this_set <- NULL
    }
    resultset <- bind_rows(resultset, this_set)
  }
  resultset <- resultset %>% 
    type_convert(col_types = cols())
  return(resultset)
}

#' @importFrom utils head 
#' @importFrom stats quantile 
#' @importFrom dplyr bind_rows as_tibble select_
#' @importFrom httr content
#' @importFrom jsonlite toJSON fromJSON prettify
#' @importFrom readr type_convert cols
sf_retrieve_rest <- function(ids,
                             fields,
                             object_name,
                             control, ...,
                             verbose = FALSE){
  
  ids <- sf_input_data_validation(ids, operation='retrieve')
  
  # https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_composite_sobjects_collections_retrieve.htm?search_text=retrieve%20multiple
  # this type of request can only handle 2000 records at a time
  batch_size <- 2000
  row_num <- nrow(ids)
  batch_id <- (seq.int(row_num)-1) %/% batch_size
  if(verbose) message("Submitting data in ", max(batch_id)+1, " Batches")
  message_flag <- unique(as.integer(quantile(0:max(batch_id), c(0.25,0.5,0.75,1))))
  
  composite_url <- paste0(make_composite_url(), "/", object_name)
  if(verbose) message(composite_url)
  
  resultset <- NULL
  for(batch in seq(0, max(batch_id))){
    if(verbose){
      batch_msg_flg <- batch %in% message_flag
      if(batch_msg_flg){
        message(paste0("Processing Batch # ", head(batch, 1) + 1))
      } 
    }
    batched_data <- ids[batch_id == batch, , drop=FALSE]
    request_body <- toJSON(list(ids = batched_data$Id, fields = fields), 
                           auto_unbox = FALSE)
    httr_response <- rPOST(url = composite_url,
                           headers = c("Accept"="application/json", 
                                       "Content-Type"="application/json"),
                           body = request_body)
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                prettify(request_body))
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, "text", encoding="UTF-8")
    resultset <- bind_rows(resultset, 
                           fromJSON(response_parsed) %>% 
                             select_(.dots =  unique(c("Id", fields))))
  }
  resultset <- resultset %>% 
    as_tibble() %>%
    type_convert(col_types = cols())
  return(resultset)
}
