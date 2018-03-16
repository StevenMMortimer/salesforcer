context("Describe")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

test_that("testing sf_describe_objects", {
  account_metadata <- sf_describe_objects("Account")
  expect_is(account_metadata, "list")
  expect_equal(length(account_metadata), 1)
  expect_equal(unlist(account_metadata[[1]]$name), "Account")
  
  account_metadata_REST <- sf_describe_objects("Account", api_type="REST")
  expect_is(account_metadata_REST, "list")
  expect_equal(length(account_metadata_REST), 1)
  expect_equal(unlist(account_metadata_REST[[1]]$name), "Account")
  
  multiple_objs_metadata <- sf_describe_objects(c("Contact", "Lead"))
  expect_is(multiple_objs_metadata, "list")
  expect_equal(length(multiple_objs_metadata), 2)
  expect_equal(sort(c(unlist(multiple_objs_metadata[[1]]$name), 
                      unlist(multiple_objs_metadata[[2]]$name))), c("Contact", "Lead"))
})
