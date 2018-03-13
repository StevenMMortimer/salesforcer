---
title: "Working with Bulk API"
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



### Using the Bulk API

For really large inserts, updates, deletes, upserts, queries you can just add 
"api_type" = "Bulk" to most functions to get the benefits of using the Bulk API 
instead of the SOAP or REST APIs. Here is the difference in using the REST API vs. 
the Bulk API to do an insert:




```r

suppressWarnings(suppressMessages(library(dplyr)))
library(salesforcer)
sf_auth()

n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
# REST
rest_created_records <- sf_create(new_contacts, "Contact", api_type="REST")
rest_created_records
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000Pt30vQAB TRUE    <list [0]>
#> 2 0036A00000Pt30wQAB TRUE    <list [0]>
# Bulk
bulk_created_records <- sf_create(new_contacts, "Contact", api_type="Bulk")
bulk_created_records
#> $successfulResults
#> # A tibble: 2 x 4
#>   sf__Id             sf__Created FirstName LastName        
#>   <chr>              <chr>       <chr>     <chr>           
#> 1 0036A00000Pt310QAB true        Test      Contact-Create-1
#> 2 0036A00000Pt311QAB true        Test      Contact-Create-2
#> 
#> $failedResults
#> # A tibble: 0 x 4
#> # ... with 4 variables: sf__Id <chr>, sf__Error <chr>, FirstName <chr>,
#> #   LastName <chr>
#> 
#> $unprocessedRecords
#> # A tibble: 0 x 2
#> # ... with 2 variables: FirstName <chr>, LastName <chr>
```

There are some differences in the way each API returns response information; however, 
the end result is exactly the same for these two calls. Also, note that this 
package utilizes the Bulk 2.0 API for most bulk calls except for bulk queries 
since Salesforce has not yet implemented it in 2.0. 

Here is a simple workflow of adding, querying, and deleting records using the Bulk API.


```r
# just add api_type="Bulk" to most calls!
# create bulk
object <- "Contact"
n <- 2
new_contacts <- tibble(FirstName = rep("Test", n),
                       LastName = paste0("Contact-Create-", 1:n))
created_records <- sf_create(new_contacts, object, api_type="Bulk")
created_records
#> $successfulResults
#> # A tibble: 2 x 4
#>   sf__Id             sf__Created FirstName LastName        
#>   <chr>              <chr>       <chr>     <chr>           
#> 1 0036A00000Pt315QAB true        Test      Contact-Create-1
#> 2 0036A00000Pt316QAB true        Test      Contact-Create-2
#> 
#> $failedResults
#> # A tibble: 0 x 4
#> # ... with 4 variables: sf__Id <chr>, sf__Error <chr>, FirstName <chr>,
#> #   LastName <chr>
#> 
#> $unprocessedRecords
#> # A tibble: 0 x 2
#> # ... with 2 variables: FirstName <chr>, LastName <chr>

# query bulk
my_soql <- sprintf("SELECT Id,
                           FirstName, 
                           LastName
                    FROM Contact 
                    WHERE Id in ('%s')", 
                   paste0(created_records$successfulResults$sf__Id , collapse="','"))

queried_records <- sf_query(my_soql, object=object, api_type="Bulk")
queried_records
#> # A tibble: 2 x 3
#>   Id                 FirstName LastName        
#>   <chr>              <chr>     <chr>           
#> 1 0036A00000Pt315QAB Test      Contact-Create-1
#> 2 0036A00000Pt316QAB Test      Contact-Create-2

# delete bulk
deleted_records <- sf_delete(queried_records$Id, object=object, api_type="Bulk")
deleted_records
#> $successfulResults
#> # A tibble: 2 x 3
#>   sf__Id             sf__Created id   
#>   <chr>              <chr>       <chr>
#> 1 0036A00000Pt315QAB false       <NA> 
#> 2 0036A00000Pt316QAB false       <NA> 
#> 
#> $failedResults
#> # A tibble: 0 x 3
#> # ... with 3 variables: sf__Id <chr>, sf__Error <chr>, id <chr>
#> 
#> $unprocessedRecords
#> # A tibble: 0 x 1
#> # ... with 1 variable: id <chr>
```
