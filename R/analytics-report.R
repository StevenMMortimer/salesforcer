# https://resources.docs.salesforce.com/226/latest/en-us/sfdc/pdf/salesforce_analytics_rest_api.pdf

#' List reports
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Displays a list of full list of reports based on the \code{Report} object. If 
#' \code{recent} is up to 200 tabular, matrix, or summary reports that you
#' recently viewed. To get additional details on reports by format, name, and other
#' fields, use a SOQL query on the Report object.
#'
#' @importFrom dplyr rename_with mutate expr 
#' @importFrom purrr transpose
#' @param recent \code{logical}; an indicator of whether to return the 200 most 
#' recently viewed reports or to invoke a query on the \code{Report} object to 
#' return all reports in the Org. By default, this argument is set to \code{FALSE} 
#' meaning that all of the reports, not just the most recently viewed reports 
#' are returned. Note that the default behavior of the reports list endpoint in 
#' the Reports and Dashboards REST API is only the most recently viewed up to 
#' 200 reports.
#' @template as_tbl
#' @template verbose
#' @return \code{tbl_df} by default, or a \code{list} depending on the value of 
#' argument \code{as_tbl}
#' @note This function will only return up to 200 of recently viewed reports when the 
#' \code{recent} argument is set to \code{TRUE}. For a complete details you must 
#' use \code{\link{sf_query}} on the report object.
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_recentreportslist.htm}{Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_list_recentreports.htm#example_recent_reportslist}{Example}
#' }
#' @examples 
#' \dontrun{
#' # to return all possible reports, which is queried from the Report object
#' reports <- sf_list_reports()
#' 
#' # return the results as a list
#' reports_as_list <- sf_list_reports(as_tbl=FALSE)
#' 
#' # return up to 200 recently viewed reports
#' all_reports <- sf_list_reports(recent=TRUE)
#' }
#' @export
sf_list_reports <- function(recent=FALSE, as_tbl=TRUE, verbose=FALSE){
  if(recent){
    this_url <- make_reports_list_url()
    resultset <- sf_rest_list(url=this_url, as_tbl=as_tbl, verbose=verbose)
  } else {
    resultset = sf_query("SELECT Id, Name FROM Report")
    # add columns to match the actual output of report list
    report_base_url <- "/services/data/v48.0/analytics/reports"
    resultset <- resultset %>% 
      rename_with(tolower) %>% 
      mutate(url = sprintf('%s/%s', report_base_url, expr("id")),  
             describeUrl = sprintf('%s/%s/%s', report_base_url, expr("id"), "describe"), 
             fieldsUrl = sprintf('%s/%s/%s', report_base_url, expr("id"), "fields"),  
             instancesUrl = sprintf('%s/%s/%s', report_base_url, expr("id"), "instances"))    
    # convert the tibble returned by the query back into a list 
    if(!as_tbl){
      resultset <- resultset %>% transpose()
    }
  }
  if(as_tbl){
    # bring id and name up front
    resultset <- resultset %>% 
      sf_reorder_cols() %>% 
      sf_guess_cols()
  }
  return(resultset)
}

#' List report filter operators
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Use the Filter Operators API to get information about which filter operators are 
#' available for reports and dashboards. The Filter Operators API is available in 
#' API version 40.0 and later.
#'
#' @template as_tbl
#' @template verbose
#' @return \code{tbl_df} by default, or a \code{list} depending on the value of 
#' argument \code{as_tbl}
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_resource.htm}{Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_list.htm}{Example}
#' }
#' @examples \dontrun{
#' report_filters <- sf_list_report_filter_operators()
#' unique_supported_fields <- report_filters %>% distinct(supported_field_type)
#' 
#' # operators to filter a picklist field
#' picklist_field_operators <- report_filters %>% filter(supported_field_type == "picklist")
#' }
#' @export
sf_list_report_filter_operators <- function(as_tbl=TRUE, verbose=FALSE){
  this_url <- make_report_filter_operators_list_url()
  resultset <- sf_rest_list(url=this_url, as_tbl=FALSE, verbose=verbose)
  if(as_tbl){
    resultset <- lapply(resultset, FUN=function(x){x %>% map_df(flatten_tbl_df)})
    resultset <- safe_bind_rows(resultset, idcol="supported_field_type")
  }
  return(resultset)
}

#' Get a list of report fields
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' The Report Fields resource returns report fields available for specified reports. 
#' Use the resource to determine the best fields for use in dashboard filters by 
#' seeing which fields different source reports have in common. Available in API 
#' version 40.0 and later.
#' 
#' @template report_id
#' @param intersect_with \code{character} a vector of unique report IDs. This is
#' helpful in determining the best fields for use in dashboard filters by seeing 
#' which fields different source reports have in common. If this argument is left 
#' empty, then the function returns a list of all possible report fields. 
#' Otherwise, returns a list of fields that specified reports share.
#' @template verbose
#' @return \code{list} representing the 4 different field report properties:
#' \describe{
#'   \item{displayGroups}{Fields available when adding a filter.}
#'   \item{equivalentFields}{Fields available for each specified report. Each object in this array is a list of common fields categorized by report type.}
#'   \item{equivalentFieldIndices}{Map of each field’s API name to the index of the field in the \code{equivalentFields} array.}
#'   \item{mergedGroups}{Merged fields.}
#' }
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_fields.htm}{Documentation}
#' }
#' @examples 
#' \dontrun{
#' # first, grab all possible reports in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' 
#' # second, get the id of the report to check fields on
#' this_report_id <- all_reports$Id[1]
#' 
#' # third, pull that report and intersect its fields with up to three other reports
#' fields <- sf_list_report_fields(this_report_id, intersect_with=head(all_reports[["Id"]],3))
#' }
#' @export
sf_list_report_fields <- function(report_id, 
                                  intersect_with = c(character(0)),
                                  verbose=FALSE){
  
  this_url <- make_report_fields_url(report_id)
  request_body <- list(intersectWith=I(intersect_with))
  httr_response <- rPOST(url = this_url, 
                         body = request_body, 
                         encode = "json")
  
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")  
  return(response_parsed)
}

