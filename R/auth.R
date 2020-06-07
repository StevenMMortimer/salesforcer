# Adapted from googlesheets package https://github.com/jennybc/googlesheets

# Modifications:
#  - Changed the scopes and authentication endpoints
#  - Renamed the function gs_auth to sf_auth to be consistent with package 
#    and added basic authentication handling
#  - Added basic authentication session handling functions

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

# environment to store credentials
.state <- new.env(parent = emptyenv())

#' Log in to Salesforce
#' 
#' Log in using Basic (Username-Password) or OAuth 2.0 authenticaion. OAuth does
#' not require sharing passwords, but will require authorizing \code{salesforcer} 
#' as a connected app to view and manage your organization. You will be directed to 
#' a web browser, asked to sign in to your Salesforce account, and to grant \code{salesforcer} 
#' permission to operate on your behalf. By default, these user credentials are 
#' cached in a file named \code{.httr-oauth-salesforcer} in the current working directory.
#'
#' @importFrom httr content oauth2.0_token oauth_app oauth_endpoint
#' @importFrom xml2 xml_new_document xml_add_child xml_add_sibling xml_set_namespace xml_find_first xml_child
#' @param username Salesforce username, typically an email address
#' @param password Salesforce password
#' @param security_token Salesforce security token. Note: A new security token is 
#' generated whenever your password is changed.
#' @param login_url a custom login url; defaults to https://login.salesforce.com. If 
#' needing to log into a sandbox or dev environment then provide its login URL (e.g. 
#' https://test.salesforce.com)
#' @param token optional; an actual token object or the path to a valid token
#'   stored as an \code{.rds} file
#' @param consumer_key,consumer_secret,callback_url the "Consumer Key","Consumer Secret", 
#' and "Callback URL" when using a connected app; defaults to the \code{salesforcer} 
#' connected apps' consumer key, secret, and callback url
#' @param cache logical or character; TRUE means to cache using the default cache 
#' file \code{.httr-oauth-salesforcer}, FALSE means don't cache. A string means use 
#' the specified path as the cache file.
#' @template verbose
#' @examples
#' \dontrun{
#' # log in using basic authentication (username-password)
#' sf_auth(username = "test@gmail.com", 
#'         password = "test_password", 
#'         security_token = "test_token")
#' 
#' # log in using OAuth 2.0
#' # Via brower or refresh of .httr-oauth-salesforcer
#' sf_auth()
#' 
#' # log in to a Sandbox environment
#' # Via brower or refresh of .httr-oauth-salesforcer
#' sf_auth(login_url = "https://test.salesforce.com")
#' 
#' # Save token and log in using it
#' saveRDS(salesforcer_state()$token, "token.rds")
#' sf_auth(token = "token.rds")
#' }
#' @export
sf_auth <- function(username = NULL,
                    password = NULL,
                    security_token = NULL,
                    login_url = getOption("salesforcer.login_url"),
                    token = NULL,
                    consumer_key = getOption("salesforcer.consumer_key"),
                    consumer_secret = getOption("salesforcer.consumer_secret"),
                    callback_url = getOption("salesforcer.callback_url"),
                    cache = getOption("salesforcer.httr_oauth_cache"),
                    verbose = FALSE){
  
  if(!is.null(username) & !is.null(password) & !is.null(security_token)){
    
    # basic authentication (username-password) -------------------------------------
    body <- xml_new_document()
    
    # build the xml request for the SOAP API
    body %>%
      xml_add_child("Envelope",
                    "xmlns:soapenv" = "http://schemas.xmlsoap.org/soap/envelope/", 
                    "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
                    "xmlns:urn" = "urn:partner.soap.sforce.com") %>%
      xml_set_namespace("soapenv") %>%
      xml_add_child("Body") %>%
      xml_set_namespace("soapenv") %>%
      xml_add_child("login") %>% 
      xml_set_namespace("urn") %>%
      xml_add_child("username", username) %>%
      xml_add_sibling("password", paste0(password, security_token))

    # POST the data using httr package and handle response
    httr_response <- rPOST(url = make_login_url(login_url),
                           headers = c("SOAPAction"="login", "Content-Type"="text/xml"), 
                           body = as.character(body))
    catch_errors(httr_response)
    response_parsed <- content(httr_response, encoding='UTF-8')
    
    # parse the response information
    login_reponse <- response_parsed %>%
      xml_find_first('.//soapenv:Body') %>%
      xml_child() %>% 
      as_list()
    
    # set the global .state variable
    .state$auth_method <- "Basic"
    .state$token = NULL
    .state$session_id <- login_reponse$result$sessionId[[1]][1]
    .state$instance_url <- gsub('(https://[^/]+)/.*', '\\1', login_reponse$result$serverUrl)
  } else {
    
    # OAuth2.0 authentication
    if (is.null(token)) {
      
      sf_oauth_app <- oauth_app("salesforce",
                                key = consumer_key, 
                                secret = consumer_secret,
                                redirect_uri = callback_url)
      
      sf_oauth_endpoints <- oauth_endpoint(request = NULL,
                                           base_url = sprintf("%s/services/oauth2", login_url),
                                           authorize = "authorize", access = "token", revoke = "revoke")
      
      proxy <- build_proxy()
      if(!is.null(proxy)){
        sf_token <- oauth2.0_token(endpoint = sf_oauth_endpoints,
                                   app = sf_oauth_app, 
                                   cache = cache, 
                                   config_init = proxy)
      } else {
        sf_token <- oauth2.0_token(endpoint = sf_oauth_endpoints,
                                   app = sf_oauth_app, 
                                   cache = cache)
      }
  
      stopifnot(is_legit_token(sf_token, verbose = TRUE))
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- sf_token
      .state$session_id <- NULL
      .state$instance_url <- sf_token$credentials$instance_url
      
    } else if (inherits(token, "Token2.0")) {
      
      # accept token from environment ------------------------------------------------
      stopifnot(is_legit_token(token, verbose = TRUE))
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- token
      .state$session_id <- NULL
      .state$instance_url <- token$credentials$instance_url
      
    } else if (inherits(token, "character")) {
      
      # accept token from file -------------------------------------------------------
      sf_token <- try(suppressWarnings(readRDS(token)), silent = TRUE)
      
      if (inherits(sf_token, "try-error")) {
        stop(sprintf("Cannot read token from alleged .rds file:\n%s", token), call. = FALSE)
      } else if (!is_legit_token(sf_token, verbose = TRUE)) {
        stop(sprintf("File does not contain a proper token:\n%s", token), call. = FALSE)
      }
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- sf_token
      .state$session_id <- NULL
      .state$instance_url <- sf_token$credentials$instance_url
      
    } else {
      stop("Input provided via 'token' is neither a token",
           "\nnor a path to an .rds file containing a token.", call. = FALSE)
    }
  }
  
  invisible(list(auth_method=.state$auth_method, 
                 token=.state$token, 
                 session_id=.state$session_id,
                 instance_url=.state$instance_url))
}

