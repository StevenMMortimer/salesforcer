library(testthat)
library(dplyr)
library(salesforcer)

if(identical(tolower(Sys.getenv("NOT_CRAN")), "true")){
  test_check("salesforcer")  
}
