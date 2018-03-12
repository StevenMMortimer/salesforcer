context("Authorization")

test_that("testing OAuth auth", {
  
  sf_auth(token = salesforcer_token)
  t <- salesforcer_state()$token
  expect_true(token_exists())
})

test_that("testing basic auth", {
  
  username <- salesforcer_test_settings$username
  password <- salesforcer_test_settings$password
  security_token <- salesforcer_test_settings$security_token
  
  session <- sf_auth(username = username,
                     password = password,
                     security_token = security_token)
  expect_is(session, "list")
})