#' Check that token appears to be legitimate
#'
#' @keywords internal
is_legit_token <- function(x, verbose = FALSE) {
  
  if (!inherits(x, "Token2.0")) {
    if (verbose) message("Not a Token2.0 object.")
    return(FALSE)
  }
  
  if ("invalid_client" %in% unlist(x$credentials)) {
    if (verbose) {
      message("Authorization error. Please check client_id and client_secret.")
    }
    return(FALSE)
  }
  
  if ("invalid_request" %in% unlist(x$credentials)) {
    if (verbose) message("Authorization error. No access token obtained.")
    return(FALSE)
  }
  
  TRUE
  
}

#' Check that an Authorized Salesforce Session Exists
#'
#' Before the user makes any calls requiring an authorized session, check if an 
#' OAuth token or session is not already available, call \code{\link{sf_auth}} to 
#' by default initiate the OAuth 2.0 workflow that will load a token from cache or 
#' launch browser flow. Return the bare token. Use
#' \code{access_token()} to reveal the actual access token, suitable for use
#' with \code{curl}.
#'
#' @template verbose
#' @return a \code{Token2.0} object (an S3 class provided by \code{httr}) or a 
#' a character string of the sessionId element of the current authorized 
#' API session
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_auth_check <- function(verbose = FALSE) {
  if (!token_available(verbose) & !session_id_available(verbose)) {
    # not auth'ed at all before a call that requires auth, so
    # start up the OAuth 2.0 workflow that should work seamlessly
    # if a cached file exists
    sf_auth(verbose = verbose)
    res <- .state$token
  } else if(token_available(verbose)) {
    issued_timestamp <- as.numeric(substr(.state$token$credentials$issued_at, 1, 10))
    nows_timestamp <- as.numeric(Sys.time())
    time_diff_in_sec <- nows_timestamp - issued_timestamp
    if(time_diff_in_sec > 3600){
      # the token is probably expired even though we have it so refresh
      # TODO: must be better way to validate the token.
      sf_auth_refresh(verbose = verbose)
    }
    res <- .state$token
  } else if(session_id_available(verbose)) {
    res <- .state$session_id
  } else {
    # somehow we've got a token and session id, just return the token
    res <- .state$token
  }
  invisible(res)
}

