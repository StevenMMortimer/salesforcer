context("Report")

key_report_metadata_fields <- c("aggregates", 
                                "hasDetailRows", 
                                "id", 
                                "name",
                                "reportBooleanFilter", 
                                "reportFilters", 
                                "reportFormat", 
                                "reportType", 
                                "showGrandTotal",
                                "showSubtotals",
                                "sortBy")

common_report_id <- "00O3s000006tE7zEAE"

report_col_names <- c("Contact ID", "First Name", "test number", "Contact Owner", 
                      "Account ID", "Account Name", "Billing City", "Account Owner")

test_that("testing sf_list_reports()", {
  # as_tbl=TRUE
  reports_tbl <- sf_list_reports()
  expect_is(reports_tbl, "tbl_df")
  expect_true(common_report_id %in% reports_tbl$id)  
  # as_tbl=FALSE
  reports_list <- sf_list_reports(as_tbl=FALSE)
  expect_is(reports_list, "list")
  
  # recent=TRUE
  reports_tbl <- sf_list_reports(recent=TRUE)
  expect_is(reports_tbl, "tbl_df")
})

test_that("testing sf_describe_report()", {
  report_described <- sf_describe_report(common_report_id)
  expect_is(report_described, "list")
  expect_named(report_described, c("attributes", 
                                   "reportExtendedMetadata", 
                                   "reportMetadata", 
                                   "reportTypeMetadata"))
  expect_true(all(key_report_metadata_fields %in% names(report_described$reportMetadata)))
})

test_that("testing sf_create_report()", {
  # creating a blank report using just the name and type
  prefix <- paste0("TEST Report-", as.integer(runif(1,1,100000)), "-")
  my_new_report <- sf_create_report(sprintf("%s Top Accounts Report", prefix), 
                                    report_type = "AccountList")
  expect_is(my_new_report, "list")
  expect_named(my_new_report, c("attributes", 
                                   "reportExtendedMetadata", 
                                   "reportMetadata", 
                                   "reportTypeMetadata"))
  expect_true(all(key_report_metadata_fields %in% names(my_new_report$reportMetadata)))
  
  # cleanup the new report
  expect_true(sf_delete_report(my_new_report$reportMetadata$id))
})

test_that("testing sf_copy_report()", {
  report_described <- sf_describe_report(common_report_id)
  report_copy_described <- sf_copy_report(common_report_id)
  expect_is(report_copy_described, "list")
  expect_named(report_copy_described, c("attributes", 
                                        "reportExtendedMetadata", 
                                        "reportMetadata", 
                                        "reportTypeMetadata"))
  expect_true(all(key_report_metadata_fields %in% 
                    names(report_copy_described$reportMetadata)))  
  expect_true(grepl(" - Copy$", report_copy_described$reportMetadata$name))
  
  # key elements are identical
  expect_equal(report_described$reportMetadata$reportFormat, 
               report_copy_described$reportMetadata$reportFormat)
  expect_equal(report_described$reportMetadata$reportType$type, 
               report_copy_described$reportMetadata$reportType$type)
  expect_equal(report_described$reportMetadata$hasDetailRows, 
               report_copy_described$reportMetadata$hasDetailRows)
  expect_equal(report_described$reportMetadata$detailColumns, 
               report_copy_described$reportMetadata$detailColumns)
  
  # clean up the copy
  report_copy_id <- report_copy_described$reportMetadata$id
  expect_true(sf_delete_report(report_copy_id))
})

