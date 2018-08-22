---
title: "Transitioning from RForcecom"
author: "Steven M. Mortimer"
date: "2018-03-12"
output:
  rmarkdown::html_vignette:
    toc: true
    toc_depth: 4
    keep_md: true
vignette: >
  %\VignetteIndexEntry{Transitioning from RForcecom}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



While writing the **salesforcer** package we were keenly aware that many folks 
are already using the **RForcecom** package to connect to Salesforce. In order 
to foster adoption and switching between the packages **salesforcer** replicates 
the functionality of many **RForcecom** functions so that you will only need to swap 
out `library(RForcecom)` for `library(salesforcer)` and still have your production 
tested scripts perform as usual.

### Authentication

**salesforcer** supports OAuth 2.0 authentication which is preferred, but for 
backward compatibility provides the username-password authentication routine 
implemented by **RForcecom**. Here is an example running the function from 
each of the packages side-by-side and producing the same result.




```r
# the RForcecom way
session1 <- RForcecom::rforcecom.login(username, paste0(password, security_token), 
                                       apiVersion=getOption("salesforcer.api_version"))
session1['sessionID'] <- "{MASKED}"
session1
#>                      sessionID                    instanceURL 
#>                     "{MASKED}" "https://na50.salesforce.com/" 
#>                     apiVersion 
#>                         "42.0"

# replicated in salesforcer package
session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token), 
                                         apiVersion=getOption("salesforcer.api_version"))
session2['sessionID'] <- "{MASKED}"
session2
#>                      sessionID                    instanceURL 
#>                     "{MASKED}" "https://na50.salesforce.com/" 
#>                     apiVersion 
#>                         "42.0"
```



Note that we must set the API version here because calls to session will not create 
a new sessionId and then we are stuck with version 35.0 (the default from 
RForcecom::rforcecom.login). Some functions in **salesforcer** implement API calls 
that are only available after version 35.0.

### CRUD Operations

"CRUD" operations (Create, Retrieve, Update, Delete) in the **RForcecom** package 
only operate on one record at a time. One benefit to using the **salesforcer** package 
is that these operations will accept a named vector (one record) or an entire `data.frame`
or `tbl_df` of records to churn through. However, rest assured that the replicated 
functions behave exactly the same way if you are hesitant to making the switch.


```r
object <- "Contact"
fields <- c(FirstName="Test", LastName="Contact-Create-Compatibility")

# the RForcecom way
result1 <- RForcecom::rforcecom.create(session, objectName=object, fields)
result1
#>                   id success
#> 1 0036A00000cIQKmQAO    true

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
result2
#>                   id success
#> 1 0036A00000cIQKrQAO    true
```

Here is an example showing the reduction in code of using **salesforcer** if you 
would like to create multiple records.


```r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))

# the RForcecom way
rforcecom_results <- NULL
for(i in 1:nrow(new_contacts)){
  temp <- RForcecom::rforcecom.create(session, 
                                      objectName = "Contact", 
                                      fields = unlist(slice(new_contacts,i)))
  rforcecom_results <- bind_rows(rforcecom_results, temp)
}
rforcecom_results
#>                   id success
#> 1 0036A00000cIQKwQAO    true
#> 2 0036A00000cIQJuQAO    true

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_create(new_contacts, object_name="Contact")
salesforcer_results
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <chr>  
#> 1 0036A00000cIQL1QAO true   
#> 2 0036A00000cIQL2QAO true
```

### Query

**salesforcer** also has better printing and type-casting when returning query result
thanks to features of the readr package.


```r
this_soql <- "SELECT Id, Email FROM Contact LIMIT 5"

# the RForcecom way
result1 <- RForcecom::rforcecom.query(session, soqlQuery = this_soql)
result1
#>                   Id
#> 1 0036A00000SncIGQAZ
#> 2 0036A00000SncIHQAZ
#> 3 0036A00000RUqb0QAD
#> 4 0036A00000RUqedQAD
#> 5 0036A00000RUqeeQAD

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.query(session, soqlQuery = this_soql)
result2
#> # A tibble: 5 x 2
#>   Id                 Email
#> * <chr>              <lgl>
#> 1 0036A00000SncIGQAZ NA   
#> 2 0036A00000SncIHQAZ NA   
#> 3 0036A00000RUqb0QAD NA   
#> 4 0036A00000RUqedQAD NA   
#> 5 0036A00000RUqeeQAD NA

# the better way in salesforcer to query
salesforcer_results <- sf_query(this_soql)
salesforcer_results
#> # A tibble: 5 x 2
#>   Id                 Email
#> * <chr>              <lgl>
#> 1 0036A00000SncIGQAZ NA   
#> 2 0036A00000SncIHQAZ NA   
#> 3 0036A00000RUqb0QAD NA   
#> 4 0036A00000RUqedQAD NA   
#> 5 0036A00000RUqeeQAD NA
```

### Describe

The **RForcecom** package has the function `rforcecom.getObjectDescription()` which returns 
a `data.frame` with one row per field on an object. The same function in **salesforcer** 
is named `sf_describe_object_fields()` and also has better printing and datatype 
casting by using tibbles.