#' Refresh an existing Authorized Salesforce Token
#'
#' Force the current OAuth to refresh. This is only needed for times when you 
#' load the token from outside the current working directory, it is expired, and 
#' you're running in non-interactive mode.
#'
#' @template verbose
#' @return a \code{Token2.0} object (an S3 class provided by \code{httr}) or a 
#' a character string of the sessionId element of the current authorized 
#' API session
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_auth_refresh <- function(verbose = FALSE) {
  if(token_available(verbose)){
    .state$token <- .state$token$refresh()
  } else {
    message("No token found. sf_auth_refresh() only refreshes OAuth tokens")
  }
  invisible(.state$token)
}

#' Check session_id availability
#'
#' Check if a session_id is available in \code{\link{salesforcer}}'s internal
#' \code{.state} environment.
#'
#' @return logical
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
session_id_available <- function(verbose = TRUE) {
  if (is.null(.state$session_id)) {
    if (verbose) {
      message("The session_id is NULL in salesforcer's internal .state environment. ", 
              "This can occur if the user is authorized using OAuth 2.0, which doesn't ", 
              "require a session_id, or the user is not yet performed any authorization ", 
              "routine.\n",
              "When/if needed, 'salesforcer' will initiate authentication ",
              "and authorization.\nOr run sf_auth() to trigger this explicitly.")
    }
    return(FALSE)
  }
  TRUE
}

#' Check token availability
#'
#' Check if a token is available in \code{\link{salesforcer}}'s internal
#' \code{.state} environment.
#'
#' @return logical
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
token_available <- function(verbose = TRUE) {
  if (is.null(.state$token)) {
    if (verbose) {
      if (file.exists(".httr-oauth-salesforcer")) {
        message("A '.httr-oauth-salesforcer' file exists in current working ",
                "directory.\nWhen/if needed, the credentials cached in ",
                "'.httr-oauth-salesforcer' will be used for this session.\nOr run sf_auth() ",
                "for explicit authentication and authorization.")
      } else {
        message("No '.httr-oauth-salesforcer' file exists in current working directory.\n",
                "When/if needed, salesforcer will initiate authentication ",
                "and authorization.\nOr run sf_auth() to trigger this explicitly.")
      }
    }
    return(FALSE)
  }
  TRUE
}

#' Return access_token attribute of OAuth 2.0 Token
#'
#' @template verbose
#' @return character; a string of the access_token element of the current token in 
#' force; otherwise NULL
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_access_token <- function(verbose = FALSE) {
  if (!token_available(verbose = verbose)) return(NULL)
  .state$token$credentials$access_token
}

#' Return session_id resulting from Basic auth routine
#'
#' @template verbose
#' @return character; a string of the sessionId element of the current authorized 
#' API session; otherwise NULL
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_session_id <- function(verbose = TRUE) {
  if (!session_id_available(verbose = verbose)) return(NULL)
  .state$session_id
}