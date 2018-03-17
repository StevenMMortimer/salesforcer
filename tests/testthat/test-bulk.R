context("Bulk API")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

test_that("testing Bulk API Functionality", {
  
  n <- 2
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Contact-Create-", 1:n), 
                         My_External_Id__c=letters[1:n])
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, "Contact", api_type="Bulk")
  expect_is(created_records, "list")
  expect_equal(names(created_records), 
               c("successfulResults", "failedResults", "unprocessedRecords"))
  expect_is(created_records$successfulResults, "tbl_df")
  expect_equal(names(created_records$successfulResults), 
               c("sf__Id", "sf__Created", "FirstName", "LastName", "My_External_Id__c"))  
  expect_equal(nrow(created_records$successfulResults), n)
  
  # sf_retrieve ---------------------------------------------------------------- 
  expect_error(
    retrieved_records <- sf_retrieve(ids=created_records$id, 
                                     fields=c("FirstName", "LastName"), 
                                     object="Contact", 
                                     api_type="Bulk")
  )
  
  # FYI: Will not find newly created records because records need to be indexed
  # Just search for some default records
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search _-----------------------------------------------------------------
  expect_error(
    searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="Bulk") 
  )
  
  ids_from_created <- created_records$successfulResults$sf__Id
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             My_External_Id__c
                     FROM Contact 
                     WHERE Id in ('%s')", 
                     paste0(ids_from_created, collapse="','"))
  # sf_query -------------------------------------------------------------------
  queried_records <- sf_query(soql=my_soql, object="Contact", api_type="Bulk")
  expect_is(queried_records, "tbl_df")
  expect_equal(names(queried_records), c("Id", "FirstName", "LastName", "My_External_Id__c"))
  expect_equal(nrow(queried_records), n)
  
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(queried_records, object="Contact", api_type="Bulk")
  expect_is(updated_records, "list")
  expect_equal(names(updated_records), 
               c("successfulResults", "failedResults", "unprocessedRecords"))
  expect_is(updated_records$successfulResults, "tbl_df")
  expect_equal(names(updated_records$successfulResults), 
               c("sf__Id", "sf__Created", "FirstName", "Id", "LastName", "My_External_Id__c"))  
  expect_equal(nrow(updated_records$successfulResults), n)
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Contact-Upsert-", n+1), 
                       My_External_Id__c=letters[n+1])
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object="Contact", 
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "Bulk")
  expect_is(upserted_records, "list")
  expect_equal(names(upserted_records), 
               c("successfulResults", "failedResults", "unprocessedRecords"))
  expect_is(upserted_records$successfulResults, "tbl_df")
  expect_equal(names(upserted_records$successfulResults), 
               c("sf__Id", "sf__Created", "FirstName", "LastName", "My_External_Id__c"))  
  expect_equal(nrow(upserted_records$successfulResults), nrow(upserted_contacts))
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$successfulResults$sf__Id, queried_records$Id)) 
  deleted_records <- sf_delete(ids_to_delete, object="Contact", api_type = "Bulk")
  expect_is(deleted_records, "list")
  expect_equal(names(deleted_records), 
               c("successfulResults", "failedResults", "unprocessedRecords"))
  expect_is(deleted_records$successfulResults, "tbl_df")
  expect_equal(names(deleted_records$successfulResults), 
               c("sf__Id", "sf__Created", "Id"))  
  expect_equal(nrow(deleted_records$successfulResults), length(ids_to_delete))
})
