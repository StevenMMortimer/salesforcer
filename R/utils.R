#' Return the package's .state environment variable
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
salesforcer_state <- function(){
  .state
}

#' Return NA if NULL
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
merge_null_to_na <- function(x){
  if(is.null(x)){ 
    NA
  } else if(length(x) == 0){
    NA
  } else if(is.list(x) & length(x) == 1 & is.null(x[[1]])){
    NA
  } else {
    x
  }
}

#' Write a CSV file in format acceptable to Salesforce APIs
#' 
#' @importFrom readr write_csv
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_write_csv <- function(x, path){
  write_csv(x=x, path=path, na="#N/A")
}

#' Determine the host operating system
#' 
#' This function determines whether the system running the R code
#' is Windows, Mac, or Linux
#'
#' @return A character string
#' @examples
#' \dontrun{
#' get_os()
#' }
#' @seealso \url{http://conjugateprior.org/2015/06/identifying-the-os-from-r}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin'){
      os <- "osx"
    }
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os)){
      os <- "osx"
    }
    if (grepl("linux-gnu", R.version$os)){
      os <- "linux"
    }
  }
  unname(tolower(os))
}

#' Validate the input for an operation
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_input_data_validation <- function(input_data, operation=''){
  
  if(operation == "convertLead"){
    leadid_col <- grepl("^LEADIDS$|^LEAD_IDS$|^ID$|^IDS$", names(input_data), ignore.case=TRUE)
    if(any(leadid_col)){
      names(input_data)[leadid_col] <- "leadId"
    }
    input_col_names <- names(input_data)
    ignoring <- character(0)
    # convert camelcase if matching
    other_expected_names <- c("leadId", "convertedStatus", "accountId", 
                              "contactId", "ownerId", "opportunityId", 
                              "doNotCreateOpportunity", "opportunityName", 
                              "overwriteLeadSource", "sendNotificationEmail")
    for(i in 1:length(input_col_names)){
      target_col <- (tolower(other_expected_names) == tolower(input_col_names[i]))
      target_col2 <- (tolower(other_expected_names) == tolower(gsub("[^A-Za-z]", "", 
                                                                    input_col_names[i])))
      if(sum(target_col) == 1){
        names(input_data)[i] <- other_expected_names[which(target_col)]
      } else if(sum(target_col2) == 1){
        names(input_data)[i] <- other_expected_names[which(target_col2)]
      } else {
        ignoring <- c(ignoring, input_col_names[i])
      }
    }
    
    if(length(ignoring) > 0){
      warning(sprintf("Ignoring the following columns: '%s'", 
                      paste0(ignoring, collapse = "', '")))
    }
    input_data <- input_data[names(input_data) %in% other_expected_names]
    
    if(!is.data.frame(input_data)){
      input_data <- as.data.frame(as.list(input_data), stringsAsFactors = FALSE)  
    }
    
    stopifnot(all(c("leadId", "convertedStatus") %in% names(input_data)))
  }
  
  if(operation == "merge"){
    # dont try to cast the input for these operations, simply check existence of params
    list_based <- TRUE
    stopifnot(names(input_data) == c("victim_ids", "master_fields"))
  } else if(operation %in% c("getDeleted", "getUpdated")){
    # dont try to cast the input for these operations, simply check existence of params
    list_based <- TRUE
    stopifnot(names(input_data) == c("start", "end"))
  } else if(!is.data.frame(input_data)){
    list_based <- FALSE
    if(is.null(names(input_data))){
      if(!is.list(input_data)){
        input_data <- as.data.frame(list(input_data), stringsAsFactors = FALSE)    
      } else {
        input_data <- as.data.frame(unlist(input_data), stringsAsFactors = FALSE)  
      }
    } else {
      input_data <- as.data.frame(as.list(input_data), stringsAsFactors = FALSE)  
    }
  } else {
    list_based <- FALSE
    # if already a data.frame, then do nothing
  }
  
  # list-based inputs, don't modify, just check existence
  if(!list_based){
    if(operation %in% c("describeSObjects") & ncol(input_data) == 1){
      names(input_data) <- "sObjectType"
    }
    if(operation %in% c("delete", "undelete", "emptyRecycleBin", "retrieve", 
                        "findDuplicatesByIds") & ncol(input_data) == 1){
      names(input_data) <- "Id"
    }
    if(operation %in% c("delete", "undelete", "emptyRecycleBin", "retrieve", 
                        "update", "findDuplicatesByIds")){
      if(any(grepl("^ID$|^IDS$", names(input_data), ignore.case=TRUE))){
        idx <- grep("^ID$|^IDS$", names(input_data), ignore.case=TRUE)
        names(input_data)[idx] <- "Id"
      }
      if(sum(names(input_data) == "Id") != 1){
        stop(paste0(sprintf("There are %s columns named 'Id' in the input_data. ", 
                            sum(names(input_data) == "Id")), 
                    "Exactly one field must be named 'Id' to specify the Ids affected by this ",
                    "operation. Please fix and resubmit."))
      }
      if(all(is.na(input_data$Id))){
        stop("All values of in the 'Id' field are missing (NA). Please fix and resubmit.")
      }
    }
    if(operation %in% c("create_attachment", "insert_attachment", "update_attachment")){
      # Body, ParentId is required (Name will be created from Body if missing)
      missing_cols <- setdiff(c("Body", "ParentId"), names(input_data))
      if(length(missing_cols) > 0){
        stop(sprintf("The following columns are required but missing from the input: %s", 
                     paste0(missing_cols, collapse = ",")))
      }
      # 6/10 Turn off this warning because there could be multiple Attachment object fields that are allowed
      # # Warn that you can only insert certain columns Name, Body, Description, ParentId, IsPrivate, and OwnerId
      # not_allowed_cols <- setdiff(names(input_data), c("Name", "Body", "Description", "ParentId", "IsPrivate", "OwnerId"))
      # if(length(not_allowed_cols) > 0){
      #   warning(sprintf("The following columns are not allowed and will be dropped: %s",
      #                   paste0(not_allowed_cols, collapse = ",")))
      #   input_data <- input_data[, names(input_data) != not_allowed_cols, drop=FALSE]
      # }
    }
    if(operation %in% c("create_document", "insert_document", "update_document")){
      # Name, FolderId is required and Body or Url
      missing_cols <- character(0)
      if("Body" %in% names(input_data)){
        if("Url" %in% names(input_data)){
          stop(paste("Both a 'Body' column and a 'Url' column were given.", 
                     "Specify one or the other, but not both."))
        }
      } else {
        if(!("Url" %in% names(input_data))){
            message(paste("Neither a 'Body' column or a 'Url' column were given.", 
                          "Specify one or the other, but not both."))
            missing_cols <- c("'Body' or 'Url'")
        }
      }
      other_missing_cols <- setdiff(c("Name", "FolderId"), names(input_data))
      missing_cols <- c(missing_cols, other_missing_cols) 
      if(length(missing_cols) > 0){
        stop(sprintf("The following columns are required but missing from the input: %s", 
                     paste0(missing_cols, collapse = ",")))
      }
    }
  }
  
  # automatically convert the date and datetime columns to the format 
  # required by Salesforce when creating or updating records
  input_data <- sf_format_time(input_data)
  
  return(input_data)
}

