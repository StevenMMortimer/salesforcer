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
token_path <- here::here("tests", "testthat", "salesforcer_token.rds")
suppressMessages(sf_auth(token = token_path, verbose = FALSE))

## ----load-package, eval=FALSE--------------------------------------------
#  suppressWarnings(suppressMessages(library(dplyr)))
#  library(salesforcer)
#  sf_auth()

## ------------------------------------------------------------------------
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
# REST
rest_created_records <- sf_create(new_contacts, object_name="Contact", api_type="REST")
rest_created_records
# Bulk
bulk_created_records <- sf_create(new_contacts, object_name="Contact", api_type="Bulk 1.0")
bulk_created_records

## ------------------------------------------------------------------------
# just add api_type="Bulk 1.0" or api_type="Bulk 2.0" to most calls!
# create bulk
object <- "Contact"
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object_name=object, api_type="Bulk 1.0")
created_records

# query bulk
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$Id , collapse="','"))

queried_records <- sf_query(my_soql, object_name=object, api_type="Bulk 1.0")
queried_records

# delete bulk
deleted_records <- sf_delete(queried_records$Id, object_name=object, api_type="Bulk 1.0")
deleted_records

