context("Search")

test_that("testing SOSL", {
  my_sosl <- paste('FIND {bond} in email fields returning', 
                   "contact(id, firstname, lastname, email, test_number__c, testcustomcheckbox__c),",
                   "lead(id, firstname, lastname, email)")
  # sf_search ------------------------------------------------------------------
  searched_records1 <- sf_search(my_sosl, is_sosl=TRUE, api_type="SOAP") 
  searched_records2 <- sf_search(my_sosl, is_sosl=TRUE, api_type="REST")
  expect_is(searched_records1, "tbl_df")
  record_names <- c("sObject", "Id", "Email",
                    "FirstName", "LastName",
                    "test_number__c", "testcustomcheckbox__c")
  expect_equal(names(searched_records1), record_names)
  expect_equal(names(searched_records2), record_names)
  expect_equal(nrow(searched_records1), nrow(searched_records2))
})

test_that("testing parameterized search", {
  my_free_text_search <- "bond"
  searched_records1 <- sf_search(my_free_text_search, api_type="REST")
  searched_records2 <- sf_search(my_free_text_search, api_type="REST", 
                                 objects = c("Account", "Contact", "Lead"),
                                 fields_scope = "EMAIL",
                                 fields = c("Id", "Name"),
                                 overall_limit = 1000,
                                 spell_correction = FALSE)
  expect_is(searched_records1, "tbl_df")
  expect_named(searched_records1, c("sObject", "Id"))
  expect_is(searched_records2, "tbl_df")
  expect_named(searched_records2, c("sObject", "Id", "Name"))
  expect_equal(nrow(searched_records1), nrow(searched_records2))
  expect_equal(sort(searched_records1$Id), sort(searched_records2$Id))
  
  expect_error(
    sf_search(my_free_text_search, is_sosl=FALSE, api_type="SOAP"), 
    paste0("The SOAP API only accepts SOSL. Set `is_sosl=TRUE` or, if trying to ", 
           "perform a free text search then, set `api_type='REST'`.")
  )
})