#' List report types
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Return a list of report types.
#'
#' @template as_tbl
#' @template verbose
#' @return \code{tbl_df} by default, or a \code{list} depending on the value of 
#' argument \code{as_tbl}
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_reporttypes_reference_list.htm}{Documentation}
#' }
#' @examples 
#' \dontrun{
#' report_types <- sf_list_report_types()
#' unique_report_types <- report_types %>% select(reportTypes.type)
#' 
#' # return the results as a list
#' reports_as_list <- sf_list_report_types(as_tbl=FALSE)
#' }
#' @export
sf_list_report_types <- function(as_tbl=TRUE, verbose=FALSE){
  this_url <- make_report_types_list_url()
  resultset <- sf_rest_list(url=this_url, as_tbl=as_tbl, verbose=verbose)
  if(as_tbl){
    resultset <- resultset %>% unnest_col(col="reportTypes")
  }
  return(resultset)
}
  
#' Describe a report type
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Return metadata about a report type.
#'
#' @param report_type \code{character}; a character representing the type of 
#' report to retrieve the metadata information on. A list of valid report types 
#' that can be described using this function will be available in the 
#' \code{reportTypes.type} column of results returned \link{sf_list_report_types}. 
#' (e.g. \code{AccountList}, \code{AccountContactRole}, \code{OpportunityHistory}, 
#' etc.)
#' @template verbose
#' @return \code{list} containing up to 4 properties that describe the report: 
#' \describe{
#'   \item{attributes}{Report type along with the URL to retrieve common objects and 
#'   joined metadata.}
#'   \item{reportMetadata}{Unique identifiers for groupings and summaries.}
#'   \item{reportTypeMetadata}{Fields in each section of a report type plus filter information for those fields.}
#'   \item{reportExtendedMetadata}{Additional information about summaries and groupings.}
#' }
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_reporttypes_reference_reporttype.htm}{Documentation}
#' }
#' @examples \dontrun{
#' reports <- sf_list_report_types()
#' unique_report_types <- reports %>% distinct(reportTypes.type)
#' 
#' # first unique report type
#' unique_report_types[[1,1]]
#' 
#' # describe that report type
#' described_report <- sf_describe_report_type(unique_report_types[[1,1]])
#' }
#' @export
sf_describe_report_type <- function(report_type, verbose=FALSE){
  this_url <- make_report_type_describe_url(report_type)
  resultset <- sf_rest_list(url=this_url, as_tbl=FALSE, verbose=verbose)
  return(resultset)  
}

#' Describe a report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Retrieves report, report type, and related metadata for a tabular, summary, 
#' or matrix report.
#' 
#' @details \itemize{
#'   \item Report metadata gives information about the report as a whole. Tells you such things as, the report type, format, the fields that are summaries, row or column groupings, filters saved to the report, and so on.
#'   \item Report type metadata tells you about all the fields available in the report type, those you can filter, and by what filter criteria.
#'   \item Report extended metadata tells you about the fields that are summaries, groupings, and contain record details in the report.
#' }
#' @template report_id
#' @template verbose
#' @return \code{list} containing up to 4 properties that describe the report: 
#' \describe{
#'   \item{attributes}{Report type along with the URL to retrieve common objects and joined metadata.}
#'   \item{reportMetadata}{Unique identifiers for groupings and summaries.}
#'   \item{reportTypeMetadata}{Fields in each section of a report type plus filter information for those fields.}
#'   \item{reportExtendedMetadata}{Additional information about summaries and groupings.}
#' }
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_getbasic_reportmetadata.htm}{Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportmetadata.htm#example_report_getdescribe}{Example}
#' }
#' @examples 
#' \dontrun{
#' # pull a list of up to 200 recent reports
#' # (for a full list you must use sf_query on the Report object)
#' reports <- sf_list_reports()
#' 
#' # id for the first report
#' reports[[1,"id"]]
#' 
#' # describe that report type
#' described_report <- sf_describe_report_type(unique_report_types[[1,"id"]])
#' }
#' @export
sf_describe_report <- function(report_id, verbose=FALSE){
  this_url <- make_report_describe_url(report_id)
  resultset <- sf_rest_list(url=this_url, as_tbl=FALSE, verbose=verbose)
  return(resultset)
}

#' Copy a report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Creates a copy of a custom, standard, or public report by sending a POST 
#' request to the Report List resource.
#' 
#' @template report_id
#' @param name \code{character}; a user-specified name for the newly cloned report. 
#' If left \code{NULL}, then the new name will be the same name as the report being 
#' cloned appended with " = Copy" that is prefixed with a number if that name is 
#' not unique. It is highly recommended to provide a name, if possible.
#' @template verbose
#' @return \code{list} representing the newly cloned report with up to 4 properties 
#' that describe the report: 
#' \describe{
#'   \item{attributes}{Report type along with the URL to retrieve common objects and 
#'   joined metadata.}
#'   \item{reportMetadata}{Unique identifiers for groupings and summaries.}
#'   \item{reportTypeMetadata}{Fields in each section of a report type plus filter information for those fields.}
#'   \item{reportExtendedMetadata}{Additional information about summaries and groupings.}
#' }
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_clone_report.htm}{Documentation}
#' }
#' @examples 
#' \dontrun{
#' # only the 200 most recently viewed reports
#' most_recent_reports <- sf_report_list()
#' 
#' # all possible reports in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' 
#' # id of the report to copy
#' this_report_id <- all_reports$Id[1]
#' 
#' # not providing a name appends " - Copy" to the name of the report being cloned
#' report_details <- sf_copy_report(this_report_id)
#' 
#' # example of providing new name to the copied report
#' report_details <- sf_copy_report(this_report_id, "My New Copy of Report ABC")
#' }
#' @export
sf_copy_report <- function(report_id, name=NULL, verbose=FALSE){
  this_url <- make_report_copy_url(report_id)
  if(is.null(name)){
    existing_reports <- sf_query("SELECT Id, Name FROM Report")
    # remove names reflecting a " - Copy"
    existing_reports$original_name <- gsub(" - Copy[0-9]{0,}$", "", existing_reports$Name)
    # which report is being requested to copy
    this_report <- existing_reports[existing_reports$Id == report_id,,drop=FALSE]
    # check that a report matching the supplied Id exists
    if(nrow(this_report) == 0){
      stop(sprintf("No report found with Id: %s", report_id))
    }
    # how many other reports have that same name (after dropping " - Copy")?
    report_name_cnt <- sum(existing_reports$original_name == this_report$original_name)
    if(report_name_cnt == 1){
      name <- paste0(this_report$original_name, " - Copy")
    } else {
      name <- paste0(this_report$original_name, " - Copy", report_name_cnt - 1)
    }
    message(sprintf("Naming the new report: '%s'", name))
  }
  this_url <- make_report_copy_url(report_id)
  httr_response <- rPOST(url = this_url, 
                         body = list(reportMetadata=list(name=name)), 
                         encode = "json")
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  return(response_parsed)
}

