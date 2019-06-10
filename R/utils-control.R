#' Auxiliary for Controlling Calls to Salesforce APIs
#' 
#' Typically only used internally by functions when control parameters are passed 
#' through via dots (...), but it can be called directly to control the behavior 
#' of API calls. This function behaves exactly like \code{\link[stats:glm.control]{glm.control}} 
#' for the \code{\link[stats:glm]{glm}} function.
#' 
#' @importFrom purrr modify modify_if map
#' @param AllOrNoneHeader \code{list}; containing the \code{allOrNone} element with 
#' a value of \code{TRUE} or \code{FALSE}. This control specifies whether a call rolls back all changes 
#' unless all records are processed successfully. This control is available in 
#' SOAP, REST, and Metadata APIs for the following functions: \code{\link{sf_create}}, 
#' \code{\link{sf_delete}}, \code{\link{sf_update}}, \code{\link{sf_upsert}}, \code{\link{sf_create_metadata}}, 
#' \code{\link{sf_delete_metadata}}, \code{\link{sf_update_metadata}}, \code{\link{sf_upsert_metadata}}. 
#' For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_allornoneheader.htm}{here}.
#' @param AllowFieldTruncationHeader \code{list}; containing the \code{allowFieldTruncation} 
#' element with a value of \code{TRUE} or \code{FALSE}. This control specifies the truncation behavior 
#' for some field types in SOAP API version 15.0 and later for the following functions: 
#' \code{\link{sf_create}}, \code{\link{sf_update}}, \code{\link{sf_upsert}}. For 
#' more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_allowfieldtruncation.htm}{here}.
#' @param AssignmentRuleHeader \code{list}; containing the \code{useDefaultRule} 
#' element with a value of \code{TRUE} or \code{FALSE} or the \code{assignmentRuleId} element. 
#' This control specifies the assignment rule to use when creating or updating an 
#' Account, Case, or Lead for the following functions: \code{\link{sf_create}}, 
#' \code{\link{sf_update}}, \code{\link{sf_upsert}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_assignmentruleheader.htm}{here}.
#' @param DisableFeedTrackingHeader \code{list}; containing the \code{disableFeedTracking} 
#' element with a value of \code{TRUE} or \code{FALSE}. This control specifies whether 
#' the changes made in the current call are tracked in feeds for SOAP API calls made 
#' with the following functions: \code{\link{sf_create}}, \code{\link{sf_delete}}, 
#' \code{\link{sf_update}}, \code{\link{sf_upsert}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_disablefeedtracking.htm}{here}.
#' @param DuplicateRuleHeader \code{list}; containing the \code{allowSave}, 
#' \code{includeRecordDetails}, and \code{runAsCurrentUser} elements each with a 
#' value of \code{TRUE} or \code{FALSE}. This control specifies how duplicate rules should be applied 
#' when using the following functions: \code{\link{sf_create}}, \code{\link{sf_update}}, 
#' \code{\link{sf_upsert}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_duplicateruleheader.htm}{here}.
#' @param EmailHeader \code{list}; containing the \code{triggerAutoResponseEmail}, 
#' \code{triggerOtherEmail}, and \code{triggerUserEmail} elements each with a 
#' value of \code{TRUE} or \code{FALSE}. This control determines if an email notification should be sent 
#' when a request is processed by SOAP API calls made with the following functions: 
#' \code{\link{sf_create}}, \code{\link{sf_delete}}, \code{\link{sf_update}}, \code{\link{sf_upsert}}, 
#' \code{\link{sf_reset_password}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_emailheader.htm}{here}.
#' @param LocaleOptions \code{list}; containing the \code{language} element. This control 
#' specifies the language of the labels returned by the \code{\link{sf_describe_objects}} 
#' function using the SOAP API. The value must be a valid user locale (language and country), such as 
#' \code{de_DE} or \code{en_GB}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_localeheader.htm}{here}. 
#' The list of valid user locales is available 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_objects_categorynodelocalization.htm#languagelocalekey_desc}{here}.
#' @param MruHeader \code{list}; containing the \code{updateMru} element with a value 
#' of \code{TRUE} or \code{FALSE}. This control indicates whether to update the list 
#' of most recently used items (\code{TRUE}) or not (\code{FALSE}) in the Recent Items 
#' section of the sidebar in the Salesforce user interface. This works for SOAP API calls 
#' made with the following functions: \code{\link{sf_create}}, \code{\link{sf_update}}, 
#' \code{\link{sf_upsert}}, \code{\link{sf_retrieve}}, \code{\link{sf_query}}. For more 
#' information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_mruheader.htm}{here}.
#' @param OwnerChangeOptions \code{list}; containing the \code{options} element. 
#' This control specifies the details of ownership of attachments and notes when a 
#' record’s owner is changed. This works for SOAP API calls made with the following functions: 
#' \code{\link{sf_update}}, \code{\link{sf_upsert}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_ownerchangeoptions.htm}{here}.
#' @param QueryOptions \code{list}; containing the \code{batchSize} element. 
#' This control specifies the batch size for query results . This works for SOAP or 
#' REST API calls made with the following functions: \code{\link{sf_query}}, 
#' \code{\link{sf_retrieve}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_queryoptions.htm}{here}.
#' @param UserTerritoryDeleteHeader \code{list}; containing the \code{transferToUserId} element. 
#' This control specifies a user to whom open opportunities are assigned when the current 
#' owner is removed from a territory. This works for the \code{\link{sf_delete}} function 
#' using the SOAP API. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_userterritorydeleteheader.htm}{here}.
#' @param BatchRetryHeader \code{list}; containing the \code{Sforce-Disable-Batch-Retry} element. 
#' When you create a bulk job, the Batch Retry control lets you disable retries 
#' for unfinished batches included in the job. This works for most operations run through 
#' the Bulk 1.0 API (e.g. \code{sf_create(., api_type = "Bulk 1.0")}) or creating 
#' a Bulk 1.0 job with \code{\link{sf_create_job_bulk}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/async_api_headers_disable_batch_retry.htm}{here}.
#' @param LineEndingHeader \code{list}; containing the \code{Sforce-Line-Ending} element. 
#' When you’re creating a bulk upload job, the Line Ending control lets you 
#' specify whether line endings are read as line feeds (LFs) or as carriage returns 
#' and line feeds (CRLFs) for fields of type Text Area and Text Area (Long). This 
#' works for most operations run through the Bulk APIs or creating a Bulk 1.0 
#' job with \code{\link{sf_create_job_bulk}}. For more information, read the 
#' Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/async_api_headers_line_ending.htm}{here}.
#' @param PKChunkingHeader \code{list}; containing the \code{Sforce-Enable-PKChunking} element. 
#' Use the PK Chunking control to enable automatic primary key (PK) chunking 
#' for a bulk query job. This works for queries run through the Bulk 1.0 API either via 
#' \code{sf_query(., api_type = "Bulk 1.0")}) or \code{\link{sf_query_bulk}}. For 
#' more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/async_api_headers_enable_pk_chunking.htm}{here}.
#' @template api_type
#' @template operation
#' @examples 
#' \dontrun{
#' this_control <- sf_control(DuplicateRuleHeader=list(allowSave=TRUE, 
#'                                                     includeRecordDetails=FALSE, 
#'                                                     runAsCurrentUser=TRUE))
#' new_contact <- c(FirstName = "Test", LastName = "Contact-Create")
#' new_record <- sf_create(new_contact, "Contact", control = this_control)
#' 
#' # specifying the controls directly and are picked up by dots
#' new_record <- sf_create(new_contact, "Contact", 
#'                         DuplicateRuleHeader = list(allowSave=TRUE, 
#'                                                    includeRecordDetails=FALSE, 
#'                                                    runAsCurrentUser=TRUE))
#' }
#' @export
sf_control <- function(AllOrNoneHeader=list(allOrNone=FALSE), 
                       AllowFieldTruncationHeader=list(allowFieldTruncation=FALSE), 
                       AssignmentRuleHeader=list(useDefaultRule=TRUE),
                       DisableFeedTrackingHeader=list(disableFeedTracking=FALSE), 
                       DuplicateRuleHeader=list(allowSave=FALSE, 
                                                includeRecordDetails=FALSE, 
                                                runAsCurrentUser=TRUE), 
                       EmailHeader=list(triggerAutoResponseEmail=FALSE, 
                                        triggerOtherEmail=FALSE, 
                                        triggerUserEmail=TRUE),
                       LocaleOptions=list(language="en_US"),
                       MruHeader=list(updateMru=FALSE), 
                       OwnerChangeOptions=list(options=list(list(execute=TRUE, 
                                                                 type="EnforceNewOwnerHasReadAccess"),
                                                            list(execute=FALSE, 
                                                                 type="KeepAccountTeam"),
                                                            list(execute=FALSE, 
                                                                 type="KeepSalesTeam"),
                                                            list(execute=FALSE, 
                                                                 type="KeepSalesTeamGrantCurrentOwnerReadWriteAccess"),
                                                            list(execute=FALSE, 
                                                                 type="SendEmail"),
                                                            list(execute=FALSE, 
                                                                 type="TransferAllOwnedCases"),
                                                            list(execute=TRUE, 
                                                                 type="TransferContacts"),
                                                            list(execute=TRUE, 
                                                                 type="TransferContracts"),
                                                            list(execute=FALSE, 
                                                                 type="TransferNotesAndAttachments"),
                                                            list(execute=TRUE, 
                                                                 type="TransferOpenActivities"),
                                                            list(execute=TRUE, 
                                                                 type="TransferOrders"),
                                                            list(execute=FALSE, 
                                                                 type="TransferOtherOpenOpportunities"),
                                                            list(execute=FALSE, 
                                                                 type="TransferOwnedClosedOpportunities"),
                                                            list(execute=FALSE, 
                                                                 type="TransferOwnedOpenCases"), 
                                                            list(execute=FALSE, 
                                                                 type="TransferOwnedOpenOpportunities"))),
                       QueryOptions=list(batchSize=1000),
                       UserTerritoryDeleteHeader=list(transferToUserId=NA), 
                       BatchRetryHeader=list(`Sforce-Disable-Batch-Retry`=FALSE), 
                       LineEndingHeader=list(`Sforce-Line-Ending`=NA), 
                       PKChunkingHeader=list(`Sforce-Enable-PKChunking`=FALSE), 
                       api_type = NULL,
                       operation = NULL){
  
  # determine which elements were supplied, dropping the function call itself
  supplied_arguments <-  as.list(match.call()[-1])
  # drop api_type and operation existing
  supplied_arguments[["api_type"]] <- NULL
  supplied_arguments[["operation"]] <- NULL
  
  # now eval them to no longer be objects of class "call"
  supplied_arguments <- supplied_arguments %>% 
    map(eval) %>% 
    # convert boolean args to lowercase
    modify(~modify_if(., is.logical, tolower))
  
  # check that they are all lists
  if(!all(sapply(supplied_arguments, is.list))){
    stop("All control arguments must be lists. Review the argument defaults in 'sf_control()' for help formatting.")
  }
  
  # check that the controls valid for the API and operation
  supplied_arguments <- filter_valid_controls(supplied_arguments, api_type = api_type)
  supplied_arguments <- filter_valid_controls(supplied_arguments, operation = operation)
  
  return(supplied_arguments)
}

