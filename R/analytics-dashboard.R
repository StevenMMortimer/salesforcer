# https://resources.docs.salesforce.com/226/latest/en-us/sfdc/pdf/salesforce_analytics_rest_api.pdf

#' List dashboards
#'
#' Returns a list of recently used dashboards
#'
#' @export
sf_dashboards_list <- function(){
  .NotYetImplemented()
  # make_dashboards_list_url
  # /services/data/v34.0/analytics/dashboards
  # GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_list_resource.htm#topic-title}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_get_list.htm#topic-title}{Example}
}

#' Describe a dashboard
#'
#' @export
sf_dashboard_describe <- function(dashboard_id){
  .NotYetImplemented()  
  # # make_dashboard_describe_url
  # /services/data/v34.0/analytics/dashboards/01ZR00000004SknMAE/describe
  # GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_get_results.htm#topic-title}{Example}
}

#' Describe dashboard components
#'
#' @export
sf_dashboard_components_describe <- function(dashboard_id, 
                                             component_ids=c(character(0))){
  .NotYetImplemented()  
  # # make_dashboard_url()
  # /services/data/v34.0/analytics/dashboards/01ZR00000008h2EMAQ
  # POST
  # {
  #   "componentIds": ["01aR00000005aT4IAI", "01aR00000005aT5IAI"]
  # }
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_get_results.htm#topic-title}{Example}  
}

#' Get the status of a dashboard
#'
#' @export
sf_dashboard_status <- function(dashboard_id, 
                                running_user = NULL, 
                                filters = list()){
  .NotYetImplemented()
  # # make_dashboard_status_url()
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE/status
  # ?runningUser=runningUserID&filter1=filter1ID&filter2=filter2ID&filter3=filter3ID
  # GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_status_resource.htm#topic-title}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_status_resource.htm#topic-title}{Example - Filtering results}
}

#' List dashboard filter operators
#'
#' @export
sf_dashboard_filter_operators_list <- function(){
  .NotYetImplemented()
  # make_report_filter_operators_list_url
  # /services/data/v34.0/analytics/filteroperators?forDashboards=true
  # GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_resource.htm}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_list.htm}{Example}
}

#' Get an analysis of the filter options for a dashboard
#'
#' @export
sf_dashboard_filter_options_analysis <- function(dashboard_id, 
                                                 filter_columns = list(), 
                                                 options = list()){
  .NotYetImplemented()
  # make_dashboard_filter_options_analysis_url
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE/filteroptionsanalysis
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_filteroptionsanalysis.htm
  
  # filter_columns \code{list}; a list of fields from the source report which you check filter values against. Each object in the array has these properties:...
  # options \code{list}; a list of objects describing a dashboard filter. Each object has these properties:...
}

#' Get the results of an existing dashboard
#' 
#' This function allows for pulling specific data from a dashboard. There is a
#' convenience function (\link{sf_get_dashboard_data}) to get the dashboard data
#' in a tabular format returned as a \code{tbl_df}.
#'
#' @export
sf_dashboard_results <- function(dashboard_id, 
                                 running_user = NULL, 
                                 filters = list()){
  .NotYetImplemented()
  # # make_dashboard_url()
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # OPTIONAL ?runningUser=runningUserID&filter1=filter1ID&filter2=filter2ID&filter3=filter3ID
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_filter_results.htm
}

#' Get dashboard data in a tabular format
#' 
#' @export
sf_get_dashboard_data <- function(dashboard_id,
                                  running_user = NULL, 
                                  filters = list()){
  .NotYetImplemented()
}

#' Refresh an existing dashboard
#'
#' @export
sf_dashboard_refresh <- function(dashboard_id, 
                                 filters=list()){
  .NotYetImplemented()
  # # make_dashboard_url()
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # PUT
  # does this support running_user?????
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_list_resource.htm#topic-title}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_refresh.htm}{Example}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_filter_results.htm}{Example - Filtering during refresh}
}

#' Copy a dashboard
#'
#' @export
sf_dashboard_copy <- function(dashboard_id, folder_id){
  .NotYetImplemented()
  # # make_dashboard_copy_url
  # /services/data/v34.0/analytics/dashboards/?cloneId=01ZD00000007S89MAE
  # POST
  # {
  #   "folderId" : "00lR0000000DnRZIA0"
  # }
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_list_resource.htm#topic-title}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_clone_dashboard.htm#topic-title}{Example}  
}

#' Update a dashboard
#'
#' @export
sf_dashboard_update <- function(dashboard_id, body){
  .NotYetImplemented()
  # # make_dashboard_url
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # PATCH
  # {
  #   "dashboardMetadata" : {
  #     "name":"myUpdatedDashboard",
  #     "folderId":"00DD00000007enH"}
  # }
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_save_dashboard.htm#topic-title}{Example}  
}

#' Set a sticky dashboard filter
#' 
#' Set a default filter value which gets applied to a dashboard when you open
#' it. The default filter value you specify only applies to you (other people
#' won’t see it when they open the dashboard). If you change the filter value
#' while viewing the dashboard, then the filter value you set in the user
#' interface overwrites the value you set via the API. To set sticky filters for
#' a dashboard, \code{canUseStickyFilter} must equal true.
#'
#' @export
sf_dashboard_set_sticky_filter <- function(dashboard_id, 
                                           filters = list()){
  .NotYetImplemented()
  # # make_dashboard_url(sticky_filter_save = TRUE)
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE?isStickyFilterSave=true
  # PATCH
  # {
  #   "filters" : [ {
  #     "errorMessage" : null,
  #     "id" : "0IBR00000004D4iOAE",
  #     "name" : "Billing City",
  #     "options" : [ {
  #    ...
  # }
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_set_filter.htm
}

#' Delete a dashboard
#'
#' @export
sf_dashboard_delete <- function(dashboard_id){
  .NotYetImplemented()
  # # make_dashboard_url
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # DELETE
  #
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_delete.htm#example_recent_reportslist}{Example}
}
