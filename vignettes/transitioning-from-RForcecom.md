---
title: "Getting Started"
author: "Steven M. Mortimer"
date: "2018-03-11"
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



First, load the `salesforcer` package and login. There are two ways to authenticate: 
1) OAuth 2.0 and 2) Basic Username-Password. It is recommended to use OAuth 2.0 so that 
passwords do not have to be shared/embedded within scripts. User credentials will 
be stored in locally cached file entitled ".httr-oauth" in the current working 
directory.


```r
library(salesforcer)
```

Just a note, that it's not necessary to setup your own Connected App in Salesforce 
to use OAuth 2.0 authentication. The only difference is that the authentication 
will be run through the client created and associated with the `salesforcer` 
package. By using the package client, you will *NOT* be giving access to Salesforce 
to anyone, the package is just the medium for you to connect to your own data. 
If you wanted more control you would specify those options like so: 


```r
options(rdfp.client_id = "012345678901-99thisisatest99.apps.googleusercontent.com")
options(rdfp.client_secret = "Th1s1sMyC1ientS3cr3t")

sf_auth()
```



### STUFF

### Check out the Tests

The **salesforcer** package has quite a bit of unit test coverage to track any 
changes made between newly released versions of the Salesforce API (typically 4 each year). 
These tests are an excellent source of examples because they cover most all cases of 
utilizing the package functions. 

For example, if you're not sure on how to how to create and delete the records you just created, then check 
out the test for `sf_delete()` at https://github.com/StevenMMortimer/salesforcer/blob/master/tests/testthat/test-blank.R.

Here is the unit test code at that link:


