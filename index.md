
[![Build Status](https://travis-ci.org/StevenMMortimer/salesforcer.svg?branch=master)](https://travis-ci.org/StevenMMortimer/salesforcer) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/StevenMMortimer/salesforcer?branch=master&svg=true)](https://ci.appveyor.com/project/StevenMMortimer/salesforcer) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/salesforcer)](http://cran.r-project.org/package=salesforcer) [![Coverage Status](https://codecov.io/gh/StevenMMortimer/salesforcer/branch/master/graph/badge.svg)](https://codecov.io/gh/StevenMMortimer/salesforcer?branch=master)

<br> <img src="man/figures/logo.png" align="right" />

**salesforcer** is an R package that connects to Salesforce APIs using tidy principles. The package implements most actions from the SOAP, REST and Bulk APIs.

Package features include:

-   OAuth 2.0 and Basic authentication methods (`sf_auth()`)
-   CRUD operations (Create, Retrieve, Update, Delete) methods for REST and Bulk APIs
-   Query operations via REST and Bulk APIs (`sf_query()`)
-   Backwards compatible functions from the **RForcecom** package, such as:
    -   `rforcecom.login()`, `rforcecom.query()`, `rforcecom.create()`, `rforcecom.update()`
-   Basic utility calls (`sf_user_info()`, `sf_server_timestamp()`, `sf_list_objects()`)

Table of Contents
-----------------

-   [Installation](#installation)
-   [Usage](#usage)
    -   [Authenticate](#authenticate)
    -   [Create](#create)
    -   [Retrieve](#retrieve)
    -   [Query](#query)
    -   [Update](#update)
    -   [Delete](#delete)
    -   [Upsert](#upsert)
    -   [Using the Bulk API](#using-the-bulk-api)
    -   [Accessing Metadata](#accessing-metadata)
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

If you encounter a clear bug, please file a minimal reproducible example on [github](https://github.com/StevenMMortimer/salesforcer/issues).

Usage
-----

### Authenticate

First, load the `salesforcer` package and login. There are two ways to authenticate: 1) OAuth 2.0 and 2) Basic Username-Password. It is recommended to use OAuth 2.0 so that passwords do not have to be shared/embedded within scripts. User credentials will be stored in locally cached file entitled ".httr-oauth" in the current working directory.

``` r
suppressWarnings(suppressMessages(library(dplyr)))
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
#> Auto-refreshing stale OAuth token.
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
created_records <- sf_create(new_contacts, "Contact")
created_records
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000Pt0qFQAR TRUE    <list [0]>
#> 2 0036A00000Pt0qGQAR TRUE    <list [0]>
```

### Retrieve

Retrieve pulls down a specific set of records and fields. It's very similar to running a query, but doesn't use SOQL. Here is an example where we retrieve the data we just created.

``` r
retrieved_records <- sf_retrieve(ids=created_records$id, 
                                 fields=c("FirstName", "LastName"), 
                                 object="Contact")
retrieved_records
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0036A00000Pt0qFQAR Test      Contact-Create-1
#> 2 0036A00000Pt0qGQAR Test      Contact-Create-2
```

### Query

Query is a little more flexible requires knowledge of Salesforcer's proprietary form of SQL called SOQL (Salesforcer Object Query Language). Here is an example where we also grab the data we just created.

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
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0036A00000Pt0qFQAR Test      Contact-Create-1
#> 2 0036A00000Pt0qGQAR Test      Contact-Create-2
```

### Update

After creating records you can update them using `sf_update()`. Updating a record requires you to pass the Salesforce `Id` of the record. Salesforce uses unique 18-character identifiers for each record and uses that to know which record to update with the information you provide. Simply include a field or column in your dataset called "Id" so the API can find the record and update with the fields you provide. Here is an example where we update the records we created earlier.

``` r
# Update some of those records
queried_records <- queried_records %>%
  mutate(FirstName = "TestTest")

updated_records <- sf_update(queried_records, object="Contact")
updated_records
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000Pt0qFQAR TRUE    <list [0]>
#> 2 0036A00000Pt0qGQAR TRUE    <list [0]>
```

### Delete

You can also delete records in Salesforce. The method implements a "soft" delete meaning that the deleted records go to the Recycle Bin which can be emptied or queried against later in the event that the record needed.

``` r
deleted_records <- sf_delete(updated_records$id)
deleted_records
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000Pt0qFQAR TRUE    <list [0]>
#> 2 0036A00000Pt0qGQAR TRUE    <list [0]>
```

### Upsert

Finally, Salesforce has a unique method called "upsert" that allows you to create and/or update records at the same time. More specifically, if the record is not found based an an "External Id" field, then Salesforce will create the record instead of updating one. Below is an example where we create 2 records, then upsert 3, where 2 are matched and updated and one is created. **NOTE**: You will need to create a custom field on the target object and ensure it is labeled as an "External Id" field. Read more at <http://blog.jeffdouglas.com/2010/05/07/using-exernal-id-fields-in-salesforce/>.

``` r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n), 
                       My_External_Id__c=letters[1:n])
created_records <- sf_create(new_contacts, "Contact")

upserted_contacts <- tibble(FirstName = rep("Test", n),
                            LastName = paste0("Contact-Upsert-", 1:n), 
                            My_External_Id__c=letters[1:n])
new_record <- tibble(FirstName = "Test",
                     LastName = paste0("Contact-Upsert-", n+1), 
                     My_External_Id__c=letters[n+1])
upserted_contacts <- bind_rows(upserted_contacts, new_record)

upserted_records <- sf_upsert(input_data=upserted_contacts, 
                              object="Contact", 
                              external_id_fieldname="My_External_Id__c")
upserted_records
#> # A tibble: 3 x 3
#>   created id                 success
#>   <chr>   <chr>              <chr>  
#> 1 false   0036A00000Pt0qKQAR true   
#> 2 false   0036A00000Pt0qLQAR true   
#> 3 true    0036A00000Pt0qPQAR true
```

### Using the Bulk API

For really large inserts, updates, deletes, upserts, queries you can just add "api\_type" = "Bulk" to most functions to get the benefits of using the Bulk API instead of the SOAP or REST APIs.

``` r
# just add api_type="Bulk" to most calls!
# create bulk
object <- "Contact"
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object, api_type="Bulk")

# query bulk
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$successfulResults$sf__Id , collapse="','"))

queried_records <- sf_query(my_soql, object=object, api_type="Bulk")

# delete bulk
deleted_records <- sf_delete(queried_records$Id, object=object, api_type="Bulk")
```

### Accessing Metadata

In future iterations of the package **salesforcer** will connect to the Metadata API; however, currently, there are RESTful calls that will return metatdata.

``` r
#sf_describe_global()
#sf_describe_object()
#sf_describe_layout()
#sf_describe_tabs()
```

Future
------

Future APIs to support:

-   Async
-   Metadata
-   Reporting
-   Analytics

Credits
-------

This application uses other open source software components. The authentication components are mostly verbatim copies of the routines established in the **googlesheets** package (<https://github.com/jennybc/googlesheets>). Methods are inspired by the **RForcecom** package (<https://github.com/hiratake55/RForcecom>). We acknowledge and are grateful to these developers for their contributions to open source.