test_that("testing sf_update_report()", {
  # create a blank report
  prefix <- paste0("TEST Report-", as.integer(runif(1,1,100000)))
  new_report_name <- sprintf("%s - Top Accounts Report", prefix)
  my_new_report <- sf_create_report(name = new_report_name, report_type = "AccountList")
  
  # update that new report
  updated_report_name <- sprintf("%s - Updated Name!", prefix)
  my_updated_report <- sf_update_report(my_new_report$reportMetadata$id,
                                        report_metadata = list(reportMetadata = list(name = updated_report_name)))
  expect_is(my_updated_report, "list")
  expect_named(my_updated_report, c("attributes", 
                                        "reportExtendedMetadata", 
                                        "reportMetadata", 
                                        "reportTypeMetadata"))
  expect_true(all(key_report_metadata_fields %in% names(my_updated_report$reportMetadata)))
  
  # key elements are identical except for the name
  expect_equal(my_new_report$reportMetadata$name, new_report_name)
  expect_equal(my_updated_report$reportMetadata$name, updated_report_name)
  expect_equal(my_new_report$reportMetadata$id, my_updated_report$reportMetadata$id)
  expect_equal(my_new_report$reportMetadata$reportType$type, 
               my_updated_report$reportMetadata$reportType$type)
  expect_equal(my_new_report$reportMetadata$hasDetailRows, 
               my_updated_report$reportMetadata$hasDetailRows)
  expect_equal(my_new_report$reportMetadata$detailColumns, 
               my_updated_report$reportMetadata$detailColumns)
  
  # cleanup the new report
  expect_true(sf_delete_report(my_updated_report$reportMetadata$id))
})

test_that("testing sf_delete_report()", {
  # creating a blank report
  prefix <- paste0("TEST Report-", as.integer(runif(1,1,100000)), "-")
  my_new_report <- sf_create_report(sprintf("%s Top Accounts Report", prefix), 
                                    report_type = "AccountList")
  # cleanup the new report
  expect_true(sf_delete_report(my_new_report$reportMetadata$id))
})

test_that("testing sf_list_report_instances()", {
  this_report_instance <- sf_execute_report(common_report_id, async=TRUE)
  # as_tbl=TRUE
  report_instances_tbl <- sf_list_report_instances(common_report_id)
  expect_is(report_instances_tbl, "tbl_df")
  expect_true(this_report_instance$id %in% report_instances_tbl$id)
  # as_tbl=FALSE
  report_instances_list <- sf_list_report_instances(common_report_id, as_tbl = FALSE)
  expect_is(report_instances_list, "list")
  
  # fake report Id
  expect_error(
    sf_list_report_instances("12395y223409820"),
    "FORBIDDEN: You don’t have sufficient privileges to perform this operation."
  )  
  
  # wait for the report instance to complete ...
  status_complete <- FALSE
  z <- 1
  interval_seconds <- 3
  max_attempts <- 200
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    Sys.sleep(interval_seconds)
    instances_list <- sf_list_report_instances(common_report_id)
    instance_status <- instances_list[[which(instances_list$id == this_report_instance$id), "status"]]
    if(instance_status %in% c("Success", "Error")){
      status_complete <- TRUE
    } else {
      # continue checking the status until success or max attempts
      z <- z + 1
    }
  }
  
  # clean up the report instance
  expect_true(sf_delete_report_instance(common_report_id, 
                                        this_report_instance$id))
})

test_that("testing sf_delete_report_instance()", {
  
  this_report_instance <- sf_execute_report(common_report_id, async=TRUE)
  
  # wait for the report instance to complete ...
  status_complete <- FALSE
  z <- 1
  interval_seconds <- 3
  max_attempts <- 200
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    Sys.sleep(interval_seconds)
    instances_list <- sf_list_report_instances(common_report_id)
    instance_status <- instances_list[[which(instances_list$id == this_report_instance$id), "status"]]
    if(instance_status %in% c("Success", "Error")){
      status_complete <- TRUE
    } else {
      # continue checking the status until success or max attempts
      z <- z + 1
    }
  }
  
  result <- sf_delete_report_instance(common_report_id, 
                                      this_report_instance$id)
  expect_true(result)
  
  # real report Id, but a fake report instance Id
  expect_error(
    sf_delete_report_instance(common_report_id, "12395y223409820"),
    "NOT_FOUND: We couldn’t find a report instance to match the URL of your request."
  )  
    
  # fake report Id, but not a fake report instance Id
  expect_error(
    sf_delete_report_instance("12395y223409820", "12395y223409820"), 
    "FORBIDDEN: You don’t have sufficient privileges to perform this operation."
  )
})

