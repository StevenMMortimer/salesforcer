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
  times = 5, 
  unit = "s"
)
res

suppressWarnings(suppressMessages(
  ggplot2::autoplot(res) + 
    ggplot2::scale_y_continuous(name="Time [seconds]", n.breaks=6)
))

## ----unsupported-bulk-queries-------------------------------------------------
# nested relationship query 
# (supposed to return the id and first name of all contacts on each account)
try(
  sf_query(
    "SELECT Id, Name, 
      (SELECT Id, FirstName FROM Contacts)
    FROM Account",
    api_type = "Bulk 2.0"
  )
)

# aggregate query
# (supposed to return the count of contacts per account)
try(
  sf_query(
    "SELECT Account.Id, Count(Name) contacts_n
    FROM Contact
    GROUP BY Account.Id",  
    api_type = "Bulk 2.0"
  )
)

## -----------------------------------------------------------------------------
contacts <- sf_query("SELECT Id, FirstName, Account.Id
                     FROM Contact", 
                     api_type = "Bulk 2.0")

accounts <- sf_query("SELECT Id, Name 
                     FROM Account", 
                     api_type = "Bulk 2.0")

nested_query_recs <- accounts %>% 
  left_join(contacts %>% 
              rename(`Contact.Id` = Id, 
                     `Contact.FirstName` = FirstName), 
            by = c("Id" = "Account.Id"))
nested_query_recs

aggregate_query_recs <- nested_query_recs %>% 
  group_by(Id) %>%
  summarize(.groups = 'drop', 
            contacts_n = sum(!is.na(Contact.Id)))
aggregate_query_recs

## ----run-performance-test2, eval=FALSE----------------------------------------
#  qry_compare <- function(api_type){
#    soql <- sprintf("SELECT Id, LastName, Account.Id, Account.Name, Owner.Id
#                     FROM Contact
#                     WHERE Account.Id = '%s'",
#                     new_account$id)
#    sf_query(soql, api_type = api_type)
#  }
#  
#  res <- microbenchmark::microbenchmark(
#    qry_compare("REST"),
#    qry_compare("Bulk 1.0"),
#    qry_compare("Bulk 2.0"),
#    times = 5,
#    unit = "s"
#  )

## -----------------------------------------------------------------------------
queried_records <- sf_query(soql, api_type = "Bulk 1.0")

## ----cleanup-performance-test-------------------------------------------------
# cleanup performance test Contact records ...
contacts_to_delete <- sf_query(
  sprintf("SELECT Id 
          FROM Contact 
          WHERE Account.Id = '%s'",
          new_account$id)
)
sf_delete(contacts_to_delete$Id, "Contact", api_type="Bulk 2.0")

# ... and finally delete the account
sf_delete(new_account$id)

## -----------------------------------------------------------------------------
# child-to-parent relationship (e.g. Account.Name from Contact record)
sf_query(
  "SELECT Id, FirstName, Account.Name
  FROM Contact
  WHERE Account.Id != null"
)

## -----------------------------------------------------------------------------
# child-to-parent relationship (e.g. Account.Name from Contact record)
sf_query(
  "SELECT Id, FirstName, Account.Name
  FROM Contact
  WHERE Account.Id = null"
)

## -----------------------------------------------------------------------------
try(
  sf_query("SELECT Id, FirstName, Account.Owner.Id
            FROM Contact", 
           api_type = "Bulk 2.0")
)

## -----------------------------------------------------------------------------
sf_query(
  "SELECT Id, Name, 
    (SELECT Id, FirstName FROM Contacts)
  FROM Account"
)

## -----------------------------------------------------------------------------
sf_query(
  "SELECT Name, Owner.Id, 
    (SELECT Id, FirstName, Owner.Id FROM Contacts)
   FROM Account"
)

