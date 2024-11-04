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

## ----simple-report------------------------------------------------------------
my_report_id <- "00O3s000006tE7zEAE"
results <- sf_run_report(my_report_id)
results

## ----filtered-report1---------------------------------------------------------
# filter records that was created before this month
filter1 <- list(column = "CREATED_DATE",
                        operator = "lessThan", 
                        value = "THIS_MONTH")

# filter records where the account billing address city is not empty
filter2 <-  list(column = "ACCOUNT.ADDRESS1_CITY",
                        operator = "notEqual", 
                        value = "")

# combine filter1 and filter2 using 'AND' which means that records must meet both filters
results_using_AND <- sf_run_report(my_report_id, 
                                   report_boolean_logic = "1 AND 2",
                                   report_filters = list(filter1, filter2))
results_using_AND

## ----filtered-report2---------------------------------------------------------
# combine filter1 and filter2 using 'OR' which means that records must meet one 
# of the filters but also throw in a row limit based on a specific sort order
results_using_OR <- sf_run_report(my_report_id, 
                                  report_boolean_logic = "1 OR 2",
                                  report_filters = list(filter1, filter2), 
                                  sort_by = "Contact.test_number__c", 
                                  decreasing = TRUE, 
                                  top_n = 5)
results_using_OR

## ----describe-report----------------------------------------------------------
report_details <- sf_describe_report(my_report_id)
report_details$reportMetadata$reportType$type
report_details$reportMetadata$reportFilters

## ----report-type-metadata-----------------------------------------------------
report_details$reportTypeMetadata$standardDateFilterDurationGroups[[6]]$standardDateFilterDurations[[1]]

## ----report-filter-operators--------------------------------------------------
# report fields
report_fields <- sf_list_report_fields(my_report_id)
head(names(report_fields$equivalentFieldIndices))

report_filters <- sf_list_report_filter_operators()
unique_supported_fields <- report_filters %>% 
  distinct(supported_field_type) %>% 
  unlist()
unique_supported_fields

# operators to filter a picklist field
picklist_field_operators <- report_filters %>% 
  filter(supported_field_type == "picklist")
picklist_field_operators

## ----admin-example------------------------------------------------------------
# first, grab all possible reports in your Org
all_reports <- sf_query("SELECT Id, Name FROM Report")

# second, get the id of the report to update
this_report_id <- all_reports$Id[1]

new_report <- sf_copy_report(this_report_id)

# third, update the report (2 ways shown)
my_updated_report <- sf_update_report(new_report$reportMetadata$id,
                                      report_metadata =
                                        list(reportMetadata =
                                          list(name = "Updated Name!")))
my_updated_report$reportMetadata$name

# alternatively, pull down its metadata and update the name
report_details <- sf_describe_report(new_report$reportMetadata$id)
report_details$reportMetadata$name <- paste0(report_details$reportMetadata$name,
                                             " - UPDATED AGAIN!")

# update the report by passing the metadata
my_updated_report <- sf_update_report(new_report$reportMetadata$id,
                                      report_metadata = report_details)
my_updated_report$reportMetadata$name

# fourth, delete that report using its Id
success <- sf_delete_report(new_report$reportMetadata$id)
success

