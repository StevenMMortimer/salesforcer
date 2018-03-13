---
title: "Transitioning from RForcecom"
author: "Steven M. Mortimer"
date: "2018-03-13"
output:
  rmarkdown::html_vignette:
    toc: true
    toc_depth: 4
    keep_md: true
vignette: >
  %\VignetteIndexEntry{Getting Started}
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
suppressWarnings(suppressMessages(library(dplyr)))
library(salesforcer)

# the RForcecom way
session1 <- RForcecom::rforcecom.login(username, paste0(password, security_token), 
                                       apiVersion=getOption("salesforcer.api_version"))
session1
#>                                                                                                          sessionID 
#> "00D6A0000003dN3!ARwAQPf4z8mXIWC8BQV.8IYAkyXl3tnHE7QHwIeOGPseY7hXAk6Gd9.2foHHo46li31WGQ9rCDmaiCfafHBjnojtTBlnJ06T" 
#>                                                                                                        instanceURL 
#>                                                                                     "https://na50.salesforce.com/" 
#>                                                                                                         apiVersion 
#>                                                                                                             "42.0"

# replicated in salesforcer package
session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token), 
                                         apiVersion=getOption("salesforcer.api_version"))
session2
#>                                                                                                          sessionID 
#> "00D6A0000003dN3!ARwAQPf4z8mXIWC8BQV.8IYAkyXl3tnHE7QHwIeOGPseY7hXAk6Gd9.2foHHo46li31WGQ9rCDmaiCfafHBjnojtTBlnJ06T" 
#>                                                                                                        instanceURL 
#>                                                                                     "https://na50.salesforce.com/" 
#>                                                                                                         apiVersion 
#>                                                                                                             "42.0"
```



Note that we must set the API version here because  calls to session will not create 
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
#> 1 0036A00000Pt0OpQAJ    true

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
result2
#>                   id success
#> 1 0036A00000Pt0OuQAJ    TRUE
```

Here is an example showing the reduction in code of using **salesforcer** if you 
would like to create multiple records.


```r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
rforcecom_results <- NULL
# the RForcecom way
for(i in 1:nrow(new_contacts)){
  temp <- RForcecom::rforcecom.create(session, 
                                      objectName = "Contact", 
                                      fields = unlist(slice(new_contacts,i)))
  rforcecom_results <- bind_rows(rforcecom_results, temp)
}
rforcecom_results
#>                   id success
#> 1 0036A00000Pt0OzQAJ    true
#> 2 0036A00000Pt0LhQAJ    true

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_create(new_contacts, "Contact")
salesforcer_results
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000Pt0P4QAJ TRUE    <list [0]>
#> 2 0036A00000Pt0P5QAJ TRUE    <list [0]>
```

### Query

**salesforcer** also has better printing and type-casting when returning query result
thanks to features of the readr package.


