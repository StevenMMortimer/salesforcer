# https://resources.docs.salesforce.com/226/latest/en-us/sfdc/pdf/salesforce_analytics_rest_api.pdf

#' List analytics notifications
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' @template source
#' @template owner_id
#' @template record_id
#' @return \code{list}
#' @export
sf_analytics_notifications_list <- function(source=c("lightningDashboardSubscribe",
                                                     "lightningReportSubscribe",
                                                     "waveNotification"), 
                                            owner_id=NULL,
                                            record_id=NULL){
  source <- match.arg(source, several.ok = TRUE)
  
  .NotYetImplemented()
  # make_notification_list_url
  # /services/data/v34.0/analytics/notifications
  # GET
  # source - Required for GET calls. Specifies what type of analytics notification to return.
  # Valid values are:
  # lightningDashboardSubscribe — dashboard subscriptions
  # lightningReportSubscribe — report subscriptions
  # waveNotification — Einstein Analytics notifications  
  #
  # ownerId - Optional for GET calls. Allows users with Manage Analytics Notifications 
  # permission to get notifications for another user with the specified ownerId.
  #
  # recordId - Optional. Return notifications for a single record. 
  # Valid values are:
  # reportId— Unique report ID
  # lensId— Unique Einstein Analytics lens ID  
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_notifications_reference_list.htm
}

#' Return limits of analytics notifications
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' @template source
#' @template record_id
#' @return \code{list}
#' @export
sf_analytics_notifications_limits <- function(source=c("lightningDashboardSubscribe",
                                                       "lightningReportSubscribe",
                                                       "waveNotification"), 
                                              record_id=NULL){
  
  source <- match.arg(source, several.ok = TRUE)
  # can only retrieve one a time (lightningDashboardSubscribe, 
  #   lightningReportSubscribe, waveNotification) so by default we will pull for all  
  
  .NotYetImplemented()
  # make_notification_limits_url
  # /services/data/v34.0/analytics/notifications/limits
  # GET
  # source - Required for GET calls. Specifies what type of analytics notification to return.
  # Valid values are:
  # lightningDashboardSubscribe — dashboard subscriptions
  # lightningReportSubscribe — report subscriptions
  # waveNotification — Einstein Analytics notifications  
  #
  # recordId - Optional. Return notifications for a single record. 
  # Valid values are:
  # reportId— Unique report ID
  # lensId— Unique Einstein Analytics lens ID    
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_notifications_reference_notification_limits.htm
}

#' Create an analytics notification
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' @template body
#' @return \code{list}
#' @export
sf_analytics_notification_create <- function(body){
  .NotYetImplemented()
  # make_notification_list_url
  # /services/data/v34.0/analytics/notifications
  # POST
  # Uses the same format as the GET and POST response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_notifications_reference_list.htm
}

#' Describe an analytics notification
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' @template notification_id
#' @return \code{list}
#' @export
sf_analytics_notification_describe <- function(notification_id){
  
  .NotYetImplemented()  
  # # make_notification_url
  # /services/data/v34.0/analytics/notifications/01ZR00000004SknMAE
  # GET
  # source - Required for GET calls. Specifies what type of analytics notification to return.
  # Valid values are:
    # lightningDashboardSubscribe — dashboard subscriptions
    # lightningReportSubscribe — report subscriptions
    # waveNotification — Einstein Analytics notifications  
  #
  # ownerId - Optional for GET calls. Allows users with Manage Analytics Notifications 
  # permission to get notifications for another user with the specified ownerId.
  #
  # recordId - Optional. Return notifications for a single record. 
  # Valid values are:
    # reportId— Unique report ID
    # lensId— Unique Einstein Analytics lens ID
}

#' Update an analytics notification
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' @template notification_id
#' @template body
#' @return \code{list}
#' @export
sf_analytics_notification_update <- function(notification_id, body){
  .NotYetImplemented()  
  # # make_notification_url
  # /services/data/v34.0/analytics/notifications/01ZR00000004SknMAE/describe
  # PUT
  # Uses the same format as the GET response body.
  # https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/analytics_api_notifications_reference_notification.htm#analytics_api_notifications_reference_notification
}

#' Delete an analytics notification
#' 
#' @description
#' \lifecycle{experimental}
#' 
#' @template notification_id
#' @return \code{logical}
#' @export
sf_analytics_notification_delete <- function(notification_id){
  .NotYetImplemented()
  # # make_notification_url
  # /services/data/v34.0/analytics/notifications/01ZD00000007S89MAE
  # DELETE
}
