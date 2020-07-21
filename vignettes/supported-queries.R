## ---- echo = FALSE------------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
options(tibble.print_min = 5L, tibble.print_max = 5L)

## ----auth, include = FALSE----------------------------------------------------
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(here)))
library(salesforcer)

username <- Sys.getenv("SALESFORCER_USERNAME")
password <- Sys.getenv("SALESFORCER_PASSWORD")
security_token <- Sys.getenv("SALESFORCER_SECURITY_TOKEN")

sf_auth(username = username,
        password = password,
        security_token = security_token)

## ----load-package, eval=FALSE-------------------------------------------------
#  library(dplyr, warn.conflicts = FALSE)
#  library(salesforcer)
#  sf_auth()

## ----query-records------------------------------------------------------------
soql <- "SELECT Id,
                FirstName, 
                LastName
         FROM Contact
         LIMIT 10"

queried_records <- sf_query(soql) # REST API is the default api_type
queried_records

queried_records <- sf_query(soql, api_type = "SOAP")
queried_records

## ----setup-performance-test---------------------------------------------------
# create a new account 
# (if replicating, you may or may not have an external id field in your Org)
prefix <- paste0("APerfTest-", as.integer(runif(1,1,99999)))
new_account <- sf_create(
  tibble(
    Name = "Test Account For Performance Test", 
    My_External_Id__c = prefix,
    Description = paste0("This is a test account with 1,000 records for ", 
                         "testing the performance differences between the ", 
                         "SOAP and REST APIs.")
  ), 
  object_name = "Account"
)

# create and associate a thousand new contacts with that account
# (again, you may or may not have an external id field in your Org)
n <- 1000
prefix <- paste0("CPerfTest-", as.integer(runif(1,1,99999)), "-")
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Query-Vignette", 1:n), 
                       test_number__c = 999.9,
                       AccountId = rep(new_account$id, n),
                       My_External_Id__c=paste0(prefix, 1:n))
new_contacts_res <- sf_create(new_contacts, "Contact", api_type = "Bulk 2.0")

## ----run-performance-test, message=FALSE--------------------------------------
qry <- function(api_type){
  sf_query(
    sprintf("SELECT Id, Name, Owner.Id, 
               (SELECT Id, LastName, Owner.Id FROM Contacts) 
            FROM Account
            WHERE Id = '%s'", 
            new_account$id), 
    api_type = api_type
  )
}
res <- microbenchmark::microbenchmark(
  qry("REST"),
  qry("SOAP"),
  times = 5
)
res

ggplot2::autoplot(res) + 
  ggplot2::scale_y_continuous(name="Time [seconds]", n.breaks=6)

