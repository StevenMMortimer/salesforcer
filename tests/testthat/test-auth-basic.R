context("Basic Authorization")

skip("Basic Auth discouraged after Feb 1, 2022.")

test_that("testing auth status", {
  expect_false(token_available())
  expect_null(sf_access_token())
  expect_true(session_id_available())
  expect_is(sf_session_id(), "character")
})

test_that("testing basic auth", {
  
  username <- Sys.getenv("SALESFORCER_USERNAME")
  password <- Sys.getenv("SALESFORCER_PASSWORD")
  security_token <- Sys.getenv("SALESFORCER_SECURITY_TOKEN")
  
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
