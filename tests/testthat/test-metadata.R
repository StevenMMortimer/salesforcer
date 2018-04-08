context("Metadata API")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

# provide the details for creating an object
rand_int <- as.integer(runif(1,1,100000))
base_obj_name <- paste0("Custom_Account_", rand_int)
custom_object <- list()
custom_object$fullName <- paste0(base_obj_name, "__c")
custom_object$label <- paste0(gsub("_", " ", base_obj_name))
custom_object$pluralLabel <- paste0(base_obj_name, "s")
custom_object$nameField <- list(displayFormat = 'AN-{0000}', 
                                label = paste0(base_obj_name, ' Number'), 
                                type = 'AutoNumber')
custom_object$deploymentStatus <- 'Deployed'
custom_object$sharingModel <- 'ReadWrite'
custom_object$enableActivities <- 'true'
custom_object$description <- paste0(base_obj_name, " created by the Metadata API")
custom_object_result <- sf_create_metadata(metadata_type = 'CustomObject',
                                           metadata = custom_object)

# adding custom fields 
# input formatted as a list
custom_fields1 <- list(list(fullName=paste0(base_obj_name, '__c.CustomField1__c'),
                            label='Test Field1',
                            length=100,
                            type='Text'), 
                       list(fullName=paste0(base_obj_name, '__c.CustomField2__c'),
                            label='Test Field2',
                            length=100,
                            type='Text'))
create_fields_result1 <- sf_create_metadata(metadata_type = 'CustomField',
                                            metadata = custom_fields1)

# input formatted as a data.frame
custom_fields2 <- data.frame(fullName=c(paste0(base_obj_name, '__c.CustomField3__c'), 
                                        paste0(base_obj_name, '__c.CustomField4__c')), 
                             label=c('Test Field3', 'Test Field4'), 
                             length=c(44,45), 
                             type=c('Text', 'Text'))
create_fields_result2 <- sf_create_metadata(metadata_type = 'CustomField', 
                                            metadata = custom_fields2)

# specify a new labels
update_metadata <- custom_object 
update_metadata$fullName <- paste0(base_obj_name, "__c")
update_metadata$label <- paste0(gsub("_", " ", base_obj_name), " - Updated")
update_metadata$pluralLabel <- paste0(base_obj_name, "_Updated", "s")
updated_custom_object_result <- sf_update_metadata(metadata_type = 'CustomObject',
                                                   metadata = update_metadata)

renamed_custom_object_result <- sf_rename_metadata(metadata_type = 'CustomObject', 
                                                   old_fullname = paste0("Custom_Account_", rand_int, "__c"), 
                                                   new_fullname = paste0("Custom_Account_", rand_int+1, "__c"))

upsert_metadata <- list(custom_object, custom_object)
upsert_metadata[[1]]$fullName <- paste0("Custom_Account_", rand_int+1, "__c")
upsert_metadata[[1]]$label <- 'New Label Custom_Account2'
upsert_metadata[[1]]$pluralLabel <- 'Custom_Account2s_new'
upsert_metadata[[2]]$fullName <- paste0("Custom_Account_", rand_int+2, "__c")
upsert_metadata[[2]]$label <- 'New Label Custom_Account3'
upsert_metadata[[2]]$pluralLabel <- 'Custom_Account3s_new'
upserted_custom_object_result <- sf_upsert_metadata(metadata_type = 'CustomObject',
                                                    metadata = upsert_metadata)

# read operations
describe_obj_result <- sf_describe_metadata()
list_obj_result <- sf_list_metadata(queries=list(list(type='CustomObject')))
read_obj_result <- sf_read_metadata(metadata_type='CustomObject',
                                    object_names=paste0("Custom_Account_", rand_int+1, "__c"))
retrieve_request <- list(unpackaged=list(types=list(members='*', name='CustomObject')))
retrieve_info <- sf_retrieve_metadata(retrieve_request)

# cleanup everything we created by deleting it
deleted_custom_object_result <- sf_delete_metadata(metadata_type = 'CustomObject', 
                                                   object_names = c(paste0("Custom_Account_", rand_int+1, "__c"), 
                                                                    paste0("Custom_Account_", rand_int+2, "__c")))

test_that("sf_create_metadata", {
  expect_is(custom_object_result, "tbl_df")
  expect_named(custom_object_result, c('fullName', 'success'))
  expect_equal(nrow(custom_object_result), 1)
  expect_equal(custom_object_result$success, 'true')
  
  expect_is(create_fields_result1, "tbl_df")
  expect_named(create_fields_result1, c('fullName', 'success'))
  expect_equal(nrow(create_fields_result1), 2)
  expect_true(all(create_fields_result1$success == 'true'))
  
  expect_is(create_fields_result2, "tbl_df")
  expect_named(create_fields_result2, c('fullName', 'success'))
  expect_equal(nrow(create_fields_result2), 2)
  expect_true(all(create_fields_result2$success == 'true'))
})

test_that("sf_update_metadata", {
  expect_is(updated_custom_object_result, "tbl_df")
  expect_named(updated_custom_object_result, c('fullName', 'success'))
  expect_equal(nrow(updated_custom_object_result), 1)
  expect_equal(updated_custom_object_result$success, 'true')
})

test_that("sf_rename_metadata", {
  expect_is(renamed_custom_object_result, "tbl_df")
  expect_named(renamed_custom_object_result, c('fullName', 'success'))
  expect_equal(nrow(renamed_custom_object_result), 1)
  expect_equal(renamed_custom_object_result$success, 'true')
})

test_that("sf_upsert_metadata", {
  expect_is(upserted_custom_object_result, "tbl_df")
  expect_named(upserted_custom_object_result, c('created', 'fullName', 'success'))
  expect_equal(nrow(upserted_custom_object_result), 2)
  expect_true(all(upserted_custom_object_result$success == 'true'))
  expect_equal(upserted_custom_object_result$created, c('false', 'true'))
})

test_that("sf_describe_metadata", {
  expect_is(describe_obj_result, "tbl_df")
  expect_true(all(c("partialSaveAllowed", "testRequired", 
                    "organizationNamespace", "metadataObjects") %in% 
                    names(describe_obj_result)))
})

test_that("sf_list_metadata", {
  expect_is(list_obj_result, "tbl_df")
  expect_true(all(c('createdById', 'createdByName', 'createdDate', 'fileName', 'fullName', 
                 'id', 'lastModifiedById', 'lastModifiedByName', 'lastModifiedDate', 
                 'manageableState', 'namespacePrefix', 'type') %in% 
                   names(list_obj_result)))
})

test_that("sf_read_metadata", {
  expect_is(read_obj_result, "list")
  expect_true(all(c('fullName', 'actionOverrides', 'fields', 'searchLayouts', 'sharingModel') %in% 
                    names(read_obj_result[[1]])))
})

test_that("sf_retrieve_metadata", {
  expect_is(retrieve_info, "tbl_df")
  expect_true(all(c('done', 'id', 'status', 'success', 'fileProperties') %in% 
                    names(retrieve_info)))
})

test_that("sf_delete_metadata", {
  expect_is(deleted_custom_object_result, "tbl_df")
  expect_named(deleted_custom_object_result, c('fullName', 'success'))
  expect_equal(nrow(deleted_custom_object_result), 2)
  expect_true(all(deleted_custom_object_result$success == 'true'))
})
