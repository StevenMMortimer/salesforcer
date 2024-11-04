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
#  library(dplyr, warn.conflicts = FALSE)
#  library(salesforcer)
#  sf_auth()

## -----------------------------------------------------------------------------
n <- 4
prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n),
                       My_External_Id__c=paste0(prefix, letters[1:n]))

## -----------------------------------------------------------------------------
# REST
rest_created_records <- sf_create(new_contacts[1:2,], 
                                  object_name="Contact", 
                                  api_type="REST")
rest_created_records

# Bulk
bulk_created_records <- sf_create(new_contacts[3:4,], 
                                  object_name="Contact", 
                                  api_type="Bulk 1.0")
bulk_created_records

## ---- include=FALSE-----------------------------------------------------------
n <- 2
prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n),
                       My_External_Id__c=paste0(prefix, letters[1:n]))

## -----------------------------------------------------------------------------
object <- "Contact"
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

## -----------------------------------------------------------------------------
n <- 20
prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n),
                       test_number__c = 1:n,
                       My_External_Id__c=paste0(prefix, letters[1:n]))

created_records_v1 <- sf_create(new_contacts[1:10,], 
                                object_name = "Contact", 
                                api_type = "Bulk 1.0")
created_records_v1

created_records_v2 <- sf_create(new_contacts[11:20,],
                                object_name = "Contact", 
                                api_type = "Bulk 2.0")
created_records_v2

## ---- warning=FALSE, message=FALSE--------------------------------------------
soql <- "SELECT Id, Name FROM Contact"
bulk1_query <- function(){sf_query(soql, "Contact", api_type="Bulk 1.0")}
bulk2_query <- function(){sf_query(soql, api_type="Bulk 2.0")} # Bulk 2.0 doesn't need object name

res <- microbenchmark::microbenchmark(
  bulk1_query(),
  bulk2_query(), 
  times=8, 
  unit = "s"
)
res

suppressWarnings(suppressMessages(
  ggplot2::autoplot(res) + 
    ggplot2::scale_y_continuous(name="Time [seconds]", n.breaks=6)
))

## ---- include=FALSE-----------------------------------------------------------
sf_delete(c(created_records_v1$Id, created_records_v2$sf__Id), 
          object_name = "Contact", api_type="Bulk 2.0")

