---
title: "Working with Bulk API"
author: "Steven M. Mortimer"
date: "2018-03-12"
output:
  rmarkdown::html_vignette:
    toc: true
    toc_depth: 4
    keep_md: true
vignette: >
  %\VignetteIndexEntry{Working with Bulk API}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



### Using the Bulk API

First, load the `salesforcer` package and login. 




```r
suppressWarnings(suppressMessages(library(dplyr)))
library(salesforcer)
sf_auth()
```

For really large inserts, updates, deletes, upserts, queries you can just add 
"api_type" = "Bulk" to most functions to get the benefits of using the Bulk API 
instead of the SOAP or REST APIs. Here is the difference in using the REST API vs. 
the Bulk API to do an insert:


```r
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
# REST
rest_created_records <- sf_create(new_contacts, object_name="Contact", api_type="REST")
rest_created_records
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000ZbPeEQAV TRUE    <list [0]>
#> 2 0036A00000ZbPeFQAV TRUE    <list [0]>
# Bulk
bulk_created_records <- sf_create(new_contacts, object_name="Contact", api_type="Bulk 1.0")
bulk_created_records
#> # A tibble: 2 x 4
#>   Id                 Success Created Error
#>   <chr>              <chr>   <chr>   <lgl>
#> 1 0036A00000ZbPeJQAV true    true    NA   
#> 2 0036A00000ZbPeKQAV true    true    NA
```

There are some differences in the way each API returns response information; however, 
the end result is exactly the same for these two calls. Also, note that this 
package utilizes the Bulk 2.0 API for most bulk calls except for bulk queries 
since Salesforce has not yet implemented it in 2.0. 

Here is a simple workflow of adding, querying, and deleting records using the Bulk 1.0 API.


```r
# just add api_type="Bulk 1.0" or api_type="Bulk 2.0" to most calls!
# create bulk
object <- "Contact"
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object_name=object, api_type="Bulk 1.0")
created_records
#> # A tibble: 2 x 4
#>   Id                 Success Created Error
#>   <chr>              <chr>   <chr>   <lgl>
#> 1 0036A00000ZbPeOQAV true    true    NA   
#> 2 0036A00000ZbPePQAV true    true    NA

# query bulk
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$Id , collapse="','"))

queried_records <- sf_query(my_soql, object_name=object, api_type="Bulk 1.0")
queried_records
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0036A00000ZbPeOQAV Test      Contact-Create-1
#> 2 0036A00000ZbPePQAV Test      Contact-Create-2

# delete bulk
deleted_records <- sf_delete(queried_records$Id, object_name=object, api_type="Bulk 1.0")
deleted_records
#> # A tibble: 2 x 4
#>   Id                 Success Created Error
#>   <chr>              <chr>   <chr>   <lgl>
#> 1 0036A00000ZbPeOQAV true    false   NA   
#> 2 0036A00000ZbPePQAV true    false   NA
```
