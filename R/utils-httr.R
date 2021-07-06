# Adapted from googlesheets package https://github.com/jennybc/googlesheets

# Modifications:
#  - Updated VERB_n to use the RETRY function from httr
#  - Added catch_errors() function
#  - Added build_proxy() function

# Copyright (c) 2017 Jennifer Bryan, Joanna Zhao
#   
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#   
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#' Generic implementation of HTTP methods with retries and authentication
#' 
#' @importFrom httr RETRY status_code config add_headers
#' @importFrom stats runif
#' @param verb string; The name of HTTP verb to execute
#' @return The last response. Note that if the request doesn't succeed after 
#' \code{times} then the request will fail and return the response.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
VERB_n <- function(verb) {
  function(url, headers=character(0), ...) {  
    current_state <- salesforcer_state()
      if(is.null(current_state$auth_method)){
        out <- RETRY(verb = verb, url = url, add_headers(headers), build_proxy(),...)
      } else if(current_state$auth_method == 'OAuth'){
        if(grepl("/services/data/v[0-9]{2}.[0-9]{1}/jobs/ingest", url)){
          out <- RETRY(verb = verb, url = url, add_headers(c(headers, "Authorization"=sprintf("Bearer %s", current_state$token$credentials$access_token))), build_proxy(), ...)  
        } else if(grepl("/services/async", url)){
          out <- RETRY(verb = verb, url = url, add_headers(c(headers, "X-SFDC-Session"=current_state$token$credentials$access_token)), build_proxy(), ...)  
        } else {
          out <- RETRY(verb = verb, url = url, config=config(token=current_state$token), add_headers(headers), build_proxy(), ...)  
        }
      } else if (current_state$auth_method == 'Basic') {
        if(grepl("/services/async", url)){
          out <- RETRY(verb = verb, url = url, add_headers(c(headers, "X-SFDC-Session"=current_state$session_id)), build_proxy(), ...)
        } else {
          out <- RETRY(verb = verb, url = url, add_headers(c(headers, "Authorization"=sprintf("Bearer %s", current_state$session_id))), build_proxy(), ...)  
        }
      }
    return(out)
  }
}

#' GETs with retries and authentication
#' 
#' @importFrom httr GET
#' @return A \code{response()} object as defined by the \code{httr} package.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rGET <- VERB_n("GET")

#' POSTs with retries and authentication
#' 
#' @importFrom httr POST
#' @return A \code{response()} object as defined by the \code{httr} package.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPOST <- VERB_n("POST")

#' PATCHs with retries and authentication
#' 
#' @importFrom httr PATCH
#' @return A \code{response()} object as defined by the \code{httr} package.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPATCH <- VERB_n("PATCH")

#' PUTs with retries and authentication
#' 
#' @importFrom httr PUT
#' @return A \code{response()} object as defined by the \code{httr} package.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPUT <- VERB_n("PUT")

#' DELETEs with retries and authentication
#' 
#' @importFrom httr DELETE
#' @return A \code{response()} object as defined by the \code{httr} package.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rDELETE <- VERB_n("DELETE")

#' Function to parse out the message and status code of an HTTP error
#' 
#' Assuming the error code is less than 500, this function will return the 
#' 
#' @param x \code{response()}; a response that indicates an error
#' @return \code{list}; a list containing the error code and message for printing.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
parse_error_code_and_message <- function(x){
  
  if(!is.null(x$exceptionCode)){
    error_code <- x$exceptionCode
    error_message <- x$exceptionMessage
  } else if(!is.null(x$error$exceptionCode)){
    error_code <- x$error$exceptionCode
    error_message <- x$error$exceptionMessage
  } else if(!is.null(x[[1]]$Error$errorCode[[1]])){
    error_code <- x[[1]]$Error$errorCode[[1]]
    error_message <- x[[1]]$Error$message[[1]]
  } else {
    error_code <- x[[1]]$errorCode 
    error_message <- x[[1]]$message
  }
  
  return(
    list(errorCode = error_code, 
         message = error_message)
  )
}

#' Function to catch and print HTTP errors
#'
#' @importFrom httr content http_error
#' @importFrom xml2 as_list xml_find_first
#' @param x \code{response()}; a response from an HTTP request
#' @return \code{logical}; return \code{FALSE} if the function finishes without 
#' detecting an error, otherwise stop the function call. 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
catch_errors <- function(x){
  if(http_error(x)){
    response_parsed <- content(x, encoding='UTF-8')
    # convert to list if xml content type
    content_type <- x$headers$`content-type`
    if(grepl('xml', content_type)){
      response_parsed <- as_list(response_parsed)
    }
    if(status_code(x) < 500){
      parsed_error <- parse_error_code_and_message(response_parsed)
      stop(sprintf("%s: %s", 
                   parsed_error$errorCode, 
                   parsed_error$message), 
           call. = FALSE)
    } else {
      error_message <- response_parsed$Envelope$Body$Fault
      stop(error_message$faultstring[[1]][1])
    }
  }
  invisible(FALSE)
}

#' Execute a non-paginated REST API call to list items
#' 
#' @importFrom purrr map_df
#' @importFrom dplyr as_tibble tibble
#' @importFrom readr col_guess type_convert
#' @importFrom httr content
#' @param url \code{character}; a valid REST API URL (as a string)
#' @template as_tbl
#' @param records_root \code{character} or \code{integer}; an index or string that 
#' identifies the element in the parsed list which contains the records returned 
#' by the API call. By default, this argument is \code{NULL}, which means that 
#' each element in the list is an individual record.
#' @template verbose
#' @return \code{tbl_df} or \code{list} of data depending on what was requested.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_rest_list <- function(url, 
                         as_tbl=FALSE, 
                         records_root=NULL,
                         verbose=FALSE){
  httr_response <- rGET(url = url)
  if(verbose){
    make_verbose_httr_message(httr_response$request$method, 
                              httr_response$request$url, 
                              httr_response$request$headers)
  }
  catch_errors(httr_response)
  response_parsed <- content(httr_response, as="parsed", encoding="UTF-8")
  
  if(as_tbl){
    if(is.null(records_root)){
      records_list <- response_parsed
    } else {
      records_list <- response_parsed[[records_root]]  
    }
    if(length(records_list) > 0){
      response_parsed <- records_list %>% 
        map_df(as_tibble) %>%
        type_convert(col_types = cols(.default = col_guess()))
    } else {
      response_parsed <- tibble()
    }
  }
  return(response_parsed)
}

#' Function to build a proxy object to pass along with httr requests
#'
#' @importFrom httr use_proxy
#' @return an \code{httr} proxy object
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
build_proxy <- function(){
  proxy <- NULL
  if (getOption("salesforcer.proxy_url") != ""){
    proxy <- use_proxy(url = getOption("salesforcer.proxy_url"),
                       port = as.integer(getOption("salesforcer.proxy_port")),
                       username = getOption("salesforcer.proxy_username"),
                       password = getOption("salesforcer.proxy_password"),
                       auth = getOption("salesforcer.proxy_auth"))
  }
  return(proxy)
}