#' Create a report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Create a new report using a POST request. To create a report, you only have to 
#' specify a name and report type to create a new report; all other metadata properties 
#' are optional. It is recommended to use the metadata from existing reports pulled 
#' using \code{\link{sf_describe_report}} as a guide on how to specify the properties 
#' of a new report. 
#'
#' @param name \code{character}; a user-specified name for the report.
#' @param report_type \code{character}; a character representing the type of 
#' report to retrieve the metadata information on.  A list of valid report types 
#' that can be created using this function will be available in the 
#' \code{reportTypes.type} column of results returned \link{sf_list_report_types}. 
#' (e.g. \code{AccountList}, \code{AccountContactRole}, \code{OpportunityHistory}, 
#' etc.)
#' @param report_metadata \code{list}; a list representing the properties to create 
#' the report with. The names of the list must be one or more of the 3 accepted 
#' metadata properties: \code{reportMetadata}, \code{reportTypeMetadata}, 
#' \code{reportExtendedMetadata}.
#' @template verbose
#' @return \code{list} representing the newly cloned report with up to 4 properties 
#' that describe the report: 
#' \describe{
#'   \item{attributes}{Report type along with the URL to retrieve common objects and 
#'   joined metadata.}
#'   \item{reportMetadata}{Unique identifiers for groupings and summaries.}
#'   \item{reportTypeMetadata}{Fields in each section of a report type plus filter information for those fields.}
#'   \item{reportExtendedMetadata}{Additional information about summaries and groupings.}
#' }
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_report_example_post_report.htm}{Documentation}
#' }
#' @examples
#' \dontrun{
#' # creating a blank report using just the name and type
#' my_new_report <- sf_create_report("Top Accounts Report", "AccountList")
#' 
#' # creating a report with additional metadata by grabbing an existing report
#' # and modifying it slightly (only the name in this case)
#' 
#' # first, grab all possible reports in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' 
#' # second, get the id of the report to copy
#' this_report_id <- all_reports$Id[1]
#' 
#' # third, pull down its metadata and update the name
#' report_describe_list <- sf_describe_report(this_report_id)
#' report_describe_list$reportMetadata$name <- "TEST API Report Creation"
#' 
#' # fourth, create the report by passing the metadata
#' my_new_report <- sf_create_report(report_metadata=report_describe_list)
#' }
#' @export
sf_create_report <- function(name=NULL, 
                             report_type=NULL, 
                             report_metadata=NULL, 
                             verbose=FALSE){
  if(!is.null(report_metadata)){
    report_metadata <- sf_input_data_validation(report_metadata, 
                                                operation='create_report')
  } else {
    if(is.null(name)){
      stop(paste0("The report name is required. Specify it using the `name` ", 
                  "argument or as part of the `report_metadata` argument"), call.=FALSE)
    }
    if(is.null(report_type)){
      stop(paste0("The report type is required. Specify it using the `report_type` ", 
                  "argument or as part of the `report_metadata` argument"), call.=FALSE)
    } 
    report_metadata <- list(reportMetadata =
                               list(name = name, 
                                    reportType =
                                      list(type=report_type)))
  }
  this_url <- make_report_create_url()
  httr_response <- rPOST(url = this_url, 
                         body = report_metadata, 
                         encode = "json")
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  return(response_parsed)  
}

