context("REST API")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

test_that("testing REST API Functionality", {
  
  n <- 2
  prefix <- paste0("REST-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Contact-Create-", 1:n), 
                         My_External_Id__c=paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, "Contact", api_type="REST")
  expect_is(created_records, "tbl_df")
  expect_equal(names(created_records), c("id", "success", "errors"))
  expect_equal(nrow(created_records), n)
  
  # sf_retrieve ----------------------------------------------------------------  
  retrieved_records <- sf_retrieve(ids=created_records$id, 
                                   fields=c("FirstName", "LastName"), 
                                   object_name="Contact", 
                                   api_type="REST")
  expect_is(retrieved_records, "tbl_df")
  expect_equal(names(retrieved_records), c("Id", "FirstName", "LastName"))
  expect_equal(nrow(retrieved_records), n)
  
  # FYI: Will not find newly created records because records need to be indexed
  # Just search for some default records
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search ------------------------------------------------------------------
  searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="REST") 
  expect_is(searched_records, "tbl_df")
  expect_equal(names(searched_records), c("sobject", "Id", "FirstName", "LastName", "My_External_Id__c"))
  expect_equal(nrow(searched_records), 3)
  
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             My_External_Id__c
                     FROM Contact 
                     WHERE Id in ('%s')", 
                     paste0(created_records$id , collapse="','"))
  # sf_query -------------------------------------------------------------------
  queried_records <- sf_query(my_soql, api_type="REST")
  expect_is(queried_records, "tbl_df")
  expect_equal(names(queried_records), c("Id", "FirstName", "LastName", "My_External_Id__c"))
  expect_equal(nrow(queried_records), n)
  
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(queried_records, object_name="Contact", api_type="REST")
  expect_is(updated_records, "tbl_df")
  expect_equal(names(updated_records), c("id", "success", "errors"))
  expect_equal(nrow(updated_records), n)
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Contact-Upsert-", n+1), 
                       My_External_Id__c=paste0(prefix, letters[n+1]))
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object_name="Contact", 
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "REST")
  expect_is(upserted_records, "tbl_df")
  expect_equal(names(upserted_records), c("id", "success", "errors"))
  expect_equal(nrow(upserted_records), nrow(upserted_records))
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$id[!is.na(upserted_records$id)], queried_records$Id))
  deleted_records <- sf_delete(ids_to_delete, api_type = "REST")
  expect_is(deleted_records, "tbl_df")
  expect_equal(names(deleted_records), c("id", "success", "errors"))
  expect_equal(nrow(deleted_records), length(ids_to_delete))
})