#' Remove NA Columns Created by Empty Related Entity Values
#' 
#' This function will detect if there are related entity columns coming back 
#' in the resultset and try to exclude an additional completely blank column 
#' created by records that don't have a relationship at all in that related entity.
#' 
#' @param dat data; a \code{tbl_df} or \code{data.frame} of a returned resultset
#' @template api_type
#' @importFrom dplyr select one_of
#' @keywords internal
#' @export
remove_empty_linked_object_cols <- function(dat, api_type = c("SOAP", "REST")){
  # try to remove references to empty linked entity objects
  # for example whenever a contact record isn't linked to an Account
  # then the record is included like this: <sf:Account xsi:nil="true"/>
  # which is very hard to discern if that is a Contact field called, "Account" that 
  # is NULL or it's a linked entity on an object called "Account" that is NULL. In 
  # our case we will try to remove if there are other fields in the result using that 
  # as a prefix to fields
  api_type <- match.arg(api_type)
  if(api_type == "REST"){
    # do nothing, typically fixed by itself
  } else if(api_type == "SOAP"){
    potential_object_prefixes <- grepl("^sf:[a-zA-Z]+\\.[a-zA-Z]+", names(dat))
    potential_object_prefixes <- names(dat)[potential_object_prefixes]
    potential_object_prefixes <- unique(gsub("(sf:)([a-zA-Z]+)\\.(.*)", "\\2", potential_object_prefixes))
    if(length(potential_object_prefixes) > 0){
      potential_null_object_fields_to_drop <- paste0("sf:", potential_object_prefixes)
      suppressWarnings(
        dat <- dat %>%
          # suppress the warning because it's possible that some of the 
          # columns are not actually in the data
          select(-one_of(potential_null_object_fields_to_drop))
      )
    }
  } else {
    stop("Unknown API type")
  }
  return(dat)
}

