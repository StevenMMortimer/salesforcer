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
#' @param verb string; The name of HTTP verb to execute
#' @importFrom httr RETRY status_code config add_headers
#' @importFrom stats runif
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
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rGET <- VERB_n("GET")

#' POSTs with retries and authentication
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPOST <- VERB_n("POST")

#' PATCHs with retries and authentication
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPATCH <- VERB_n("PATCH")

#' PUTs with retries and authentication
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPUT <- VERB_n("PUT")

#' DELETEs with retries and authentication
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rDELETE <- VERB_n("DELETE")

#' Function to catch and print HTTP errors
#'
#' @importFrom httr content http_error
#' @importFrom xml2 as_list xml_find_first
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
      if(!is.null(response_parsed$exceptionCode)){
        stop(sprintf("%s: %s", 
                     response_parsed$exceptionCode, 
                     response_parsed$exceptionMessage), 
             call. = FALSE)
      } else if(!is.null(response_parsed$error$exceptionCode)){
        stop(sprintf("%s: %s", 
                     response_parsed$error$exceptionCode, 
                     response_parsed$error$exceptionMessage), 
             call. = FALSE)
      } else if(!is.null(response_parsed[[1]]$Error$errorCode[[1]])){
        stop(sprintf("%s: %s", 
                     response_parsed[[1]]$Error$errorCode[[1]], 
                     response_parsed[[1]]$Error$message[[1]]), 
             call. = FALSE)
      }  else {
        stop(sprintf("%s: %s", 
                     response_parsed[[1]]$errorCode, 
                     response_parsed[[1]]$message), 
             call. = FALSE)
      }
    } else {
      error_message <- response_parsed$Envelope$Body$Fault
      stop(error_message$faultstring[[1]][1])
    }
  }
  invisible(FALSE)
}

#' Function to build a proxy object to pass along with httr requests
#'
#' @importFrom httr use_proxy
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
