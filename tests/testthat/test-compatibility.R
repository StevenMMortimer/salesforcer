context("RForcecom Compatibility")

test_that("testing rforcecom.login compatibility", {

  username <- salesforcer_test_settings$username
  password <- salesforcer_test_settings$password
  security_token <- salesforcer_test_settings$security_token

  session1 <- RForcecom::rforcecom.login(username, paste0(password, security_token))
  session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token))

  expect_equal(session1, session2)
})
