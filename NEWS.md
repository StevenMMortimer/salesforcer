# salesforcer 0.0.0.9000

## Features

* OAuth 2.0 and Basic authentication methods (`sf_auth()`)
* CRUD operations (Create, Retrieve, Update, Delete) for REST and Bulk APIs: 
  * `sf_create()`
  * `sf_retrieve()`
  * `sf_update()` 
  * `sf_upsert()`
  * `sf_delete()` 
* Query operations via REST and Bulk APIs (`sf_query()`)
* Backwards compatibile versions of **RForcecom** package functions:
  * `rforcecom.login()` 
  * `rforcecom.getServerTimestamp()`
  * `rforcecom.query()`
  * `rforcecom.bulkQuery()`
* Basic utility calls: 
  * `sf_user_info()`
  * `sf_server_timestamp()`
  * `sf_list_rest_api_versions()`
  * `sf_list_resources()`
  * `sf_list_api_limits()`
  * `sf_list_objects()`
