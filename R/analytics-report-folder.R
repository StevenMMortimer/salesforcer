# https://resources.docs.salesforce.com/226/latest/en-us/sfdc/pdf/salesforce_analytics_rest_api.pdf

#' List report folders
#'
#' @export
sf_report_folders_list <- function(){
  .NotYetImplemented()
  # make_report_folders_list_url
  # /services/data/v43.0/folders
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_ops.htm#FolderDetailRepresentation  
}

#' Create report folder
#'
#' @export
sf_report_folder_create <- function(body){
  .NotYetImplemented()
  # make_report_folders_list_url
  # /services/data/v43.0/folders
  # POST
  # Uses the same format as the GET response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_ops.htm#FolderInputRepresentation  
}

#' Describe a report folder
#'
#' @export
sf_report_folder_describe <- function(report_folder_id){
  # # make_report_folder_url
  # /services/data/v43.0/folders/00lxx000000flSFAAY
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_ops.htm#FolderDetailRepresentation  
}

#' Update a report folder
#'
#' @export
sf_report_folder_update <- function(report_folder_id, body){
  .NotYetImplemented()  
  # # make_report_folder_url
  # /services/data/v43.0/folders/00lxx000000flSFAAY
  # PATCH
  # Uses the same format as the GET response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_ops.htm#FolderInputRepresentation
}

#' Delete a report folder
#'
#' @export
sf_report_folder_delete <- function(report_folder_id){
  .NotYetImplemented()
  # # make_report_folder_url
  # /services/data/v43.0/folders/01ZD00000007S89MAE
  # DELETE
}

#' List the shares in a report folder
#'
#' @export
sf_report_folder_shares_list <- function(report_folder_id){
  # # make_report_folder_share_url
  # /services/data/v43.0/folders/00lxx000000flSFAAY/shares/004xx000001Sy1GAAS
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_shares.htm 
}

#' Add shares to a report folder
#' 
#' Creates new shares and appends them to the existing share list for the folder.
#'
#' @export
sf_report_folder_shares_add <- function(report_folder_id, body){
  .NotYetImplemented()  
  # # make_report_folder_share_url
  # /services/data/v43.0/folders/00lxx000000flSFAAY/shares/004xx000001Sy1GAAS
  # POST
  # Uses the same format as the GET response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_shares.htm
}

#' Update the shares for a report folder
#' 
#' Creates new shares to replace the existing shares in the share list for the folder.
#'
#' @export
sf_report_folder_shares_update <- function(report_folder_id, body){
  .NotYetImplemented()
  # # make_report_folder_share_url
  # /services/data/v43.0/folders/01ZD00000007S89MAE/shares/004xx000001Sy1GAAS
  # PUT
  # Uses the same format as the GET response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_shares.htm
}

#' Describe a report folder share
#'
#' @export
sf_report_folder_share_describe <- function(report_folder_id, share_id){
  # # make_report_folder_share_url
  # /services/data/v43.0/folders/00lxx000000flSFAAY/shares/004xx000001Sy1GAAS
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_shares_by_id.htm
}

#' Update a report folder share
#'
#' @export
sf_report_folder_share_update <- function(report_folder_id, share_id, body){
  .NotYetImplemented()  
  # # make_report_folder_share_url
  # /services/data/v43.0/folders/00lxx000000flSFAAY/shares/004xx000001Sy1GAAS
  # PATCH
  # Uses the same format as the GET response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_shares_by_id.htm#FolderSharesInputRepresentation 
}

#' Delete a report folder share
#'
#' @export
sf_report_folder_share_delete <- function(report_folder_id, share_id){
  .NotYetImplemented()
  # # make_report_folder_share_url
  # /services/data/v43.0/folders/01ZD00000007S89MAE/shares/004xx000001Sy1GAAS
  # DELETE
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_shares_by_id.htm
}

#' Get report folder share recipients
#'
#' @export
sf_report_folder_share_recipients <- function(report_folder_id, 
                                              share_type = c("User", "Group", "Role"), 
                                              search_term = "", 
                                              limit = 100){
  .NotYetImplemented()
  # # make_report_folder_share_recipients_url
  # /services/data/v43.0/folders/01ZD00000007S89MAE/share-recipients?shareType=<shareType>
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_share_recipients.htm
  # share_type \code{character} Return data for the recipients of the specified type, such as "user", "group", or "role".
  # search_term \code{character} Search to match share recipients' names.	Default is "" (no restriction).
  # limit	\code{integer} Limit to the number of search results.	Default is 100.
}

#' Get the subfolders (children) of a report folder
#'
#' @export
sf_report_folder_children <- function(report_folder_id, 
                                      page_size = 10, 
                                      page = NULL){
  .NotYetImplemented()
  # # make_report_folder_children_url
  # /services/data/v43.0/folders/01ZD00000007S89MAE/children
  # GET
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_folders_children.htm
  # page_size	\code{integer} integer that indicates how many results each page returns. Default is 10.
  # page	\code{integer} integer that indicates which page of results to return. Default is 1.
}
