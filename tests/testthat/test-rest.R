context("REST API")

salesforcer_token <- readRDS("salesforcer_token.rds")
sf_auth(token = salesforcer_token)

test_that("testing REST API Functionality", {
  
  n <- 2
  new_contacts <- tibble(FirstName = rep("Test", n),
                         LastName = paste0("Contact-Create-", 1:n), 
                         My_External_Id__c=letters[1:n])
  # sf_create ------------------------------------------------------------------  
  created_records <- sf_create(new_contacts, "Contact", api_type="REST")
  
  # sf_retrieve ----------------------------------------------------------------  
  retrieved_records <- sf_retrieve(ids=created_records$id, 
                                   fields=c("FirstName", "LastName"), 
                                   object="Contact")
  
  my_sosl <- paste("FIND {Test} in name fields returning", 
                   "contact(id, phone, firstname, lastname)")
  # sf_search _-----------------------------------------------------------------
  searched_records <- sf_search(my_sosl, is_sosl=TRUE, api_type="REST")
  
  my_soql <- sprintf("SELECT Id, 
                             FirstName, 
                             LastName, 
                             My_External_Id__c
                     FROM Contact 
                     WHERE Id in ('%s')", 
                     paste0(created_records$id , collapse="','"))
  # sf_query _------------------------------------------------------------------
  queried_records <- sf_query(my_soql, api_type="REST")
  
  queried_records <- queried_records %>%
    mutate(FirstName = "TestTest")
  
  # sf_update ------------------------------------------------------------------
  updated_records <- sf_update(queried_records, object="Contact", api_type="REST")
  
  new_record <- tibble(FirstName = "Test",
                       LastName = paste0("Contact-Upsert-", n+1), 
                       My_External_Id__c=letters[n+1])
  upserted_contacts <- bind_rows(queried_records %>% select(-Id), new_record)

  # sf_upsert ------------------------------------------------------------------
  upserted_records <- sf_upsert(input_data=upserted_contacts, 
                                object="Contact", 
                                external_id_fieldname="My_External_Id__c", 
                                api_type = "REST")
  
  # sf_delete ------------------------------------------------------------------
  deleted_records <- sf_delete(c(upserted_records$id[!is.na(upserted_records$id)], 
                                 queried_records$Id), api_type = "REST")
})
