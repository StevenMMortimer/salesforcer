context("REST API")

test_that("testing REST API Functionality", {
  
  n <- 2
  object <- "Contact"
  prefix <- paste0("REST-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("REST-Contact-Create-", 1:n), 
                         My_External_Id__c = paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, object_name = object, api_type="REST")
  expect_is(created_records, "tbl_df")
  expect_equal(names(created_records), c("id", "success"))
  expect_equal(nrow(created_records), n)
  expect_is(created_records$success, "logical")
  
  # sf_retrieve ----------------------------------------------------------------  
  retrieved_records <- sf_retrieve(ids = created_records$id, 
                                   fields = c("FirstName", "LastName"), 
                                   object_name = object, 
                                   api_type = "REST")
  expect_is(retrieved_records, "tbl_df")
  expect_equal(names(retrieved_records), c("sObject", "Id", "FirstName", "LastName"))
  expect_equal(nrow(retrieved_records), n)
  
  # FYI: Will not find newly created records because records need to be indexed
  # Just search for some default records
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search ------------------------------------------------------------------
  searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="REST") 
  expect_is(searched_records, "tbl_df")
  expect_named(searched_records, c("sObject", "Id", "FirstName", "LastName"))
  expect_equal(nrow(searched_records), 3)
  
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             My_External_Id__c
                     FROM Contact 
                     WHERE Id in ('%s')", 
                     paste0(created_records$id , collapse="','"))
  # sf_query -------------------------------------------------------------------
  queried_records <- sf_query(my_soql, object_name = object , api_type="REST")
  expect_is(queried_records, "tbl_df")
  expect_equal(names(queried_records), c("Id", "FirstName", "LastName", "My_External_Id__c"))
  expect_equal(nrow(queried_records), n)
  
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(queried_records, object_name = object, api_type="REST")
  expect_is(updated_records, "tbl_df")
  expect_equal(names(updated_records), c("id", "success"))
  expect_equal(nrow(updated_records), n)
  expect_is(updated_records$success, "logical")
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("REST-Contact-Upsert-", n+1), 
                       My_External_Id__c=paste0(prefix, letters[n+1]))
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data = upserted_contacts, 
                                object_name = object, 
                                external_id_fieldname = "My_External_Id__c", 
                                api_type = "REST")
  expect_is(upserted_records, "tbl_df")
  expect_equal(names(upserted_records), c("id", "success", "created"))
  expect_equal(nrow(upserted_records), nrow(upserted_records))
  expect_equal(upserted_records$success, c(TRUE, TRUE, TRUE))
  expect_equal(upserted_records$created, c(FALSE, FALSE, TRUE))
  
  # sf_create_attachment -------------------------------------------------------
  attachment_details <- tibble(Name = c("salesforcer Logo"),
                               Body = system.file("extdata", "logo.png", package="salesforcer"),
                               ContentType = c("image/png"),
                               ParentId = upserted_records$id[1]) #"0016A0000035mJ5")
  attachment_records <- sf_create_attachment(attachment_details, api_type="REST")
  expect_is(attachment_records, "tbl_df")
  expect_equal(names(attachment_records), c("id", "success", "errors"))
  expect_equal(nrow(attachment_records), 1)  
  
  # sf_update_attachment -------------------------------------------------------
  # TODO: Add this test?
  
  # sf_delete ------------------------------------------------------------------
  # clean up by deleting attachment first
  deleted_records <- sf_delete(attachment_records$id, object_name = "Attachment", api_type = "REST")
  
  ids_to_delete <- unique(c(upserted_records$id[!is.na(upserted_records$id)], queried_records$Id))
  deleted_records <- sf_delete(ids_to_delete, object_name = object, api_type = "REST")
  expect_is(deleted_records, "tbl_df")
  expect_equal(names(deleted_records), c("id", "success"))
  expect_equal(nrow(deleted_records), length(ids_to_delete))
  expect_is(deleted_records$success, "logical")
  expect_true(all(deleted_records$success))
})
