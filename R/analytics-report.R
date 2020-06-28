# https://resources.docs.salesforce.com/226/latest/en-us/sfdc/pdf/salesforce_analytics_rest_api.pdf

#' List reports
#' 
#' Displays a list of up to 200 tabular, matrix, or summary reports that you
#' recently viewed. To get a full list of reports by format, name, and other
#' fields, use a SOQL query on the Report object. The resource can also be used
#' to make a copy of a report.
#'
#' @export
sf_reports_list <- function(){
  .NotYetImplemented()
# make_report_types_list_url
# /services/data/v34.0/analytics/reports
# GET
  #https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_list_recentreports.htm#example_recent_reportslist
}

#' List report filter operators
#'
#' @export
sf_report_filter_operators_list <- function(){
  .NotYetImplemented()
# make_report_filter_operators_list_url
# /services/data/v34.0/analytics/reportTypes?forDashboards=false
# GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_resource.htm}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_list.htm}{Example} 
}

#' List report types
#'
#' @export
sf_report_types_list <- function(){
  .NotYetImplemented()
# # sf_report_type_list
# /services/data/v34.0/analytics/reportTypes
# GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_reporttypes_reference_list.htm
}
  
#' Describe a report type
#'
#' @export
sf_report_type_describe <- function(){
  .NotYetImplemented()  
# # 
# /services/data/v34.0/analytics/reportTypes/{type}
# GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_reporttypes_reference_reporttype.htm
}

#' Create a report
#'
#' @export
sf_report_create <- function(name, report_type){
  .NotYetImplemented()
  # make_report_create_url
  # /services/data/v34.0/analytics/reports
  # POST
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_report_example_post_report.htm
  # reportMetadata
  # reportExtendedMetadata
  # reportTypeMetadata
}

#' Copy a report
#'
#' @export
sf_report_copy <- function(report_id){
  .NotYetImplemented()
  # # make_report_copy_url
  # /services/data/v34.0/analytics/reports?cloneId=00OD0000001cxIE
  # POST
  # {
  #   "reportMetadata" : {
  #     "name":"myNewReport"
  # }
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_clone_report.htm
}

#' Update a report
#'
#' @export
sf_report_update <- function(report_id, body){
  .NotYetImplemented()
  # # make_report_url
  # /services/data/v34.0/analytics/reports/00OD0000001cxIE
  # PATCH
  # {
  #   "reportMetadata" : {
  #     "name":"myUpdatedReport",
  #     "folderId":"00DD00000007enH"}
  # }
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_save_report.htm#example_save_report
}

#' Delete a report
#'
#' @export
sf_report_delete <- function(report_id){
  .NotYetImplemented()
  # # make_report_url
  # /services/data/v34.0/analytics/reports/00OD0000001cxIE
  # DELETE
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_delete_report.htm#example_delete_report
}
  
#' Get list of report fields
#' 
#' The Report Fields resource returns report fields available for specified
#' reports. Use the resource to determine the best fields for use in dashboard
#' filters by seeing which fields different source reports have in common.
#' Available in API version 40.0 and later.
#' 
#' @param intersect_with \code{character} a vector of unique report IDs
#' @export
sf_report_fields <- function(intersect_with = c(character(0))){
  .NotYetImplemented()
# # 
# /services/data/v34.0/analytics/reports/00OD0000001cxIE/fields
# POST
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_fields.htm
}
  
#' Describe a report
#'
#' @export
sf_report_describe <- function(){
  .NotYetImplemented()  
# # 
# /services/data/v34.0/analytics/reports/00OD0000001cxIE/describe
# GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_getbasic_reportmetadata.htm
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportmetadata.htm#example_report_getdescribe}{Example}
  
}

#' Execute a report
#'
#' @export
sf_report_execute <- function(){
  .NotYetImplemented()  
# # 
# /services/data/v34.0/analytics/reports/00OD0000001cxIE
# GET or POST
# # if async
# /services/data/v34.0/analytics/reports/00OD0000001cxIE/instances
# POST  
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_getreportrundata.htm}{Sync}  
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_sync_reportexecute}{Example - Sync}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instances_summaryasync.htm}{Async}  
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_report_async_instances}{Example - Async}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_filter_reportdata.htm#example_requestbody_execute_resource}{Filtering Results}  
}

#' List report instances
#'
#' @export
sf_report_instances_list <- function(){
  .NotYetImplemented()
# # 
# /services/data/v34.0/analytics/reports/00OD0000001cxIE/instances
# GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instances_resource.htm
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_list_asyncreportruns.htm#example_async_fetchresults_instances}{Example}
}

#' List report instance results
#'
#' @export
sf_report_instance_results <- function(){
  .NotYetImplemented()  
# # 
# /services/data/v34.0/analytics/reports/00OD0000001cxIE/instances/0LGR00000000He3OAE
# GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instance_resource_results.htm
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_get_reportdata.htm#example_instance_reportresults}{Example}
}

#' Delete a report instance
#'
#' @export
sf_report_instance_delete <- function(){
  .NotYetImplemented()
# # 
# /services/data/v34.0/analytics/reports/00OD0000001cxIE/instances/0LGR00000000He3OAE
# DELETE
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_instance_resource_results.htm
}

#' Query a report
#' 
#' This function allows for pulling specific data from a report. There is a convenience 
#' function (\link{sf_get_report_data}) to get the report data in a tabular 
#' format returned as a \code{tbl_df}.
#'
#' @export
sf_report_query <- function(){
  .NotYetImplemented()
# # 
# Tabular Report is T!T key, Summary & Matrix Report is all over the place
# /services/data/v37.0/analytics/reports/query
# POST
# {
#   "reportMetadata" : {
#     ...
#   }
# }
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_report_query.htm
}

#' Get a report's data in tabular format
#' 
#' @export
sf_get_report_data <- function(){
  .NotYetImplemented()
}