#' Update a report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Save changes to a report by sending a PATCH request to the Report resource. 
#' Note that saving a report deletes any running async report jobs because they 
#' might be obsolete based on the updates.
#'
#' @template report_id
#' @param report_metadata \code{list}; a list representing the properties to create 
#' the report with. The names of the list must be one or more of the 3 accepted 
#' metadata properties: \code{reportMetadata}, \code{reportTypeMetadata}, 
#' \code{reportExtendedMetadata}.
#' @template verbose
#' @return \code{list} representing the newly cloned report with up to 4 properties 
#' that describe the report: 
#' \describe{
#'   \item{attributes}{Report type along with the URL to retrieve common objects and 
#'   joined metadata.}
#'   \item{reportMetadata}{Unique identifiers for groupings and summaries.}
#'   \item{reportTypeMetadata}{Fields in each section of a report type plus filter information for those fields.}
#'   \item{reportExtendedMetadata}{Additional information about summaries and groupings.}
#' }
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_save_report.htm#example_save_report}{Example}
#' }
#' @examples
#' \dontrun{
#' # first, grab all possible reports in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' 
#' # second, get the id of the report to update
#' this_report_id <- all_reports$Id[1]
#' 
#' my_updated_report <- sf_update_report(this_report_id,
#'                                       report_metadata =
#'                                         list(reportMetadata =
#'                                           list(name = "Updated Report Name!")))
#' 
#' # alternatively, pull down its metadata and update the name
#' report_details <- sf_describe_report(this_report_id)
#' report_details$reportMetadata$name <- paste0(report_details$reportMetadata$name,
#'                                              " - UPDATED")
#' 
#' # fourth, update the report by passing the metadata
#' my_updated_report <- sf_update_report(this_report_id,
#'                                       report_metadata = report_details)
#' }
#' @export
sf_update_report <- function(report_id, report_metadata, verbose=FALSE){
  report_metadata <- sf_input_data_validation(report_metadata, 
                                              operation='create_report')
  this_url <- make_report_url(report_id)
  httr_response <- rPATCH(url = this_url, 
                         body = report_metadata, 
                         encode = "json")
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  return(response_parsed)    
}