test_that("testing sf_list_report_types()", {
  # as_tbl = TRUE
  report_types_tbl <- sf_list_report_types()
  expect_is(report_types_tbl, "tbl_df")
  expect_named(report_types_tbl, c("label", 
                                   "reportTypes.describeUrl", 
                                   "reportTypes.isHidden", 
                                   "reportTypes.isHistorical", 
                                   "reportTypes.label", 
                                   "reportTypes.supportsJoinedFormat", 
                                   "reportTypes.type", 
                                   "reportTypes.description"))
  # as_tbl = FALSE
  report_types_list <- sf_list_report_types(as_tbl = FALSE)
  expect_is(report_types_list, "list")
})

test_that("testing sf_describe_report_type()", {
  this_report_type <- "AccountList"
  account_list_report_type <- sf_describe_report_type(this_report_type)
  expect_is(account_list_report_type, "list")
  expect_named(account_list_report_type, c("attributes", 
                                           "reportExtendedMetadata", 
                                           "reportMetadata", 
                                           "reportTypeMetadata"))
  expect_equal(account_list_report_type$reportMetadata$reportType$type, this_report_type)
  expect_true(all(key_report_metadata_fields %in% names(account_list_report_type$reportMetadata)))
})

test_that("testing sf_list_report_fields()", {
  # as_tbl = TRUE
  report_fields <- sf_list_report_fields(common_report_id)
  expect_is(report_fields, "list")
  expect_named(report_fields, c("displayGroups", 
                                "equivalentFieldIndices", 
                                "equivalentFields", 
                                "mergedGroups"))
})

test_that("testing sf_list_report_filter_operators()", {
  # as_tbl = TRUE
  filter_ops_tbl <- sf_list_report_filter_operators()
  expect_is(filter_ops_tbl, "tbl_df")
  expect_named(filter_ops_tbl, c("supported_field_type", "label", "name"))
  
  # as_tbl = FALSE
  filter_ops_list <- sf_list_report_filter_operators(as_tbl = FALSE)
  expect_is(filter_ops_list, "list")
})

test_that("testing sf_execute_report() synchronously", {
  # sync
  common_report_df <- sf_execute_report(common_report_id)
  expect_is(common_report_df, "tbl_df")
  expect_named(common_report_df, report_col_names)
  expect_is(common_report_df$`test number`, "numeric")

  # sync, with values instead of labels
  common_report_df <- sf_execute_report(common_report_id, labels = FALSE)
  expect_is(common_report_df, "tbl_df")
  expect_equal(common_report_df$`Contact ID`, common_report_df$`First Name`)
  expect_equal(common_report_df$`Account ID`, common_report_df$`Account Name`)
  
  # sync, without guessing types
  common_report_df <- sf_execute_report(common_report_id, 
                                        guess_types = FALSE)
  expect_is(common_report_df, "tbl_df")
  expect_true(all(sapply(common_report_df, class) == "character"))
  
  # sync, with complete metadata element
  report_details <- sf_describe_report(common_report_id)
  report_details$reportMetadata$reportFilters[[2]]$operator <- "equals"
  common_report_df <- sf_execute_report(common_report_id, 
                                        report_metadata = report_details$reportMetadata)
  expect_is(common_report_df, "tbl_df")
  expect_equal(nrow(common_report_df), 1)
  expect_named(common_report_df, report_col_names)
  expect_is(common_report_df$`test number`, "numeric")    
  
  # report that is requesting to sort by too many fields at once
  report_details <- sf_describe_report(common_report_id)
  report_details$reportMetadata$sortBy <- list(list(sortColumn = 'Contact.test_number__c', 
                                                    sortOrder = "Asc"), 
                                               list(sortColumn = 'ACCOUNT.ADDRESS1_CITY', 
                                                    sortOrder = "Desc"))
  expect_error(
    sf_execute_report(common_report_id, 
                      async = FALSE, 
                      report_metadata =  report_details$reportMetadata), 
    "BAD_REQUEST: A report can only be sorted by one column."
  )
})

