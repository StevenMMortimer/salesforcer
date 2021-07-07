context("SOAP API")

test_that("testing SOAP API Functionality", {
  
  n <- 2
  object <- "Contact"
  prefix <- paste0("SOAP-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("SOAP-Contact-Create-", 1:n), 
                         My_External_Id__c=paste0(prefix, letters[1:n]))
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, object_name=object, api_type="SOAP")
  expect_is(created_records, "tbl_df")
  expect_equal(names(created_records), c("id", "success"))
  expect_equal(nrow(created_records), n)
  expect_is(created_records$success, "logical")
  
  # sf_create error ------------------------------------------------------------
  new_campaign_members <- tibble(CampaignId = "",
                                 ContactId = "0036A000002C6MbQAK")
  create_error_records <- sf_create(new_campaign_members, 
                               object_name = "CampaignMember", 
                               api_type = "SOAP")
  expect_is(create_error_records, "tbl_df")
  expect_equal(names(create_error_records), c("success", "errors"))
  expect_equal(nrow(create_error_records), 1)
  expect_is(create_error_records$errors, "list")
  expect_equal(length(create_error_records$errors[1][[1]]), 2)
  expect_equal(sort(names(create_error_records$errors[1][[1]][[1]])), 
               c("message", "statusCode"))
  
  new_campaign_members <- tibble(CampaignId = "7013s000000j6n1AAA",
                                 ContactId = "0036A000002C6MbQAK")
  create_error_records <- sf_create(new_campaign_members, 
                                    object_name = "CampaignMember", 
                                    api_type = "SOAP")
  expect_is(create_error_records, "tbl_df")
  expect_equal(names(create_error_records), c("success", "errors"))
  expect_equal(nrow(create_error_records), 1)
  expect_is(create_error_records$errors, "list")   
  expect_equal(length(create_error_records$errors[1][[1]]), 1)
  expect_equal(sort(names(create_error_records$errors[1][[1]][[1]])), 
               c("message", "statusCode"))
  
  # sf_create duplicate --------------------------------------------------------
  dupe_n <- 3
  prefix <- paste0("KEEP-", as.integer(runif(1,1,100000)), "-")
  new_contacts <- tibble(FirstName = rep("KEEP", dupe_n),
                         LastName = paste0("Test-Contact-Dupe", 1:dupe_n),
                         Email = rep("keeptestcontact@gmail.com", dupe_n),
                         Phone = rep("(123) 456-7890", dupe_n),
                         test_number__c = rep(999.9, dupe_n),
                         My_External_Id__c = paste0(prefix, 1:dupe_n, "ZZZ"))
  dupe_records <- sf_create(new_contacts, 
                            object_name = "Contact", 
                            api_type = "SOAP",
                            control = list(allowSave = FALSE, 
                                           includeRecordDetails = TRUE,
                                           runAsCurrentUser = TRUE))
  expect_is(dupe_records, "tbl_df")
  expect_equal(names(dupe_records), c("success", "errors"))
  expect_equal(nrow(dupe_records), dupe_n)
  expect_is(dupe_records$errors, "list")   
  expect_equal(length(dupe_records$errors[1][[1]]), 1)
  expect_equal(sort(names(dupe_records$errors[1][[1]][[1]])), 
               c("duplicateResult", "message", "statusCode"))
  
  # sf_retrieve ----------------------------------------------------------------
  retrieved_records <- sf_retrieve(ids = created_records$id,
                                   fields = c("FirstName", "LastName"),
                                   object_name = object, 
                                   api_type = "SOAP")
  expect_is(retrieved_records, "tbl_df")
  expect_equal(names(retrieved_records), c("sObject", "Id", "FirstName", "LastName"))
  expect_equal(nrow(retrieved_records), n)
  
  # FYI: Will not find newly created records because records need to be indexed
  # Just search for some default records
  my_sosl <- paste("FIND {(336)} in phone fields returning", 
                   "contact(id, firstname, lastname, my_external_id__c),",
                   "lead(id, firstname, lastname)")
  # sf_search ------------------------------------------------------------------
  searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="SOAP")  
  expect_is(searched_records, "tbl_df")
  expect_equal(names(searched_records), c("sObject", "Id", "FirstName", "LastName"))
  expect_equal(nrow(searched_records), 3)
  
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             My_External_Id__c
                     FROM Contact 
                     WHERE Id in ('%s')", 
                     paste0(created_records$id , collapse="','"))
  # sf_query -------------------------------------------------------------------
  queried_records <- sf_query(my_soql, api_type="SOAP")
  expect_is(queried_records, "tbl_df")
  expect_equal(names(queried_records), c("Id", "FirstName", "LastName", "My_External_Id__c"))
  expect_equal(nrow(queried_records), n)
  
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(
    queried_records, object_name=object, api_type="SOAP", 
    # test syntax for this control argument alongside the function
    OwnerChangeOptions = list(
      options = list(
        list(execute = TRUE, type = "TransferNotesAndAttachments"),
        list(execute = TRUE, type = "TransferOpenActivities")
      )
    ),
  )
  expect_is(updated_records, "tbl_df")
  expect_equal(names(updated_records), c("id", "success"))
  expect_equal(nrow(updated_records), n)
  expect_is(updated_records$success, "logical")
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("SOAP-Contact-Upsert-", n+1), 
                       My_External_Id__c=paste0(prefix, letters[n+1]))
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object_name=object,
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "SOAP")
  expect_is(upserted_records, "tbl_df")
  expect_equal(names(upserted_records), c("id", "success", "created"))
  expect_equal(nrow(upserted_records), nrow(upserted_records))
  expect_equal(upserted_records$success, c(TRUE, TRUE, TRUE))
  expect_equal(upserted_records$created, c(FALSE, FALSE, TRUE))  
  
  
  # sf_create_attachment -------------------------------------------------------
  attachment_details <- tibble(Name = c("salesforcer Logo"),
                               Body = system.file("extdata", "logo.png", package="salesforcer"),
                               ContentType = c("image/png"),
                               ParentId = upserted_records$id[1]) #"0016A0000035mJ5"
  attachment_records <- sf_create_attachment(attachment_details, api_type="SOAP")
  expect_is(attachment_records, "tbl_df")
  expect_equal(names(attachment_records), c("id", "success"))
  expect_equal(nrow(attachment_records), 1)
  expect_true(attachment_records$success)
  
  # sf_update_attachment -------------------------------------------------------
  temp_f <- tempfile(fileext = ".zip")
  zipr(temp_f, system.file("extdata", "logo.png", package="salesforcer"))
  attachment_details2 <- tibble(Id = attachment_records$id[1],
                                Name = "logo.png.zip",
                                Body = temp_f)
  attachment_records_update <- sf_update_attachment(attachment_details2, api_type="SOAP")
  expect_is(attachment_records_update, "tbl_df")
  expect_equal(names(attachment_records_update), c("id", "success"))
  expect_true(attachment_records_update$success)
  expect_equal(nrow(attachment_records_update), 1)
  
  # sf_delete_attachment -------------------------------------------------------
  deleted_attachments <- sf_delete_attachment(attachment_records$id, api_type = "SOAP")
  expect_is(deleted_attachments, "tbl_df")
  expect_equal(names(deleted_attachments), c("id", "success"))
  expect_equal(nrow(deleted_attachments), 1)
  expect_true(deleted_attachments$success)
  
  # sf_delete ------------------------------------------------------------------
  ids_to_delete <- unique(c(upserted_records$id[!is.na(upserted_records$id)], queried_records$Id))
  deleted_records <- sf_delete(ids_to_delete, object_name=object, api_type = "SOAP")
  expect_is(deleted_records, "tbl_df")
  expect_equal(names(deleted_records), c("id", "success"))
  expect_equal(nrow(deleted_records), length(ids_to_delete))
  expect_is(created_records$success, "logical")
  expect_true(all(deleted_records$success))
})

