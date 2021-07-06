#' Base REST API URL Generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send REST API calls to. This URL is specific to your instance and the API 
#' version being used.
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
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send REST API calls to regarding a specific object. This URL is also specific 
#' to your instance and the API version being used.
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

#' Chatter Users URL Generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send REST API calls regarding chatter users. This URL is specific to your 
#' instance and the API version because it relies on the base rest URL.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_chatter_users_url <- function(){
  paste0(make_base_rest_url(), "chatter/users/")
}

#' Composite URL Generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send composite REST API calls to. This URL is specific to your 
#' instance and the API version because it relies on the base rest URL.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_composite_url <- function(){
  paste0(make_base_rest_url(), "composite/sobjects")
}

#' Query URL Generator
#' 
#' @importFrom xml2 url_escape
#' @template soql
#' @template queryall
#' @param next_records_url \code{character}; a string returned by a Salesforce 
#' query from where to find subsequent records returned by a paginated query.
#' @return \code{character}; a complete URL (as a string) to send a request 
#' to in order to retrieve queried records.
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
#' @param search_string \code{character}; a valid string for conducting a simple 
#' RESTful search using parameters instead of a SOSL clause.
#' @param params \code{list}; a list of other values to populate in the URL 
#' query string to further restrict the search
#' @return \code{character}; a complete URL (as a string) that has applied the 
#' proper escaping and formatting for the search specified by the function inputs.
#' @references \url{https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_search_parameterized.htm}
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
#' @param search_string \code{character}; a valid string for conducting a SOSL 
#' search.
#' @return \code{character}; a complete URL (as a string) that has applied the 
#' proper escaping and formatting for the search specified by the string.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_search_url <- function(search_string){
  paste0(make_base_rest_url(), "search/?q=", 
         url_escape(search_string, reserved = "{}"))
}

#' REST Objects URL Generator
#' 
#' @template object_name 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send REST API calls to regarding a specific object. This URL is also specific 
#' to your instance and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_rest_objects_url <- function(object_name){
  paste0(make_base_rest_url(), "sobjects/", object_name, "/")
}

#' REST Individual Record URL Generator
#' 
#' @template object_name
#' @template sf_id
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send REST API calls to regarding a specific record in an object. This URL is 
#' also specific to your instance and the API version being used.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_rest_record_url <- function(object_name, sf_id){
  paste0(make_base_rest_url(), "sobjects/", object_name, "/", sf_id)
}

#' Composite Batch URL Generator
#' 
#' @return \code{character}; a complete URL (as a string) that will be used to 
#' send composite batch REST API calls to. This URL is specific to your instance 
#' and the API version being used because it relies on the base REST URL.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_composite_batch_url <- function(){
  paste0(make_base_rest_url(), "composite/batch/")
}