#' Return the Accepted Control Arguments by API Type
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
accepted_controls_by_api <- function(api_type = c("SOAP", "REST", "Bulk 1.0", "Bulk 2.0", "Metadata")){
  this_api_type <- match.arg(api_type)
  switch(this_api_type, 
         "SOAP" = c("AllOrNoneHeader", "AllowFieldTruncationHeader", "AssignmentRuleHeader", 
                    "DisableFeedTrackingHeader", "DuplicateRuleHeader",
                    "EmailHeader", "LocaleOptions", 
                    "MruHeader", "OwnerChangeOptions", 
                    "QueryOptions", "UserTerritoryDeleteHeader"),
         "REST" = c("AllOrNoneHeader", "AssignmentRuleHeader", "QueryOptions"),
         "Bulk 1.0" = c("LineEndingHeader", "BatchRetryHeader", "PKChunkingHeader"),
         "Bulk 2.0" = c("LineEndingHeader"), 
         "Metadata" = c("AllOrNoneHeader"),
         character(0))
}

#' Return the Accepted Control Arguments by Operation
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
accepted_controls_by_operation <- function(operation = c("delete", "undelete", "hardDelete", 
                                                         "insert", "update", "upsert", 
                                                         "query", "queryall", "retrieve", 
                                                         "resetPassword", "describeSObjects")){
  record_creation_controls <- c("AllOrNoneHeader", "AllowFieldTruncationHeader", 
                                "AssignmentRuleHeader", "DisableFeedTrackingHeader", 
                                "DuplicateRuleHeader", "EmailHeader", "MruHeader")
  query_controls <- c("MruHeader", "QueryOptions", "PKChunkingHeader")
  bulk_controls <- c("BatchRetryHeader", "LineEndingHeader")
  this_operation <- match.arg(operation)
  switch(this_operation, 
         "delete" = c("AllOrNoneHeader", "DisableFeedTrackingHeader", "EmailHeader", 
                      "UserTerritoryDeleteHeader", bulk_controls),
         "undelete" = c("AllOrNoneHeader", "AllowFieldTruncationHeader"), 
         "hardDelete" = bulk_controls,
         "merge" = "AllowFieldTruncationHeader",
         "insert" = c(record_creation_controls, bulk_controls),
         "update" = c(record_creation_controls, bulk_controls, "OwnerChangeOptions"),
         "upsert" = c(record_creation_controls, bulk_controls, "OwnerChangeOptions"),
         "query" = query_controls,
         "queryall" = query_controls, 
         "retrieve" = c("MruHeader"),
         "resetPassword" = c("EmailHeader"),
         "describeSObjects" = c("LocaleOptions"),
         character(0))
}

