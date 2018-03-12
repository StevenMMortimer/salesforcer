context("RForcecom Compatibility")

salesforcer_test_settings <- readRDS("salesforcer_test_settings.rds")
salesforcer_token <- readRDS("salesforcer_token.rds")

test_that("testing rforcecom.login compatibility", {

  username <- salesforcer_test_settings$username
  password <- salesforcer_test_settings$password
  security_token <- salesforcer_test_settings$security_token

  # must set the API Version here because new calls to session will not 
  # create a new sessionId and then we are stuck with version 35.0 (the default from RForcecom::rforcecom.login)
  session1 <- RForcecom::rforcecom.login(username, paste0(password, security_token), 
                                         apiVersion=getOption("salesforcer.api_version"))
  session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token), 
                                           apiVersion=getOption("salesforcer.api_version"))

  expect_equal(session1, session2)
})

username <- salesforcer_test_settings$username
password <- salesforcer_test_settings$password
security_token <- salesforcer_test_settings$security_token
session <- RForcecom::rforcecom.login(username=username, 
                                      password=paste0(password, security_token), 
                                      apiVersion = getOption("salesforcer.api_version"))

sf_auth(token = salesforcer_token)

test_that("testing rforcecom.query compatibility", {
  
  soql <- "SELECT Id, Account.Name, Email FROM Contact LIMIT 10"
  
  result1 <- RForcecom::rforcecom.query(session, soqlQuery=soql)
  result2 <- salesforcer::rforcecom.query(session, soqlQuery=soql)

  expect_equal(sort(names(result1)), sort(names(result2)))
  expect_equal(nrow(result1), nrow(result2))
})

test_that("testing rforcecom.bulkQuery compatibility", {
  
  soql <- "SELECT Id, Email FROM Contact LIMIT 10"
  object <- "Contact"
  
  result1 <- RForcecom::rforcecom.bulkQuery(session, soqlQuery=soql, object=object)
  result2 <- salesforcer::rforcecom.bulkQuery(session, soqlQuery=soql, object=object)
  
  expect_equal(sort(names(result1)), sort(names(result2)))
  expect_equal(nrow(result1), nrow(result2))
})

test_that("testing rforcecom.create compatibility", {
  
  version <- getOption("salesforcer.api_version")
  expect_equal(as.numeric(version), as.numeric("42.0"))

  object <- "Contact"
  fields <- c(FirstName="Test", LastName="Contact-Create-Compatibility")
  
  result1 <- RForcecom::rforcecom.create(session, objectName=object, fields)
  result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
  
  expect_equal(names(result1), c("id", "success"))
  expect_is(result1, "data.frame")
  expect_is(result2, "data.frame")
  expect_equal(sort(names(result1)), sort(names(result2)))
  expect_equal(nrow(result1), nrow(result2))
  
  # clean up
  delete_result1 <- sf_delete(ids=c(result1$id, result2$id), object)
})

test_that("testing rforcecom.delete compatibility", {

  object <- "Contact"
  new_contact <- c(FirstName="Test", LastName="Contact-Delete-Compatibility")
  
  result1 <- sf_create(new_contact, "Contact")
  result1 <- RForcecom::rforcecom.delete(session, objectName=object, id=result1$id)
  
  result2 <- sf_create(new_contact, "Contact")
  result2 <- salesforcer::rforcecom.delete(session, objectName=object, id=result2$id)
  
  expect_null(result1)
  expect_equal(result1, result2)
})

test_that("testing rforcecom.update compatibility", {
  
  object <- "Contact"
  new_contact <- c(FirstName="Test", LastName="Contact-Update-Compatibility")
  fields <- c(FirstName="Test", LastName="Contact-Update-Compatibility2")
  
  create_result1 <- sf_create(new_contact, "Contact")
  result1 <- RForcecom::rforcecom.update(session, objectName=object, id=create_result1$id, fields)
  
  create_result2 <- sf_create(new_contact, "Contact")
  result2 <- salesforcer::rforcecom.update(session, objectName=object, id=create_result2$id, fields)
  
  expect_null(result1)
  expect_equal(result1, result2)
  
  # clean up
  delete_result1 <- sf_delete(ids=c(create_result1$id, create_result2$id), object)
})

test_that("testing rforcecom.getServerTimestamp compatibility", {
  result1 <- RForcecom::rforcecom.getServerTimestamp(session)
  result2 <- salesforcer::rforcecom.getServerTimestamp(session)
  expect_equal(round(result1, units = "mins"),
               round(result2, units = "mins"))
})

# test_that("testing rforcecom.retrieve compatibility", {
#   
# })

# test_that("testing rforcecom.upsert compatibility", {
#   
# })

# test_that("testing rforcecom.search compatibility", {
#   
# })

# test_that("testing rforcecom.bulkAction compatibility", {
#   
# })