#' Try to Guess the Object if User Does Not Specify for Bulk Queries
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
guess_object_name_from_soql <- function(soql){
  object_name <- gsub("SELECT (.*) FROM ([A-Za-z_]+)\\b(.*)", "\\2", soql, ignore.case = TRUE)
  if(is.null(object_name)){
    stop("The `object_name` argument is NULL. This argument must be provided when using the Bulk APIs.")
  }
  message(sprintf("Guessed %s as the object_name from supplied SOQL. Please set `object_name` explicity if this is incorrect because it is required by the Bulk 1.0 API.", object_name))
  return(object_name)
}

#' Format Headers for Printing
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
format_headers_for_verbose <- function(request_headers){
  paste0(paste(names(request_headers), unlist(request_headers), sep=': '), collapse = "; ")
}

#' Format Verbose Call
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_verbose_httr_message <- function(method, url, headers = NULL, body = NULL){
  message(sprintf("\n--HTTP Request----------------\n%s %s", method, url))
  if(!is.null(headers)) message(sprintf("--Headers---------------------\n%s", 
                                        format_headers_for_verbose(headers)))
  if(!is.null(body)) message(sprintf("--Body------------------------\n%s", 
                                     body))
  return(invisible())
}

#' Format Datetimes for Create and Update operations
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @importFrom lubridate as_datetime
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_datetime <- function(x){
  format(as_datetime(x), "%Y-%m-%dT%H:%M:%SZ")  
}

#' Format Dates for Create and Update operations
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_date <- function(x){
  x <- as_datetime(format(x, "%Y-%m-%d 00:00:00"), tz=Sys.timezone())
  sf_format_datetime(x)
}

sf_format_time <- function (x, ...) {
  UseMethod("sf_format_time", x)
}

#' Format all Date and Datetime columns in a list
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_time.list <- function(x){
  lapply(x, FUN=function(xx){
    if(is.list(xx)){
      lapply(xx, sf_format_time)
    } else {
      sf_format_time(xx)  
    }
  })
}

#' Format all Date and Datetime columns in a dataset
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_time.data.frame <- function(x){
  x %>%
    mutate_if(is.POSIXct, sf_format_datetime) %>% 
    mutate_if(is.POSIXlt, sf_format_datetime) %>% 
    mutate_if(is.POSIXt, sf_format_datetime) %>% 
    mutate_if(is.Date, sf_format_date)
}


#' @export
sf_format_time.Date <- function(x){ 
  sf_format_date(x)
}

#' @export
sf_format_time.POSIXct <- function(x){ 
  sf_format_datetime(x)
}

#' @export
sf_format_time.POSIXlt <- function(x){ 
  sf_format_datetime(x)
}

#' @export
sf_format_time.POSIXt <- function(x){ 
  sf_format_datetime(x)
}

#' @export
sf_format_time.character <- function(x){ 
  x
}

#' @export
sf_format_time.numeric <- function(x){ 
  x
}

#' @export
sf_format_time.logical <- function(x){ 
  x
}
