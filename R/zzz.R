.onLoad <- function(libname, pkgname) {
  
  op <- options()
  op.salesforcer <- list(
    salesforcer.api_version = "54.0",
    salesforcer.login_url = "https://login.salesforce.com",
    salesforcer.proxy_url = "",
    salesforcer.proxy_port = NULL,
    salesforcer.proxy_username = NULL,
    salesforcer.proxy_password = NULL,
    salesforcer.proxy_auth = "basic",
    salesforcer.consumer_key = "3MVG9CEn_O3jvv0yRMQezJ8PwesiIknRU9v9j778rv78UvJ2JTQzSG.QduxyMxYaldoNEhO0eVvw4ogCT58c5",
    salesforcer.consumer_secret = "3471656211653393546",
    salesforcer.callback_url = "http://localhost:1410/",
    salesforcer.httr_oauth_cache = ".httr-oauth-salesforcer"
  )
  toset <- !(names(op.salesforcer) %in% names(op))
  if(any(toset)) options(op.salesforcer[toset])
  
  invisible()
  
}

# store state variables in the '.state' internal environment (created in sf_auth.R)
.state$auth_method <- NULL
.state$token <- NULL
.state$session_id <- NULL
.state$instance_url <- NULL
