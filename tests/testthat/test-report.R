context("Bulk 1.0")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

common_report_id <- "00O3s000006tAx8EAE"
common_report_instance <- sf_report_execute(common_report_id, async=FALSE)

test_that("testing sf_reports_list()", {
  # as_tbl=TRUE
  reports_tbl <- sf_reports_list()
  expect_is(reports_tbl, "tbl_df")
  expect_true(common_report_id %in% reports_tbl$id)  
  # as_tbl=FALSE
  reports_list <- sf_reports_list(as_tbl=FALSE)
  expect_is(reports_list, "list")
  
  # complete=TRUE
  reports_tbl <- sf_reports_list(complete=TRUE)
  expect_is(reports_tbl, "tbl_df")
  expect_true(common_report_id %in% reports_tbl$id) 
})

test_that("testing sf_report_describe()", {
  report_described <- sf_report_describe(common_report_id)
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

test_that("testing sf_report_create()", {

  
})

test_that("testing sf_report_copy()", {
  report_described <- sf_report_describe(common_report_id)
  report_copy_described <- sf_report_describe(common_report_id)
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
  
  # identical after removing the id
  report_described$reportMetadata$id <- NULL
  copy_id <- report_copy_described$reportMetadata$id
  report_copy_described$reportMetadata$id <- NULL
  expect_true(identical(report_described, report_copy_described))
  
  # clean up the copy
  expect_true(sf_report_delete(copy_id))
})

test_that("testing sf_report_update()", {
  
  
})

test_that("testing sf_report_delete()", {
  
  
})

test_that("testing sf_report_instances_list()", {
  # as_tbl=TRUE
  report_instances_tbl <- sf_report_instances_list(common_report_id)
  expect_is(report_instances_tbl, "tbl_df")
  expect_true(common_report_instance$id %in% report_instances_tbl$id)
  # as_tbl=FALSE
  report_instances_list <- sf_report_instances_list(common_report_id, as_tbl = FALSE)
  expect_is(report_instances_list, "list")
  
  # fake report Id
  expect_error(
    sf_report_instances_list("12395y223409820"),
    "FORBIDDEN: You don’t have sufficient privileges to perform this operation."
  )  
})

test_that("testing sf_report_instance_delete()", {
  result <- sf_report_instance_delete(common_report_id, 
                                      common_report_instance$id)
  expect_true(result)
  
  # real report Id, but a fake report instance Id
  expect_error(
    sf_report_instance_delete(common_report_id, "12395y223409820"),
    "NOT_FOUND: We couldn’t find a report instance to match the URL of your request."
  )  
    
  # fake report Id, but not a fake report instance Id
  expect_error(
    sf_report_instance_delete("12395y223409820", "12395y223409820"), 
    "FORBIDDEN: You don’t have sufficient privileges to perform this operation."
  )
})

test_that("testing sf_report_types_list()", {
  # as_tbl = TRUE
  report_types_tbl <- sf_report_types_list()
  expect_is(report_types_tbl, "tbl_df")
  expect_named(report_types_tbl, c("label", 
                                   "reportTypes.describeUrl", 
                                   "reportTypes.isHidden", 
                                   "reportTypes.isHistorical", 
                                   "reportTypes.label", 
                                   "reportTypes.supportsJoinedFormat", 
                                   "reportTypes.type"))
  # as_tbl = FALSE
  report_types_list <- sf_report_types_list(as_tbl = FALSE)
  expect_is(report_types_list, "list")
})

test_that("testing sf_report_type_describe()", {
  this_report_type <- "AccountList"
  account_list_report_type <- sf_report_type_describe(this_report_type)
  expect_is(account_list_report_type, "list")
  expect_named(account_list_report_type, c("attributes", 
                                           "reportExtendedMetadata", 
                                           "reportMetadata", 
                                           "reportTypeMetadata"))
  expect_equal(account_list_report_type$reportMetadata$reportType$type, this_report_type)
})

test_that("testing sf_report_fields()", {
  # as_tbl = TRUE
  report_fields <- sf_report_fields(common_report_id)
  expect_is(report_fields, "list")
  expect_named(report_fields, c("displayGroups", 
                                "equivalentFieldIndices", 
                                "equivalentFields", 
                                "mergedGroups"))
})

test_that("testing sf_report_filter_operators_list()", {
  # as_tbl = TRUE
  filter_ops_tbl <- sf_report_filter_operators_list()
  expect_is(filter_ops_tbl, "tbl_df")
  expect_named(filter_ops_tbl, c("supported_field_type", "label", "name"))
  
  # as_tbl = FALSE
  filter_ops_list <- sf_report_filter_operators_list(as_tbl = FALSE)
  expect_is(filter_ops_list, "list")
})




test_that("testing sf_report_execute()", {
  
  
})

test_that("testing sf_report_instance_results()", {
  
})

test_that("testing sf_report_query()", {
  
  
})

test_that("testing sf_run_report()", {
  
})
