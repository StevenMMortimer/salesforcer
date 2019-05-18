context("Search")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

test_that("testing SOSL", {
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search ------------------------------------------------------------------
  searched_records1 <- sf_search(my_sosl, is_sosl=TRUE, api_type="SOAP")  
  searched_records2 <- sf_search(my_sosl, is_sosl=TRUE, api_type="REST") 
  expect_is(searched_records1, "tbl_df")
  expect_named(searched_records1, c("sObject", "Id", "FirstName", 
                                    "LastName", "My_External_Id__c"))
  expect_equal(names(searched_records1), names(searched_records2))
  expect_equal(nrow(searched_records1), nrow(searched_records2))
})

test_that("testing parameterized search", {
  my_free_text_search <- "(336)"
  searched_records1 <- sf_search(my_free_text_search, api_type="REST") 
  searched_records2 <- sf_search(my_free_text_search, api_type="REST", 
                                 objects = c("Account", "Contact", "Lead"),
                                 fields_scope = "PHONE",
                                 fields = c("Id", "Name"),
                                 overall_limit = 1000,
                                 spell_correction = FALSE)
  expect_is(searched_records1, "tbl_df")
  expect_named(searched_records1, c("sObject", "Id"))
  expect_is(searched_records2, "tbl_df")
  expect_named(searched_records2, c("sObject", "Id", "Name"))
  expect_equal(nrow(searched_records1), nrow(searched_records2))
  
  expect_error(
    searched_records <- sf_search(my_free_text_search, is_sosl=FALSE, api_type="SOAP")
  )
})
