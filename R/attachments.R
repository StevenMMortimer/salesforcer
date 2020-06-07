#' Download an Attachment
#' 
#' This function will allow you to download an attachment to disk based on the 
#' attachment body, file name, and path.
#' 
#' @importFrom httr content
#' @param body character; a URL path to the body of the attachment in Salesforce, 
#' typically retrieved via query on the Attachment object
#' @param name character; the name of the file you would like to save the content to
#' @param path character; a directory path where to create file, defaults to the 
#' current directory.
#' @examples 
#' \dontrun{
#' queried_attachments <- sf_query("SELECT Body, Name 
#'                                  FROM Attachment 
#'                                  WHERE ParentId = '0016A0000035mJ5'")
#' mapply(sf_download_attachment, queried_attachments$Body, queried_attachments$Name)
#' }
#' @export 
sf_download_attachment <- function(body, name, path = "."){
  resp <- rGET(sprintf("%s%s", salesforcer_state()$instance_url, body))
  f <- file.path(path, name)
  writeBin(content(resp, "raw"), f)
  return(invisible(file.exists(f)))
}

#' Create Attachments
#' 
#' This function will allow you to create attachments (and other blob data, such as 
#' Documents) by supplying file paths (absolute or relative) to media that you 
#' would like to upload to Salesforce along with accompanying metadata, such as 
#' a Description, Keywords, ParentId, FolderId, etc.
#' 
#' @param input_data \code{named vector}, \code{matrix}, \code{data.frame}, or 
#' \code{tbl_df}; data can be coerced into a \code{data.frame}. The input must 
#' contain a column entitled 'Body' with an absolute or relative file path 
#' (unless creating a Document using a Url) along with other required fields depending 
#' on the object. See the details below for the other required fields when creating 
#' Attachments and Documents.
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
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_attachment.htm}
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_document.htm}
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_insert_update_blob.htm}
#' @examples 
#' \dontrun{
#' # upload two PDFs from working directory to a particular record as Attachments
#' file_path1 <- here::here("doc1.pdf")
#' file_path2 <- here::here("doc2.pdf")
#' parent_record_id <- "0033s00000zLbgs"
#' attachment_details <- tibble(Body = c(file_path1, file_path2), 
#'                              ParentId = rep(parent_record_id, 2))
#' result <- sf_create_attachment(attachment_details)
#' 
#' # the function supports inserting all blob content, just update the 
#' # object_name argument to add the PDF as a Document instead of an Attachment
#' document_details <- tibble(Name = "doc1.pdf", 
#'                            Description = "Test Document 1", 
#'                            Body = file_path1,
#'                            FolderId = "00l6A000001EgIwQAK",
#'                            Keywords = "example,test,document")
#' result <- sf_create_attachment(document_details, object_name = "Document")
#' 
#' # the Bulk API can be envoked using api_type="Bulk 1.0" which will automatically 
#' # take a data.frame of Attachment info and create a ZIP file with CSV manifest 
#' # that is required for that API
#' result <- sf_create_attachment(attachment_details, api_type="Bulk 1.0")
#' }
#' @export
sf_create_attachment <- function(input_data, 
                                 object_name = "Attachment",
                                 api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0"),
                                 control = list(...), ...,
                                 verbose = FALSE){
  
  api_type <- match.arg(api_type)
  
  # determine how to pass along the control args 
  all_args <- list(...)
  control_args <- return_matching_controls(control)
  control_args$api_type <- api_type
  control_args$operation <- "insert"
  if("AssignmentRuleHeader" %in% names(control_args)){
    if(!object_name %in% c("Account", "Case", "Lead")){
      stop("The AssignmentRuleHeader can only be used when creating, updating, or upserting an Account, Case, or Lead")
    }
  }
  
  if(api_type == "SOAP"){
    resultset <- sf_create_attachment_soap(input_data = input_data,
                                           object_name = object_name,
                                           control = control_args, 
                                           verbose = verbose)
  } else if(api_type == "REST"){
    resultset <- sf_create_attachment_rest(input_data = input_data,
                                           object_name = object_name,
                                           control = control_args, 
                                           verbose = verbose)
  } else if(api_type == "Bulk 1.0"){
    resultset <- sf_create_attachment_bulk_v1(input_data, 
                                              object_name = object_name,
                                              control = control_args, 
                                              verbose = verbose, ...)
  } else if(api_type == "Bulk 2.0"){
    stop("Binary Attachments are not supported in Bulk 2.0 API. Use 'REST, 'SOAP', or 'Bulk 1.0' APIs instead.")
  } else {
    stop("Unknown API type.")
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
sf_create_attachment_soap <- function(input_data, 
                                      object_name = "Attachment", 
                                      control, ...,
                                      verbose = FALSE){
  
  input_data <- sf_input_data_validation(operation = sprintf("create_%s", 
                                                             tolower(object_name)), 
                                         input_data)
  # check if files exist at paths specified and encode which is required for SOAP
  input_data <- check_and_encode_files(input_data, encode=TRUE)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    message("The AllOrNoneHeader is ignored when creating attachments since the procedure iterates one at a time.")
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
    resultset <- bind_rows(resultset, this_set)
  }
  resultset <- resultset %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Create Attachment using REST API
#' 
#' @importFrom readr cols type_convert
#' @importFrom dplyr as_tibble bind_rows
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom mime guess_type
#' @importFrom curl form_data form_file
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_attachment_rest <- function(input_data, 
                                      object_name = "Attachment",
                                      control, ..., 
                                      verbose = FALSE){
  
  input_data <- sf_input_data_validation(operation = sprintf("create_%s", 
                                                             tolower(object_name)), 
                                         input_data)
  # check if files exist at paths specified since REST doesnt need them encoded
  input_data <- check_and_encode_files(input_data, encode=FALSE)
  
  control <- do.call("sf_control", control)
  if("AllOrNoneHeader" %in% names(control)){
    message("The AllOrNoneHeader is ignored when creating attachments since the procedure iterates one at a time.")
  }
  request_headers <- c("Accept"="application/json", "Content-Type"="application/json")
  if("AssignmentRuleHeader" %in% names(control)){
    # take the first list element because it could be useDefaultRule (T/F) or assignmentRuleId
    request_headers <- c(request_headers, c("Sforce-Auto-Assign" = control$AssignmentRuleHeader[[1]]))
  }

  target_url <- make_rest_objects_url(object_name) 
  resultset <- NULL
  for(i in 1:nrow(input_data)){
    this_data <- as.list(input_data[i,,drop=TRUE])
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
    # and update because those enherently passed as JSON arrays 
    resultset <- bind_rows(resultset, fromJSON(sprintf("[%s]", response_parsed)))
  }
  resultset <- resultset %>%
    as_tibble() %>%
    type_convert(col_types = cols())
  return(resultset)
}

#' Create Attachments using Bulk 1.0 API
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
sf_create_attachment_bulk_v1 <- function(input_data, 
                                         object_name = "Attachment",
                                         content_type = "ZIP_CSV",
                                         control, ...,
                                         verbose = FALSE){
  control <- do.call("sf_control", control)
  resultset <- sf_bulk_operation(input_data = input_data, 
                                 object_name = object_name, 
                                 operation = "insert", 
                                 api_type = "Bulk 1.0",
                                 content_type = content_type,
                                 control = control, ...,
                                 verbose = verbose)
  return(resultset)
}


#sf_update_attachment <- function(){}


#' Check that file paths exist and data is encoded if specified
#' 
#' @importFrom base64enc base64encode
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
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
