#' Determine the host operating system
#' 
#' This function determines whether the system running the R code
#' is Windows, Mac, or Linux
#'
#' @return A character string
#' @examples
#' \dontrun{
#' get_os()
#' }
#' @seealso \url{http://conjugateprior.org/2015/06/identifying-the-os-from-r}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin'){
      os <- "osx"
    }
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os)){
      os <- "osx"
    }
    if (grepl("linux-gnu", R.version$os)){
      os <- "linux"
    }
  }
  unname(tolower(os))
}

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
        stop(sprintf("%s: %s", response_parsed$exceptionCode, response_parsed$exceptionMessage))
      } else if(!is.null(response_parsed$error$exceptionCode)){
        stop(sprintf("%s: %s", response_parsed$error$exceptionCode, response_parsed$error$exceptionMessage))
      } else if(!is.null(response_parsed[[1]]$Error$errorCode[[1]])){
        stop(sprintf("%s: %s", response_parsed[[1]]$Error$errorCode[[1]], response_parsed[[1]]$Error$message[[1]]))
      }  else {
        stop(sprintf("%s: %s", response_parsed[[1]]$errorCode, response_parsed[[1]]$message))  
      }
    } else {
      error_message <- response_parsed %>%
        xml_find_first('.//soapenv:Fault') %>%
        as_list()
      stop(error_message$faultstring[[1]][1])
    }
  }
  invisible(FALSE)
}

#' Generic implementation of HTTP methods with retries and authentication
#' 
#' @importFrom httr status_code config add_headers
#' @importFrom stats runif
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
VERB_n <- function(VERB, n = 5) {
  function(url, headers=character(0), ...) {
    
    if(length(url) == 0) stop("User not authenticated. Log in using sf_auth()")
    
    current_state <- salesforcer_state()
    for (i in seq_len(n)) {
      
      if(is.null(current_state$auth_method)){
        out <- VERB(url = url, add_headers(headers), ...)
      }
      else if(current_state$auth_method=='OAuth'){
        if(grepl("/services/data/v[0-9]{2}.[0-9]{1}/jobs/ingest", url)){
          out <- VERB(url = url, add_headers(c(headers, "Authorization"=sprintf("Bearer %s", current_state$token$credentials$access_token))), ...)  
        } else if(grepl("/services/async", url)){
          out <- VERB(url = url, add_headers(c(headers, "X-SFDC-Session"=current_state$token$credentials$access_token)), ...)  
        } else {
          out <- VERB(url = url, config=config(token=current_state$token), add_headers(headers), ...)  
        }
      } else if (current_state$auth_method=='Basic') {
        out <- VERB(url = url, add_headers(c(headers, "Authorization"=sprintf("Bearer %s", current_state$session_id))), ...)
      }
      
      status <- status_code(out)
      if (status < 500 || i == n) break
      backoff <- runif(n = 1, min = 0, max = 2 ^ i - 1)
      ## TO DO: honor a verbose argument or option
      mess <- paste("HTTP error %s on attempt %d ...\n",
                    "  backing off %0.2f seconds, retrying")
      mpf(mess, status, i, backoff)
      Sys.sleep(backoff)
    }
    out
  }
}

#' GETs with retries and authentication
#' 
#' @importFrom httr GET
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rGET <- VERB_n(GET)

#' POSTs with retries and authentication
#' 
#' @importFrom httr POST
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPOST <- VERB_n(POST)

#' PATCHs with retries and authentication
#' 
#' @importFrom httr PATCH
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPATCH <- VERB_n(PATCH)

#' PUTs with retries and authentication
#' 
#' @importFrom httr PUT
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rPUT <- VERB_n(PUT)

#' DELETEs with retries and authentication
#' 
#' @importFrom httr DELETE
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
rDELETE <- VERB_n(DELETE)

## good news: these are handy and call. = FALSE is built-in
##  bad news: 'fmt' must be exactly 1 string, i.e. you've got to paste, iff
##             you're counting on sprintf() substitution
cpf <- function(...) cat(paste0(sprintf(...), "\n"))
mpf <- function(...) message(sprintf(...))
wpf <- function(...) warning(sprintf(...), call. = FALSE)
spf <- function(...) stop(sprintf(...), call. = FALSE)

#' Return the package's .state environment variable
#' 
#' @export
salesforcer_state <- function(){
  .state
}

#' Write a CSV file in format acceptable to Salesforce APIs
#' 
#' @importFrom readr write_csv
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_write_csv <- function(x, path){
  write_csv(x=x, path=path, na="#N/A")
}