test_that("testing sf_execute_report() asynchronously", {
  
  # async
  common_report_instance <- sf_execute_report(common_report_id, async=TRUE)
  expect_is(common_report_instance, "tbl_df")
  expect_named(common_report_instance, c("id", "ownerId", "status", 
                                         "requestDate", "completionDate", 
                                         "hasDetailRows", "queryable", "url"))
  
  # wait for the report to complete ...
  status_complete <- FALSE
  z <- 1
  interval_seconds <- 3
  max_attempts <- 200
  Sys.sleep(interval_seconds)
  while (z < max_attempts & !status_complete){
    Sys.sleep(interval_seconds)
    instances_list <- sf_list_report_instances(common_report_id)
    instance_status <- instances_list[[which(instances_list$id == common_report_instance$id), "status"]]
    if(instance_status == "Error"){
      stop(sprintf("Report run failed (Report Id: %s; Instance Id: %s).",
                   common_report_id, common_report_instance$id),
           call.=FALSE)
    } else {
      if(instance_status == "Success"){
        status_complete <- TRUE
      } else {
        # continue checking the status until success or max attempts
        z <- z + 1
      }
    }
  }
  results <- sf_get_report_instance_results(common_report_id, common_report_instance$id)
  expect_is(results, "tbl_df")
  expect_named(results, report_col_names)
  expect_is(results$`test number`, "numeric")
  
  # test with a Fact Map other than "T!T"
  expect_error(
    sf_get_report_instance_results(common_report_id,
                                   common_report_instance$id,
                                   fact_map_key = ""), 
    "Fact map key is not 'T!T'"
  )
})

test_that("testing sf_run_report()", {
  
  # simple sync report 
  results <- sf_run_report(common_report_id, async=FALSE)
  expect_is(results, "tbl_df")
  expect_named(results, report_col_names)
  expect_is(results$`test number`, "numeric")  
  
  # simple async report 
  results <- sf_run_report(common_report_id)
  expect_is(results, "tbl_df")
  expect_named(results, report_col_names)
  expect_is(results$`test number`, "numeric")  
  
  # filtered report
  filter1 <- list(column = "CREATED_DATE",
                  operator = "lessThan",
                  value = "THIS_MONTH")
  filter2 <-  list(column = "ACCOUNT.ADDRESS1_CITY",
                   operator = "equals",
                   value = "")
  filtered_results <- sf_run_report(common_report_id, 
                                    report_boolean_logic = "1 AND 2",
                                    report_filters = list(filter1, filter2))
  expect_is(filtered_results, "tbl_df")
  expect_gte(nrow(filtered_results), 1)
  expect_named(filtered_results, report_col_names)
  expect_is(filtered_results$`test number`, "numeric")    
  
  # sorted by the top test number
  results <- sf_run_report(common_report_id, 
                           async = FALSE, 
                           sort_by = 'Contact.test_number__c', 
                           decreasing = TRUE,
                           top_n = 3)
  expect_is(results, "tbl_df")
  expect_equal(nrow(results), 3)
  expect_named(results, report_col_names)
  expect_equal(results$`test number`, c(99, 23, NA))
  
  # limited to the first result
  results <- sf_run_report(common_report_id, 
                           async = FALSE,
                           sort_by = 'Contact.test_number__c',
                           decreasing = TRUE,
                           top_n = 1)
  expect_is(results, "tbl_df")
  expect_equal(nrow(results), 1)
  expect_named(results, report_col_names)
  expect_is(results$`test number`, "numeric")

  # trying to take top N without having a sortby argument
  expect_error(
    sf_run_report(common_report_id, 
                  async = FALSE, 
                  top_n = 1),
    "A report must be sorted by one column when requesting a Top N number of rows."
  )
    
  # trying to sort by more than 1 field
  expect_error(
    sf_run_report(common_report_id, 
                  async = FALSE, 
                  sort_by = c("Contact.test_number__c", "ACCOUNT.ADDRESS1_CITY")),
    "Currently, Salesforce will only allow a report to be sorted by, at most, one column."
  )  
})

test_that("testing sf_query_report()", {
  skip("Not implemented yet.")
})