#' Delete a report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Delete a report by sending a DELETE request to the Report resource. Deleted 
#' reports are moved to the Recycle Bin.
#'
#' @template report_id
#' @template verbose
#' @return \code{logical} indicating whether the report was deleted. This function 
#' will return \code{TRUE} if successful in deleting the report.
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_delete_report.htm#example_delete_report}{Documentation}
#' }
#' @examples
#' \dontrun{
#' # first, grab all possible reports in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' 
#' # second, get the id of the report to delete
#' this_report_id <- all_reports$Id[1]
#' 
#' # third, delete that report using its Id
#' success <- sf_delete_report(this_report_id)
#' }
#' @export
sf_delete_report <- function(report_id, verbose=FALSE){
  this_url <- make_report_url(report_id)
  httr_response <- rDELETE(url = this_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  if(is.null(response_parsed) & status_code(httr_response) == 204){
    response_parsed <- TRUE
  }
  return(invisible(response_parsed))
}

#' Execute a report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Get summary data with or without details by running a report synchronously or
#' asynchronously through the API. When you run a report, the API returns data
#' for the same number of records that are available when the report is run in
#' the Salesforce user interface. Include the \code{filters} argument in your
#' request to get specific results on the fly by passing dynamic filters,
#' groupings, and aggregates in the report metadata. Finally, you may want to 
#' use \code{\link{sf_run_report}}.
#' 
#' @details Run a report synchronously if you expect it to finish running quickly. 
#' Otherwise, we recommend that you run reports through the API asynchronously 
#' for these reasons:
#' \itemize{
#'   \item Long running reports have a lower risk of reaching the timeout limit 
#'   when run asynchronously.
#'   \item The 2-minute overall Salesforce API timeout limit doesn’t apply to 
#'   asynchronous runs.
#'   \item The Salesforce Reports and Dashboards REST API can handle a higher 
#'   number of asynchronous run requests at a time.
#'   \item Since the results of an asynchronously run report are stored for a 
#'   24-hr rolling period, they’re available for recurring access.
#' }
#' 
#' Before you filter a report, it helpful to check the following properties in the metadata 
#' that tell you if a field can be filtered, the values and criteria you can filter 
#' by, and filters that already exist in the report: 
#' \itemize{
#'   \item filterable
#'   \item filterValues
#'   \item dataTypeFilterOperatorMap
#'   \item reportFilters
#' }
#' 
#' @importFrom lifecycle deprecated is_present deprecate_warn
#' @importFrom dplyr mutate across select any_of everything
#' @importFrom readr parse_datetime type_convert cols col_guess
#' @importFrom tibble as_tibble_row
#' @importFrom httr content
#' @template report_id
#' @template async
#' @template include_details
#' @template labels
#' @template guess_types
#' @template bind_using_character_cols
#' @template as_tbl
#' @template report_metadata
#' @template verbose
#' @return \code{tbl_df} by default, but a \code{list} when \code{as_tbl=FALSE}, 
#' which means that the content from the API is converted from JSON to a list 
#' with no other post-processing.
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_getreportrundata.htm}{Sync Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_sync_reportexecute}{Sync Example}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instances_summaryasync.htm}{Async Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_report_async_instances}{Async Example}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_filter_reportdata.htm#example_requestbody_execute_resource}{Filtering Results}
#' }
#' @examples
#' \dontrun{
#' # first, get the Id of a report in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' this_report_id <- all_reports$Id[1]
#' 
#' # then execute a synchronous report that will wait for the results
#' results <- sf_execute_report(this_report_id)
#' 
#' # alternatively, you can execute an async report and then grab its results when done
#' #   - The benefit of an async report is that the results will be stored for up to
#' #     24 hours for faster recall, if needed
#' results <- sf_execute_report(this_report_id, async=TRUE)
#' 
#' # check if completed and proceed if the status is "Success"
#' instance_list <- sf_list_report_instances(report_id)
#' instance_status <- instance_list[[which(instance_list$id == results$id), "status"]]
#' if(instance_status == "Success"){
#'   results <- sf_get_report_instance_results(report_id, results$id)
#' }
#' 
#' # Note: For more complex execution use the report_metadata argument.
#' # This can be done by building the list from scratch based on Salesforce 
#' # documentation (not recommended) or pulling down the existing reportMetadata 
#' # property of the report and modifying the list slightly (recommended). 
#' # In addition, for relatively simple changes, you can leverage the convenience 
#' # function sf_report_wrapper() which makes it easier to retrieve report results
#' report_details <- sf_describe_report(this_report_id)
#' report_metadata <- list(reportMetadata = report_details$reportMetadata)
#' report_metadata$reportMetadata$showGrandTotal <- FALSE
#' report_metadata$reportMetadata$showSubtotals <- FALSE
#' fields <- sf_execute_report(this_report_id,
#'                             report_metadata = report_metadata)
#' }
#' @export
sf_execute_report <- function(report_id, 
                              async = FALSE, 
                              include_details = TRUE,
                              labels = TRUE,
                              guess_types = TRUE, 
                              bind_using_character_cols = deprecated(),
                              as_tbl = TRUE,
                              report_metadata = NULL,
                              verbose = FALSE){
  
  if(is_present(bind_using_character_cols)) {
    deprecate_warn("1.0.0", 
                   "salesforcer::sf_execute_report(bind_using_character_cols)", 
                   details = paste0("The `bind_using_character_cols` functionality ", 
                                    "will always be `TRUE` going forward. Per the ", 
                                    "{readr} package, we have to read as character ", 
                                    "and then invoke `type_convert()` in order to ",
                                    "use all values in a column to guess its type."))
  } 
  
  if(!is.null(report_metadata)){
    report_metadata <- sf_input_data_validation(report_metadata,
                                                operation = "filter_report")
  }

  this_url <- make_report_execute_url(report_id, async, include_details)

  if(!is.null(report_metadata)){
    httr_response <- rPOST(url = this_url,
                           body = report_metadata,
                           encode = "json")
  } else {
    if(async){
      httr_response <- rPOST(url = this_url)
    } else {
      httr_response <- rGET(url = this_url)  
    }
  }
  if(verbose){
    make_verbose_httr_message(httr_response$request$method,
                              httr_response$request$url,
                              httr_response$request$headers, 
                              report_metadata)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")

  # if as_tbl = FALSE, then return the parsed list, else reformat into a tbl_df
  if(as_tbl){
    if(async){
      response_parsed <- response_parsed %>% 
        set_null_elements_to_na_recursively() %>%
        as_tibble_row() %>% 
        mutate(across(any_of(c("completionDate", "requestDate")), 
                      ~parse_datetime(as.character(.x)))) %>% 
        type_convert(col_types = cols(.default = col_guess())) %>% 
        select(any_of(c("id", "ownerId", "status", 
                        "requestDate", "completionDate", 
                        "hasDetailRows", "queryable", "url")), 
               everything())
    } else {
      # parse the same way you would the report instance results
      response_parsed <- response_parsed %>% 
        parse_report_detail_rows(
          labels = labels,
          guess_types = guess_types
        )
    }
  }
  return(response_parsed)
}

#' List report instances
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Returns a list of instances for a report that you requested to be run asynchronously. 
#' Each item in the list is treated as a separate instance of the report run with 
#' metadata in that snapshot of time.
#'
#' @importFrom purrr map_df
#' @importFrom dplyr mutate across select any_of everything
#' @importFrom readr parse_datetime type_convert cols col_guess
#' @template report_id
#' @template as_tbl
#' @template verbose
#' @return \code{tbl_df} by default, or a \code{list} depending on the value of 
#' argument \code{as_tbl}
#' @family Report Instance functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instances_resource.htm}{Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_list_asyncreportruns.htm#example_async_fetchresults_instances}{Example}
#' }
#' @examples
#' \dontrun{
#' # first, get the Id of a report in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' this_report_id <- all_reports$Id[1]
#' 
#' # second, execute an async report
#' results <- sf_execute_report(this_report_id, async=TRUE)
#' 
#' # third, pull a list of async requests ("instances") usually meant for checking 
#' # if a recently requested report has succeeded and the results can be retrieved
#' instance_list <- sf_list_report_instances(this_report_id)
#' instance_status <- instance_list[[which(instance_list$id == results$id), "status"]]
#' }
#' @export
sf_list_report_instances <- function(report_id, as_tbl=TRUE, verbose=FALSE){
  this_url <- make_report_instances_list_url(report_id)
  resultset <- sf_rest_list(url=this_url, as_tbl=FALSE, verbose=verbose)
  if(as_tbl){
    resultset <- resultset %>% 
      set_null_elements_to_na_recursively() %>%
      map_df(flatten_tbl_df) %>% 
      mutate(across(any_of(c("completionDate", "requestDate")), 
                    ~parse_datetime(as.character(.x)))) %>% 
      type_convert(col_types = cols(.default = col_guess())) %>% 
      select(any_of(c("id", "ownerId", "status", 
                      "requestDate", "completionDate", 
                      "hasDetailRows", "queryable", "url")), 
             everything())
  }
  return(resultset)
}

#' Delete a report instance
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' If the given report instance has a status of \code{Success} or \code{Error}, 
#' delete the report instance.
#'
#' @template report_id
#' @template report_instance_id
#' @template verbose
#' @return \code{logical} indicating whether the report instance was deleted. This function 
#' will return \code{TRUE} if successful in deleting the report instance.
#' @family Report Instance functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instance_resource_results.htm}{Documentation}
#' }
#' @examples
#' \dontrun{
#' # first, get the Id of a report in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' this_report_id <- all_reports$Id[1]
#' 
#' # second, ensure that report has been executed at least once asynchronously
#' results <- sf_execute_report(this_report_id, async=TRUE)
#' 
#' # check if that report has succeeded, if so (or if it errored), then delete
#' instance_list <- sf_list_report_instances(this_report_id)
#' instance_status <- instance_list[[which(instance_list$id == results$id), "status"]]
#' }
#' @export
sf_delete_report_instance <- function(report_id, 
                                      report_instance_id, 
                                      verbose=FALSE){
  this_url <- make_report_instance_url(report_id, report_instance_id)
  httr_response <- rDELETE(url = this_url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  if(is.null(response_parsed) & status_code(httr_response) == 204){
    response_parsed <- TRUE
  }
  return(invisible(response_parsed))
}

#' Get report instance results
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Retrieves results for an instance of a report run asynchronously with or without 
#' filters. Depending on your asynchronous report run request, data can be at the 
#' summary level or include details.
#'
#' @importFrom lifecycle deprecated is_present deprecate_warn
#' @importFrom purrr map_df pluck set_names map_chr
#' @template report_id
#' @template report_instance_id
#' @template labels
#' @template guess_types
#' @template bind_using_character_cols
#' @template fact_map_key
#' @template verbose
#' @return \code{tbl_df}; the detail report data. More specifically, the detailed 
#' data from the "T!T" entry in the fact map.
#' @family Report Instance functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instance_resource_results.htm}{Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_instance_reportresults}{Example}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_factmap_example.htm}{Factmap Documentation}
#' }
#' @examples
#' \dontrun{
#' # execute a report asynchronously in your Org
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' this_report_id <- all_reports$Id[1]
#' results <- sf_execute_report(this_report_id, async=TRUE)
#' 
#' # check if that report has succeeded, ... 
#' instance_list <- sf_list_report_instances(this_report_id)
#' instance_status <- instance_list[[which(instance_list$id == results$id), "status"]]
#' 
#' # ... if so, then grab the results
#' if(instance_status == "Success"){
#'   report_data <- sf_get_report_instance_results(report_id = this_report_id, 
#'                                                 report_instance_id = results$id)
#' }
#' }
#' @export
sf_get_report_instance_results <- function(report_id, 
                                           report_instance_id,
                                           labels = TRUE,
                                           guess_types = TRUE, 
                                           bind_using_character_cols = deprecated(),
                                           fact_map_key = "T!T",
                                           verbose = FALSE){
  
  if(is_present(bind_using_character_cols)) {
    deprecate_warn("1.0.0", 
                   "salesforcer::sf_get_report_instance_results(bind_using_character_cols)", 
                   details = paste0("The `bind_using_character_cols` functionality ", 
                                    "will always be `TRUE` going forward. Per the ", 
                                    "{readr} package, we have to read as character ", 
                                    "and then invoke `type_convert()` in order to ",
                                    "use all values in a column to guess its type."))
  }   
  
  this_url <- make_report_instance_url(report_id, report_instance_id)
  resultset <- sf_rest_list(url = this_url, as_tbl = FALSE, verbose = verbose)
  resultset <- resultset %>% 
    parse_report_detail_rows(
      fact_map_key = fact_map_key,
      labels = labels,
      guess_types = guess_types
    )
  return(resultset)
}

#' Get a report's data in tabular format
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function is a convenience wrapper for retrieving the data from a report.
#' By default, it executes an asynchronous report and waits for the detailed data
#' summarized in a tabular format, before pulling them down and returning as a
#' \code{tbl_df}.
#' 
#' @details This function is essentially a wrapper around \code{\link{sf_execute_report}}. 
#' Please review or use that function and/or \code{\link{sf_query_report}} if you 
#' want to have more control over how the report is run and what format should
#' be returned. In this case we've forced the \code{reportFormat="TABULAR"}
#' without total rows and given options to filter, and select the Top N as
#' function arguments rather than forcing the user to create an entire list of
#' \code{reportMetadata}.
#' 
#' @importFrom lifecycle deprecated is_present deprecate_warn
#' @template report_id
#' @param report_filters \code{list}; A \code{list} of reportFilter specifications. 
#' Each must be a list with 3 elements: 1) \code{column}, 2) \code{operator}, and 
#' 3) \code{value}. You can find out how certain field types can be filtered by 
#' reviewing the results of \code{\link{sf_list_report_filter_operators}}.
#' @param report_boolean_logic \code{character}; a string of boolean logic to parse 
#' custom field filters if more than one is specified. For example, if three filters 
#' are specified, then they can be combined using the logic \code{"(1 OR 2) AND 3"}.
#' @param sort_by \code{character}; the name of the column(s) used to sort the results. 
#' @param decreasing \code{logical}; the indicator(s) of whether each column in the 
#' \code{sort_by} argument should be ordered by increasing or decreasing values. If 
#' the length is shorter than the length of the sort_by argument then the elements 
#' will be recycled.
#' @param top_n \code{integer}; an integer which sets a row limit filter to a report. 
#' The results will be ordered as they appear in the report unless specified differently 
#' via the \code{sort_by} and \code{decreasing} arguments. Note, it is sometimes 
#' helpful to specify the \code{top_n} argument if a report contains many rows, but 
#' you are only interested in a subset of them. Alternatively, you can limit the count 
#' of returned rows via the \code{report_filters} argument.
#' @param decreasing \code{logical}; a indicator of whether the results should be 
#' ordered by increasing or decreasing values in \code{sort_by} column when selecting the 
#' top N records. Note, this argument will be ignored if not specifying Top N. You can  
#' sort the records using \code{\link[dplyr]{arrange}} after the results are returned.
#' @template async
#' @template interval_seconds
#' @template max_attempts
#' @param wait_for_results \code{logical}; indicating whether to wait for the
#' report finish running so that data can be obtained. Otherwise, return the
#' report instance details which can be used to retrieve the results when the
#' async report has finished.
#' @template guess_types
#' @template bind_using_character_cols
#' @template fact_map_key
#' @template verbose
#' @return \code{tbl_df}
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_getreportrundata.htm}{Sync Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_sync_reportexecute}{Sync Example}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instances_summaryasync.htm}{Async Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_report_async_instances}{Async Example}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_filter_reportdata.htm#example_requestbody_execute_resource}{Filtering Results}
#' }
#' @examples
#' \dontrun{
#' # find a report in your org and run it
#' all_reports <- sf_query("SELECT Id, Name FROM Report")
#' this_report_id <- all_reports$Id[1]
#' results <- sf_run_report(this_report_id)
#' 
#' # apply your own filters to that same report
#' # set up some filters, if needed
#' # filter records that was created before this month
#' filter1 <- list(column = "CREATED_DATE",
#'                 operator = "lessThan", 
#'                 value = "THIS_MONTH")
#' 
#' # filter records where the account billing address city is not empty
#' filter2 <-  list(column = "ACCOUNT.ADDRESS1_CITY",
#'                  operator = "notEqual", 
#'                  value = "")
#' 
#' # combine filter1 and filter2 using 'AND' so that records must meet both filters
#' results_using_AND <- sf_run_report(my_report_id, 
#'                                    report_boolean_logic = "1 AND 2",
#'                                    report_filters = list(filter1, filter2))
#' 
#' # combine filter1 and filter2 using 'OR' which means that records must meet one 
#' # of the filters but also throw in a row limit based on a specific sort order
#' results_using_OR <- sf_run_report(my_report_id, 
#'                                   report_boolean_logic = "1 OR 2",
#'                                   report_filters = list(filter1, filter2), 
#'                                   sort_by = "Contact.test_number__c", 
#'                                   decreasing = TRUE, 
#'                                   top_n = 5)
#' }
#' @export
sf_run_report <- function(report_id,
                          report_filters = NULL,
                          report_boolean_logic = NULL,
                          sort_by = character(0),
                          decreasing = FALSE,
                          top_n = NULL,
                          async = TRUE,
                          interval_seconds = 3,
                          max_attempts = 200,
                          wait_for_results = TRUE,
                          guess_types = TRUE,
                          bind_using_character_cols = deprecated(),
                          fact_map_key = "T!T",
                          verbose = FALSE){
  
  if(is_present(bind_using_character_cols)) {
    deprecate_warn("1.0.0", 
                   "salesforcer::sf_run_report(bind_using_character_cols)", 
                   details = paste0("The `bind_using_character_cols` functionality ", 
                                    "will always be `TRUE` going forward. Per the ", 
                                    "{readr} package, we have to read as character ", 
                                    "and then invoke `type_convert()` in order to ",
                                    "use all values in a column to guess its type."))
  }    
  
  # build out the body of the request based on the inputted arguments by starting 
  # with a simplified version and then adding to it based on the user inputted arguments
  request_body <- simplify_report_metadata(report_id, verbose = verbose)
  
  if(!is.null(report_filters)){
    stopifnot(is.list(report_filters))
    for(i in 1:length(report_filters)){
      report_filters[[i]] <- metadata_type_validator(obj_type = "ReportFilterItem", 
                                                     obj_data = report_filters[[i]])[[1]]
    }
    if(is.null(report_boolean_logic)){
      if(length(report_filters) > 1){
        report_boolean_logic <- paste((1:length(report_filters)), collapse=" AND ")
        message(sprintf(paste0("The argument `report_boolean_logic` was left NULL. ", 
                               "Assuming the report filters should be combined using 'AND' ", 
                               "like so: %s"), report_boolean_logic))
      } else {
        report_boolean_logic <- NA
      }
    } else {
      stopifnot(is.character(report_boolean_logic))
    }
  } else {
    # value must be null when filter logic is not specified
    report_boolean_logic <- NA
  }
  
  request_body$reportMetadata$reportBooleanFilter <- report_boolean_logic
  request_body$reportMetadata$reportFilters <- report_filters
  
  if(length(sort_by) > 0 & !(all(is.na(sort_by)))){
    if(length(sort_by) > 1){
      stop(paste0("Currently, Salesforce will only allow a report to be sorted ", 
                  "by, at most, one column."), call. = FALSE)
    } else {
      if(length(decreasing) < length(sort_by)){
        decreasing <- rep_len(decreasing, length.out = length(sort_by))  
      }
      sort_list_spec <- list()
      for(i in 1:length(sort_by)){
        sort_list_spec[[i]] <- list(sortColumn = sort_by[i], 
                                    sortOrder = if(decreasing[i]) "Desc" else "Asc")
      }
      request_body$reportMetadata$sortBy <- sort_list_spec
    }
  } else {
    # if there is no sortBy, then set it to NA, if there is, then leave it alone 
    # beause it is required when Top N is specified and the user might just want 
    # to use the existing sort order in the report
    if(is.null(request_body$reportMetadata$sortBy) || 
        is.na(request_body$reportMetadata$sortBy) || 
        length(request_body$reportMetadata$sortBy) == 0){
      request_body$reportMetadata$sortBy <- NA
    }
  }
  if(!is.null(top_n)){
    if(is.na(request_body$reportMetadata$sortBy)){
      stop(paste0("A report must be sorted by one column when requesting a ", 
                  "Top N number of rows."), call. = FALSE)
    } else if(length(request_body$reportMetadata$sortBy) > 1){
      stop(paste0("A report can only be sorted by one column when requesting a ", 
                  "Top N number of rows."), call. = FALSE)
    } else{
      # the direction is always 'Asc' because Salesforce doesn't accept 'Desc'. It 
      # relies on the 'sortOrder' element within the 'sortBy' element
      request_body$reportMetadata$topRows <- list(rowLimit = top_n, direction = "Asc")
    }
  }
  
  results <- sf_execute_report(report_id, 
                               async = async, 
                               report_metadata = request_body,
                               guess_types = guess_types,
                               verbose = verbose)
  
  # request the report results (still wait if async is specified)
  if(async){
    if(wait_for_results){
      status_complete <- FALSE
      z <- 1
      Sys.sleep(interval_seconds)
      while (z < max_attempts & !status_complete){
        if (verbose){
          if(z %% 5 == 0){
            message(paste0("Attempt to retrieve records #", z))
          }
        }
        Sys.sleep(interval_seconds)
        instances_list <- sf_list_report_instances(report_id, verbose = verbose)
        instance_status <- instances_list[[which(instances_list$id == results$id), "status"]]
        if(instance_status == "Error"){
          stop(sprintf("Report run failed (Report Id: %s; Instance Id: %s).", 
                       report_id, results$id), 
               call.=FALSE)
        } else {
          if(instance_status == "Success"){
            status_complete <- TRUE
          } else {
            # continue checking the status until success or max attempts
            z <- z + 1
          }
        }
      }
      results <- sf_get_report_instance_results(report_id, 
                                                results$id, 
                                                guess_types = guess_types,
                                                fact_map_key = "T!T",
                                                verbose = verbose)
    }
  }
  # if not aysnc and waiting for results, then sf_execute_report() will return 
  # the parsed dataset (if sync) or request details if async to check on the results 
  # without having the wrapper executing the wait. This is so users can leverage 
  # the simpler interface (i.e. providing function arguments) instead of researching 
  # the Salesforce documentation and building the reportMetadata property from scratch
  return(results)
}

