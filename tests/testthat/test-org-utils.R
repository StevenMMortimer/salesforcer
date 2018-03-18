context("Org Utils")

test_that("testing sf_user_info()", {
  res <- sf_user_info() 
  expect_is(res, "list")
  expect_true(all(c("id", "isActive", "firstName", "lastName", "email") %in% names(res)))
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
