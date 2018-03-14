## salesforcer 0.1.0.9000

### Features

* Nothing yet!

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