#' Get Report Data without Saving Changes to or Creating a Report
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Run a report without creating a new report or changing the existing one by making
#' a POST request to the query resource. This allows you to get report data 
#' without filling up your Org with unnecessary reports.
#' 
#' @details Note that you can query a report's data simply by providing its \code{Id}.
#' However, the data will only be the detailed data from the tabular format 
#' with no totals or other metadata. If you would like more control, for example, 
#' filtering the results or grouping them in specific ways, then you will need 
#' to specify a list to the \code{report_metadata} argument. The \code{report_metadata} 
#' argument requires specific knowledge on the structure the \code{reportMetadata}
#' property of a report. For more information, please review the Salesforce documentation 
#' in detail \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_getbasic_reportmetadata.htm#analyticsapi_basicmetadata}{HERE}. 
#' Additional references are provided in the \code{"See Also"} section.
#'
#' @template report_id
#' @template report_metadata
#' @template verbose
#' @return \code{tbl_df}
#' @family Report functions
#' @section Salesforce Documentation:
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_report_query.htm}{Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_report_query_example.htm#sforce_analytics_rest_api_report_query_example}{Example}
#' }
#' @export
sf_query_report <- function(report_id,
                            report_metadata = NULL, 
                            verbose = FALSE){
  
  .NotYetImplemented()
  
  # if(!is.null(report_metadata)){
  #   report_metadata <- sf_input_data_validation(report_metadata,
  #                                               operation = "filter_report")
  # } else {
  #   # copy existing report metadata and then set options to something simpler, 
  #   # meaning no filters, no aggregates, no totals or subtotals, and at the 
  #   # detail level in tablular format
  #   report_metadata <- simplify_report_metadata(report_id, verbose = verbose)
  # }
  # 
  # this_url <- make_report_query_url()
  # httr_response <- rPOST(url = this_url,
  #                        body = report_metadata,
  #                        encode = "json")
  # if(verbose){
  #   make_verbose_httr_message(httr_response$request$method,
  #                             httr_response$request$url,
  #                             httr_response$request$headers, 
  #                             report_metadata)
  # }
  # catch_errors(httr_response)
  # response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  # resultset <- parse_report_detail_rows(response_parsed)
  # return(resultset)
}
