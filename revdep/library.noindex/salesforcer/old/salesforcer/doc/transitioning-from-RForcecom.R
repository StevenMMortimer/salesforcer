## ---- echo = FALSE------------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
options(tibble.print_min = 5L, tibble.print_max = 5L)

## ----auth-background, include = FALSE-----------------------------------------
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(here)))
library(salesforcer)
token_path <- Sys.getenv("SALESFORCER_TOKEN_PATH")
sf_auth(token = paste0(token_path, "salesforcer_token.rds"))

## ----load-package, eval=FALSE-------------------------------------------------
#  library(salesforcer)
#  sf_auth()

## ---- warning=FALSE, eval=FALSE-----------------------------------------------
#  
#  # Beginning February 1, 2022, basic authentication will no longer work. You must
#  # log in to Salesforce using MFA (generating an OAuth 2.0 token typically from
#  # the browser).
#  
#  # the RForcecom way
#  # RForcecom::rforcecom.login(username, paste0(password, security_token),
#  #                            apiVersion=getOption("salesforcer.api_version"))
#  # replicated in salesforcer package
#  session <- salesforcer::rforcecom.login(username,
#                                           paste0(password, security_token),
#                                           apiVersion = getOption("salesforcer.api_version"))
#  session['sessionID'] <- "{MASKED}"
#  session

## ---- warning=FALSE-----------------------------------------------------------
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))

# the RForcecom way (requires a loop)
# rforcecom_results <- NULL
# for(i in 1:nrow(new_contacts)){
#   temp <- RForcecom::rforcecom.create(session, 
#                                       objectName = "Contact", 
#                                       fields = unlist(slice(new_contacts,i)))
#   rforcecom_results <- bind_rows(rforcecom_results, temp)
# }

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_create(new_contacts, object_name="Contact")
salesforcer_results

## ---- warning=FALSE-----------------------------------------------------------
this_soql <- "SELECT Id, Email FROM Contact LIMIT 5"

# the RForcecom way
# RForcecom::rforcecom.query(session, soqlQuery = this_soql)

# the better way in salesforcer to query
salesforcer_results <- sf_query(this_soql)
salesforcer_results

## ---- warning=FALSE-----------------------------------------------------------
# the RForcecom way
# RForcecom::rforcecom.getObjectDescription(session, objectName='Account')

# the better way in salesforcer to get object fields
result2 <- salesforcer::sf_describe_object_fields('Account')
result2

