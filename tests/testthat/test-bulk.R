context("Bulk 1.0")

test_that("testing Bulk 1.0 Functionality", {
  
  n <- 2
  object <- "Contact"
  prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Bulk 1.0-Contact-Create-", 1:n), 
                         test_number__c = 22,
                         My_External_Id__c=paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, object_name=object, api_type="Bulk 1.0")
  expect_is(created_records, "tbl_df")
  expect_named(created_records, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(created_records), nrow(new_contacts))
  expect_true(all(created_records$Success))
  
  # sf_retrieve ---------------------------------------------------------------- 
  expect_error(
    retrieved_records <- sf_retrieve(ids=created_records$Id, 
                                     fields=c("FirstName", "LastName"), 
                                     object_name=object, 
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
                             My_External_Id__c,
                             test_number__c
                     FROM Contact
                     WHERE Id in ('%s')", 
                     paste0(ids_from_created, collapse="','"))
  # sf_query -------------------------------------------------------------------
  queried_records <- sf_query(soql=my_soql, object_name=object, api_type="Bulk 1.0")
  expect_is(queried_records, "tbl_df")
  expect_equal(lapply(queried_records, class), 
               list(Id = "character", 
                    FirstName = "character", 
                    LastName = "character", 
                    My_External_Id__c = "character", 
                    test_number__c = "numeric"))
  expect_equal(nrow(queried_records), n)
  
  # test the column force to all character
  queried_records2 <- sf_query(soql = my_soql, 
                               object_name = object, 
                               guess_types = FALSE,
                               api_type = "Bulk 1.0")
  expect_is(queried_records2, "tbl_df")
  expect_equal(lapply(queried_records2, class), 
               list(Id = "character", 
                    FirstName = "character", 
                    LastName = "character", 
                    My_External_Id__c = "character", 
                    test_number__c = "character"))
  
  # test query that returns nothing
  queried_records3 <- sf_query(soql = "SELECT Id FROM Contact WHERE FirstName='ZZZYYYXXX'", 
                               object_name = object, 
                               api_type = "Bulk 1.0")
  expect_is(queried_records3, "tbl_df")
  expect_equal(nrow(queried_records3), 0)
  
  # sf_update ------------------------------------------------------------------
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  updated_records <- sf_update(queried_records, object_name=object, api_type="Bulk 1.0")
  expect_is(updated_records, "tbl_df")
  expect_named(updated_records, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(updated_records), nrow(queried_records))
  expect_true(all(updated_records$Success))
  expect_true(all(!updated_records$Created))
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Bulk 1.0-Contact-Upsert-", n+1), 
                       My_External_Id__c=paste0(prefix, letters[n+1]), 
                       test_number__c = 23)
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object_name=object,
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "Bulk 1.0")
  expect_is(upserted_records, "tbl_df")
  expect_named(upserted_records, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(upserted_records), nrow(upserted_contacts))
  expect_true(all(upserted_records$Success))
  expect_equal(upserted_records$Created, c(FALSE, FALSE, TRUE))
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$Id, queried_records$Id)) 
  deleted_records <- sf_delete(ids_to_delete, object_name=object, api_type = "Bulk 1.0")
  expect_is(deleted_records, "tbl_df")
  expect_named(deleted_records, c("Id", "Success", "Created", "Error")) 
  expect_equal(nrow(deleted_records), length(ids_to_delete))
  expect_true(all(deleted_records$Success))
  expect_true(all(!deleted_records$Created))
})

context("Bulk 2.0")