#' Filter Out Control Arguments by API or Operation
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
filter_valid_controls <- function(supplied, api_type = NULL, operation = NULL){
  if(!is.null(api_type)){
    valid <- accepted_controls_by_api(api_type)
    # provide a warning before dropping 
    if(length(setdiff(names(supplied), valid)) >  0){
      warning(sprintf("Ignoring the following controls which are not used in the %s API: %s",
                      api_type,
                      paste0(setdiff(names(supplied), valid), collapse=", ")),
              call. = TRUE)
    }
    supplied <- supplied[intersect(names(supplied), valid)]
  }
  
  if(!is.null(operation)){
    valid <- accepted_controls_by_operation(operation)
    # provide a warning before dropping 
    if(length(setdiff(names(supplied), valid)) >  0){
      warning(sprintf("Ignoring the following controls which are not used in the '%s' operation: %s",
                      operation,
                      paste0(setdiff(names(supplied), valid), collapse=", ")),
              call. = TRUE)
    }
    supplied <- supplied[intersect(names(supplied), valid)]
  }
  
  return(supplied)
}

#' Of All Args Return Ones Matching Control Arguments
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
return_matching_controls <- function(args){
  possible_controls <- formals(sf_control)  
  idx <- names(args) %in% names(possible_controls)
  return(args[idx])
}


