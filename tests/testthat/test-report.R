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

common_report_id <- "00O3s000006tDLCEA2"

test_that("testing sf_list_reports()", {
  # as_tbl=TRUE
  reports_tbl <- sf_list_reports()
  expect_is(reports_tbl, "tbl_df")
  expect_true(common_report_id %in% reports_tbl$id)  
  # as_tbl=FALSE
  reports_list <- sf_list_reports(as_tbl=FALSE)
  expect_is(reports_list, "list")
  
  # recent=FALSE
  reports_tbl <- sf_list_reports(recent=FALSE)
  expect_is(reports_tbl, "tbl_df")
  expect_true(common_report_id %in% reports_tbl$id) 
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
  
  # clean up the report instance
  expect_true(sf_delete_report_instance(common_report_id, 
                                        this_report_instance$id))
})

test_that("testing sf_delete_report_instance()", {
  
  this_report_instance <- sf_execute_report(common_report_id, async=TRUE)
  
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

test_that("testing sf_execute_report()", {
  # # sync
  # common_report_instance <- sf_execute_report(common_report_id)
  # 
  # # sync, with values instead of labels
  # common_report_instance <- sf_execute_report(common_report_id)
  # 
  # # async
  # common_report_instance <- sf_execute_report(common_report_id, async=TRUE)
})

test_that("testing sf_get_report_instance_results()", {
  # 
  # this_report_instance <- sf_execute_report(common_report_id, async=TRUE)
  # 
  # # wait for the report to complete ...
  # status_complete <- FALSE
  # z <- 1
  # Sys.sleep(interval_seconds)
  # while (z < max_attempts & !status_complete){
  #   if (verbose){
  #     if(z %% 5 == 0){
  #       message(paste0("Attempt to retrieve records #", z))
  #     }
  #   }
  #   Sys.sleep(interval_seconds)
  #   instances_list <- sf_list_report_instances(report_id, verbose = verbose)
  #   instance_status <- instances_list[[instances_list$id == results$id, "status"]]
  #   if(instance_status == "Error"){
  #     stop(sprintf("Report run failed (Report Id: %s; Instance Id: %s).", 
  #                  report_id, results$id), 
  #          call.=FALSE)
  #   } else {
  #     if(instance_status == "Success"){
  #       status_complete <- TRUE
  #     } else {
  #       # continue checking the status until success or max attempts
  #       z <- z + 1
  #     }
  #   }
  # }
  # results <- sf_get_report_instance_results(report_id, results$id)
  # 
  # # test with a Fact Map other than "T!T"
  # expect_error(
  #   sf_get_report_instance_results(report_id, 
  #                                  results$id)
  #                                  fact_map_key = ""
  # )
})

test_that("testing sf_query_report()", {
  
  
})

test_that("testing sf_run_report()", {
  
})
