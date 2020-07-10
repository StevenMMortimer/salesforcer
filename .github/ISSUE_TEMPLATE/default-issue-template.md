---
name: Default issue template
about: This issue template is the default when reporting an issue.
title: ''
labels: ''
assignees: StevenMMortimer
---

### Issue submission checklist

When filing your issue please make an attempt to troubleshoot a little bit on your own. If your issue is specifically related to a query, but please consider using the "Query issue template". Also, please consider some of the suggestions below before submitting an issue. Thank you!

  - [ ] I have set `verbose=TRUE` function argument if possible. 
  
  - [ ] I have tried a few different function call arguments to see if I can workaround and/or isolate the issue (e.g. reviewing the output from the "SOAP" vs "REST" or the "Bulk 1.0" vs "Bulk 2.0" or tinkering with the `control` argument in the function call).
  
  
  - [ ] I have taken a look at the unit tests directory [./tests/testthat/](./tests/testthat/) to see if my type of issue has been documented and tested.
  
  - [ ] I have considered making a minimal reproducible example using the [**reprex**](http://reprex.tidyverse.org/) package. Details on how to create a reprex are available here: https://www.tidyverse.org/help/#reprex.
  
  - [ ] I have included the version of R and any packages that are used (Hint: Simply copy/paste the result of `devtools::session_info()` at the bottom of your issue).
  
  Thank you for considering these steps. It will speed up the process of resolving your issue.  
  
----

### Issue description

A brief description of the problem.

### reprex

```r
# consider inserting a reprex here
```

---

### Session Info

```r
# consider inserting the output of devtools::session_info() here 
```