# HELD BACK CONTROL OPTIONS BECAUSE THEY MAY BE CONFUSING OR NOT FEASIBLE GIVEN 
# THE WAY THE PACKAGE IS CURRENTLY WRITTEN:

#CallOptions=list(client=NA, defaultNamespace=NA)
#' CallOptions \code{list}; containing the \code{client} and \code{defaultNamespace}
#' elements. This control specifies the call options needed to work with a specific client. 
#' This control is only available for use with the Partner WSDL and works for most all functions 
#' in this package. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_calloptions.htm}{here}.

#LimitInfoHeader=list(current="20", 
#                     limit="250", 
#                     type="API REQUESTS")
#' LimitInfoHeader \code{list}; containing the \code{current}, \code{limit}, 
#' and \code{type} elements. This control determines if limit information for the organization should 
#' be returned in the header each request response. This works for most all functions, 
#' except \code{\link{sf_auth()}}. For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_limitinfo.htm}{here}.

#PackageVersionHeader=list(packageVersions=NA)
#' PackageVersionHeader \code{list}; containing the \code{packageVersions} element. 
#' This header specifies the package version for each installed managed package in 
#' API version 16.0 and later. This works for most all functions in this package. 
#' For more information, read the Salesforce documentation 
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api.meta/api/sforce_api_header_packageversionheader.htm}{here}.

#ContentTypeHeader=list(`Content-Type`="application/xml")
#' ContentTypeHeader \code{list}; containing the \code{Content-Type} element.
#' This header specifies the format for your request and response. Set the value of
#' this header to match the contentType of the job you’re working with. This works
#' for most all functions with the Bulk 1.0 API. For more information, read the Salesforce documentation
#' \href{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/async_api_headers_content_type.htm}{here}.


# REST Translations
#  AllorNoneHeader =  (allOrNone, currently in our batched data process)
#  AssignmentRuleHeader = Sforce-Auto-Assign
#  DuplicateRuleHeader = NONE!
#  QueryOptions = Sforce-Query-Options

# Bulk 1.0 Translations
#  AssignmentRuleHeader = assignmentRuleId (in the job info) (only if id?)
#  AllorNoneHeader? = Unknown if SOAP works for Bulk 1.0 as well
#  DuplicateRuleHeader? = Unknown if SOAP works for Bulk 1.0 as well

# Bulk 2.0 Translations (does not use any headers)
# Just line ending?
