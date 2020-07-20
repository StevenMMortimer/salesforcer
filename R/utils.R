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
  } else if(operation %in% c("create_report", "filter_report")){
    list_based <- TRUE
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
        stop_w_errors_listed(paste0("The following columns are required but missing ", 
                                    "from the input:"), missing_cols)
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
        stop_w_errors_listed(paste0("The following columns are required but missing ", 
                                    "from the input:"), missing_cols)        
      }
    }
  }
  
  if(operation %in% c("create_report")){
    report_properties <- c('reportMetadata', 'reportTypeMetadata', 'reportExtendedMetadata')
    if(!is.list(input_data)){
      stop(sprintf(paste0("The report metadata must be a list with up ", 
                          "to 3 elements matching the properties of a report: %s."), 
                   paste0(report_properties, collapse=", ")), call.=FALSE)
    }    
    if(any(!(names(input_data) %in% report_properties))){
      if("attributes" %in% names(input_data)){
        # drop the attributes element which is returned as part of sf_describe_report
        # so that users do not need to remove themselves if passing metadata from 
        # one function to the next
        input_data$attributes <- NULL
      } else {
        stop(sprintf(paste0("Found properties the report metadata that are ", 
                            "not supported. Only the following are supported: %s"), 
                     paste0(report_properties, collapse=", ")), call. = FALSE)
      }
    }
    # drop NULLs if they exist, which can occur if using straight from sf_describe_report
    input_data <- drop_empty_recursively(input_data)    
  }
  
  if(operation %in% c("filter_report")){
    if(!(all(names(input_data) == "reportMetadata"))){
      if(length(input_data) %in% c(3, 4) & "reportMetadata" %in% names(input_data)){
        input_data <- list(reportMetadata = input_data$reportMetadata)
      } else if(length(input_data) != 1){
        # assume that the list has not been wrapped in reportMetadata
        input_data <- list(reportMetadata = input_data)
      } else {
        stop(paste0("You must format the report metadata as a list of length 1 ", 
                    "and that element named 'reportMetadata'.", call. = FALSE))
      }
    }
    if("attributes" %in% names(input_data$reportMetadata)){
      # drop the attributes element which is returned as part of sf_describe_report
      # so that users do not need to remove themselves if passing metadata from 
      # one function to the next
      input_data$reportMetadata$attributes <- NULL
    }
    report_metadata_properties <- c('aggregates', 
                                    'allowedInCustomDetailFormula', 
                                    'buckets', 
                                    'chart', 
                                    'crossFilters', 
                                    'customDetailFormula', 
                                    'customSummaryFormula', 
                                    'currency', 
                                    'dashboardSetting',
                                    'description',
                                    'detailColumns', 
                                    'developerName', 
                                    'division', 
                                    'folderId', 
                                    'groupingsAcross', 
                                    'groupingsDown', 
                                    'hasDetailRows', 
                                    'hasRecordCount', 
                                    'historicalSnapshotDates', 
                                    'id', 
                                    'name', 
                                    'presentationOptions', 
                                    'reportBooleanFilter', 
                                    'reportFilters', 
                                    'reportFormat', 
                                    'reportType', 
                                    'scope', 
                                    'showGrandTotal', 
                                    'showSubtotals', 
                                    'sortBy', 
                                    'standardDateFilter', 
                                    'standardFilters', 
                                    'supportsRoleHierarchy', 
                                    'topRows', 
                                    'userOrHierarchyFilterId')
    if(any(!(names(input_data$reportMetadata) %in% report_metadata_properties))){
      if(all(!(names(input_data$reportMetadata) %in% report_metadata_properties))){
        stop(sprintf(paste0("None of the supplied properties are valid report metadata. ", 
                            "Only the following are supported: %s."), 
                     paste0(report_metadata_properties, collapse=", ")), call. = FALSE)
      } else {
        properties_to_drop <- setdiff(names(input_data$reportMetadata), report_metadata_properties)
        message(sprintf(paste0("Dropping the following supplied report metadata properties, ", 
                               "which are not supported: %s."), 
                        paste0(properties_to_drop, collapse=", ")))
        for(i in 1:length(input_data$reportMetadata)){
          input_data$reportMetadata[[properties_to_drop[i]]] <- NULL
        }
      }
    }
    
    # TODO: Watch and see if this creates errors (currently ignoring anything in 
    # the list that is of the class AsIs regardless of its length) 
    # drop NULLs if they exist, which can occur if using straight from sf_describe_report
    input_data <- drop_empty_recursively(input_data)  
    
    # validate the report filters which are commonly passed
    if("reportFilters" %in% names(input_data$reportMetadata)){
      for(i in 1:length(input_data$reportMetadata$reportFilters)){
        input_data$reportMetadata$reportFilters[[i]] <- metadata_type_validator(
          obj_type = "ReportFilterItem", 
          obj_data = input_data$reportMetadata$reportFilters[[i]]
        )[[1]]
      }
    }
    
    # handle specific cases that are known to cause issues. For example, the 
    # standardDateFilter element cannot have endDate and startDate missing in its spec
    if("standardDateFilter" %in% names(input_data$reportMetadata)){
      if(length(input_data$reportMetadata$standardDateFilter) != 4){
        input_data$reportMetadata$standardDateFilter <- NULL
      } else {
        if((is.na(input_data$reportMetadata$standardDateFilter$startDate) || 
           (length(input_data$reportMetadata$standardDateFilter$startDate) == 0)) || 
           (is.na(input_data$reportMetadata$standardDateFilter$endDate) || 
            (length(input_data$reportMetadata$standardDateFilter$endDate) == 0))){
          input_data$reportMetadata$standardDateFilter <- NULL  
        }
      }
    }
    
    if(("topRows" %in% names(input_data$reportMetadata)) && 
       (is.null(input_data$reportMetadata$sortBy) || 
        is.na(input_data$reportMetadata$sortBy) || 
        length(input_data$reportMetadata$sortBy) == 0)){
      warning(paste0("In order for the row limit to be applied to the results ", 
                     "the report metadata must contain a 'sortBy' element to ", 
                     "determine which top rows are returned."), call. = FALSE)
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
    catch_unknown_api(api_type)
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
  message(sprintf(paste0("Guessed '%s' as the object_name from supplied SOQL.\n", 
                         "Please set `object_name` explicitly if this is incorrect ", 
                         "because it is required by the Bulk APIs."), object_name))
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
#' @importFrom jsonlite prettify
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_verbose_httr_message <- function(method, 
                                      url, 
                                      headers = NULL, 
                                      body = NULL, 
                                      auto_unbox = TRUE,
                                      ...){
  message(sprintf("\n--HTTP Request----------------\n%s %s", method, url))
  
  if(!is.null(headers)){ 
    message(sprintf("--Headers---------------------\n%s", 
                    format_headers_for_verbose(headers)))
  }
  
  if(!is.null(body)){
    if(is.list(body)){
      body <- toJSON(body, pretty = TRUE, auto_unbox = auto_unbox, ...)
    }
    message(sprintf("--Body------------------------\n%s", 
                    body))
  }
  
  return(invisible(NULL))
}

#' Catch unknown API type
#' 
#' This function will alert the user that the supplied value to the argument 
#' \code{api_type} is not one of the valid options.
#' 
#' @param x \code{character}; The value of the \code{api_type} argument provided 
#' by the user.
#' @return \code{simpleError}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
catch_unknown_api <- function(x, supported=c(character(0))){
  if(x %in% c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0")){
    if(length(supported) > 0){
      stop(sprintf(paste0("The %s API is not supported for this function.\n",
                          "Please use one of the following:\n  - %s"), 
                   x, paste0(supported, collapse="\n  - ")), 
           call. = FALSE)    
    } else {
      stop(sprintf("The %s API is not supported for this function.", x), 
           call. = FALSE)
    }
  } else {
    stop(sprintf("Unknown API. The `api_type` argument was set to: %s", x), 
         call. = FALSE)
  }
}

#' List a vector of errors and stop execution
#' 
#' @param main_text \code{character}; The text used to introduce the list of 
#' errors, typically ending with a colon. For example: \code{"Please fix the 
#' following issue(s) before proceeding:"}.
#' @param errors \code{errors}; a vector of errors that will be formatted into 
#' a bulleted list for the user to review with each error listed on a new line.
#' @return \code{simpleError}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
stop_w_errors_listed <- function(main_text=NULL, errors=NULL){
  if(!is.null(errors)){
    if(is.null(main_text)){
      if(length(errors) == 0){
        stop(call.=FALSE)
      } else {
        main_text <- sprintf("Please fix the following issue%s before proceeding:", 
                             if(length(errors) > 1) 's' else '')
      }
    }
    stop(sprintf(paste0(trimws(main_text), "\n  - %s"), 
                 paste0(errors, collapse="\n  - ")), call.=FALSE)    
  } else {
    stop(main_text, call.=FALSE)
  }
}

#' List a vector of errors and provide a warning
#' 
#' @param main_text \code{character}; The text used to introduce the list of 
#' errors, typically ending with a colon. For example: \code{"Consider fixing the 
#' following issue(s):"}.
#' @param errors \code{errors}; a vector of errors that will be formatted into 
#' a bulleted list for the user to review with each error listed on a new line.
#' @return \code{simpleError}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
warn_w_errors_listed <- function(main_text=NULL, errors=NULL){
  if(!is.null(errors)){
    if(is.null(main_text)){
      if(length(errors) > 0){
        main_text <- sprintf("Consider fixing the following issue%s:", 
                             if(length(errors) > 1) 's' else '')
      }
    }
    warning(sprintf(paste0(trimws(main_text), "\n  - %s"), 
                    paste0(errors, collapse="\n  - ")), call.=FALSE)    
  } else {
    warning(main_text, call.=FALSE)
  }
}

#' List a vector of issues and in a message
#' 
#' @param main_text \code{character}; The text used to introduce the list of 
#' errors, typically ending with a colon. For example: \code{"Consider fixing the 
#' following issue(s):"}.
#' @param errors \code{errors}; a vector of issues that will be formatted into 
#' a bulleted list for the user to review with each issue listed on a new line.
#' @return \code{NULL} invisibly
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
message_w_errors_listed <- function(main_text = "Consider the following:", 
                                    errors = NULL){
  if(!is.null(errors)){
    message(sprintf(paste0(trimws(main_text), "\n  - %s"), 
                    paste0(errors, collapse="\n  - ")))
  }
  return(invisible(NULL))
}

#' Execute a non-paginated REST API call to list items
#' 
#' @template as_tbl
#' @param records_root \code{character} or \code{integer}; an index or string that 
#' identifies the element in the parsed list which contains the records returned 
#' by the API call. By default, this argument is \code{NULL}, which means that 
#' each element in the list is an individual record.
#' @template verbose
#' @importFrom purrr map_df
#' @importFrom dplyr as_tibble tibble
#' @importFrom readr col_guess type_convert
#' @importFrom httr content
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_rest_list <- function(url, 
                         as_tbl=FALSE, 
                         records_root=NULL,
                         verbose=FALSE){
  httr_response <- rGET(url = url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  
  if(as_tbl){
    if(is.null(records_root)){
      records_list <- response_parsed
    } else {
      records_list <- response_parsed[[records_root]]  
    }
    if(length(records_list) > 0){
      response_parsed <- records_list %>% 
        map_df(as_tibble) %>%
        type_convert(col_types = cols(.default = col_guess()))
    } else {
      response_parsed <- tibble()
    }
  }
  return(response_parsed)
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

#' @export
sf_format_time.NULL <- function(x){ 
  x
}

#' @export
sf_format_time.AsIs <- function(x){ 
  x
}
