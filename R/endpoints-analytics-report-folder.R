#' Analytics Folder collections URL generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics folder calls to. This URL is specific to your instance 
#' and the API version being used.
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
#' @template report_folder_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics folder calls to. This URL is specific to your instance 
#' and the API version being used.
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
#' @template report_folder_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics folder calls to. This URL is specific to your instance 
#' and the API version being used.
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
#' @template report_folder_id
#' @template share_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics folder calls to. This URL is specific to your instance 
#' and the API version being used.
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
#' @template report_folder_id
#' @param share_type \code{character}; the type of data for the recipients, 
#' such as user, group, or role. The default is "User".
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics folder calls to. This URL is specific to your instance 
#' and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_analytics_folder_share_recipients_url <- function(report_folder_id, share_type="User"){
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
#' @template report_folder_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send Analytics folder calls to. This URL is specific to your instance 
#' and the API version being used.
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
