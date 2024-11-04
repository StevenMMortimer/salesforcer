## ---- echo = FALSE------------------------------------------------------------
NOT_CRAN <- identical(tolower(Sys.getenv("NOT_CRAN")), "true")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  purl = NOT_CRAN,
  eval = NOT_CRAN
)
options(tibble.print_min = 5L, tibble.print_max = 5L)

## ----auth, include = FALSE----------------------------------------------------
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(purrr)))
suppressWarnings(suppressMessages(library(here)))
library(salesforcer)
token_path <- Sys.getenv("SALESFORCER_TOKEN_PATH")
sf_auth(token = paste0(token_path, "salesforcer_token.rds"))

## ----load-package, eval=FALSE-------------------------------------------------
#  library(dplyr, warn.conflicts = FALSE)
#  library(purrr)
#  library(salesforcer)
#  sf_auth()

## ----metadata-read------------------------------------------------------------
read_obj_result <- sf_read_metadata(metadata_type = "CustomObject",
                                    object_names = c("Account", "Contact"))

read_obj_result[[1]][c("fullName", "label", "sharingModel", "enableHistory")]

first_two_fields_idx <- head(which(names(read_obj_result[[1]]) == "fields"), 2)

# show the first two returned fields of the Account object
read_obj_result[[1]][first_two_fields_idx]

## ----soap-describe-object-fields----------------------------------------------
acct_fields <- sf_describe_object_fields("Account")
acct_fields %>% select(name, label, length, soapType, type)

# show the picklist selection options for the Account Type field
acct_fields %>% 
  filter(label == "Account Type") %>% 
  .$picklistValues

## ----rest-describe-objects----------------------------------------------------
describe_obj_result <- sf_describe_objects(object_names=c('Account', 'Contact'))

# confirm that the Account object is queryable
describe_obj_result[[1]][c('label', 'queryable')]

# now show the different picklist values for the Account Type field
all_fields <- describe_obj_result[[1]][names(describe_obj_result[[1]]) == "fields"]

acct_type_field_idx <- which(sapply(all_fields, 
                                    FUN=function(x){x$label}) == "Account Type")
acct_type_field <- all_fields[[acct_type_field_idx]]
acct_type_field[which(names(acct_type_field) == "picklistValues")] %>% 
  map_df(as_tibble)

## ----metadata-crud------------------------------------------------------------
# create an object
base_obj_name <- "Custom_Account1"
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

# add fields to the object
custom_fields <- tibble(fullName=c(paste0(base_obj_name, '__c.CustomField3__c'), 
                                   paste0(base_obj_name, '__c.CustomField4__c')), 
                        label=c('Test Field3', 'Test Field4'), 
                        length=c(100, 100), 
                        type=c('Text', 'Text'))
create_fields_result <- sf_create_metadata(metadata_type = 'CustomField', 
                                           metadata = custom_fields)

# delete the object
delete_obj_result <- sf_delete_metadata(metadata_type = 'CustomObject', 
                                        object_names = c('Custom_Account1__c'))

## ----metadata-crud-field-security, eval=FALSE---------------------------------
#  # get list of user proviles in order to get the "fullName"
#  # parameter correct in the next call
#  my_queries <- list(list(type = 'Profile'))
#  profiles_list <- sf_list_metadata(queries = my_queries)
#  
#  admin_editable <- list(fullName = 'Admin',
#                         fieldPermissions=list(field=paste0(custom_object$fullName,
#                                                            '.CustomField3__c'),
#                                               editable='true'),
#                         fieldPermissions=list(field=paste0(custom_object$fullName,
#                                                            '.CustomField4__c'),
#                                               editable='true'))
#  
#  # update the field level security to "editable" for your fields
#  prof_update <- sf_update_metadata(metadata_type = 'Profile',
#                                    metadata = admin_editable)
#  
#  # now try inserting values into that custom object's fields
#  my_new_data = tibble(CustomField3__c = "Hello World", CustomField4__c = "Hello World")
#  added_record <- sf_create(my_new_data, object_name = custom_object$fullName)

