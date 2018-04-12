
salesforcer<img src="man/figures/salesforcer.png" width="120px" align="right" />
================================================================================

[![Build Status](https://travis-ci.org/StevenMMortimer/salesforcer.svg?branch=master)](https://travis-ci.org/StevenMMortimer/salesforcer) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/StevenMMortimer/salesforcer?branch=master&svg=true)](https://ci.appveyor.com/project/StevenMMortimer/salesforcer) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/salesforcer)](http://cran.r-project.org/package=salesforcer) [![Coverage Status](https://codecov.io/gh/StevenMMortimer/salesforcer/branch/master/graph/badge.svg)](https://codecov.io/gh/StevenMMortimer/salesforcer?branch=master)

**salesforcer** is an R package that connects to Salesforce Platform APIs using tidy principles. The package implements most actions from the SOAP, REST, Bulk 1.0, Bulk 2.0, and Metadata APIs. Package features include:

-   OAuth 2.0 (Single Sign On) and Basic (Username-Password) Authentication methods (`sf_auth()`)
-   CRUD (Create, Retrieve, Update, Delete) methods for records using the SOAP, REST, and Bulk APIs
-   Query records via the SOAP, REST, and Bulk 1.0 APIs using `sf_query()`
-   Retrieve and modify metadata (Custom Objects, Fields, etc.) using the Metadata API with:
    -   `sf_describe_objects()`, `sf_create_metadata()`, `sf_update_metadata()`
-   Utilize backwards compatible functions for the **RForcecom** package, such as:
    -   `rforcecom.login()`, `rforcecom.query()`, `rforcecom.create()`, `rforcecom.update()`
-   Basic utility calls (`sf_user_info()`, `sf_server_timestamp()`, `sf_list_objects()`)

Table of Contents
-----------------

-   [Installation](#installation)
-   [Usage](#usage)
    -   [Authenticate](#authenticate)
    -   [Create](#create)
    -   [Query](#query)
    -   [Update](#update)
    -   [Bulk Operations](#bulk-operations)
    -   [Using the Metadata API](#using-the-metadata-api)
-   [Future](#future)
-   [Credits](#credits)
-   [More Information](#more-information)

Installation
------------

``` r
# this package is currently not on CRAN, so it should be installed from GitHub
# install.packages("devtools")
devtools::install_github("StevenMMortimer/salesforcer")
```

If you encounter a clear bug, please file a minimal reproducible example on [GitHub](https://github.com/StevenMMortimer/salesforcer/issues).

Usage
-----

### Authenticate

First, load the **salesforcer** package and login. There are two ways to authenticate:

1.  OAuth 2.0
2.  Basic Username-Password

It is recommended to use OAuth 2.0 so that passwords do not have to be shared or embedded within scripts. User credentials will be stored in locally cached file entitled ".httr-oauth-salesforcer" in the current working directory.

``` r
suppressWarnings(suppressMessages(library(dplyr)))
suppressWarnings(suppressMessages(library(purrr)))
library(salesforcer)

# Using OAuth 2.0 authentication
sf_auth()

# Using Basic Username-Password authentication
sf_auth(username = "test@gmail.com", 
        password = "{PASSWORD_HERE}",
        security_token = "{SECURITY_TOKEN_HERE}")
```

After logging in with `sf_auth()`, you can check your connectivity by looking at the information returned about the current user. It should be information about you!

``` r
# pull down information of person logged in
# it's a simple easy call to get started 
# and confirm a connection to the APIs
user_info <- sf_user_info()
sprintf("User Id: %s", user_info$id)
#> [1] "User Id: 0056A000000MPRjQAO"
sprintf("User Active?: %s", user_info$isActive)
#> [1] "User Active?: TRUE"
```

### Create

Salesforce has objects and those objects contain records. One default object is the "Contact" object. This example shows how to create two records in the Contact object.

``` r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object_name="Contact")
created_records
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <chr>  
#> 1 0036A00000SnhbfQAB true   
#> 2 0036A00000SnhbgQAB true
```

### Query

Salesforce has proprietary form of SQL called SOQL (Salesforce Object Query Language). SOQL is a powerful tool that allows you to return the attributes of records on almost any object in Salesforce including Accounts, Contacts, Tasks, Opportunities, even Attachments! Below is an example where we grab the data we just created including Account object information for which the Contact record is associated with. The Account column is all `NA` since we have yet to provide information to link these Contacts with Accounts.

``` r
my_soql <- sprintf("SELECT Id, 
                           Account.Name, 
                           FirstName, 
                           LastName 
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$id , collapse="','"))

queried_records <- sf_query(my_soql)
queried_records
#> # A tibble: 2 x 4
#>   Id                 Account FirstName LastName        
#> * <chr>              <lgl>   <chr>     <chr>           
#> 1 0036A00000SnhbfQAB NA      Test      Contact-Create-1
#> 2 0036A00000SnhbgQAB NA      Test      Contact-Create-2
```

### Update

After creating records you can update them using `sf_update()`. Updating a record requires you to pass the Salesforce `Id` of the record. Salesforce creates a unique 18-character identifier on each record and uses that to know which record to attach the update information you provide. Simply include a field or column in your update dataset called "Id" and the information will be matched. Here is an example where we update each of the records we created earlier with a new first name called "TestTest".

``` r
# Update some of those records
queried_records <- queried_records %>%
  mutate(FirstName = "TestTest") %>% 
  select(-Account)

updated_records <- sf_update(queried_records, object_name="Contact")
updated_records
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <chr>  
#> 1 0036A00000SnhbfQAB true   
#> 2 0036A00000SnhbgQAB true
```

### Bulk Operations

For really large operations (inserts, updates, upserts, deletes, and queries) Salesforce provides the [Bulk 1.0](https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_intro.htm) and [Bulk 2.0](https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/introduction_bulk_api_2.htm) APIs. In order to use the Bulk APIs in **salesforcer** you can just add `api_type = "Bulk 1.0"` or `api_type = "Bulk 2.0"` to your functions and the operation will be executed using the Bulk APIs. It's that simple.

The benefits of using the Bulk API for larger datasets is that the operation will reduce the number of individual API calls (organization usually have a limit on total calls) and batching the requests in bulk is usually quicker than running thousands of individuals calls when your data is large. **Note:** the Bulk 2.0 API does **NOT** guarantee the order of the data submitted is preserved in the output. This means that you must join on other data columns to match up the Ids that are returned in the output with the data you submitted. For this reason, Bulk 2.0 may not be a good solution for creating, updating, or upserting records where you need to keep track of the created Ids. The Bulk 2.0 API would be fine for deleting records where you only need to know which Ids were successfully deleted.

``` r
# create contacts using the Bulk API
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object_name="Contact", api_type="Bulk 1.0")

# query large recordsets using the Bulk API
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$Id , collapse="','"))

queried_records <- sf_query(my_soql, object_name="Contact", api_type="Bulk 1.0")

# delete these records using the Bulk API
deleted_records <- sf_delete(queried_records$Id, object_name="Contact", api_type="Bulk 1.0")
```

### Using the Metadata API

Salesforce is a very flexible platform. Salesforce provides the [Metadata API](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_intro.htm) for users to create, read, update and delete the objects, page layouts, and more. This makes it very easy to programmatically setup and teardown the Salesforce environment. One common use case for the Metadata API is retrieving information about an object (fields, permissions, etc.). You can use the `sf_read_metadata()` function to return a list of objects and their metadata. In the example below we retrieve the metadata for the Account and Contact objects. Note that the `metadata_type` argument is "CustomObject". Standard Objects are an implementation of CustomObjects, so they are returned using that metadata type.

``` r
read_obj_result <- sf_read_metadata(metadata_type='CustomObject',
                                    object_names=c('Account', 'Contact'))
read_obj_result[[1]][c('fullName', 'label', 'sharingModel', 'enableHistory')]
#> $fullName
#> [1] "Account"
#> 
#> $label
#> [1] "Account"
#> 
#> $sharingModel
#> [1] "ReadWrite"
#> 
#> $enableHistory
#> [1] "false"
first_two_fields_idx <- head(which(names(read_obj_result[[1]]) == 'fields'), 2)
# show the first two returned fields of the Account object
read_obj_result[[1]][first_two_fields_idx]
#> $fields
#> $fields$fullName
#> [1] "AccountNumber"
#> 
#> $fields$trackFeedHistory
#> [1] "false"
#> 
#> 
#> $fields
#> $fields$fullName
#> [1] "AccountSource"
#> 
#> $fields$trackFeedHistory
#> [1] "false"
#> 
#> $fields$type
#> [1] "Picklist"
```

The data is returned as a list because object definitions are highly nested representations. You may notice that we are missing some really specific details, such as, the picklist values of a field with type "Picklist". You can get that information using the function `sf_describe_object()` function which is actually part of the REST and SOAP APIs. It is recommended that you try out the various metadata functions `sf_read_metadata()`, `sf_list_metadata()`, `sf_describe_metadata()`, and `sf_describe_objects()` in order to see which information best suits your use case.

``` r
describe_obj_result <- sf_describe_objects(object_names=c('Account', 'Contact'))
describe_obj_result[[1]][c('label', 'queryable')]
#> $label
#> [1] "Account"
#> 
#> $queryable
#> [1] "true"
# show the first two returned fields of the Account object
the_type_field <- describe_obj_result[[1]][[58]]
the_type_field$name
#> [1] "Type"
map_df(the_type_field[which(names(the_type_field) == "picklistValues")], as_tibble)
#> # A tibble: 7 x 4
#>   active defaultValue label                      value                    
#>   <chr>  <chr>        <chr>                      <chr>                    
#> 1 true   false        Prospect                   Prospect                 
#> 2 true   false        Customer - Direct          Customer - Direct        
#> 3 true   false        Customer - Channel         Customer - Channel       
#> 4 true   false        Channel Partner / Reseller Channel Partner / Resell…
#> 5 true   false        Installation Partner       Installation Partner     
#> 6 true   false        Technology Partner         Technology Partner       
#> 7 true   false        Other                      Other
```

Where the Metadata API really shines is when it comes to CRUD operations on metadata. In this example we will create an object, add fields to it, then delete that object.

``` r
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
deleted_custom_object_result <- sf_delete_metadata(metadata_type = 'CustomObject', 
                                                   object_names = c('Custom_Account1__c'))
```

Future
------

Future APIs to support:

-   [Reports and Dashboards REST API](https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/api_analytics/sforce_analytics_rest_api_intro.htm)
-   [Analytics REST API](https://developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_rest.meta/bi_dev_guide_rest/bi_rest_overview.htm)

Credits
-------

This application uses other open source software components. The authentication components are mostly verbatim copies of the routines established in the **googlesheets** package (<https://github.com/jennybc/googlesheets>). Methods are inspired by the **RForcecom** package (<https://github.com/hiratake55/RForcecom>). We acknowledge and are grateful to these developers for their contributions to open source.

More Information
----------------

Salesforce provides client libraries and examples in many programming langauges (Java, Python, Ruby, and PhP) but unfortunately R is not a supported language. However, most all operations supported by the Salesforce APIs are available via this package. This package makes requests best formatted to match what the APIs require as input. This articulation is not perfect and continued progress will be made to add and improve functionality. For details on formatting, attributes, and methods please refer to [Salesforce's documentation](https://developer.salesforce.com/page/Salesforce_APIs) as they are explained better there.

More information is also available on the `pkgdown` site at <https://StevenMMortimer.github.io/salesforcer>.

[Top](#salesforcer)

------------------------------------------------------------------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
