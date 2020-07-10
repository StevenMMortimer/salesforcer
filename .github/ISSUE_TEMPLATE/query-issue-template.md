---
name: Query issue template
about: This issue template is for reporting an issue with a query.
title: ''
labels: ''
assignees: StevenMMortimer

---

When filing your issue please 
make an attempt to understand the and debug yourself. In a couple ways: 

  1. Slightly modify your function call to `sf_query()` to observe the results. Here 
  are a few prompting questions that may assist you:  
  
    - What do you see when you set `verbose=TRUE` argument?
    - What happens if you change the `control` argument, specifically the batch size? 
    - What happens if you try using a different API e.g. ("SOAP" vs "REST" or "Bulk 1.0" vs "Bulk 2.0")
    - What happens if you change your query slightly? 
    - Do you need a parent-to-child nested relationship query or will a relationship lookup suffice? 
    
  2. Check out Salesforce's [Workbench](https://workbench.developerforce.com/login.php) 
  tool to see how it builds out queries.
  
  3. Review the unit test coverage for queries at: <a target="_blank" href="https://github.com/StevenMMortimer/salesforcer/blob/master/tests/testthat/test-query.R">https://github.com/StevenMMortimer/salesforcer/blob/master/tests/testthat/test-query.R</a>. 
  These unit tests were written to cover a variety of use cases and to track any 
  changes made between newly released versions of the Salesforce API (typically 
  4 each year). These tests are an excellent source of examples that may be 
  helpful in troubleshooting your own query.
  
  4. Roll up your sleeves and dive into the source code for the **salesforcer** 
  package. The main scripts to review are:  
  
    - <a target="_blank" href="https://github.com/StevenMMortimer/salesforcer/blob/master/R/query.R">https://github.com/StevenMMortimer/salesforcer/blob/master/R/query.R</a>
    - <a target="_blank" href="https://github.com/StevenMMortimer/salesforcer/blob/master/R/utils-query.R">https://github.com/StevenMMortimer/salesforcer/blob/master/R/utils-query.R</a>
