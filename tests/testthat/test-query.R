context("Query")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

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
  soap_queried_records <- sf_query(zero_row_soql, object_name=object, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_equal(nrow(soap_queried_records), 0)
  expect_equal(names(soap_queried_records), character(0))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(zero_row_soql, object_name=object, api_type="REST")
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
  soap_queried_records <- sf_query(simple_select_soql, object_name=object, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_equal(sort(names(soap_queried_records)), 
               sort(c(contact_fields_to_test_wo_compound, 
                      paste("MailingAddress", c("city", "country", "postalCode", "state", "street"), sep="."))))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(simple_select_soql, object_name=object, api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  expect_equal(sort(names(rest_queried_records)), 
               sort(c(contact_fields_to_test_wo_compound, 
                      paste("MailingAddress", c("city", "country", "postalCode", "state", "street"), sep="."))))
  
  # Bulk 1.0 API ---------------------------------------------------------------
  expect_error(sf_query(simple_select_soql, object_name=object, api_type="Bulk 1.0"), 
               "FUNCTIONALITY_NOT_ENABLED: Selecting compound data not supported in Bulk Query")
  
  simple_select_soql_wo_compound <- sprintf("SELECT %s FROM Contact", 
                                       paste0(contact_fields_to_test_wo_compound, collapse=", "))  
  bulk1_queried_records <- sf_query(simple_select_soql_wo_compound, object_name=object, api_type="Bulk 1.0")
  expect_is(bulk1_queried_records, "tbl_df")
  expect_gt(nrow(bulk1_queried_records), 0)
  expect_equal(sort(names(bulk1_queried_records)), 
               sort(contact_fields_to_test_wo_compound))
  
  # Bulk 2.0 API ---------------------------------------------------------------
  expect_error(sf_query(simple_select_soql, api_type="Bulk 2.0"), 
               "API_ERROR: Selecting compound data not supported in Bulk Query")
  
  simple_select_soql_wo_compound <- sprintf("SELECT %s FROM Contact", 
                                            paste0(contact_fields_to_test_wo_compound, collapse=", "))  
  bulk2_queried_records <- sf_query(simple_select_soql_wo_compound, api_type="Bulk 2.0")
  expect_is(bulk2_queried_records, "tbl_df")
  expect_gt(nrow(bulk2_queried_records), 0)
  expect_equal(sort(names(bulk2_queried_records)), 
               sort(contact_fields_to_test_wo_compound)) 
})

test_that("testing simple relationship query", {
  
  relationship_fields <- c("Name", "test_number__c", "Account.Id", "Account.Name", "Owner.Name")
  relationship_soql <- sprintf("SELECT %s FROM Contact", paste(relationship_fields, collapse=", "))
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(relationship_soql, object_name=object, api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_equal(sort(names(soap_queried_records)), sort(relationship_fields))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(relationship_soql, object_name=object, api_type="REST")
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

test_that("testing parent-child nested query", {
  
  nested_soql <- "SELECT Name, (SELECT LastName, test_number__c, Owner.Id FROM Contacts) FROM Account"
  
  # SOAP API -------------------------------------------------------------------  
  soap_queried_records <- sf_query(nested_soql, object_name="Account", api_type="SOAP")
  expect_is(soap_queried_records, "tbl_df")
  expect_gt(nrow(soap_queried_records), 0)
  expect_equal(sort(names(soap_queried_records)), 
               sort(c("Name", 
                      "Contact.LastName", "Contact.test_number__c", 
                      "Contact.Owner.Id")))
  
  # REST API -------------------------------------------------------------------  
  rest_queried_records <- sf_query(nested_soql, object_name="Account", api_type="REST")
  expect_is(rest_queried_records, "tbl_df")
  expect_gt(nrow(rest_queried_records), 0)
  # slightly different than SOAP API because it has "Contact.Owner.User.Id" instead of Contact.Owner.Id
  expect_equal(sort(names(rest_queried_records)), 
               sort(c("Name", 
                      "Contact.LastName", "Contact.test_number__c", 
                      "Contact.Owner.User.Id")))
  
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
