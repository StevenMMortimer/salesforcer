context("Authorization")

test_that("testing missing auth", {
  expect_false(token_available())
  expect_null(sf_access_token())
  expect_false(session_id_available())
  expect_null(sf_session_id())
})

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

test_that("testing basic auth", {
  
  username <- salesforcer_test_settings$username
  password <- salesforcer_test_settings$password
  security_token <- salesforcer_test_settings$security_token
  
  session <- sf_auth(username = username,
                     password = password,
                     security_token = security_token)
  expect_is(session, "list")
  expect_named(session, c("auth_method", "token", "session_id", "instance_url"))
})

test_that("testing token and session availability after basic auth", {
  expect_true(session_id_available())
  expect_true(!is.null(sf_session_id()))
})