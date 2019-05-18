context("Org Utils")

test_that("testing sf_user_info()", {
  res <- sf_user_info() 
  expect_is(res, "list")
  expect_true(all(c("userId", "organizationId", "userFullName", "userEmail") %in% names(res)))
  
  res <- sf_user_info(api_type="Chatter") 
  expect_is(res, "list")
  expect_true(all(c("id", "isActive", "firstName", "lastName", "email") %in% names(res)))
})

test_that("testing sf_set_password()", {
  # nothing right now
})

test_that("testing sf_reset_password()", {
  # nothing right now
})

test_that("testing sf_server_timestamp()", {
  res <- sf_server_timestamp() 
  expect_is(res, "POSIXct")
})

test_that("testing sf_list_rest_api_versions()", {
  res <- sf_list_rest_api_versions() 
  versions <- sapply(res, function(x){as.integer(x$version)})
  expect_is(res, "list")
  expect_true(all(20:42 %in% versions))  
})

test_that("testing sf_list_resources()", {
  res <- sf_list_resources()
  expect_is(res, "list")
  expect_true(all(c("metadata", "chatter", "analytics", 
                    "search", "parameterizedSearch", 
                    "limits", "query", "sobjects", "actions") %in% names(res)))
})

test_that("testing sf_list_api_limits()", {
  res <- sf_list_api_limits()
  expect_is(res, "list")
  expect_true(all(c("DailyApiRequests", "DailyBulkApiRequests", "PermissionSets", 
                    "DataStorageMB", "FileStorageMB") %in% names(res)))
})

test_that("testing sf_list_objects()", {
  res <- sf_list_objects()
  valid_object_names <- sapply(res$sobjects, FUN=function(x){x$name})
  expect_is(res, "list")
  expect_true(all(c("Account", "Contact", "Lead", 
                    "Opportunity", "Task") %in% valid_object_names))
})

test_that("testing sf_find_duplicates()", {
  duplicates_search <- sf_find_duplicates(search_criteria = list(Email="bond_john@grandhotels.com"),
                                          object_name = "Contact")
  expect_is(duplicates_search, "tbl_df")
  expect_named(duplicates_search, c("sObject", "Id"))
})

test_that("testing sf_find_duplicates_by_id()", {
  duplicates_search <- sf_find_duplicates_by_id(sf_id = "0036A000002C6McQAK")
  expect_is(duplicates_search, "tbl_df")
  expect_named(duplicates_search, c("sObject", "Id"))
})
