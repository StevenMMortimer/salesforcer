## ---- echo = FALSE-------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)

## ----auth, include = FALSE-----------------------------------------------
library(salesforcer)
token_path <- here::here("tests", "testthat", "salesforcer_token.rds")
suppressMessages(sf_auth(token = token_path, verbose = FALSE))

## ----sample-create-------------------------------------------------------
new_contact <- c(FirstName = "Test", LastName = "Contact-Create")
record <- sf_create(new_contact,
                    object_name = "Contact",
                    DisableFeedTrackingHeader = list(disableFeedTracking = TRUE), 
                    api_type = "SOAP")

## ---- include = FALSE----------------------------------------------------
deleted_records <- sf_delete(record$id)

## ----sample-create-w-duplicate-------------------------------------------
new_contact <- c(FirstName = "Test", LastName = "Contact-Create")
record <- sf_create(new_contact,
                    object_name = "Contact",
                    DuplicateRuleHeader = list(allowSave = TRUE, 
                                               includeRecordDetails = FALSE, 
                                               runAsCurrentUser = TRUE))

## ---- include = FALSE----------------------------------------------------
deleted_records <- sf_delete(record$id)

## ----sample-create-w-warning---------------------------------------------
new_contact <- c(FirstName = "Test", LastName = "Contact-Create")
record <- sf_create(new_contact,
                    object_name = "Contact",
                    BatchRetryHeader = list(`Sforce-Disable-Batch-Retry` = FALSE), 
                    api_type = "SOAP")

## ---- include = FALSE----------------------------------------------------
deleted_records <- sf_delete(record$id)

## ----sample-query--------------------------------------------------------
new_contact <- c(FirstName = "Test", LastName = "Contact-Create")
records <- sf_query("SELECT Id, Name FROM Account LIMIT 1000",
                    object_name = "Account",
                    control = sf_control(QueryOptions = list(batchSize = 100)), 
                    api_type = "SOAP")

