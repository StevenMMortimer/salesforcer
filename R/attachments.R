#' Download an Attachment
#' 
#' @description
#' `r lifecycle::badge("stable")`
#' 
#' This function will allow you to download an attachment to disk based on the 
#' attachment body, file name, and path.
#' 
#' @importFrom tools file_ext
#' @importFrom httr content
#' @param body \code{character}; a URL path to the body of the attachment in 
#' Salesforce, typically retrieved by \code{\link{sf_query}} on the Attachment 
#' object. Alternatively, you can specify the Salesforce Id of the Attachment.
#' @param name \code{character}; the name of the file you would like to save the
#' content to. Note that you should include the file extension in this name
#' and if this argument is left \code{NULL}, then a query will be made to
#' determine the name and file extension needed. This process may result in a
#' slower download process, so attempt to provide the body and name arguments
#' whenever possible for the best performance.
#' @template sf_id
#' @template object_name
#' @param path \code{character}; a directory path where to create file, defaults 
#' to the current directory.
#' @return \code{character}; invisibly return the file path of the downloaded 
#' content
#' @family Attachment functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_blob_retrieve.htm}{Get Attachment Content from a Record}
#' }
#' @examples 
#' \dontrun{
#' # downloading all attachments for a Parent record
#' # if your attachment name doesn't include the extension, then you can use the 
#' # ContentType column to append it to the Name, if needed
#' queried_attachments <- sf_query("SELECT Id, Body, Name, ContentType 
#'                                  FROM Attachment 
#'                                  WHERE ParentId = '0016A0000035mJ5'")
#' mapply(sf_download_attachment, queried_attachments$Body, queried_attachments$Name)
#' 
#' # downloading an attachment by its Id
#' # (the file name will be the same as it exists in Salesforce)
#' sf_download_attachment(sf_id = queried_attachments$Id[1])
#' }
#' @export 
sf_download_attachment <- function(body, 
                                   name = NULL, 
                                   sf_id = NULL, 
                                   object_name = c("Attachment", "Document"),
                                   path = "."){
  
  object_name <- match.arg(object_name)
  
  if(!is.null(sf_id)){
    this_url <- sprintf("%s/services/data/v48.0/sobjects/%s/%s/Body", 
                        salesforcer_state()$instance_url, object_name, sf_id)
  } else {
    this_url <- sprintf("%s%s", salesforcer_state()$instance_url, body)
  }
  resp <- rGET(this_url)
  
  if(is.null(name)){
    # need to derive the id and then pull
    if(is.null(sf_id)){
      object_name <- gsub("sobjects/(.*)/(.*)/Body", "\\1", this_url)
      sf_id <- gsub("sobjects/(.*)/(.*)/Body", "\\2", this_url)
    }
    details <- sf_query(sprintf("SELECT Name, ContentType 
                                 FROM %s
                                 WHERE Id = '%s'", 
                                object_name, 
                                sf_id)
                        )
    content_ext <- file_ext(details$Name[1])
    if(content_ext == ""){
      name <- paste0(details$Name[1], details$ContentType[1])
    } else {
      name <- details$Name[1]
    }
  }
  
  f <- file.path(path, name)
  writeBin(content(resp, "raw"), f)
  return(invisible(f))
}