```r
# the RForcecom way
result1 <- RForcecom::rforcecom.getObjectDescription(session, objectName='Account')

# backwards compatible in the salesforcer package
result2 <- salesforcer::rforcecom.getObjectDescription(session, objectName='Account')

# the better way in salesforcer to get object fields
result3 <- salesforcer::sf_describe_object_fields('Account')
#> Parsed with column specification:
#> cols(
#>   .default = col_character(),
#>   byteLength = col_double(),
#>   digits = col_double(),
#>   length = col_double(),
#>   precision = col_double(),
#>   scale = col_double()
#> )
#> See spec(...) for full column specifications.
result3
#> # A tibble: 67 x 166
#>    aggregatable autoNumber byteLength calculated caseSensitive createable
#>    <chr>        <chr>           <dbl> <chr>      <chr>         <chr>     
#>  1 true         false             18. false      false         false     
#>  2 false        false              0. false      false         false     
#>  3 true         false             18. false      false         false     
#>  4 true         false            765. false      false         true      
#>  5 true         false            120. false      false         true      
#>  6 true         false             18. false      false         true      
#>  7 true         false            765. false      false         true      
#>  8 true         false            120. false      false         true      
#>  9 true         false            240. false      false         true      
#> 10 true         false             60. false      false         true      
#> # ... with 57 more rows, and 160 more variables: custom <chr>,
#> #   defaultedOnCreate <chr>, deprecatedAndHidden <chr>, digits <dbl>,
#> #   filterable <chr>, groupable <chr>, idLookup <chr>, label <chr>,
#> #   length <dbl>, name <chr>, nameField <chr>, namePointing <chr>,
#> #   nillable <chr>, permissionable <chr>, polymorphicForeignKey <chr>,
#> #   precision <dbl>, queryByDistance <chr>, restrictedPicklist <chr>,
#> #   scale <dbl>, searchPrefilterable <chr>, soapType <chr>,
#> #   sortable <chr>, type <chr>, unique <chr>, updateable <chr>,
#> #   defaultValue.text <chr>, defaultValue..attrs <chr>, referenceTo <chr>,
#> #   relationshipName <chr>, compoundFieldName <chr>, extraTypeInfo <chr>,
#> #   picklistValues.active <chr>, picklistValues.defaultValue <chr>,
#> #   picklistValues.label <chr>, picklistValues.value <chr>,
#> #   picklistValues.active.1 <chr>, picklistValues.defaultValue.1 <chr>,
#> #   picklistValues.label.1 <chr>, picklistValues.value.1 <chr>,
#> #   picklistValues.active.2 <chr>, picklistValues.defaultValue.2 <chr>,
#> #   picklistValues.label.2 <chr>, picklistValues.value.2 <chr>,
#> #   picklistValues.active.3 <chr>, picklistValues.defaultValue.3 <chr>,
#> #   picklistValues.label.3 <chr>, picklistValues.value.3 <chr>,
#> #   picklistValues.active.4 <chr>, picklistValues.defaultValue.4 <chr>,
#> #   picklistValues.label.4 <chr>, picklistValues.value.4 <chr>,
#> #   picklistValues.active.5 <chr>, picklistValues.defaultValue.5 <chr>,
#> #   picklistValues.label.5 <chr>, picklistValues.value.5 <chr>,
#> #   picklistValues.active.6 <chr>, picklistValues.defaultValue.6 <chr>,
#> #   picklistValues.label.6 <chr>, picklistValues.value.6 <chr>,
#> #   picklistValues.active.7 <chr>, picklistValues.defaultValue.7 <chr>,
#> #   picklistValues.label.7 <chr>, picklistValues.value.7 <chr>,
#> #   picklistValues.active.8 <chr>, picklistValues.defaultValue.8 <chr>,
#> #   picklistValues.label.8 <chr>, picklistValues.value.8 <chr>,
#> #   picklistValues.active.9 <chr>, picklistValues.defaultValue.9 <chr>,
#> #   picklistValues.label.9 <chr>, picklistValues.value.9 <chr>,
#> #   picklistValues.active.10 <chr>, picklistValues.defaultValue.10 <chr>,
#> #   picklistValues.label.10 <chr>, picklistValues.value.10 <chr>,
#> #   picklistValues.active.11 <chr>, picklistValues.defaultValue.11 <chr>,
#> #   picklistValues.label.11 <chr>, picklistValues.value.11 <chr>,
#> #   picklistValues.active.12 <chr>, picklistValues.defaultValue.12 <chr>,
#> #   picklistValues.label.12 <chr>, picklistValues.value.12 <chr>,
#> #   picklistValues.active.13 <chr>, picklistValues.defaultValue.13 <chr>,
#> #   picklistValues.label.13 <chr>, picklistValues.value.13 <chr>,
#> #   picklistValues.active.14 <chr>, picklistValues.defaultValue.14 <chr>,
#> #   picklistValues.label.14 <chr>, picklistValues.value.14 <chr>,
#> #   picklistValues.active.15 <chr>, picklistValues.defaultValue.15 <chr>,
#> #   picklistValues.label.15 <chr>, picklistValues.value.15 <chr>,
#> #   picklistValues.active.16 <chr>, picklistValues.defaultValue.16 <chr>,
#> #   picklistValues.label.16 <chr>, picklistValues.value.16 <chr>,
#> #   picklistValues.active.17 <chr>, …
```

In the future more features will be migrated from **RForcecom** to make the 
transition as seamless as possible.
