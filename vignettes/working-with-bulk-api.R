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
library(salesforcer)
## I grab the token from the testing directory because that's where it is to be
## found on Travis
token_path <- file.path("..", "tests", "testthat", "salesforcer_token.rds")
suppressMessages(sf_auth(token = token_path, verbose = FALSE))

## ------------------------------------------------------------------------

suppressWarnings(suppressMessages(library(dplyr)))
library(salesforcer)
sf_auth()

n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
# REST
rest_created_records <- sf_create(new_contacts, "Contact", api_type="REST")
rest_created_records
# Bulk
bulk_created_records <- sf_create(new_contacts, "Contact", api_type="Bulk")
bulk_created_records

## ------------------------------------------------------------------------
# just add api_type="Bulk" to most calls!
# create bulk
object <- "Contact"
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object, api_type="Bulk")
created_records

# query bulk
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$successfulResults$sf__Id , collapse="','"))

queried_records <- sf_query(my_soql, object=object, api_type="Bulk")
queried_records

# delete bulk
deleted_records <- sf_delete(queried_records$Id, object=object, api_type="Bulk")
deleted_records

