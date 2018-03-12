library(testthat)
library(salesforcer)

if (identical(tolower(Sys.getenv("NOT_CRAN")), "true") & 
    identical(tolower(Sys.getenv("TRAVIS_PULL_REQUEST")), "false")) {
  
  salesforcer_test_settings <- readRDS("salesforcer_test_settings.rds")
  salesforcer_token <- readRDS("salesforcer_token.rds")
  test_check("salesforcer")
}