#' Create Attachments
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function will allow you to create attachments (and other blob data, such as 
#' Documents) by supplying file paths (absolute or relative) to media that you 
#' would like to upload to Salesforce along with accompanying metadata, such as 
#' a Description, Keywords, ParentId, FolderId, etc.
#' 
#' @template attachment_input_data
#' @template object_name
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
#' @template verbose
#' @return \code{tbl_df} with details of the created records
#' @note The length of any file name can’t exceed 512 bytes (per Bulk 1.0 API). 
#' The SOAP API create call restricts these files to a maximum size of 25 MB. For a file 
#' attached to a Solution, the limit is 1.5 MB. The maximum email attachment size is 3 MB. 
#' You can only create or update documents to a maximum size of 5 MB. The REST API 
#' allows you to insert or update blob data limited to 50 MB of text data or 37.5 MB 
#' of base64–encoded data.
#' @family Attachment functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_attachment.htm}{Attachment Object (SOAP)}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_document.htm}{Document Object (SOAP)}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_insert_update_blob.htm}{Insert or Update Blob Data}
#' }
#' @examples 
#' \dontrun{
#' # upload two PDFs from working directory to a particular record as Attachments
#' file_path1 <- here::here("doc1.pdf")
#' file_path2 <- here::here("doc2.pdf")
#' parent_record_id <- "0036A000002C6MmQAK"
#' attachment_details <- tibble(Body = c(file_path1, file_path2), 
#'                              ParentId = rep(parent_record_id, 2))
#' result <- sf_create_attachment(attachment_details)
#' 
#' # the function supports inserting all blob content, just update the 
#' # object_name argument to add the PDF as a Document instead of an Attachment
#' document_details <- tibble(Name = "doc1.pdf", 
#'                            Description = "Test Document 1", 
#'                            Body = file_path1,
#'                            FolderId = "00l6A000001EgIwQAK", # replace with your FolderId!
#'                            Keywords = "example,test,document")
#' result <- sf_create_attachment(document_details, object_name = "Document")
#' 
#' # the Bulk API can be invoked using api_type="Bulk 1.0" which will automatically 
#' # take a data.frame of Attachment info and create a ZIP file with CSV manifest 
#' # that is required for that API
#' result <- sf_create_attachment(attachment_details, api_type="Bulk 1.0")
#' }
#' @export
sf_create_attachment <- function(attachment_input_data, 
                                 object_name = c("Attachment", "Document"),
                                 api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                                 control = list(...), ...,
                                 verbose = FALSE){
  
  api_type <- match.arg(api_type)
  object_name <- match.arg(object_name)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "insert"
  if("AssignmentRuleHeader" %in% names(control_args)){
    if(!object_name %in% c("Account", "Case", "Lead")){
      stop(paste0("The AssignmentRuleHeader can only be used when creating, ", 
                  "updating, or upserting an Account, Case, or Lead."), .call=FALSE)
    }
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_create_attachment_soap(attachment_input_data = attachment_input_data,
                                           object_name = object_name,
                                           control = control_args, 
                                           verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_create_attachment_rest(attachment_input_data = attachment_input_data,
                                           object_name = object_name,
                                           control = control_args, 
                                           verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_create_attachment_bulk_v1(attachment_input_data = attachment_input_data, 
                                              object_name = object_name,
                                              control = control_args, 
                                              verbose = verbose, ...)
  } else {
    catch_unknown_api(api_type, c("SOAP", "REST", "Bulk 1.0"))
  }
  return(resultset)
}

#' Create Attachment using SOAP API
#' 
#' @importFrom readr cols type_convert
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom dplyr bind_rows
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_attachment_soap <- function(attachment_input_data, 
                                      object_name = c("Attachment", "Document"),
                                      control, ...,
                                      verbose = FALSE){
  
  object_name <- match.arg(object_name)
  input_data <- sf_input_data_validation(operation = sprintf("create_%s", 
                                                             tolower(object_name)), 
                                         attachment_input_data)
  # check if files exist at paths specified and encode which is required for SOAP
  input_data <- check_and_encode_files(input_data, encode=TRUE)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    message(paste0("The `AllOrNoneHeader` is ignored when creating attachments ", 
                   "since the procedure iterates one at a time."))
  }
  base_soap_url <- make_base_soap_url()
  resultset <- NULL
  for(i in 1:nrow(input_data)){
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = input_data[i, , drop=FALSE],
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
    resultset <- safe_bind_rows(list(resultset, this_set))
  }
  resultset <- resultset %>%
    sf_reorder_cols() %>% 
    sf_guess_cols()
  return(resultset)
}

#' Create Attachment using REST API
#' 
#' @importFrom readr cols type_convert
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom jsonlite toJSON fromJSON prettify
#' @importFrom mime guess_type
#' @importFrom curl form_data form_file
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_attachment_rest <- function(attachment_input_data, 
                                      object_name = c("Attachment", "Document"),
                                      control, ..., 
                                      verbose = FALSE){
  
  object_name <- match.arg(object_name)
  input_data <- sf_input_data_validation(operation = sprintf("create_%s", 
                                                             tolower(object_name)), 
                                         attachment_input_data)
  # check if files exist at paths specified since REST doesn't need them encoded
  input_data <- check_and_encode_files(input_data, encode=FALSE)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    message(paste0("The `AllOrNoneHeader` is ignored when creating attachments ", 
                   "since the procedure iterates one at a time."))
  }
  request_headers <- c("Accept" = "application/json", 
                       "Content-Type" = "application/json")
  target_url <- make_rest_objects_url(object_name) 
  resultset <- NULL
  for(i in 1:nrow(input_data)){
    this_data <- as.list(input_data[i, , drop=TRUE])
    this_file_path <- this_data$Body
    this_data$Body <- NULL
    json_metadata <- toJSON(this_data, auto_unbox = TRUE, na="null")
    request_body <- list(
      entity_document = form_data(json_metadata, type = "application/json"),
      Body = form_file(this_file_path, type = guess_type(this_file_path))
    )
    # post the multipart body
    httr_response <- rPOST(url = target_url, body = request_body, encode = "multipart")
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                paste("--boundary_string      ",
                                      prettify(json_metadata), 
                                      "--boundary_string      ",
                                      sprintf("Binary data from file: %s", this_file_path),
                                      "--boundary_string--    ",
                                      sep = "\n"))
    }
    catch_errors(httr_response)
    response_parsed <- content(httr_response, as = "text", encoding = "UTF-8")
    # NOTE: Wrap response with "[]" to make the JSON an array of results, otherwise 
    # converting the fromJSON response into a dataframe will choke on the empty list
    # I have no idea why fromJSON would parse things differently. 
    # This doesn't occur with the calls to the composite REST API like with create 
    # and update because those inherently passed as JSON arrays 
    resultset <- safe_bind_rows(list(resultset, fromJSON(sprintf("[%s]", response_parsed))))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    sf_reorder_cols() %>% 
    sf_guess_cols()
  return(resultset)
}

