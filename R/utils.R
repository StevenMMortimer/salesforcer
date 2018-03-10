
#' @importFrom httr status_code content
#' @importFrom xml2 as_list xml_find_first
#' @keywords internal
catch_errors <- function(x){
  if(status_code(x) != 200){
    response_parsed <- content(x, encoding='UTF-8')
    if(status_code(x) < 500){
      stop(sprintf("%s: %s", response_parsed[[1]]$errorCode, response_parsed[[1]]$message))
    } else {
      # if xml vs. json????
      error_message <- response_parsed %>%
        xml_find_first('.//soapenv:Fault') %>%
        as_list()
      stop(error_message$faultstring[[1]][1])
    }
  }
  invisible(FALSE)
}

#' @importFrom httr status_code config add_headers
#' @importFrom stats runif
#' @keywords internal
VERB_n <- function(VERB, n = 5) {
  function(url, headers=character(0), ...) {
    
    if(length(url) == 0) stop("User not authenticated. Log in using sf_auth()")
    
    for (i in seq_len(n)) {
      
      if(is.null(.state$auth_method)){
        out <- VERB(url = url, add_headers(headers), ...)
      }
      else if(.state$auth_method=='OAuth'){
        out <- VERB(url = url, config=config(token=.state$token), add_headers(headers), ...)
      } else if (.state$auth_method=='Basic') {
        out <- VERB(url = url, add_headers(c(headers, "Authorization"=paste("Bearer", .state$session_id))), ...)
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

#' @importFrom httr GET
#' @keywords internal
rGET <- VERB_n(GET)
#' @importFrom httr POST
#' @keywords internal
rPOST <- VERB_n(POST)

## good news: these are handy and call. = FALSE is built-in
##  bad news: 'fmt' must be exactly 1 string, i.e. you've got to paste, iff
##             you're counting on sprintf() substitution
cpf <- function(...) cat(paste0(sprintf(...), "\n"))
mpf <- function(...) message(sprintf(...))
wpf <- function(...) warning(sprintf(...), call. = FALSE)
spf <- function(...) stop(sprintf(...), call. = FALSE)
