# salesforcer 1.0.1

## Dependencies

  * Increase the package's default Salesforce API version to 54.0 (Spring '22)
  * Added a deprecation warning that using basic authentication (password and 
    security token) will no longer work since Salesforce announced that all
    customers will be migrated to MFA beginning February 1st, 2022
    ([link](https://admin.salesforce.com/blog/2021/everything-admins-need-to-know-about-the-mfa-requirement)). Many thanks to @klaw2 for highlighting in #113.
  * Remove deprecated use of `dplyr::across()` and add logic to circumvent a
    new warning emitted by `readr::type_convert()` when no character columns 
    are present
    
## Bug fixes

  * Changed the naming convention for dashboard-related functions to contain the
    action verb first (e.g., `sf_copy_dashboard` instead of `sf_dashboard_copy`)

---

# salesforcer 1.0.0 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v1.0.0)

## Dependencies

  * Increase the package's default Salesforce API version to 52.0 (Summer '21).
  
  * Remove uses of {RForcecom} after it was archived on CRAN on 6/8/2021 (#101)
  
  * Remove LazyData option in DESCRIPTION since `data()` is not utilized
  
  * Deprecate argument in `sf_write_csv()` from `path` to `file` as was done in 
    {readr} v1.4.0.
    
  * Deprecate argument `bind_using_character_cols` because we will always need
    to bind as character and then parse if `guess_types=TRUE`. Per comments in
    tidyverse/readr#588 and tidyverse/readr#98, we must read all of the data as
    character first and then use `type_convert()` to ensure that we use all values
    in the column to guess the type. The default for `read_csv()` is to only use
    the first 1,000 rows and its `guess_max` argument cannot be set to `Inf`.
    
  * Change lifecycle status from "Maturing" to "Status" per the retirement of 
    "Maturing" in the {lifecycle} package. The documentation notes:
    
    > Previously we used as maturing for functions that lay somewhere between experimental and stable. We stopped using this stage because, like questioning, it’s not clear what actionable information this stage delivers.
    
    In addition, the lifecycle guidance states that experimental packages have
    version numbers less than 1.0.0 and may have major changes in its future.
    The {salesforcer} package has achieved a stable state with core
    functionality implemented and a focus on backwards compatibility due to the
    volume of users.

## Features

  * Improve documentation to retrieve the access token or session ID after 
    authentication (#97)
    
  * Improve parsing of Bulk API query recordsets from CSV where all values 
    in the column will be used to guess the type instead of the first 1000.

## Bug fixes

  * Generalize the date and datetime parsing mechanism, such that, reports with 
    date and datetime fields are not returned as NA (#93)
    
  * Fix the format of the `OwnerChangeOptions` header so it is accepted (#94)
  
  * Fix bug that caused Bulk 2.0 calls to crash when the results had datetime 
    fields in the recordset (#95)

---

# salesforcer 0.2.2 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.2.2)

## Dependencies

  * This release relaxes the dependency on {dplyr} and brings back use of 
  `rbindlist()` from {data.table} because of limitations of `dplyr::bind_rows()`. 
  As noted in (tidyverse/dplyr#5429) {dplyr} will only support binding data.frames 
  or lists of data.frames, **not** a list of lists which is needed in some 
  applications of the {salesforcer} package.
  * Due to other recent changes between {vctrs} and {dplyr}, you may now see the 
  following warning displayed when loading {salesforcer}, which is emitted by the 
  loading of {dplyr}:
  
  ```r
  Warning: replacing previous import 'vctrs::data_frame' by 'tibble::data_frame' when loading 'dplyr'
  ```
  
## Features

  * None 
  
  
## Bug fixes

  * None 

# salesforcer 0.2.1 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.2.1)

## Dependencies

  * **CAUTION: This release requires {dplyr 1.0.0} because {dplyr 1.0.1} introduced 
  a bug in `bind_rows()` with how it binds lists where the list elements have differing 
  lengths. This is documented in tidyverse/dplyr#5417 and r-lib/vctrs#1073. The 
  timeline for a fix is unknown as of Aug 16, 2020.** You can install the older 
  version of {dplyr} using the following command: 
  
  ```r
  remotes::install_version("dplyr", "1.0.0")
  ```

## Features

  * Add support for the `defaultLimit` argument in `sf_search()` to be able to 
  restrict the number of records from each individual object when searching 
  across one or more objects.
  * Add support for updating attachments with the `sf_update_attachments()` 
  function (#79).
  * Add support for downloading attachments just by its Id. In addition, the 
  `sf_download_attachment()` function returns the file path of the downloaded 
  content instead of a logical indicating success.

## Bug fixes

  * Fix bug introduced in {salesforcer 0.2.0} which could not stack records with 
  errors longer than length 1. The new solution is to always return the `errors` 
  column as a list, which is coerced to length 1 for the record (#66).
  * Fix bug in `sf_search()` that was passing `"true"/"false"` instead of actual 
  boolean value for the `spellCorrection` parameter in the POST body.  

---

# salesforcer 0.2.0 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.2.0)

## Dependencies

  * **CAUTION: This release only has automated test coverage on R 4.0.0 or greater. 
  Users should still be able to install and run using R (>= 3.6.0). However, it 
  is recommended to upgrade to R 4.0.0 or greater.**

## Features
  
  * Add experimental support for the Reports and Dashboards REST API.
  
  * Add support for Bulk 2.0 queries that was added in Salesforce version 47.0
  (Winter '20). **CAUTION: The Bulk 2.0 API is now the default API when using
  `sf_query_bulk()` or `sf_run_bulk_query()`**. Please test prior to upgrading
  in a production environment where you are running bulk queries.
  
  * Standardize the column order and format of query and CRUD operations that 
  prioritizes the object type and Ids over other fields and finaly relationship 
  fields. **CAUTION: This will switch up the order of the columns returned by 
  your existing code**. Please test prior to upgrading in a production environment 
  where column ordering is a breaking change. For example we prioritize the following 
  fields in queries alphabetically within this prioritization waterfall: 

    1. The `sObject` field first (indicates the record's object if multiple objects returned in the results)  
    2. The Id field second (`Id`, `id`, `sf__Id`)  
    3. Salesforce record success status (`Success`, `success`, `sf_Success`)  
    4. Salesforce record created status (`Created`, `created`, `sf__Created`)  
    5. Salesforce record error(s) status (`Error`, `error`, `errors`, 
  `errors.statusCode`, `errors.fields`, `errors.message`, `sf__Error`)  
    6. All other fields from the target object (e.g. `Name`, `Phone`, etc.)  
    7. Relationship fields (fields from a parent or child of the target). For example, 
    anything typically containing a dot like `Account.Id`, `Owner.Name`, etc.  
  
  * Standardize the names of functions that submit long running jobs to Salesforce. 
  These functions now all start with `sf_run_*`. However, the original names have 
  been aliased to the new names so this version will acknowledge the old function 
  names without deprecation warning.For example, the new names are: 
  
    * `sf_query_bulk()` ==> `sf_run_bulk_query()`  
    * `sf_bulk_operation()` ==> `sf_run_bulk_operation()`  
    * `sf_run_report()`  
    
  * Add support for logging in with a proxy without having to use OAuth 2.0 as
  the authentication method. When proxy support was first implemented in
  {salesforcer} 0.1.4, it only supported proxy connections when logging in via
  OAuth 2.0. Now, this untested version of proxy support for basic
  authentication has been implemented. This means that proxy users should be
  able to login using just a username, password, and security token if their
  organization has not implemented OAuth 2.0 or if they do not want to use OAuth
  2.0 while logging in via this package.
  
  * Add lifecycle badges to signal maturity of different package aspects.
  
  * Add two vignettes, one that outlines the query types supported by the package 
  and another that outlines the new report functionality that was introduced in 
  this release.
  
  * Add enhanced query test coverage in its own test script.
  
  * Remove dependency on {data.table} which does not have a build for R-devel. This 
  should only affect `sf_read_metadata()`.
  
  
## Bug Fixes

  * Fix bug that prevented enabling PKChunking in Bulk 1.0 queries. Users can
  now specify using `TRUE/FALSE` or details like `chunkSize` that imply `TRUE`.
  The results are then parsed appropriately by waiting for all individual
  batches to finish. (#46)
  
  * Fix bugs in REST and SOAP API queries to prevent infinite looping and
  mangling results of relationship queries, specifically parent-to-child 
  nested queries. (#19, #35, #38, #54)
  
  * Fix bug in REST and SOAP APIs where the creation of a record that fails
  duplicate rules will return the duplicate match results as well and cause the
  entire function call to fail because it cannot parse the results. Now only the
  status code and message are returned and the function will execute
  successfully even if the record has not been created due to the rule.

---

# salesforcer 0.1.4 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.4)

## Features

  * Rebuilt package against R 4.0 (no issues observed with 3.6.3, 4.0.0, 4.0.1)
  (#53)
  
  * Upgrade to Salesforce version 48.0 (Spring '20) from version 46.0 (Summer '19)
  
  * Add support for connections through a proxy by setting in package options (#32)
  
  * CRUD operations now automatically cast date and datetime (Date, POSIXct,
  POSIXlt, POSIXt) formats into an accepted string format recognized by
  Salesforce (`YYYY-MM-DDThh:mm:ss.sssZ`).
  
  * Add `batch_size` argument to support specifying custom batch sizes for Bulk jobs
  
  * Add `sf_convert_lead()` which takes leads and will associate them to the
  corresponding Accounts, Contacts, and Opportunities as directed in the input
  along with many other options to send an email to the new owner, block the
  opportunity creation, and more.
  
  * Add `sf_create_attachment()` along with a vignette that better describes how
  to interact with attachments and other blob data.
  
  * Add Attachment and Metadata vignettes along with updated Bulk vignette.
  
## Bug Fixes

  * Fix issue where REST query was not correctly passing and honoring the batch
  size control argument to paginate results
  
  * Fix issue in results of REST query pagination where the function was looping
  infinitely because of a bug in the implementation that would continue using
  the same `next_records_url` that was previously passed into the function (#54)
  
  * Fix issue where the results of Bulk 1.0 query batches where returning fewer
  rows than expected because of using `content(..., as="text")` which truncated
  the results instead of using `content(..., type="text/csv")` (#54)
  
  * Fix issue where the details of an object's picklist contains NULLs (e.g. the
  `validFor` entry of a picklist value is NULL) so now it is replaced with NA
  and then can be bound together into a data.frame (#27)
  
  * Fix issue where NA values in create, update, and upsert operations where
  setting the fields to blank in Bulk APIs, but not the SOAP or REST APIs. Now
  NA values in a record will set the field to blank across all APIs (#29)
  
  * Fix issue where supplying all NA values in the Id field for certain
  operations would result in a cryptic error message (`"BAD_REQUEST: Unsupported
  Tooling Sobject Type"`); the affected operations are: delete, undelete,
  emptyRecycleBin, retrieve, update, and findDuplicatesByIds

---

# salesforcer 0.1.3 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.3)

## Features

  * Upgrade to version 46.0 (Summer '19) from version 45.0 (Spring '19)
  
  * Add **RForcecom** backward compatible version of
  `rforcecom.getObjectDescription()`
  
  * Add `sf_describe_object_fields()` which is a tidier version of
  `rforcecom.getObjectDescription()`
  
  * Allow users to control whether query results are kept as all character or
  the types are guessed (#12)
  
  * Add `sf_get_all_jobs_bulk()` so that users can see retrieve details for all
  bulk jobs (#13)
  
  * Add new utility functions `sf_set_password()` and `sf_reset_password()` (#11)
  
  * Add two new functions to check for duplicates (`sf_find_duplicates()`,
  `sf_find_duplicates_by_id()`) (#4)
  
  * Add new function to download attachments to disk
  (`sf_download_attachment()`) (#20)
  
  * Add functionality to infer the `object_name` argument, required for bulk
  queries, if left blank.
  
  * Add `control` argument to most all package functions and dots (`...`) which
  allows for more than a dozen different control parameters listed in
  `sf_control()` to be fed into existing function calls to tweak the default
  behavior. For example, if you would like to override duplicate rules then you
  can adjust the `DuplicateRuleHeader`. If you would like to have certain
  assignment rule run on newly created records, then pass in the
  `AssignmentRuleHeader` (#4, #5)
  
  * Add new function `sf_undelete()` which will take records out of the Recycle Bin
  
  * Add new function `sf_empty_recycle_bin()` which will remove records
  permanently from the Recycle Bin
  
  * Add new function `sf_merge()` which combines up to 3 records of the same
  type into 1 record (#22)
  
## Bug Fixes

  * Fix bug where Username/Password authenticated sessions where not working with 
  api_type = "Bulk 1.0"
  
  * Fix bug where Bulk 1.0 queries that timeout hit an error while trying to abort 
  since that only supported aborting Bulk 2.0 jobs (#13)
  
  * Fix bug that had only production environment logins possible because of hard 
  coding (@weckstm, #18)
  
  * Enhance `sf_describe_object_fields()` to be robust against nested list
  elements and also return picklist labels and their values as a tibble (#16)
  
  * Fix bug where four of the bulk operation options (`content_type`, `concurrency_mode`, 
  `line_ending`, and `column_delimiter`) where not being passed down from 
  the top level generic functions like `sf_create()`, `sf_update()`, etc. However, 
  `line_ending` has now been moved into the `sf_control` function so it is no longer 
  explicitly listed for bulk operations as an argument. (@mitch-niche, #23)
  
  * Ensure that for SOAP, REST, and Bulk 2.0 APIs the verbose argument prints out 
  the XML or JSON along with the URL of the call so it can be replicated via cURL or 
  some other programming language (#8)
  
---
  
# salesforcer 0.1.2 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.2)

## Features

  * Add support for Bulk 1.0 operations of "create", "update", "upsert", "delete" 
  and "hardDelete"
  
  * Bulk 2.0 operations, by default, now return a single `tbl_df` containing all 
  of the successful records, error records, and unprocessed records
  
  * Create internal functions that explicitly call each API for an operation. For 
  example, `sf_create()` routes into `sf_create_soap()`, `sf_create_rest()`, and 
  `sf_bulk_operation()`.

---

# salesforcer 0.1.1 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.1)

## Features

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
    
  * Update the default file name for a cached token to `.httr-oauth-salesforcer` 
  so that it does not clash with other package token names.

## Bug Fixes

  * `sf_user_info()` returning `argument is of length zero` because token is not 
automatically refreshed before calling GET.

  * `sf_token()` ignoring basic authorized sessions since it was only looking 
  for a token using `token_avaiable()`. Replace with `sf_auth_check()` so now 
  it considers a session or a token to be "available" (#1).

---

# salesforcer 0.1.0 [release](https://github.com/StevenMMortimer/salesforcer/releases/tag/v0.1.0)

## Features

  * OAuth 2.0 and Basic authentication methods (`sf_auth()`)
  
  * Query operations via REST and Bulk APIs (`sf_query()`)
  
  * CRUD operations (Create, Retrieve, Update, Delete) for REST and Bulk APIs: 
  
    * `sf_create()`
    * `sf_retrieve()`
    * `sf_update()` 
    * `sf_upsert()`
    * `sf_delete()`
    
  * Backwards compatible versions of **RForcecom** package functions:
  
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