#' Create Attachments using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_attachment_bulk_v1 <- function(attachment_input_data, 
                                         object_name = c("Attachment", "Document"),
                                         content_type = "ZIP_CSV",
                                         control, ...,
                                         verbose = FALSE){
  object_name <- match.arg(object_name)
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = attachment_input_data, 
                                 object_name = object_name, 
                                 operation = "insert", 
                                 api_type = "Bulk 1.0",
                                 content_type = content_type,
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}

#' Update Attachments
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function will allow you to update attachments (and other blob data, such as 
#' Documents) by providing the Id of the attachment record and the file paths 
#' (absolute or relative) to media that you would like to upload to Salesforce 
#' along with other supported metadata for this operation (\code{Name}, 
#' \code{Body}, \code{IsPrivate}, and \code{OwnerId}).
#' 
#' @template attachment_input_data
#' @template object_name
#' @template api_type
#' @template control
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
#' @template verbose
#' @return \code{tbl_df} with details of the created records
#' @note The length of any file name can’t exceed 512 bytes (per Bulk 1.0 API). 
#' The SOAP API create call restricts these files to a maximum size of 25 MB. For a file 
#' attached to a Solution, the limit is 1.5 MB. The maximum email attachment size is 3 MB. 
#' You can only create or update documents to a maximum size of 5 MB. The REST API 
#' allows you to insert or update blob data limited to 50 MB of text data or 37.5 MB 
#' of base64–encoded data.
#' @family Attachment functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_attachment.htm}{Attachment Object (SOAP)}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_document.htm}{Document Object (SOAP)}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_insert_update_blob.htm}{Insert or Update Blob Data}
#' }
#' @examples 
#' \dontrun{
#' # upload a PDF to a particular record as an Attachment
#' file_path <- system.file("extdata",
#'                          "data-wrangling-cheatsheet.pdf",
#'                          package = "salesforcer")
#' parent_record_id <- "0036A000002C6MmQAK" # replace with your own ParentId!
#' attachment_details <- tibble(Body = file_path, ParentId = parent_record_id)
#' create_result <- sf_create_attachment(attachment_details)
#' 
#' # download, zip, and re-upload the PDF
#' pdf_path <- sf_download_attachment(sf_id = create_result$id[1])
#' zipped_path <- paste0(pdf_path, ".zip")
#' zip(zipped_path, pdf_path)
#' attachment_details <- tibble(Id = create_result$id, Body = zipped_path)
#' update_result <- sf_update_attachment(attachment_details)
#' }
#' @export
sf_update_attachment <- function(attachment_input_data,
                                 object_name = c("Attachment"),
                                 api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                                 control = list(...), ...,
                                 verbose = FALSE){
  object_name <- match.arg(object_name)
  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "update"
  if("AssignmentRuleHeader" %in% names(control_args)){
    if(!object_name %in% c("Account", "Case", "Lead")){
      stop(paste0("The AssignmentRuleHeader can only be used when creating, ", 
                  "updating, or upserting an Account, Case, or Lead."), .call=FALSE)
    }
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_update_attachment_soap(attachment_input_data = attachment_input_data,
                                           object_name = object_name,
                                           control = control_args, 
                                           verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_update_attachment_rest(attachment_input_data = attachment_input_data,
                                           object_name = object_name,
                                           control = control_args, 
                                           verbose = verbose)
    
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_update_attachment_bulk_v1(attachment_input_data = attachment_input_data, 
                                              object_name = object_name,
                                              control = control_args, 
                                              verbose = verbose, ...)
  } else {
    catch_unknown_api(api_type, c("SOAP", "REST"))
  }
  return(resultset)
}

#' Update Attachment using SOAP API
#' 
#' @importFrom readr cols type_convert
#' @importFrom httr content
#' @importFrom xml2 xml_ns_strip xml_find_all
#' @importFrom purrr map_df
#' @importFrom dplyr bind_rows
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_update_attachment_soap <- function(attachment_input_data, 
                                      object_name = c("Attachment"),
                                      control, ...,
                                      verbose = FALSE){
  object_name <- match.arg(object_name)
  input_data <- sf_input_data_validation(operation = sprintf("update_%s", 
                                                             tolower(object_name)), 
                                         attachment_input_data)
  # check if files exist at paths specified and encode which is required for SOAP
  input_data <- check_and_encode_files(input_data, encode=TRUE)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    message(paste0("The `AllOrNoneHeader` is ignored when updating attachments ", 
                   "since the procedure iterates one at a time."))
  }
  base_soap_url <- make_base_soap_url()
  resultset <- NULL
  for(i in 1:nrow(input_data)){
    r <- make_soap_xml_skeleton(soap_headers = control)
    xml_dat <- build_soap_xml_from_list(input_data = input_data[i, , drop=FALSE],
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
      map_df(xml_nodeset_to_df)
    resultset <- safe_bind_rows(list(resultset, this_set))
  }
  resultset <- resultset %>%
    sf_reorder_cols() %>% 
    sf_guess_cols()
  return(resultset)
}

#' Update Attachment using REST API
#' 
#' @importFrom readr cols type_convert
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom jsonlite toJSON fromJSON prettify
#' @importFrom mime guess_type
#' @importFrom curl form_data form_file
#' @importFrom httr status_code http_error content
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_update_attachment_rest <- function(attachment_input_data, 
                                      object_name = c("Attachment"),
                                      control, ..., 
                                      verbose = FALSE){
  object_name <- match.arg(object_name)
  input_data <- sf_input_data_validation(operation = sprintf("update_%s", 
                                                             tolower(object_name)), 
                                         attachment_input_data)
  # check if files exist at paths specified since REST doesn't need them encoded
  input_data <- check_and_encode_files(input_data, encode=FALSE)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    message(paste0("The `AllOrNoneHeader` is ignored when updating attachments ", 
                   "since the procedure iterates one at a time."))
  }
  request_headers <- c("Accept" = "application/json", 
                       "Content-Type" = "application/json")
  resultset <- NULL
  for(i in 1:nrow(input_data)){
    this_id <- input_data[i, "Id", drop=TRUE]
    target_url <- make_rest_record_url(object_name, this_id)
    this_data <- as.list(input_data[i,,drop=TRUE])
    this_data$Id <- NULL
    this_file_path <- this_data$Body
    this_data$Body <- NULL
    json_metadata <- toJSON(this_data, auto_unbox = TRUE, na="null")
    request_body <- list(
      entity_document = form_data(json_metadata, type = "application/json"),
      Body = form_file(this_file_path, type = guess_type(this_file_path))
    )
    # post the multipart body
    httr_response <- rPATCH(url = target_url, 
                            body = request_body, 
                            encode = "multipart")
    if(verbose){
      make_verbose_httr_message(httr_response$request$method,
                                httr_response$request$url, 
                                httr_response$request$headers, 
                                paste("--boundary_string      ",
                                      prettify(json_metadata), 
                                      "--boundary_string      ",
                                      sprintf("Binary data from file: %s", this_file_path),
                                      "--boundary_string--    ",
                                      sep = "\n"))
    }
    
    # format the result because if successful, it will be blank!
    if(status_code(httr_response) == 204){
      this_resultset <- tibble(id = this_id, success = TRUE, errors = list(list()))
    } else if(http_error(httr_response)){
      response_parsed <- content(httr_response, as = "parsed", encoding = 'UTF-8')
      parsed_error <- parse_error_code_and_message(response_parsed)
      this_resultset <- tibble(id = this_id, success = FALSE, errors = list(parsed_error))
    } else {
      # Assuming we need to wrap response with "[]" to make the JSON an array of 
      # like we do with `sf_create_attachment_rest()`
      response_parsed <- content(httr_response, as = "text", encoding = "UTF-8")
      this_resultset <- fromJSON(sprintf("[%s]", response_parsed))      
    }
    resultset <- safe_bind_rows(list(resultset, this_resultset))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    sf_reorder_cols() %>% 
    sf_guess_cols()
  return(resultset)
}

#' Update Attachments using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_update_attachment_bulk_v1 <- function(attachment_input_data, 
                                         object_name = c("Attachment"),
                                         content_type = "ZIP_CSV",
                                         control, ...,
                                         verbose = FALSE){
  object_name <- match.arg(object_name)
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = attachment_input_data,
                                 object_name = object_name,
                                 operation = "update",
                                 api_type = "Bulk 1.0",
                                 content_type = content_type,
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}

#' Delete Attachments
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function is a wrapper around \code{\link{sf_delete}} that accepts a list 
#' of Ids and assumes that they are in the Attachment object and should be deleted. 
#' This function is solely provided as a convenience and to provide the last 
#' attachment function to parallel the CRUD functionality for all other records.
#' 
#' @template ids
#' @template object_name
#' @template api_type
#' @param ... arguments passed to \code{\link{sf_control}} or further downstream 
#' to \code{\link{sf_bulk_operation}}
#' @template verbose
#' @return \code{tbl_df} with details of the deleted records
#' @note Because the SOAP and REST calls chunk data into batches of 200 records 
#' the AllOrNoneHeader will only apply to the success or failure of every batch 
#' of records and not all records submitted to the function.
#' @family Attachment functions
#' @examples 
#' \dontrun{
#' # upload a PDF to a particular record as an Attachment
#' file_path <- system.file("extdata",
#'                          "data-wrangling-cheatsheet.pdf",
#'                          package = "salesforcer")
#' parent_record_id <- "0036A000002C6MmQAK" # replace with your own ParentId!
#' attachment_details <- tibble(Body = file_path, ParentId = parent_record_id)
#' create_result <- sf_create_attachment(attachment_details)
#' 
#' # now delete the attachment
#' # note that the function below is just running the following!
#' # sf_delete(ids = create_result$id)
#' sf_delete_attachment(ids = create_result$id)
#' }
#' @export
sf_delete_attachment <- function(ids,
                                 object_name = c("Attachment"),
                                 api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                                 ...,
                                 verbose = FALSE){
  object_name <- match.arg(object_name)
  api_type <- match.arg(api_type)
  sf_delete(ids = ids, 
            object_name = object_name, 
            api_type = api_type, 
            ..., 
            verbose = verbose)
}

#' Check that file paths exist and data is encoded if specified
#' 
#' @importFrom base64enc base64encode
#' @family Attachment functions
#' @param dat \code{tbl_df} or \code{list} of information regarding attachments 
#' stored locally that will be encoded for use in the APIs.
#' @param column \code{character}; a string that indicates which column in the 
#' \code{dat} argument is storing the body of information that needs to be encoded.
#' @param encode \code{logical}; a indicator of whether the body column should 
#' be encoded in this step, which allows us to utilize this function for checking 
#' or checking and encoding.
#' @param n_check \code{integer}; an integer specifying how many elements in the 
#' \code{dat} argument that should be checked to see if the referenced file path 
#' exists locally. This fails the function early if users accidentally specify 
#' the wrong path.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
check_and_encode_files <- function(dat, column = "Body", encode = TRUE, n_check = 100){
  # Documents can be created from Urls so ignore encoding if there is no "Body" column
  if(column == "Body" & !("Body" %in% names(dat))){
    # assume that the column was not specified and left as "Body" default but the 
    # data itself contains another column holding the body data, typically a Url
  } else {
    # stop if the body is a factor
    if(is.factor(dat[[column]])){
      stop(sprintf("The '%s' column is a factor. Convert all columns to string so paths, URLs, etc. are interpreted correctly.", column))
    }
    # stop if content at file.path does not exist
    files_exist <- sapply(head(dat[[column]], n_check), file.exists)
    if(any(!files_exist)){
      not_found_idx <- which(!files_exist)
      for(i in head(not_found_idx, 5)){
        message(sprintf("Row %s, File Not Found: %s", i, dat[[i, column]]))
      }
      if(sum(!files_exist) > 5){
        message(sprintf("There were %s files not found. Run `sapply(dat[,'%s'], file.exists)` to see them all)", 
                        sum(!files_exist), column))
      }
      if(nrow(dat) > n_check){
        message(sprintf("Only checked the first %s rows of the '%s' column are valid file paths.", 
                        n_check, column))
      }
      stop(sprintf("Cannot process until all values in '%s' column are valid file paths.", column))
    }
    # in the event that the Name field is missing then, create it using the file's 
    # basename (includes the extension; for example, "doc1.pdf")
    if(column == "Body" & ("Body" %in% names(dat)) & !("Name" %in% names(dat))){
      dat[,"Name"] <- basename(dat[["Body"]])
    }
    if(encode){
      # base64 encode the values in the target column
      dat[,column] <- sapply(dat[[column]], base64encode)  
    }
  }
  return(dat)
}
