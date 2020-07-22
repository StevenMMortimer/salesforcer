# https://resources.docs.salesforce.com/226/latest/en-us/sfdc/pdf/salesforce_analytics_rest_api.pdf

#' List dashboards
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Returns a list of recently used dashboards
#'
#' @template as_tbl
#' @template verbose
#' @return \code{list} or \code{tbl_df} depending on the value of argument \code{as_tbl}
#' @seealso 
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_list_resource.htm#topic-title}{Salesforce Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_get_list.htm#topic-title}{Salesforce Example}
#' }
#' @export
sf_dashboards_list <- function(as_tbl=TRUE, verbose=FALSE){
  this_url <- make_dashboards_list_url()
  resultset <- sf_rest_list(url=this_url, as_tbl=as_tbl, verbose=verbose)
  return(resultset)
}

#' Describe a dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Returns metadata for the specified dashboard, including dashboard components, 
#' filters, layout, and the running user.
#'
#' @template dashboard_id
#' @template as_tbl
#' @template verbose
#' @return \code{list} or \code{tbl_df} depending on the value of argument \code{as_tbl}
#' @seealso 
#' \itemize{
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_describe_resource.htm}{Salesforce Documentation}
#'   \item \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_example_get_dashboard_metadata.htm#analytics_api_dashboard_example_get_dashboard_metadata}{Salesforce Example}
#' }
#' @export
sf_dashboard_describe <- function(dashboard_id, as_tbl=TRUE, verbose=FALSE){
  this_url <- make_dashboard_describe_url(dashboard_id)
  resultset <- sf_rest_list(url=this_url, as_tbl=as_tbl, verbose=verbose)
  return(resultset)
}

#' Describe dashboard components
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @param component_ids \code{character}; a vector of Unique Salesforce Ids of a 
#' dashboard component.
#' @return \code{list}
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
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_get_results.htm#topic-title}{Salesforce Example}  
}

#' Get the status of a dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @template running_user
#' @template dashboard_filters
#' @return \code{list}
#' @export
sf_dashboard_status <- function(dashboard_id,
                                running_user = NULL, 
                                dashboard_filters = c(character(0))){
  .NotYetImplemented()
  # # make_dashboard_status_url()
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE/status
  # ?runningUser=runningUserID&filter1=filter1ID&filter2=filter2ID&filter3=filter3ID
  # GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_status_resource.htm#topic-title}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_status_resource.htm#topic-title}{Example - Filtering results}
}

#' List dashboard filter operators
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @return \code{list}
#' @export
sf_dashboard_filter_operators_list <- function(){
  .NotYetImplemented()
  # make_report_filter_operators_list_url
  # /services/data/v34.0/analytics/filteroperators?forDashboards=true
  # GET
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_resource.htm}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_filteroperators_reference_list.htm}{Salesforce Example}
}

#' Get an analysis of the filter options for a dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @param filter_columns \code{list}; a list of fields from the source report 
#' which you check filter values against. Each object in the array has these 
#' properties:...
#' @param options \code{list}; a list of objects describing a dashboard filter. 
#' Each object has these properties:...
#' @return \code{list}
#' @export
sf_dashboard_filter_options_analysis <- function(dashboard_id, 
                                                 filter_columns = list(), 
                                                 options = list()){
  .NotYetImplemented()
  # make_dashboard_filter_options_analysis_url
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE/filteroptionsanalysis
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_filteroptionsanalysis.htm
  

}

#' Get the results of an existing dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' This function allows for pulling specific data from a dashboard. There is a
#' convenience function (\link{sf_get_dashboard_data}) to get the dashboard data
#' in a tabular format returned as a \code{tbl_df}.
#' 
#' @template dashboard_id
#' @template running_user
#' @template dashboard_filters
#' @return \code{tbl_df}
#' @export
sf_dashboard_results <- function(dashboard_id,
                                 running_user = NULL, 
                                 dashboard_filters = c(character(0))){
  .NotYetImplemented()
  # # make_dashboard_url()
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # OPTIONAL ?runningUser=runningUserID&filter1=filter1ID&filter2=filter2ID&filter3=filter3ID
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_filter_results.htm
}

#' Get dashboard data in a tabular format
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @template running_user
#' @template dashboard_filters
#' @return \code{tbl_df}
#' @export
sf_get_dashboard_data <- function(dashboard_id,
                                  running_user = NULL, 
                                  dashboard_filters = c(character(0))){
  .NotYetImplemented()
}

#' Refresh an existing dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @template dashboard_filters
#' @return \code{list}
#' @export
sf_dashboard_refresh <- function(dashboard_id, 
                                 dashboard_filters=c(character(0))){
  .NotYetImplemented()
  # # make_dashboard_url()
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # PUT
  # does this support running_user?????
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_list_resource.htm#topic-title}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_refresh.htm}{Salesforce Example}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_filter_results.htm}{Example - Filtering during refresh}
}

#' Copy a dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @template report_folder_id
#' @return \code{list}
#' @export
sf_dashboard_copy <- function(dashboard_id, report_folder_id){
  .NotYetImplemented()
  # # make_dashboard_copy_url
  # /services/data/v34.0/analytics/dashboards/?cloneId=01ZD00000007S89MAE
  # POST
  # {
  #   "folderId" : "00lR0000000DnRZIA0"
  # }
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_list_resource.htm#topic-title}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_clone_dashboard.htm#topic-title}{Salesforce Example}  
}

#' Update a dashboard
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @template body
#' @return \code{list}
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
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_save_dashboard.htm#topic-title}{Salesforce Example}  
}

#' Set a sticky dashboard filter
#' 
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' Set a default filter value which gets applied to a dashboard when you open
#' it. The default filter value you specify only applies to you (other people
#' won’t see it when they open the dashboard). If you change the filter value
#' while viewing the dashboard, then the filter value you set in the user
#' interface overwrites the value you set via the API. To set sticky filters for
#' a dashboard, \code{canUseStickyFilter} must equal true.
#' Saves any dashboard filters set in the request so that they’re also set the 
#' next time you open the dashboard. NOTE: You can only set dashboard filters for 
#' yourself, not for other users.
#'
#' @template dashboard_id
#' @template dashboard_filters
#' @return \code{list}
#' @export
sf_dashboard_set_sticky_filter <- function(dashboard_id, 
                                           dashboard_filters = c(character(0))){
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
#' @description
#' `r lifecycle::badge("experimental")`
#' 
#' @template dashboard_id
#' @return \code{logical}
#' @export
sf_dashboard_delete <- function(dashboard_id){
  .NotYetImplemented()
  # # make_dashboard_url
  # /services/data/v34.0/analytics/dashboards/01ZD00000007S89MAE
  # DELETE
  #
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_results_resource.htm}{Salesforce Documentation}
  # \href{https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_dashboard_delete.htm#example_recent_reportslist}{Salesforce Example}
}
