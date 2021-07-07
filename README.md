
# salesforcer<img src="man/figures/salesforcer.png" width="120px" align="right" />

<!-- badges: start -->

[![R Build
Status](https://github.com/stevenmmortimer/salesforcer/workflows/R-CMD-check/badge.svg)](https://github.com/stevenmmortimer/salesforcer/actions?workflow=R-CMD-check)
[![CRAN
Status](https://www.r-pkg.org/badges/version/salesforcer)](https://cran.r-project.org/package=salesforcer)
[![Lifecycle:
Stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![Monthly
Downloads](https://cranlogs.r-pkg.org/badges/last-month/salesforcer)](https://cran.r-project.org/package=salesforcer)
[![Coverage
Status](https://codecov.io/gh/stevenmmortimer/salesforcer/branch/main/graph/badge.svg)](https://codecov.io/gh/stevenmmortimer/salesforcer?branch=main)
<!-- badges: end -->

{salesforcer} is an R package that connects to Salesforce Platform APIs
using tidy principles. The package implements actions from the REST,
SOAP, Bulk 1.0, Bulk 2.0, Reports and Dashboards, and Metadata APIs.

Package features include:

  - OAuth 2.0 (Single Sign On) and Basic (Username-Password)
    Authentication methods (`sf_auth()`)
  - CRUD (Create, Retrieve, Update, Delete) methods for records using
    the SOAP, REST, and Bulk APIs
  - Query records via the SOAP, REST, Bulk 1.0, and Bulk 2.0 APIs using
    `sf_query()`
  - Manage and execute reports and dashboards with:
      - `sf_list_reports()`, `sf_create_report()`, `sf_run_report()`,
        and more
  - Retrieve and modify metadata (Custom Objects, Fields, etc.) using
    the Metadata API with:
      - `sf_describe_objects()`, `sf_create_metadata()`,
        `sf_update_metadata()`, and more
  - Utilize backwards compatible functions for the {RForcecom} package,
    such as:
      - `rforcecom.login()`, `rforcecom.getObjectDescription()`,
        `rforcecom.query()`, `rforcecom.create()`
  - Basic utility calls (`sf_user_info()`, `sf_server_timestamp()`,
    `sf_list_objects()`)
  - Functions to assist with master data management (MDM) or data
    integrity of records by finding duplicates (`sf_find_duplicates()`,
    `sf_find_duplicates_by_id()`), merging records (`sf_merge()`), and
    converting leads (`sf_convert_lead()`)
  - Recover (`sf_undelete()`) or delete from the Recycle Bin
    (`sf_empty_recycle_bin()`) and list ids of records deleted
    (`sf_get_deleted()`) or updated (`sf_get_updated()`) within a
    specific timeframe
  - Passing API call control parameters such as, “All or None”,
    “Duplicate Rule”, “Assignment Rule” execution and many more\!

## Table of Contents

  - [Installation](#installation)
  - [Vignettes](#vignettes)
  - [Usage](#usage)
      - [Authenticate](#authenticate)
      - [Create](#create)
      - [Query](#query)
      - [Update](#update)
      - [Bulk Operations](#bulk-operations)
      - [Using the Metadata API](#using-the-metadata-api)
  - [Future](#future)
  - [Credits](#credits)
  - [More Information](#more-information)

## Installation

``` r
# install the current CRAN version (1.0.0)
install.packages("salesforcer")

# or get the development version on GitHub
# install.packages("remotes")
remotes::install_github("StevenMMortimer/salesforcer")
```

If you encounter an issue while using this package, please file a
minimal reproducible example on
[GitHub](https://github.com/stevenmmortimer/salesforcer/issues).

## Vignettes

The README below outlines the basic package functionality. For more
information please feel free to browse the {salesforcer} website at
<https://stevenmmortimer.github.io/salesforcer/> which contains the
following vignettes:

  - [Getting
    Started](https://stevenmmortimer.github.io/salesforcer/articles/getting-started.html)
  - [Supported
    Queries](https://stevenmmortimer.github.io/salesforcer/articles/supported-queries.html)
  - [Working with Bulk
    APIs](https://stevenmmortimer.github.io/salesforcer/articles/working-with-bulk-apis.html)
  - [Working with
    Reports](https://stevenmmortimer.github.io/salesforcer/articles/working-with-reports.html)
  - [Working with
    Attachments](https://stevenmmortimer.github.io/salesforcer/articles/working-with-attachments.html)
  - [Working with
    Metadata](https://stevenmmortimer.github.io/salesforcer/articles/working-with-metadata.html)
  - [Passing Control
    Args](https://stevenmmortimer.github.io/salesforcer/articles/passing-control-args.html)
  - [Transitioning from
    RForcecom](https://stevenmmortimer.github.io/salesforcer/articles/transitioning-from-RForcecom.html)

## Usage

### Authenticate

First, load the {salesforcer} package and login. There are two ways to
authenticate:

1.  OAuth 2.0
2.  Basic Username-Password

It is recommended to use OAuth 2.0 so that passwords do not have to be
shared or embedded within scripts. User credentials will be stored in
locally cached file entitled “.httr-oauth-salesforcer” in the current
working directory. Also, note that if you use OAuth 2.0 authentication
then the package will automatically refresh it so you will not have to
call `sf_auth()` during each session if you have a cached
“.httr-oauth-salesforcer” file in the working directory. The cache
file is named that way to not conflict with the “.httr-oauth” files
created by other packages.

``` r
library(dplyr, warn.conflicts = FALSE)
library(salesforcer)

# Using OAuth 2.0 authentication
sf_auth()

# Using Basic Username-Password authentication
sf_auth(username = "test@gmail.com", 
        password = "{PASSWORD_HERE}",
        security_token = "{SECURITY_TOKEN_HERE}")
```

After logging in with `sf_auth()`, you can check your connectivity by
looking at the information returned about the current user. It should be
information about you\!

``` r
# pull down information of person logged in
# it's a simple easy call to get started 
# and confirm a connection to the APIs
user_info <- sf_user_info()
sprintf("Organization Id: %s", user_info$organizationId)
#> [1] "Organization Id: 00D6A0000003dN3UAI"
sprintf("User Id: %s", user_info$userId)
#> [1] "User Id: 0056A000000MPRjQAO"
```

### Create

Salesforce has objects and those objects contain records. One default
object is the “Contact” object. This example shows how to create two
records in the Contact object.

``` r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object_name = "Contact")
created_records
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <lgl>  
#> 1 0033s000014AgdIAAS TRUE   
#> 2 0033s000014AgdJAAS TRUE
```

### Query

Salesforce has proprietary form of SQL called SOQL (Salesforce Object
Query Language). SOQL is a powerful tool that allows you to return the
attributes of records on almost any object in Salesforce including
Accounts, Contacts, Tasks, Opportunities, even Attachments\! Below is an
example where we grab the data we just created including Account object
information for which the Contact record is associated with.

``` r
my_soql <- sprintf("SELECT Id, 
                           Account.Name, 
                           FirstName, 
                           LastName 
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$id , collapse = "','"))
queried_records <- sf_query(my_soql)
queried_records
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0033s000014AgdIAAS Test      Contact-Create-1
#> 2 0033s000014AgdJAAS Test      Contact-Create-2
```

**NOTE**: In the example above, you’ll notice that the `"Account.Name"`
column does not appear in the results. This is because the SOAP and REST
APIs only return an empty Account object for the record if there is no
relationship to an account (see
<a rel="noopener noreferrer" target="_blank"
href="https://github.com/stevenmmortimer/salesforcer/issues/78">\#78</a>).
There is no reliable way to extract and rebuild the empty columns based
on the query string. If there were Account information, an additional
column titled `"Account.Name"` would appear in the results. Note, that
the Bulk 1.0 and Bulk 2.0 APIs will return `"Account.Name"` as a column
of all `NA` values for this query because they return results
differently.

### Update

After creating records you can update them using `sf_update()`. Updating
a record requires you to pass the Salesforce `Id` of the record.
Salesforce creates a unique 18-character identifier on each record and
uses that to know which record to attach the update information you
provide. Simply include a field or column in your update dataset called
“Id” and the information will be matched. Here is an example where we
update each of the records we created earlier with a new first name
called “TestTest”.

``` r
# Update some of those records
queried_records <- queried_records %>%
  mutate(FirstName = "TestTest")

updated_records <- sf_update(queried_records, object_name = "Contact")
updated_records
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <lgl>  
#> 1 0033s000014AgdIAAS TRUE   
#> 2 0033s000014AgdJAAS TRUE
```

### Bulk Operations

For really large operations (inserts, updates, upserts, deletes, and
queries) Salesforce provides the
[Bulk 1.0](https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/asynch_api_intro.htm)
and
[Bulk 2.0](https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/introduction_bulk_api_2.htm)
APIs. In order to use the Bulk APIs in {salesforcer} you can just add
`api_type = "Bulk 1.0"` or `api_type = "Bulk 2.0"` to your functions and
the operation will be executed using the Bulk APIs. It’s that simple.

The benefits of using the Bulk API for larger datasets is that the
operation will reduce the number of individual API calls (organization
usually have a limit on total calls) and batching the requests in bulk
is usually quicker than running thousands of individuals calls when your
data is large. **Note:** the Bulk 2.0 API does **NOT** guarantee the
order of the data submitted is preserved in the output. This means that
you must join on other data columns to match up the Ids that are
returned in the output with the data you submitted. For this reason,
Bulk 2.0 may not be a good solution for creating, updating, or upserting
records where you need to keep track of the created Ids. The Bulk 2.0
API would be fine for deleting records where you only need to know which
Ids were successfully deleted.

``` r
# create contacts using the Bulk API
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, "Contact", api_type = "Bulk 1.0")
created_records
#> # A tibble: 2 x 4
#>   Id                 Success Created Error
#>   <chr>              <lgl>   <lgl>   <lgl>
#> 1 0033s000014AgfhAAC TRUE    TRUE    NA   
#> 2 0033s000014AgfiAAC TRUE    TRUE    NA

# query large recordsets using the Bulk API
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$Id , collapse = "','"))

queried_records <- sf_query(my_soql, "Contact", api_type = "Bulk 1.0")
queried_records
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0033s000014AgfhAAC Test      Contact-Create-1
#> 2 0033s000014AgfiAAC Test      Contact-Create-2

# delete these records using the Bulk 2.0 API
deleted_records <- sf_delete(queried_records$Id, "Contact", api_type = "Bulk 2.0")
deleted_records
#> # A tibble: 2 x 4
#>   Id                 sf__Id             sf__Created sf__Error
#>   <chr>              <chr>              <lgl>       <lgl>    
#> 1 0033s000014AgfhAAC 0033s000014AgfhAAC FALSE       NA       
#> 2 0033s000014AgfiAAC 0033s000014AgfiAAC FALSE       NA
```

### Using the Metadata API

Salesforce is a very flexible platform in that it provides the [Metadata
API](https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_intro.htm)
for users to create, read, update and delete their entire Salesforce
environment from objects to page layouts and more. This makes it very
easy to programmatically setup and teardown the Salesforce environment.
One common use case for the Metadata API is retrieving information about
an object (fields, permissions, etc.). You can use the
`sf_read_metadata()` function to return a list of objects and their
metadata. In the example below we retrieve the metadata for the Account
and Contact objects. Note that the `metadata_type` argument is
“CustomObject”. Standard Objects are an implementation of
CustomObjects, so they are returned using that metadata type.

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

The data is returned as a list because object definitions are highly
nested representations. You may notice that we are missing some really
specific details, such as, the picklist values of a field with type
“Picklist”. You can get that information using
`sf_describe_object_fields()`. Here is an example using
`sf_describe_object_fields()` where we get a `tbl_df` with one row for
each field on the Account object:

``` r
acct_fields <- sf_describe_object_fields('Account')
acct_fields %>% select(name, label, length, soapType, type)
#> # A tibble: 68 x 5
#>   name           label            length soapType    type     
#>   <chr>          <chr>            <chr>  <chr>       <chr>    
#> 1 Id             Account ID       18     tns:ID      id       
#> 2 IsDeleted      Deleted          0      xsd:boolean boolean  
#> 3 MasterRecordId Master Record ID 18     tns:ID      reference
#> 4 Name           Account Name     255    xsd:string  string   
#> 5 Type           Account Type     40     xsd:string  picklist 
#> # … with 63 more rows

# show the picklist selection options for the Account Type field
acct_fields %>% 
  filter(label == "Account Type") %>% 
  .$picklistValues
#> [[1]]
#> # A tibble: 7 x 4
#>   active defaultValue label                      value                     
#>   <chr>  <chr>        <chr>                      <chr>                     
#> 1 true   false        Prospect                   Prospect                  
#> 2 true   false        Customer - Direct          Customer - Direct         
#> 3 true   false        Customer - Channel         Customer - Channel        
#> 4 true   false        Channel Partner / Reseller Channel Partner / Reseller
#> 5 true   false        Installation Partner       Installation Partner      
#> # … with 2 more rows
```

## Future

Future APIs to support (roughly in priority order):

  - [Connect (Chatter) REST
    API](https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/intro_what_is_chatter_connect.htm)
  - [Analytics External Data
    API](https://developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_ext_data.meta/bi_dev_guide_ext_data/bi_ext_data_overview.htm)
  - [Analytics REST
    API](https://developer.salesforce.com/docs/atlas.en-us.bi_dev_guide_rest.meta/bi_dev_guide_rest/bi_rest_overview.htm)
  - [Tooling
    API](https://developer.salesforce.com/docs/atlas.en-us.api_tooling.meta/api_tooling/intro_api_tooling.htm)
  - [Actions
    API](https://developer.salesforce.com/docs/atlas.en-us.api_action.meta/api_action/actions_intro.htm)
  - [Streaming
    API](https://developer.salesforce.com/docs/atlas.en-us.api_streaming.meta/api_streaming/intro_stream.htm)
  - [Place Order
    API](https://developer.salesforce.com/docs/atlas.en-us.api_placeorder.meta/api_placeorder/sforce_placeorder_rest_api_intro.htm)
  - [Industries
    API](https://developer.salesforce.com/docs/atlas.en-us.api_rest_industries.meta/api_rest_industries/intro.htm)
  - [Data.com
    API](https://developer.salesforce.com/docs/atlas.en-us.datadotcom_api_dev_guide.meta/datadotcom_api_dev_guide/datadotcom_api_dev_guide_intro.htm)

## Credits

This application uses other open source software components. The
authentication components are mostly verbatim copies of the routines
established in the {googlesheets} package
(<https://github.com/jennybc/googlesheets>). Methods are inspired by the
{RForcecom} package (<https://github.com/hiratake55/RForcecom>). We
acknowledge and are grateful to these developers for their contributions
to open source.

## More Information

Salesforce provides client libraries and examples in many programming
languages (Java, Python, Ruby, and PhP) but unfortunately R is not a
supported language. However, most all operations supported by the
Salesforce APIs are available via this package. This package makes
requests best formatted to match what the APIs require as input. This
articulation is not perfect and continued progress will be made to add
and improve functionality. For details on formatting, attributes, and
methods please refer to [Salesforce’s
documentation](https://trailhead.salesforce.com/en/content/learn/modules/api_basics/api_basics_overview)
as they are explained better there. More information is also available
on the {salesforcer} pkgdown website at
<https://stevenmmortimer.github.io/salesforcer/>.

[Get supported salesforcer with the Tidelift
Subscription](https://tidelift.com/subscription/pkg/cran-salesforcer?utm_source=cran-salesforcer&utm_medium=referral&utm_campaign=readme)

-----

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/stevenmmortimer/salesforcer/blob/main/.github/CODE_OF_CONDUCT.md).
By participating in this project you agree to abide by its terms.

[Top](#salesforcer)
