context("RForcecom Compatibility")

salesforcer_test_settings <- readRDS("salesforcer_test_settings.rds")
salesforcer_token <- readRDS("salesforcer_token.rds")

test_that("testing rforcecom.login compatibility", {

  username <- salesforcer_test_settings$username
  password <- salesforcer_test_settings$password
  security_token <- salesforcer_test_settings$security_token

  session1 <- RForcecom::rforcecom.login(username, paste0(password, security_token))
  session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token))

  expect_equal(session1, session2)
})

username <- salesforcer_test_settings$username
password <- salesforcer_test_settings$password
security_token <- salesforcer_test_settings$security_token
session <- RForcecom::rforcecom.login(username=username, 
                                      password=paste0(password, security_token), 
                                      apiVersion = "42.0")

sf_auth(token = salesforcer_token)

test_that("testing rforcecom.query compatibility", {
  
  soql <- "SELECT Id, Account.Name, Email FROM Contact LIMIT 10"
  
  result1 <- RForcecom::rforcecom.query(session, soqlQuery=soql)
  result2 <- salesforcer::rforcecom.query(session, soqlQuery=soql)

  expect_equal(sort(names(result1)), sort(names(result2)))
  expect_equal(nrow(result1), nrow(result2))
})

test_that("testing rforcecom.bulkQuery compatibility", {
  
  soql <- "SELECT Id, Account.Name, Email FROM Contact LIMIT 10"
  object <- "Contact"
  
  result1 <- RForcecom::rforcecom.bulkQuery(session, soqlQuery=soql, object=object)
  result2 <- salesforcer::rforcecom.bulkQuery(session, soqlQuery=soql, object=object)
  
  expect_equal(sort(names(result1)), sort(names(result2)))
  expect_equal(nrow(result1), nrow(result2))
})

test_that("testing rforcecom.create compatibility", {

  object <- "Contact"
  fields <- c(FirstName="Test", LastName="Contact-Compatibility999")
    
  result1 <- RForcecom::rforcecom.create(session, objectName=object, fields)
  result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
  
  expect_equal(names(result1), c("id", "success"))
  expect_is(result1, "data.frame")
  expect_is(result2, "data.frame")
  expect_equal(sort(names(result1)), sort(names(result2)))
  expect_equal(nrow(result1), nrow(result2))
})


# test_that("testing rforcecom.query compatibility", {
#   
#   result1 <- RForcecom::rforcecom.query()
#   result2 <- salesforcer::rforcecom.query()
#   
# })
