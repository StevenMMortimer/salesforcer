#' Analytics Folder collections URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_collections_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/folders/",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' Analytics Folder operations URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_operations_url <- function(report_folder_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/folders/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_folder_id)      
}

#' Analytics Folder shares URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_shares_url <- function(report_folder_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/folders/%s/shares",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_folder_id)
}

#' Analytics Folder share by Id URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_share_by_id_url <- function(report_folder_id, share_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/folders/%s/shares/%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_folder_id, 
          share_id)   
}

#' Analytics Folder share recipients URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_share_recipients_url <- function(report_folder_id, share_type){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/folders/%s/share-recipients?shareType=%s",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_folder_id, 
          share_type)      
}

#' Analytics Folder child operations URL generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_child_operations_url <- function(report_folder_id){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/folders/%s/children",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          report_folder_id)
}
