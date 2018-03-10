# environment to store credentials
.state <- new.env(parent = emptyenv())

#' Log in to Salesforce
#' 
#' Log in using Basic (Username-Password) or OAuth 2.0 authenticaion. OAuth does
#' not require sharing passwords, but will require authorizing \code{salesforcer} 
#' as a connected app to view and manage your organization. You will be directed to 
#' a web browser, asked to sign in to your Salesforce account, and to grant \code{salesforcer} 
#' permission to operate on your behalf. By default, these user credentials are 
#' cached in a file named .httr-oauth in the current working directory.
#'
#' @importFrom httr content oauth2.0_token oauth_app oauth_endpoint
#' @importFrom xml2 xml_new_document xml_add_child xml_add_sibling xml_set_namespace xml_find_first xml_child
#' @param username Salesforce username, typically an email address
#' @param password Salesforce password
#' @param security_token Salesforce security token. Note: A new security token is 
#' generated whenever your password is changed.
#' @param login_url a custom login url; defaults to https://login.salesforce.com
#' @param token optional; an actual token object or the path to a valid token
#'   stored as an \code{.rds} file
#' @param consumer_key,consumer_secret,callback_url the "Consumer Key","Consumer Secret", 
#' and "Callback URL" when using a connected app; defaults to the \code{salesforcer} 
#' connected apps' consumer key, secret, and callback url
#' @param cache logical indicating if \code{salesforcer} should cache
#'   credentials in the default cache file \code{.httr-oauth}
#' @template verbose
#' @examples
#' \dontrun{
#' # log in using basic authentication (username-password)
#' sf_auth(username = "test@gmail.com", 
#'         password = "test_password", 
#'         security_token = )
#' 
#' # log in using OAuth 2.0
#' # Via brower or refresh of .httr-oauth
#' sf_auth()
#' 
#' # Save token and log in using it
#' saveRDS(.state$token, "token.rds")
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
    httr_response <- rPOST(url = sprintf('%s/services/Soap/u/%s', login_url, getOption("salesforcer.api_version")),
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
    .state$session_id <- login_reponse$result$sessionId
    .state$instance_url <- gsub('(https://[^/]+)/.*', '\\1', login_reponse$result$serverUrl)
  } else {
    
    # OAuth2.0 authentication
    if (is.null(token)) {
      
      sf_oauth_app <- oauth_app("salesforce",
                                key = consumer_key, 
                                secret = consumer_secret,
                                redirect_uri = callback_url)
      
      sf_oauth_endpoints <- oauth_endpoint(request = NULL,
                                           base_url = "https://login.salesforce.com/services/oauth2",
                                           authorize = "authorize", access = "token", revoke = "revoke")
      
      sf_token <- oauth2.0_token(sf_oauth_endpoints,
                                 sf_oauth_app)
  
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
      .state$instance_url <- sf_token$credentials$instance_url
      
    } else if (inherits(token, "character")) {
      
      # accept token from file -------------------------------------------------------
      sf_token <- try(suppressWarnings(readRDS(token)), silent = TRUE)
      
      if (inherits(sf_token, "try-error")) {
        spf("Cannot read token from alleged .rds file:\n%s", token)
      } else if (!is_legit_token(sf_token, verbose = TRUE)) {
        spf("File does not contain a proper token:\n%s", token)
      }
      
      # set the global .state variable
      .state$auth_method <- "OAuth"
      .state$token <- sf_token
      .state$session_id <- NULL
      .state$instance_url <- sf_token$credentials$instance_url
      
    } else {
      spf("Input provided via 'token' is neither a",
          "token,\nnor a path to an .rds file containing a token.")
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
