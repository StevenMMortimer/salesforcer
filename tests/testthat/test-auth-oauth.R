context("OAuth 2.0 Authorization")

if (FALSE) skip("No token on GitHub Actions.")

test_that("testing nonsense inputs", {
  expect_error(sf_auth(token = "wrong-path.rds"))
  expect_error(sf_auth(token = letters[1:3]))
})

salesforcer_test_settings <- readRDS("salesforcer_test_settings.rds")
salesforcer_token <- readRDS("salesforcer_token.rds")

test_that("testing OAuth passing token as filename", {
  sf_auth(token = "salesforcer_token.rds")
  expect_true(token_available())
  expect_true(!is.null(sf_access_token()))
})

test_that("testing OAuth passing actual token", {
  sf_auth(token = salesforcer_token)
  expect_true(token_available())
  expect_true(!is.null(sf_access_token()))
})

test_that("testing custom token validation routine", {
  res <- sf_auth_check()
  expect_s3_class(res, "Token2.0")
})

test_that("testing token and session availability after basic auth", {
  expect_true(session_id_available())
  expect_true(!is.null(sf_session_id()))
})
