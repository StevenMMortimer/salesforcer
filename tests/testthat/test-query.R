context("Query")

object <- 'Contact'
contact_fields_to_test <- c(
  'Id'  # id type
  , 'OwnerId'  # reference type
  , 'Salutation'  # picklist type
  , 'LastName'  # string type
  , 'Phone'  # phone type
  , 'IsDeleted'  # boolean type
  , 'Description'  # textarea type
  , 'LastActivityDate'  # date type
  , 'LastViewedDate'  # dateTime type
  , 'MailingAddress'  # address type
  , 'test_number__c'  # double type
  , 'Email'  # email type
  , 'PhotoUrl'  # url type
)
contact_fields_to_test_wo_compound <- contact_fields_to_test[contact_fields_to_test != 'MailingAddress']

test_that("testing zero row query", {
  
  zero_row_soql <- sprintf("SELECT %s FROM Contact WHERE FirstName='ksfheifh'", 
                           paste0(contact_fields_to_test, collapse=", "))

  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(zero_row_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_equal(nrow(soap_queried_records), 0)
  expect_equal(names(soap_queried_records), character(0))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(zero_row_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_equal(nrow(rest_queried_records), 0)
  expect_equal(names(rest_queried_records), character(0))
  
  # Bulk 1.0 API ---------------------------------------------------------------
  expect_error(sf_query(zero_row_soql, object_name=object, api_type="Bulk 1.0"), 
               "FUNCTIONALITY_NOT_ENABLED: Selecting compound data not supported in Bulk Query")

  zero_row_soql_wo_compound <- sprintf("SELECT %s FROM Contact WHERE FirstName='ksfheifh'", 
                                       paste0(contact_fields_to_test_wo_compound, collapse=", "))  
  bulk1_queried_records <- sf_query(zero_row_soql_wo_compound, object_name=object, api_type="Bulk 1.0")
  expect_is(bulk1_queried_records, "tbl_df")
  expect_equal(nrow(bulk1_queried_records), 0)
  expect_equal(names(bulk1_queried_records), character(0))

  # Bulk 2.0 API ---------------------------------------------------------------
  expect_error(sf_query(zero_row_soql, api_type="Bulk 2.0"), 
               "API_ERROR: Selecting compound data not supported in Bulk Query")
  
  zero_row_soql_wo_compound <- sprintf("SELECT %s FROM Contact WHERE FirstName='ksfheifh'", 
                                       paste0(contact_fields_to_test_wo_compound, collapse=", "))  
  bulk2_queried_records <- sf_query(zero_row_soql_wo_compound, api_type="Bulk 2.0")
  expect_is(bulk2_queried_records, "tbl_df")
  expect_equal(nrow(bulk2_queried_records), 0)
  expect_equal(sort(names(bulk2_queried_records)), 
               sort(contact_fields_to_test_wo_compound))   
})


test_that("testing simple SELECT query", {
  
  simple_select_soql <- sprintf("SELECT %s FROM Contact", 
                                paste0(contact_fields_to_test, collapse=", "))
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(simple_select_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_equal(sort(names(soap_queried_records)), 
               sort(c(contact_fields_to_test_wo_compound, 
                      paste("MailingAddress", c("city", "country", 
                                                "postalCode", "state", 
                                                "street"), sep="."))))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(simple_select_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_equal(sort(names(rest_queried_records)), 
               sort(c(contact_fields_to_test_wo_compound, 
                      paste("MailingAddress", c("city", "country", 
                                                "postalCode", "state", 
                                                "street"), sep="."))))
  
  # Bulk 1.0 API ---------------------------------------------------------------
  expect_error(sf_query(simple_select_soql, object_name=object, api_type="Bulk 1.0"), 
               paste0("FUNCTIONALITY_NOT_ENABLED: Selecting compound data not ", 
                      "supported in Bulk Query"))
  
  simple_select_soql_wo_compound <- sprintf("SELECT %s FROM Contact", 
                                       paste0(contact_fields_to_test_wo_compound, 
                                              collapse=", "))
  bulk1_queried_records <- sf_query(simple_select_soql_wo_compound, 
                                    object_name=object, 
                                    api_type="Bulk 1.0")
  expect_is(bulk1_queried_records, "tbl_df")
  expect_gt(nrow(bulk1_queried_records), 0)
  expect_equal(sort(names(bulk1_queried_records)), 
               sort(contact_fields_to_test_wo_compound))
  
  # Bulk 2.0 API ---------------------------------------------------------------
  expect_error(sf_query(simple_select_soql, api_type="Bulk 2.0"), 
               "API_ERROR: Selecting compound data not supported in Bulk Query")
  
  simple_select_soql_wo_compound <- sprintf("SELECT %s FROM Contact", 
                                            paste0(contact_fields_to_test_wo_compound, 
                                                   collapse=", "))  
  bulk2_queried_records <- sf_query(simple_select_soql_wo_compound, 
                                    api_type="Bulk 2.0")
  expect_is(bulk2_queried_records, "tbl_df")
  expect_gt(nrow(bulk2_queried_records), 0)
  expect_equal(sort(names(bulk2_queried_records)), 
               sort(contact_fields_to_test_wo_compound)) 
})

test_that("testing child-to-parent lookup relationship query", {
  
  relationship_fields <- c("Name", "test_number__c", "Account.Id", "Account.Name", "Owner.Name")
  relationship_soql <- sprintf("SELECT %s FROM Contact", paste(relationship_fields, collapse=", "))
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(relationship_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_equal(sort(names(soap_queried_records)), sort(relationship_fields))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(relationship_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_equal(sort(names(rest_queried_records)), sort(relationship_fields))  
  
  # Bulk 1.0 API ---------------------------------------------------------------
  bulk1_queried_records <- sf_query(relationship_soql, object_name=object, api_type="Bulk 1.0")
  expect_is(bulk1_queried_records, "tbl_df")
  expect_gt(nrow(bulk1_queried_records), 0)
  expect_equal(sort(names(bulk1_queried_records)), sort(relationship_fields)) 

  # Bulk 2.0 API ---------------------------------------------------------------
  bulk2_queried_records <- sf_query(relationship_soql, api_type="Bulk 2.0")
  expect_is(bulk2_queried_records, "tbl_df")
  expect_gt(nrow(bulk2_queried_records), 0)
  expect_equal(sort(names(bulk2_queried_records)), sort(relationship_fields))     
})

test_that("testing child-to-parent-grandparent relationship lookup query", {
  
  relationship_fields <- c("Id", "FirstName", "test_number__c", 
                           "Account.Id", "Account.Name", "Account.Owner.FirstName")
  relationship_soql <- sprintf("SELECT %s FROM Contact", paste(relationship_fields, collapse=", "))
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(relationship_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_equal(sort(names(soap_queried_records)), sort(relationship_fields))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(relationship_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_equal(sort(names(rest_queried_records)), sort(relationship_fields))  
  
  # Bulk 1.0 API ---------------------------------------------------------------
  bulk1_queried_records <- sf_query(relationship_soql, object_name=object, api_type="Bulk 1.0")
  expect_is(bulk1_queried_records, "tbl_df")
  expect_gt(nrow(bulk1_queried_records), 0)
  expect_equal(sort(names(bulk1_queried_records)), sort(relationship_fields)) 
  
  # Bulk 2.0 API ---------------------------------------------------------------
  expect_error(sf_query(relationship_soql, api_type="Bulk 2.0"),
               paste0("Failure during batch processing: FeatureNotEnabled : ", 
                      "Cannot serialize value for 'Owner' in CSV format"))
})

test_that("testing parent-to-child nested relationship query", {
  
  nested_soql <- "SELECT Id, 
                     (SELECT Id FROM Contacts)
                  FROM Account"
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(nested_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_named(soap_queried_records, c("Id", "Contact.Id"))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(nested_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_named(soap_queried_records, c("Id", "Contact.Id"))
  
  # Bulk 1.0 API ---------------------------------------------------------------
  expect_error(sf_query(nested_soql, object_name=object, api_type="Bulk 1.0"), 
               paste0("INVALID_TYPE_FOR_OPERATION: The root entity of the requested ", 
                      "query (Account) does not match the entity of the requested ", 
                      "Bulk API Job (Contact)"), 
               fixed=TRUE)
  
  expect_error(sf_query(nested_soql, object_name="Account", api_type="Bulk 1.0"), 
               paste0("FeatureNotEnabled : Aggregate Relationships not supported ", 
                      "in Bulk Query with CSV content type"))
  
  # Bulk 2.0 API ---------------------------------------------------------------  
  expect_error(sf_query(nested_soql, api_type="Bulk 2.0"), 
               paste0("API_ERROR: Aggregate Relationships not supported ", 
                      "in Bulk V2 Query with CSV content type"))  
})

test_that(paste0("testing parent-to-child nested relationship query with both ", 
                 "having child-to-parent lookup"), {
                   
  nested_soql <- "SELECT Owner.Id, 
                     (SELECT Owner.Id FROM Contacts) 
                  FROM Account"
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(nested_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_named(soap_queried_records, c("Contact.Owner.Id", "Owner.Id"))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(nested_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_named(rest_queried_records, c("Contact.Owner.Id", "Owner.Id"))
})

test_that(paste0("testing parent-to-child nested relationship query with both ", 
                 "having child-to-parent lookups and parent with other fields"), {
                   
  nested_soql <- "SELECT Id, Owner.Id, 
                     (SELECT Owner.Id FROM Contacts) 
                  FROM Account"
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(nested_soql, 
                                   object_name="Account", 
                                   api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_named(soap_queried_records, 
               c("Id",
                 "Contact.Owner.Id", 
                 "Owner.Id"))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(nested_soql, object_name="Account", api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_named(rest_queried_records, 
               c("Id",
                 "Contact.Owner.Id", 
                 "Owner.Id"))
})

test_that(paste0("testing parent-to-child nested relationship query with child ", 
                 "having child-to-parent lookup"), {
  
  nested_soql <- "SELECT Id, Name, Owner.Id, 
                     (SELECT Id, LastName, test_number__c, Owner.Id FROM Contacts) 
                  FROM Account"
  
  expected_fields <- c("Id", 
                      "Name", 
                      "Contact.Id", 
                      "Contact.LastName", 
                      "Contact.Owner.Id", 
                      "Contact.test_number__c", 
                      "Owner.Id") 
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(nested_soql, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_named(soap_queried_records, expected_fields)
  expect_is(soap_queried_records$Contact.test_number__c, "numeric")
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(nested_soql, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_named(rest_queried_records, expected_fields)
  expect_is(rest_queried_records$Contact.test_number__c, "numeric")
})

test_that(paste0("testing parent-to-child nested relationship query where the ", 
                 "count of child records exceed batch size"), {
                   
  nested_soql <- "SELECT Id, Name, Owner.Id, 
                  (SELECT Id, LastName, test_number__c, Owner.Id FROM Contacts) 
                  FROM Account
                  WHERE Id = '0013s00000zFdugAAC'"
  
  expected_fields <- c("Id", 
                      "Name", 
                      "Contact.Id", 
                      "Contact.LastName", 
                      "Contact.Owner.Id", 
                      "Contact.test_number__c", 
                      "Owner.Id") 
  
  control <- sf_control(QueryOptions = list(batchSize = 200))
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(nested_soql, control = control, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_equal(nrow(soap_queried_records), 300)
  expect_equal(ncol(soap_queried_records), 7)
  expect_named(soap_queried_records, expected_fields)
  expect_is(soap_queried_records$Contact.test_number__c, "numeric")
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(nested_soql, control = control, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_equal(nrow(rest_queried_records), 300)
  expect_equal(ncol(rest_queried_records), 7)
  expect_named(rest_queried_records, expected_fields)
  expect_is(rest_queried_records$Contact.test_number__c, "numeric")
})