test_that("testing Bulk 2.0 Functionality", {
  
  n <- 2
  object <- "Contact"
  prefix <- paste0("Bulk-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Bulk 2.0-Contact-Create-", 1:n), 
                         test_number__c = 22,
                         My_External_Id__c=paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, object_name=object, api_type="Bulk 2.0")
  expect_is(created_records, "tbl_df")
  expect_named(created_records, c("sf__Id", "sf__Created", "sf__Error", 
                                  "FirstName", "LastName", "My_External_Id__c", 
                                  "test_number__c"))  
  expect_equal(nrow(created_records), n)
  expect_true(all(is.na(created_records$sf__Error)))
  expect_true(all(created_records$sf__Created))
  
  # sf_retrieve ---------------------------------------------------------------- 
  expect_error(
    retrieved_records <- sf_retrieve(ids=created_records$sf__Id, 
                                     fields=c("FirstName", "LastName"), 
                                     object_name=object,
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
  queried_records <- sf_query(soql=my_soql, 
                              object_name=object, 
                              api_type="Bulk 2.0")
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(queried_records, object_name=object, api_type="Bulk 2.0")
  expect_is(updated_records, "tbl_df")
  expect_named(updated_records, c("Id", "sf__Id", "sf__Created", "sf__Error", 
                                  "FirstName", "LastName", "My_External_Id__c", 
                                  "test_number__c"))  
  expect_equal(nrow(updated_records), nrow(queried_records))
  expect_true(all(is.na(updated_records$sf__Error)))
  expect_true(all(!updated_records$sf__Created))
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Bulk 2.0-Contact-Upsert-", n+1), 
                       test_number__c = 23,
                       My_External_Id__c=paste0(prefix, letters[n+1]))
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)
  
  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data = upserted_contacts, 
                                object_name = object,
                                external_id_fieldname = "My_External_Id__c", 
                                api_type = "Bulk 2.0")
  expect_is(upserted_records, "tbl_df")
  expect_named(upserted_records, c("sf__Id", "sf__Created", "sf__Error", 
                                   "FirstName", "LastName", "My_External_Id__c", 
                                   "test_number__c")) 
  expect_equal(nrow(upserted_records), nrow(upserted_contacts))
  expect_true(all(is.na(upserted_records$sf__Error)))
  expect_equal(upserted_records$sf__Created, c(FALSE, FALSE, TRUE))  
  
  # sf_create_attachment -------------------------------------------------------
  attachment_details <- tibble(Name = c("logo.png"),
                               Body = system.file("extdata", "logo.png", package="salesforcer"),
                               ContentType = c("image/png"),
                               ParentId = upserted_records$sf__Id[1]) #"0016A0000035mJ5"
  attachment_records_csv <- sf_create_attachment(attachment_details, api_type="Bulk 1.0")
  expect_is(attachment_records_csv, "tbl_df")
  expect_equal(names(attachment_records_csv), c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(attachment_records_csv), 1)
  expect_true(attachment_records_csv$Success)
  
  attachment_records_json <- sf_create_attachment(attachment_details, 
                                                  api_type="Bulk 1.0", 
                                                  content_type="ZIP_JSON")
  expect_is(attachment_records_json, "tbl_df")
  expect_equal(names(attachment_records_json), c("id", "success", "created", "errors"))
  expect_equal(nrow(attachment_records_json), 1)
  expect_true(attachment_records_json$success)
  
  attachment_records_xml <- sf_create_attachment(attachment_details, 
                                                 api_type="Bulk 1.0", 
                                                 content_type="ZIP_XML")
  expect_is(attachment_records_xml, "tbl_df")
  expect_equal(names(attachment_records_xml), c("id", "success", "created"))
  expect_equal(nrow(attachment_records_xml), 1)
  expect_true(attachment_records_xml$success)
  
  # sf_update_attachment -------------------------------------------------------
  temp_f <- tempfile(fileext = ".zip")
  zipr(temp_f, system.file("extdata", "logo.png", package="salesforcer"))
  attachment_details2 <- tibble(Id = attachment_records_csv$Id[1],
                                Name = "logo.png.zip",
                                Body = temp_f)
  attachment_records_update <- sf_update_attachment(attachment_details2, api_type="Bulk 1.0")
  expect_is(attachment_records_update, "tbl_df")
  expect_equal(names(attachment_records_update), c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(attachment_records_update), 1)
  expect_true(attachment_records_update$Success)
  
  # sf_delete_attachment -------------------------------------------------------
  ids_to_delete <- c(attachment_records_csv$Id, 
                     attachment_records_json$id, 
                     attachment_records_xml$id)
  deleted_attachments <- sf_delete_attachment(ids_to_delete, api_type = "Bulk 1.0")
  expect_is(deleted_attachments, "tbl_df")
  expect_named(deleted_attachments, c("Id", "Success", "Created", "Error"))
  expect_equal(nrow(deleted_attachments), length(ids_to_delete))
  expect_true(all(is.na(deleted_attachments$Error)))
  expect_true(all(!deleted_attachments$Created))
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$sf__Id, queried_records$Id)) 
  deleted_records <- sf_delete(ids_to_delete, object_name=object, api_type = "Bulk 2.0")
  expect_is(deleted_records, "tbl_df")
  expect_named(deleted_records, c("Id", "sf__Id", "sf__Created", "sf__Error"))
  expect_equal(nrow(deleted_records), length(ids_to_delete))
  expect_true(all(is.na(deleted_records$sf__Error)))
  expect_true(all(!deleted_records$sf__Created))
  
  # sf_get_all_jobs_bulk -------------------------------------------------------
  # the other bulk functions are tested within the other functions (e.g. sf_get_job_bulk)
  bulk_jobs <- sf_get_all_jobs_bulk(verbose=TRUE)
  expect_is(bulk_jobs, "tbl_df")
  expect_true(all(c("id", "operation", "object", "jobType", "state") %in% names(bulk_jobs)))
  
  # sf_get_all_query_jobs_bulk -------------------------------------------------------
  # the other bulk functions are tested within the other functions (e.g. sf_get_job_bulk)
  bulk_query_jobs <- sf_get_all_query_jobs_bulk()
  expect_is(bulk_query_jobs, "tbl_df")
  expect_true(all(c("id", "operation", "object", "state") %in% names(bulk_query_jobs)))  
})
