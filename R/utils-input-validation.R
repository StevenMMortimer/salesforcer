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
                        "update", "update_attachment", "update_document", 
                        "findDuplicatesByIds")){
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
      if(operation == "update_attachment"){
        missing_cols <- setdiff(c("Body"), names(input_data))
      } else {
        missing_cols <- setdiff(c("Body", "ParentId"), names(input_data))
      }
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
      if(operation == "update_document"){
        other_missing_cols <- character(0)
      } else {
        other_missing_cols <- setdiff(c("Name", "FolderId"), names(input_data))
      }
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