```r
this_soql <- "SELECT Id, Email FROM Contact"

# the RForcecom way
result1 <- RForcecom::rforcecom.query(session, soqlQuery = this_soql)
result1
#>                     Id                     Email
#> 1   0036A000002C6MWQA0             rose@edge.com
#> 2   0036A000002C6MXQA0             sean@edge.com
#> 3   0036A000002C6MYQA0    jrogers@burlington.com
#> 4   0036A000002C6MbQAK  barr_tim@grandhotels.com
#> 5   0036A000002C6McQAK bond_john@grandhotels.com
#> 6   0036A000002C6MdQAK          spavlova@uog.com
#> 7   0036A000002C6MeQAK            lboyle@uog.com
#> 8   0036A000002C6MfQAK     b.levy@expressl&t.net
#> 9   0036A000002C6MgQAK    j.davis@expressl&t.net
#> 10  0036A000002C6MhQAK         jane_gray@uoa.edu
#> 11  0036A000002C6MjQAK            ajames@uog.com
#> 12  0036A000002C6MkQAK           tripley@uog.com
#> 13  0036A000002C6MlQAK            ldcruz@uog.com
#> 14  0036A000002C6MmQAK      efrank@genepoint.com
#> 15  0036A000002C6MnQAK            agreen@uog.com
#> 16  0036A00000PsxokQAB                      <NA>
#> 17  0036A00000Psy2mQAB                      <NA>
#> 18  0036A00000Psy3GQAR                      <NA>
#> 19  0036A00000Psy3pQAB                      <NA>
#> 20  0036A00000Psxl2QAB                      <NA>
#> 21  0036A00000Psxl3QAB                      <NA>
#> 22  0036A00000PsxmtQAB                      <NA>
#> 23  0036A00000PsxnXQAR                      <NA>
#> 24  0036A00000Psxp6QAB                      <NA>
#> 25  0036A00000PsxsDQAR                      <NA>
#> 26  0036A00000PsxudQAB                      <NA>
#> 27  0036A00000Psy1ZQAR                      <NA>
#> 28  0036A00000Psy3LQAR                      <NA>
#> 29  0036A00000PsyBfQAJ                      <NA>
#> 30  0036A00000PsyDzQAJ                      <NA>
#> 31  0036A00000PsyBhQAJ                      <NA>
#> 32  0036A00000Pt0LbQAJ                      <NA>
#> 33  0036A00000Pt0LgQAJ                      <NA>
#> 34  0036A00000Pt0MoQAJ                      <NA>
#> 35  0036A00000Pt0MyQAJ                      <NA>
#> 36  0036A00000Pt0OzQAJ                      <NA>
#> 37  0036A00000Pt0LhQAJ                      <NA>
#> 38  0036A00000Pt0MtQAJ                      <NA>
#> 39  0036A00000PsxmoQAB                      <NA>
#> 40  0036A00000Pt0LTQAZ                      <NA>
#> 41  0036A00000Pt0LUQAZ                      <NA>
#> 42  0036A00000PsxrtQAB                      <NA>
#> 43  0036A00000PsxrKQAR                      <NA>
#> 44  0036A00000PsxofQAB                      <NA>
#> 45  0036A00000Pt0LlQAJ                      <NA>
#> 46  0036A00000PsyDGQAZ                      <NA>
#> 47  0036A00000PsxjMQAR                      <NA>
#> 48  0036A00000Psxm5QAB                      <NA>
#> 49  0036A00000Pt0P4QAJ                      <NA>
#> 50  0036A00000Pt0P5QAJ                      <NA>
#> 51  0036A00000PsxqCQAR                      <NA>
#> 52  0036A00000PsyEdQAJ                      <NA>
#> 53  0036A00000PsxswQAB                      <NA>
#> 54  0036A00000Pt0LvQAJ                      <NA>
#> 55  0036A00000Pt0LwQAJ                      <NA>
#> 56  0036A00000Pt0MjQAJ                      <NA>
#> 57  0036A00000PsxnSQAR                      <NA>
#> 58  0036A00000Psxo1QAB                      <NA>
#> 59  0036A00000Psxo6QAB                      <NA>
#> 60  0036A00000PsxpEQAR                      <NA>
#> 61  0036A00000PsxnnQAB                      <NA>
#> 62  0036A00000PsxqgQAB                      <NA>
#> 63  0036A00000PsxsrQAB                      <NA>
#> 64  0036A00000Psy1eQAB                      <NA>
#> 65  0036A00000Psy2hQAB                      <NA>
#> 66  0036A00000Psy1fQAB                      <NA>
#> 67  0036A00000PsyDbQAJ                      <NA>
#> 68  0036A00000Pt0NmQAJ                      <NA>
#> 69  0036A00000Pt0MCQAZ                      <NA>
#> 70  0036A00000Pt0MDQAZ                      <NA>
#> 71  0036A00000PsyEaQAJ                      <NA>
#> 72  0036A00000Psxm0QAB                      <NA>
#> 73  0036A00000Psy2DQAR                      <NA>
#> 74  0036A00000PsyCmQAJ                      <NA>
#> 75  0036A00000PsxsIQAR                      <NA>
#> 76  0036A00000PsxuiQAB                      <NA>
#> 77  0036A00000PsyFCQAZ                      <NA>
#> 78  0036A00000Pt0M0QAJ                      <NA>
#> 79  0036A00000Pt0M1QAJ                      <NA>
#> 80  0036A00000Pt0OpQAJ                      <NA>
#> 81  0036A00000Pt0OuQAJ                      <NA>
#> 82  0036A00000Pt0M5QAJ                      <NA>
#> 83  0036A00000Pt0M6QAJ                      <NA>
#> 84  0036A00000Pt0NwQAJ                      <NA>
#> 85  0036A00000PsxrFQAR                      <NA>
#> 86  0036A00000Psy3uQAB                      <NA>
#> 87  0036A00000Psxp9QAB                      <NA>
#> 88  0036A00000Psy28QAB                      <NA>
#> 89  0036A00000PsyChQAJ                      <NA>
#> 90  0036A00000Pt0NrQAJ                      <NA>
#> 91  0036A00000Pt0O1QAJ                      <NA>
#> 92  0036A00000Pt0OBQAZ                      <NA>
#> 93  0036A00000Pt0OCQAZ                      <NA>
#> 94  0036A00000PsyC8QAJ                      <NA>
#> 95  0036A00000Pt0LqQAJ                      <NA>
#> 96  0036A00000Pt0N8QAJ                      <NA>
#> 97  0036A00000Pt0N9QAJ                      <NA>
#> 98  0036A00000Pt0O6QAJ                      <NA>
#> 99  0036A00000Pt0O7QAJ                      <NA>
#> 100 0036A00000Pt0N3QAJ                      <NA>
#> 101 0036A00000Pt0N4QAJ                      <NA>

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.query(session, soqlQuery = this_soql)
result2
#> # A tibble: 101 x 2
#>    Id                 Email                    
#>    <chr>              <chr>                    
#>  1 0036A000002C6MWQA0 rose@edge.com            
#>  2 0036A000002C6MXQA0 sean@edge.com            
#>  3 0036A000002C6MYQA0 jrogers@burlington.com   
#>  4 0036A000002C6MbQAK barr_tim@grandhotels.com 
#>  5 0036A000002C6McQAK bond_john@grandhotels.com
#>  6 0036A000002C6MdQAK spavlova@uog.com         
#>  7 0036A000002C6MeQAK lboyle@uog.com           
#>  8 0036A000002C6MfQAK b.levy@expressl&t.net    
#>  9 0036A000002C6MgQAK j.davis@expressl&t.net   
#> 10 0036A000002C6MhQAK jane_gray@uoa.edu        
#> # ... with 91 more rows

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_query(this_soql)
salesforcer_results
#> # A tibble: 101 x 2
#>    Id                 Email                    
#>    <chr>              <chr>                    
#>  1 0036A000002C6MWQA0 rose@edge.com            
#>  2 0036A000002C6MXQA0 sean@edge.com            
#>  3 0036A000002C6MYQA0 jrogers@burlington.com   
#>  4 0036A000002C6MbQAK barr_tim@grandhotels.com 
#>  5 0036A000002C6McQAK bond_john@grandhotels.com
#>  6 0036A000002C6MdQAK spavlova@uog.com         
#>  7 0036A000002C6MeQAK lboyle@uog.com           
#>  8 0036A000002C6MfQAK b.levy@expressl&t.net    
#>  9 0036A000002C6MgQAK j.davis@expressl&t.net   
#> 10 0036A000002C6MhQAK jane_gray@uoa.edu        
#> # ... with 91 more rows
```

In the future more features will be migrated from **RForcecom** to make the 
transition as seamless as possible.
