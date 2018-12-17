context("Bulk 1.0")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

test_that("testing Bulk 1.0 Functionality", {
  
  n <- 2
  prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Contact-Create-", 1:n), 
                         test_number__c = 22,
                         My_External_Id__c=paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, object_name="Contact", api_type="Bulk 1.0")
  expect_is(created_records, "tbl_df")
  expect_named(created_records, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(created_records), nrow(new_contacts))
  expect_true(all(created_records$Success))
  
  # sf_retrieve ---------------------------------------------------------------- 
  expect_error(
    retrieved_records <- sf_retrieve(ids=created_records$Id, 
                                     fields=c("FirstName", "LastName"), 
                                     object_name="Contact", 
                                     api_type="Bulk 1.0")
  )
  
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, test_number__c, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search ------------------------------------------------------------------
  expect_error(
    searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="Bulk 1.0") 
  )
  
  ids_from_created <- created_records$Id
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             test_number__c,
                             My_External_Id__c
                     FROM Contact 
                     WHERE Id in ('%s')", 
                     paste0(ids_from_created, collapse="','"))
  # sf_query -------------------------------------------------------------------
  queried_records <- sf_query(soql=my_soql, object_name="Contact", api_type="Bulk 1.0")
  expect_is(queried_records, "tbl_df")
  expect_equal(lapply(queried_records, class), 
               list(Id="character", FirstName="character", LastName="character", 
                    test_number__c="numeric", My_External_Id__c="character"))
  expect_equal(nrow(queried_records), n)
  
  # test the column force to all character
  queried_records2 <- sf_query(soql=my_soql, object_name="Contact", guess_types = FALSE, api_type="Bulk 1.0")
  expect_equal(lapply(queried_records2, class), 
               list(Id="character", FirstName="character", LastName="character", 
                    test_number__c="character", My_External_Id__c="character"))
  
  # sf_update ------------------------------------------------------------------
  
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  updated_records <- sf_update(queried_records, object_name="Contact", api_type="Bulk 1.0")
  expect_is(updated_records, "tbl_df")
  expect_named(updated_records, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(updated_records), nrow(queried_records))
  expect_true(all(updated_records$Success))
  expect_true(all(!updated_records$Created))
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Contact-Upsert-", n+1), 
                       test_number__c = 23,
                       My_External_Id__c=paste0(prefix, letters[n+1]))
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object_name="Contact", 
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "Bulk 1.0")
  expect_is(upserted_records, "tbl_df")
  expect_named(upserted_records, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(upserted_records), nrow(upserted_contacts))
  expect_true(all(upserted_records$Success))
  expect_equal(upserted_records$Created, c(FALSE, FALSE, TRUE))
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$Id, queried_records$Id)) 
  deleted_records <- sf_delete(ids_to_delete, object_name="Contact", api_type = "Bulk 1.0")
  expect_is(deleted_records, "tbl_df")
  expect_named(deleted_records, c("Id", "Success", "Created", "Error")) 
  expect_equal(nrow(deleted_records), length(ids_to_delete))
  expect_true(all(deleted_records$Success))
  expect_true(all(!deleted_records$Created))
})

context("Bulk 2.0")

test_that("testing Bulk 2.0 Functionality", {
  
  n <- 2
  prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Contact-Create-", 1:n), 
                         test_number__c = 22,
                         My_External_Id__c=paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, object_name="Contact", api_type="Bulk 2.0")
  expect_is(created_records, "tbl_df")
  expect_named(created_records, c("sf__Id", "sf__Created", "FirstName", "LastName", 
                                  "My_External_Id__c", "test_number__c", "sf__Error"))  
  expect_equal(nrow(created_records), n)
  expect_true(all(is.na(created_records$sf__Error)))
  expect_true(all(created_records$sf__Created))
  
  # sf_retrieve ---------------------------------------------------------------- 
  expect_error(
    retrieved_records <- sf_retrieve(ids=created_records$sf__Id, 
                                     fields=c("FirstName", "LastName"), 
                                     object_name="Contact", 
                                     api_type="Bulk 2.0")
  )
  
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, test_number__c, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search ------------------------------------------------------------------
  expect_error(
    searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="Bulk 2.0") 
  )
  
  ids_from_created <- created_records$sf__Id
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             test_number__c,
                             My_External_Id__c
                      FROM Contact 
                      WHERE Id in ('%s')", 
                     paste0(ids_from_created, collapse="','"))
  # sf_query -------------------------------------------------------------------
  expect_error(
    queried_records <- sf_query(soql=my_soql, object_name="Contact", api_type="Bulk 2.0")
  )
  
  queried_records <- sf_query(soql=my_soql, object_name="Contact", api_type="Bulk 1.0")
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(queried_records, object_name="Contact", api_type="Bulk 2.0")
  expect_is(updated_records, "tbl_df")
  expect_named(updated_records, c("sf__Id", "sf__Created", "FirstName", "Id", "LastName", 
                                  "My_External_Id__c", "test_number__c", "sf__Error"))  
  expect_equal(nrow(updated_records), nrow(queried_records))
  expect_true(all(is.na(updated_records$sf__Error)))
  expect_true(all(!updated_records$sf__Created))
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Contact-Upsert-", n+1), 
                       test_number__c = 23,
                       My_External_Id__c=paste0(prefix, letters[n+1]))
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)
  
  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object_name="Contact", 
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "Bulk 2.0")
  expect_is(upserted_records, "tbl_df")
  expect_named(upserted_records, c("sf__Id", "sf__Created", "FirstName", "LastName", 
                                   "My_External_Id__c", "test_number__c", "sf__Error"))  
  expect_equal(nrow(upserted_records), nrow(upserted_contacts))
  expect_true(all(is.na(upserted_records$sf__Error)))
  expect_equal(upserted_records$sf__Created, c(FALSE, FALSE, TRUE))  
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$sf__Id, queried_records$Id)) 
  deleted_records <- sf_delete(ids_to_delete, object_name="Contact", api_type = "Bulk 2.0")
  expect_is(deleted_records, "tbl_df")
  expect_named(deleted_records, c("sf__Id", "sf__Created", "Id", "sf__Error"))
  expect_equal(nrow(deleted_records), length(ids_to_delete))
  expect_true(all(is.na(deleted_records$sf__Error)))
  expect_true(all(!deleted_records$sf__Created))
  
  # sf_get_all_jobs_bulk -------------------------------------------------------
  # the other bulk functions are tested within the other functions (e.g. sf_get_job_bulk)
  bulk_jobs <- sf_get_all_jobs_bulk()
  expect_is(bulk_jobs, "tbl_df")
  expect_true(all(c("id", "operation", "object", "jobType", "state") %in% names(bulk_jobs)))
})
