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
token_path <- Sys.getenv("SALESFORCER_TOKEN_PATH")
sf_auth(token = paste0(token_path, "salesforcer_token.rds"))

## ----load-package, eval=FALSE-------------------------------------------------
#  library(salesforcer)
#  sf_auth()

## ----sample-create------------------------------------------------------------
new_contact <- c(FirstName = "Jenny", 
                 LastName = "Williams", 
                 Email = "jennyw@gmail.com")
record1 <- sf_create(new_contact,
                     object_name = "Contact",
                     DisableFeedTrackingHeader = list(disableFeedTracking = TRUE))
record1

## ----sample-create-w-duplicate------------------------------------------------
# override the duplicate rules ...
record2 <- sf_create(new_contact,
                     object_name = "Contact",
                     DuplicateRuleHeader = list(allowSave = TRUE, 
                                                includeRecordDetails = FALSE, 
                                                runAsCurrentUser = TRUE))
record2

# ... or succumb to the duplicate rules
record3 <- sf_create(new_contact,
                     object_name = "Contact",
                     DuplicateRuleHeader = list(allowSave = FALSE, 
                                                includeRecordDetails = FALSE, 
                                                runAsCurrentUser = TRUE))
record3

## ----sample-create-w-warning--------------------------------------------------
record4 <- sf_create(new_contact,
                     object_name = "Contact",
                     DuplicateRuleHeader = list(allowSave = FALSE, 
                                                includeRecordDetails = FALSE, 
                                                runAsCurrentUser = TRUE),
                     api_type = "REST")
record4

## ---- include = FALSE---------------------------------------------------------
deleted_records <- sf_delete(c(record1$id, record2$id))

## ----sample-query-------------------------------------------------------------
sf_query("SELECT Id, Name FROM Account LIMIT 1000",
         object_name = "Account",
         control = sf_control(QueryOptions = list(batchSize = 200)))

