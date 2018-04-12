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
#> 1 0036A00000SncEYQAZ    true

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
result2
#>                   id success
#> 1 0036A00000SncEdQAJ    true
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
#> 1 0036A00000SncEiQAJ    true
#> 2 0036A00000SncEnQAJ    true

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_create(new_contacts, object_name="Contact")
salesforcer_results
#> # A tibble: 2 x 2
#>   id                 success
#>   <chr>              <chr>  
#> 1 0036A00000SncELQAZ true   
#> 2 0036A00000SncEMQAZ true
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
#> 1 0036A00000RUqb0QAD
#> 2 0036A00000RUqedQAD
#> 3 0036A00000RUqeeQAD
#> 4 0036A00000RUpmQQAT
#> 5 0036A00000RUpnnQAD

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.query(session, soqlQuery = this_soql)
result2
#> # A tibble: 5 x 2
#>   Id                 Email
#> * <chr>              <lgl>
#> 1 0036A00000RUqb0QAD NA   
#> 2 0036A00000RUqedQAD NA   
#> 3 0036A00000RUqeeQAD NA   
#> 4 0036A00000RUpmQQAT NA   
#> 5 0036A00000RUpnnQAD NA

# the better way in salesforcer to query
salesforcer_results <- sf_query(this_soql)
salesforcer_results
#> # A tibble: 5 x 2
#>   Id                 Email
#> * <chr>              <lgl>
#> 1 0036A00000RUqb0QAD NA   
#> 2 0036A00000RUqedQAD NA   
#> 3 0036A00000RUqeeQAD NA   
#> 4 0036A00000RUpmQQAT NA   
#> 5 0036A00000RUpnnQAD NA
```

In the future more features will be migrated from **RForcecom** to make the 
transition as seamless as possible.
