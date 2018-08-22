## ---- echo = FALSE-------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ----auth, include = FALSE-----------------------------------------------
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(here)))
library(salesforcer)
options_path <- here::here("tests", "testthat", "salesforcer_test_settings.rds")
salesforcer_test_settings <- readRDS(options_path)
username <- salesforcer_test_settings$username
password <- salesforcer_test_settings$password
security_token <- salesforcer_test_settings$security_token

## ---- warning=FALSE------------------------------------------------------
# the RForcecom way
session1 <- RForcecom::rforcecom.login(username, paste0(password, security_token), 
                                       apiVersion=getOption("salesforcer.api_version"))
session1['sessionID'] <- "{MASKED}"
session1

# replicated in salesforcer package
session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token), 
                                         apiVersion=getOption("salesforcer.api_version"))
session2['sessionID'] <- "{MASKED}"
session2

## ---- include=FALSE------------------------------------------------------
# keep using the session, just rename it to "session"
session <- salesforcer::rforcecom.login(username, paste0(password, security_token), 
                                         apiVersion=getOption("salesforcer.api_version"))

## ---- warning=FALSE------------------------------------------------------
object <- "Contact"
fields <- c(FirstName="Test", LastName="Contact-Create-Compatibility")

# the RForcecom way
result1 <- RForcecom::rforcecom.create(session, objectName=object, fields)
result1

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
result2

## ---- warning=FALSE------------------------------------------------------
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))

# the RForcecom way
rforcecom_results <- NULL
for(i in 1:nrow(new_contacts)){
  temp <- RForcecom::rforcecom.create(session, 
                                      objectName = "Contact", 
                                      fields = unlist(slice(new_contacts,i)))
  rforcecom_results <- bind_rows(rforcecom_results, temp)
}
rforcecom_results

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_create(new_contacts, object_name="Contact")
salesforcer_results

## ---- warning=FALSE------------------------------------------------------
this_soql <- "SELECT Id, Email FROM Contact LIMIT 5"

# the RForcecom way
result1 <- RForcecom::rforcecom.query(session, soqlQuery = this_soql)
result1

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.query(session, soqlQuery = this_soql)
result2

# the better way in salesforcer to query
salesforcer_results <- sf_query(this_soql)
salesforcer_results

## ---- warning=FALSE------------------------------------------------------
# the RForcecom way
result1 <- RForcecom::rforcecom.getObjectDescription(session, objectName='Account')

# backwards compatible in the salesforcer package
result2 <- salesforcer::rforcecom.getObjectDescription(session, objectName='Account')

# the better way in salesforcer to get object fields
result3 <- salesforcer::sf_describe_object_fields('Account')
result3

