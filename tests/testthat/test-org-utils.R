context("Org Utils")

test_that("testing sf_user_info()", {
  res <- sf_user_info() 
  expect_is(res, "list")
  expect_true(all(c("userId", "organizationId", "userFullName", "userEmail") %in% names(res)))
  
  res <- sf_user_info(api_type="Chatter") 
  expect_is(res, "list")
  expect_true(all(c("id", "isActive", "firstName", "lastName", "email") %in% names(res)))
})

test_that("testing sf_set_password()", {
  # nothing right now
})

test_that("testing sf_reset_password()", {
  # nothing right now
})

test_that("testing sf_server_timestamp()", {
  res <- sf_server_timestamp() 
  expect_is(res, "POSIXct")
})

test_that("testing sf_list_rest_api_versions()", {
  res <- sf_list_rest_api_versions() 
  versions <- sapply(res, function(x){as.integer(x$version)})
  expect_is(res, "list")
  expect_true(all(20:46 %in% versions))  
})

test_that("testing sf_list_resources()", {
  res <- sf_list_resources()
  expect_is(res, "list")
  expect_true(all(c("metadata", "chatter", "analytics", 
                    "search", "parameterizedSearch", 
                    "limits", "query", "sobjects", "actions") %in% names(res)))
})

test_that("testing sf_list_api_limits()", {
  res <- sf_list_api_limits()
  expect_is(res, "list")
  expect_true(all(c("DailyApiRequests", "DailyBulkApiRequests", "PermissionSets", 
                    "DataStorageMB", "FileStorageMB") %in% names(res)))
})

test_that("testing sf_list_objects()", {
  res <- sf_list_objects()
  valid_object_names <- sapply(res$sobjects, FUN=function(x){x$name})
  expect_is(res, "list")
  expect_true(all(c("Account", "Contact", "Lead", 
                    "Opportunity", "Task") %in% valid_object_names))
})

test_that("testing sf_find_duplicates()", {
  duplicates_search <- sf_find_duplicates(search_criteria = list(Email="bond_john@grandhotels.com"),
                                          object_name = "Contact")
  expect_is(duplicates_search, "tbl_df")
  expect_named(duplicates_search, c("sObject", "Id"))
})

test_that("testing sf_find_duplicates_by_id()", {
  duplicates_search <- sf_find_duplicates_by_id(sf_id = "0036A000002C6McQAK") 
  expect_is(duplicates_search, "tbl_df")
  expect_named(duplicates_search, c("sObject", "Id"))
})

test_that("testing sf_convert_lead()", {
  # create lead
  new_lead <- tibble(FirstName = "Tim", LastName = "Barr",
                     Company = "Grand Hotels & Resorts Ltd")
  rec <- sf_create(new_lead, "Lead")
  # convert it
  to_convert <- tibble(leadId = rec$id, 
                       convertedStatus = "Closed - Converted", 
                       accountId = "0016A0000035mJ8QAI", 
                       contactId = "0036A000002C6MbQAK", 
                       doNotCreateOpportunity = TRUE)
  converted_lead <- sf_convert_lead(to_convert)
  expect_is(converted_lead, "tbl_df")
  expect_named(converted_lead, c("accountId", "contactId", "leadId", 
                                 "opportunityId", "success"))
  # delete the lead
  sf_delete(rec$id)
})

test_that("testing sf_merge()", {
  n <- 3
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Contact", 1:n),
                         Description = paste0("Description", 1:n))
  new_recs1 <- sf_create(new_contacts, object_name = "Contact")
  merge_res <- sf_merge(master_id = new_recs1$id[1],
                        victim_ids = new_recs1$id[2:3],
                        object_name = "Contact",
                        master_fields = c("Description" = new_contacts$Description[2]))
  expect_is(merge_res, "tbl_df")
  expect_named(merge_res, c("id", "success", "mergedRecordIds", "updatedRelatedIds", "errors"))
  expect_equal(nrow(merge_res), 1)
  
  # check the second and third records now have the same Master Record Id as the first
  merge_check <- sf_query(sprintf("SELECT Id, MasterRecordId, Description FROM Contact WHERE Id IN ('%s')", 
                                  paste0(new_recs1$id, collapse="','")), queryall = TRUE)
  expect_equal(merge_check$MasterRecordId, c(NA, new_recs1$id[1], new_recs1$id[1]))
  expect_equal(merge_check$Description, c("Description2", "Description2", "Description3"))
})

test_that("testing sf_undelete()", {
  new_contact <- c(FirstName = "Test", LastName = "Contact")
  new_records <- sf_create(new_contact, object_name = "Contact")
  delete <- sf_delete(new_records$id[1],
                      AllOrNoneHeader = list(allOrNone = TRUE))
  is_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
                                 new_records$id[1]),
                         queryall = TRUE)
  # test that the record has been deleted
  expect_true(is_deleted$IsDeleted[1])
  
  undelete <- sf_undelete(new_records$id[1])
  # test that undeleting was a success
  expect_true(undelete$success[1])
  
  # test that the record is no longer deleted
  is_not_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
                                     new_records$id[1]))
  expect_false(is_not_deleted$IsDeleted[1])
})

test_that("testing sf_empty_recycle_bin()", {
  new_contact <- c(FirstName = "Test", LastName = "Contact")
  new_records <- sf_create(new_contact, object_name = "Contact")
  delete <- sf_delete(new_records$id[1],
                      AllOrNoneHeader = list(allOrNone = TRUE))
  is_deleted <- sf_query(sprintf("SELECT Id, IsDeleted FROM Contact WHERE Id='%s'",
                                 new_records$id[1]),
                         queryall = TRUE)
  # test that the record has been deleted
  expect_true(is_deleted$IsDeleted[1])
  
  hard_deleted <- sf_empty_recycle_bin(new_records$id[1])
  # test that hard deleting was a success
  expect_true(hard_deleted$success[1])
  
  # confirm that the record really is gone (can't be deleted)
  undelete <- sf_undelete(new_records$id[1])
  # test that undeleting was a success
  expect_false(undelete$success[1])
})

test_that("testing sf_get_deleted()", {
  deleted_recs <- sf_get_deleted("Contact", Sys.Date() - 1, Sys.Date() + 1)
  expect_is(deleted_recs, "tbl_df")
  expect_named(deleted_recs, c("deletedDate", "id"))
})

test_that("testing sf_get_updated()", {
  updated_recs <- sf_get_updated("Contact", Sys.Date() - 1, Sys.Date() + 1)
  expect_is(updated_recs, "tbl_df")
  expect_named(updated_recs, c("id"))
})
