## salesforcer 0.1.4

### Features

  * Rebuilt package against R 4.0 (no issues observed with 3.6.3, 4.0.0, 4.0.1) (#53)
  * Upgraded to Salesforce version 48.0 (Spring '20) from version 46.0 (Summer '19)
  * Add support for connections through a proxy by setting in package options (#32)
  * CRUD operations now atomatically cast date and datetime (Date, POSIXct, POSIXlt, POSIXt) 
  formats into an accepted string format recognized by Salesforce (`YYYY-MM-DDThh:mm:ss.sssZ`)
  * Add `batch_size` argument to support specifying custom batch sizes for Bulk jobs
  * Add `sf_convert_lead()` which takes leads and will associate them to the corresponding 
  Accounts, Contacts, and Opportunities as directed in the input along with many other 
  options to send an email to the new owner, block the opportunity creation, and more.  
  * Add `sf_create_attachment()` along with a vignette that better describes how to 
  interact with attachments and other blob data.  
  * Add Attachment and Metadata vignettes along with updating the Bulk vignette.
  
### Bug Fixes

  * Fix issue where REST query was not correctly passing and honoring the batch 
  size control argument to paginate results
  * Fix issue in results of REST query pagination where the function was looping 
  infinitely because of a bug in the implementation that would continue using the 
  same `next_records_url` that was previously passed into the function (#54)
  * Fix issue where the results of Bulk 1.0 query batches where returning 
  fewer rows than expected because of using `content(..., as="text")` which truncated 
  the results instead of using `content(..., type="text/csv")` (#54)
  * Fix issue where the details of an object's picklist contains NULLs (e.g. the 
  `validFor` entry of a picklist value is NULL) so now it is replaced with NA and 
  then can be bound together into a data.frame (#27)
  * Fix issue where NA values in create, update, and upsert operations where setting 
  the fields to blank in Bulk APIs, but not the SOAP or REST APIs. Now NA values in 
  a record will set the field to blank across all APIs (#29)
  * Fix issue where supplying all NA values in the Id field for certain operations 
  would result in a cryptic error message (`"BAD_REQUEST: Unsupported Tooling Sobject 
  Type"`); the affected operations are: delete, undelete, emptyRecycleBin, retrieve, 
  update, and findDuplicatesByIds

## salesforcer 0.1.3 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.3)

### Features

  * Upgraded to version 46.0 (Summer '19) from version 45.0 (Spring '19)
  * Add **RForcecom** backward compatibile version of `rforcecom.getObjectDescription()`
  * Add `sf_describe_object_fields()` which is a tidyier version of `rforcecom.getObjectDescription()`
  * Allow users to control whether query results are kept as all character or the 
  types are guessed (#12)
  * Add `sf_get_all_jobs_bulk()` so that users can see retrieve details for all 
  bulk jobs (#13)
  * Add new utility functions `sf_set_password()` and `sf_reset_password()` (#11)
  * Add two new functions to check for duplicates (`sf_find_duplicates()`, `sf_find_duplicates_by_id()`) (#4)
  * Add new function to download attachments to disk (`sf_download_attachment()`) (#20)
  * The `object_name` argument, required for bulk queries, will be inferred if left blank, 
  making it no longer a required argument
  * Almost all functions in the package now have a `control` argument and dots (`...`) which 
  allows for more than a dozen different control parameters listed in `sf_control()` to be 
  fed into existing function calls to tweak the default behavior. For example, if you would 
  like to override duplicate rules then you can adjust the `DuplicateRuleHeader`. If you 
  would like to have certain assignment rule run on newly created records, then pass in the 
  `AssignmentRuleHeader` (#4, #5)
  * Add new function `sf_undelete()` which will take records out of the Recycle Bin
  * Add new function `sf_empty_recycle_bin()` which will remove records permanently 
  from the Recycle Bin
  * Add new function `sf_merge()` which combines up to 3 records of the same type 
  into 1 record (#22)
  
### Bug Fixes

  * Fix bug where Username/Password authenticated sessions where not working with 
  api_type = "Bulk 1.0"
  * Fix bug where Bulk 1.0 queries that timeout hit an error while trying to abort 
  since that only supported aborting Bulk 2.0 jobs (#13)
  * Fix bug that had only production environment logins possible because of hard 
  coding (@weckstm, #18)
  * Make `sf_describe_object_fields()` more robust against nested list elements and 
  also return picklists as tibbles (#16)
  * Fix bug where four of the bulk operation options (`content_type`, `concurrency_mode`, 
  `line_ending`, and `column_delimiter`) where not being passed down from 
  the top level generic functions like `sf_create()`, `sf_update()`, etc. However, 
  `line_ending` has now been moved into the `sf_control` function so it is no longer 
  explicitly listed for bulk operations as an argument. (@mitch-niche, #23)
  * Ensure that for SOAP, REST, and Bulk 2.0 APIs the verbose argument prints out 
  the XML or JSON along with the URL of the call so it can be replicated via cURL or 
  some other programming language (#8)
  
---
  
## salesforcer 0.1.2 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.2)

### Features

  * Add support for Bulk 1.0 operations of "create", "update", "upsert", "delete" and "hardDelete"
  * Bulk 2.0 operations, by default, now return a single `tbl_df` containing all 
  of the successful records, error records, and unprocessed records
  * Created internal functions that explicity call each API for an operation. For 
  example, `sf_create()` routes into `sf_create_soap()`, `sf_create_rest()`, and 
  `sf_bulk_operation()`.

---

## salesforcer 0.1.1 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.1)

### Features

  * Add `sf_search()` with REST and SOAP API support for SOSL and free text search
  * Add `sf_describe_objects()` with REST and SOAP API to return object metadata
  * Add REST API support for upsert (`sf_upsert()`)
  * Add SOAP API support for the following operations:
    * `sf_create()`
    * `sf_update()`
    * `sf_delete()`
    * `sf_retrieve()`
  * Add Metadata API support for the following operations:
    * `sf_create_metadata()`
    * `sf_read_metadata()`
    * `sf_update_metadata()`
    * `sf_upsert_metadata()`
    * `sf_delete_metadata()`
    * `sf_describe_metadata()`
    * `sf_list_metadata()`
    * `sf_rename_metadata()`
    * `sf_retrieve_metdata()`
    * `sf_deploy_metdata()`
  * Make the default file name for a cached token `.httr-oauth-salesforcer` so that 
  it does not clash with other package token names

### Bug Fixes

  * `sf_user_info()` returning `argument is of length zero` because token is not 
automatically refreshed before calling GET

  * `sf_token()` ignoring basic auth'ed sessions since it was only looking for a token 
using `token_avaiable()`. Replace with `sf_auth_check()` so now it considers a 
session or a token to be "available" (#1).

---

## salesforcer 0.1.0 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.0)

### Features

  * OAuth 2.0 and Basic authentication methods (`sf_auth()`)
  * Query operations via REST and Bulk APIs (`sf_query()`)
  * CRUD operations (Create, Retrieve, Update, Delete) for REST and Bulk APIs: 
    * `sf_create()`
    * `sf_retrieve()`
    * `sf_update()` 
    * `sf_upsert()`
    * `sf_delete()`
  * Backwards compatibile versions of **RForcecom** package functions:
    * `rforcecom.login()` 
    * `rforcecom.getServerTimestamp()`
    * `rforcecom.query()`
    * `rforcecom.bulkQuery()`
    * `rforcecom.create()`
    * `rforcecom.update()`
    * `rforcecom.upsert()`
    * `rforcecom.delete()`
  * Basic utility calls: 
    * `sf_user_info()`
    * `sf_server_timestamp()`
    * `sf_list_rest_api_versions()`
    * `sf_list_resources()`
    * `sf_list_api_limits()`
    * `sf_list_objects()`
