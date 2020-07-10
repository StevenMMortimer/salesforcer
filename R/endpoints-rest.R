#' Base REST API URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_base_rest_url <- function(){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"))
}

#' REST API Describe URL Generator
#' 
#' @template object_name
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_rest_describe_url <- function(object_name){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  sprintf("%s/services/data/v%s/sobjects/%s/describe/",
          salesforcer_state()$instance_url,
          getOption("salesforcer.api_version"), 
          object_name)
}

#' Parameterized Search URL Generator
#' 
#' @importFrom xml2 url_escape
#' @importFrom httr build_url parse_url
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_parameterized_search_url <- function(search_string, params){
  this_url <- parse_url(paste0(make_base_rest_url(), "parameterizedSearch/"))
  this_url$query <- c(list(q=url_escape(search_string)), params)
  build_url(this_url)
}

#' Chatter Users URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_chatter_users_url <- function(){
  paste0(make_base_rest_url(), "chatter/users/")
}

#' Composite URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_composite_url <- function(){
  paste0(make_base_rest_url(), "composite/sobjects")
}

#' Query URL Generator
#' 
#' @importFrom xml2 url_escape
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_query_url <- function(soql, queryall, next_records_url){
  # ensure we are authenticated first so the url can be formed
  sf_auth_check()
  if(!is.null(next_records_url)){
    # pull more records from a previous query
    query_url <- sprintf('%s%s', 
                         salesforcer_state()$instance_url, 
                         next_records_url)
  } else {
    # set the url based on the query
    query_url <- sprintf('%s/services/data/v%s/%s/?q=%s', 
                         salesforcer_state()$instance_url,
                         getOption("salesforcer.api_version"),
                         if(queryall) "queryAll" else "query",
                         url_escape(soql))
  }
  return(query_url)
}

#' Parameterized Search URL Generator
#' 
#' @importFrom xml2 url_escape
#' @importFrom httr build_url parse_url
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_parameterized_search_url <- function(search_string=NULL, params=NULL){
  this_url <- parse_url(paste0(make_base_rest_url(), "parameterizedSearch/"))
  if(!is.null(search_string)){
    if(!is.null(params)){
      this_url$query <- c(list(q=url_escape(search_string)), params)
    } else {
      this_url$query <- list(q=url_escape(search_string))
    }
  }
  result <- build_url(this_url)
  return(result)
}

#' Search URL Generator
#' 
#' @importFrom xml2 url_escape
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_search_url <- function(search_string){
  paste0(make_base_rest_url(), "search/?q=", 
         url_escape(search_string, reserved = "{}"))
}

#' REST Objects URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_rest_objects_url <- function(object){
  paste0(make_base_rest_url(), "sobjects/", object, "/")
}

#' Composite Batch URL Generator
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_composite_batch_url <- function(){
  paste0(make_base_rest_url(), "composite/batch/")
}