context("Report")

common_report_id <- "00O3s000006tDLCEA2"
common_report_instance <- sf_execute_report(common_report_id, async=TRUE)

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
  expect_true(all(c("aggregates", 
                    "hasDetailRows", 
                    "id", 
                    "name",
                    "reportBooleanFilter", 
                    "reportFilters", 
                    "reportFormat", 
                    "reportType", 
                    "showGrandTotal",
                    "showSubtotals",
                    "sortBy") %in% names(report_described$reportMetadata)))
})

test_that("testing sf_create_report()", {

  
})

test_that("testing sf_copy_report()", {
  report_described <- sf_describe_report(common_report_id)
  report_copy_described <- sf_copy_report(common_report_id)
  expect_is(report_copy_described, "list")
  expect_named(report_copy_described, c("attributes", 
                                        "reportExtendedMetadata", 
                                        "reportMetadata", 
                                        "reportTypeMetadata"))
  expect_true(all(c("aggregates", 
                    "hasDetailRows", 
                    "id", 
                    "name",
                    "reportBooleanFilter", 
                    "reportFilters", 
                    "reportFormat", 
                    "reportType", 
                    "showGrandTotal",
                    "showSubtotals",
                    "sortBy") %in% names(report_copy_described$reportMetadata)))  
  
  # key elements are identical
  
  expect_equal(report_described$reportFormat, report_copy_described$reportFormat)
  expect_equal(report_described$reportType$type, report_copy_described$reportType$type)
  expect_equal(report_described$hasDetailRows, report_copy_described$hasDetailRows)
  expect_equal(report_described$detailColumns, report_copy_described$detailColumns)
  
  # clean up the copy
  report_copy_id <- report_copy_described$reportMetadata$id
  expect_true(sf_delete_report(report_copy_id))
})

test_that("testing sf_update_report()", {
  
  
})

test_that("testing sf_delete_report()", {
  
  
})

test_that("testing sf_list_report_instances()", {
  # as_tbl=TRUE
  report_instances_tbl <- sf_list_report_instances(common_report_id)
  expect_is(report_instances_tbl, "tbl_df")
  expect_true(common_report_instance$id %in% report_instances_tbl$id)
  # as_tbl=FALSE
  report_instances_list <- sf_list_report_instances(common_report_id, as_tbl = FALSE)
  expect_is(report_instances_list, "list")
  
  # fake report Id
  expect_error(
    sf_list_report_instances("12395y223409820"),
    "FORBIDDEN: You don’t have sufficient privileges to perform this operation."
  )  
})

test_that("testing sf_delete_report_instance()", {
  result <- sf_delete_report_instance(common_report_id, 
                                      common_report_instance$id)
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
  
  
})

test_that("testing sf_get_report_instance_results()", {
  
})

test_that("testing sf_query_report()", {
  
  
})

test_that("testing sf_run_report()", {
  
})
