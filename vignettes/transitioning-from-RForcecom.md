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
session1['sessionId'] <- "{MASKED}"
session1
#>                                                                                                          sessionID 
#> "00D6A0000003dN3!ARwAQMRcZIyFVM3n6aC_vxbJsPxoN8cYW7Q8ebxOV_a8tz8psFKCNRtxFHWZE9WG13kaXXKjgPu99L8Ug8QZDSncxSVtIrvi" 
#>                                                                                                        instanceURL 
#>                                                                                     "https://na50.salesforce.com/" 
#>                                                                                                         apiVersion 
#>                                                                                                             "42.0" 
#>                                                                                                          sessionId 
#>                                                                                                         "{MASKED}"

# replicated in salesforcer package
session2 <- salesforcer::rforcecom.login(username, paste0(password, security_token), 
                                         apiVersion=getOption("salesforcer.api_version"))
session2['sessionId'] <- "{MASKED}"
session2
#>                                                                                                          sessionID 
#> "00D6A0000003dN3!ARwAQMRcZIyFVM3n6aC_vxbJsPxoN8cYW7Q8ebxOV_a8tz8psFKCNRtxFHWZE9WG13kaXXKjgPu99L8Ug8QZDSncxSVtIrvi" 
#>                                                                                                        instanceURL 
#>                                                                                     "https://na50.salesforce.com/" 
#>                                                                                                         apiVersion 
#>                                                                                                             "42.0" 
#>                                                                                                          sessionId 
#>                                                                                                         "{MASKED}"
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
#> 1 0036A00000Pt1nbQAB    true

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.create(session, objectName=object, fields)
result2
#>                   id success
#> 1 0036A00000Pt1ngQAB    TRUE
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
#> 1 0036A00000Pt1nlQAB    true
#> 2 0036A00000Pt1nqQAB    true

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_create(new_contacts, "Contact")
salesforcer_results
#> # A tibble: 2 x 3
#>   id                 success errors    
#>   <chr>              <lgl>   <list>    
#> 1 0036A00000Pt1o0QAB TRUE    <list [0]>
#> 2 0036A00000Pt1o1QAB TRUE    <list [0]>
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
#> 16  0036A00000Pt1ZtQAJ                      <NA>
#> 17  0036A00000Pt1ZuQAJ                      <NA>
#> 18  0036A00000Pt1nbQAB                      <NA>
#> 19  0036A00000Pt1ngQAB                      <NA>
#> 20  0036A00000Pt1nqQAB                      <NA>
#> 21  0036A00000Pt15tQAB                      <NA>
#> 22  0036A00000Pt15uQAB                      <NA>
#> 23  0036A00000PsxokQAB                      <NA>
#> 24  0036A00000Pt0VlQAJ                      <NA>
#> 25  0036A00000Pt0VmQAJ                      <NA>
#> 26  0036A00000Psy2mQAB                      <NA>
#> 27  0036A00000Psy3GQAR                      <NA>
#> 28  0036A00000Psy3pQAB                      <NA>
#> 29  0036A00000Pt0qZQAR                      <NA>
#> 30  0036A00000Pt1ZZQAZ                      <NA>
#> 31  0036A00000Pt11oQAB                      <NA>
#> 32  0036A00000Psxl2QAB                      <NA>
#> 33  0036A00000Psxl3QAB                      <NA>
#> 34  0036A00000PsxmtQAB                      <NA>
#> 35  0036A00000PsxnXQAR                      <NA>
#> 36  0036A00000Psxp6QAB                      <NA>
#> 37  0036A00000PsxsDQAR                      <NA>
#> 38  0036A00000PsxudQAB                      <NA>
#> 39  0036A00000Psy1ZQAR                      <NA>
#> 40  0036A00000Psy3LQAR                      <NA>
#> 41  0036A00000PsyBfQAJ                      <NA>
#> 42  0036A00000PsyDzQAJ                      <NA>
#> 43  0036A00000PsyBhQAJ                      <NA>
#> 44  0036A00000Pt0LbQAJ                      <NA>
#> 45  0036A00000Pt0LgQAJ                      <NA>
#> 46  0036A00000Pt0MoQAJ                      <NA>
#> 47  0036A00000Pt0MyQAJ                      <NA>
#> 48  0036A00000Pt0OzQAJ                      <NA>
#> 49  0036A00000Pt0LhQAJ                      <NA>
#> 50  0036A00000Pt0P9QAJ                      <NA>
#> 51  0036A00000Pt0PAQAZ                      <NA>
#> 52  0036A00000Pt0MtQAJ                      <NA>
#> 53  0036A00000Pt0qeQAB                      <NA>
#> 54  0036A00000Pt0rcQAB                      <NA>
#> 55  0036A00000Pt0rmQAB                      <NA>
#> 56  0036A00000Pt0rnQAB                      <NA>
#> 57  0036A00000Pt0saQAB                      <NA>
#> 58  0036A00000Pt0vyQAB                      <NA>
#> 59  0036A00000Pt0yTQAR                      <NA>
#> 60  0036A00000Pt0roQAB                      <NA>
#> 61  0036A00000Pt13TQAR                      <NA>
#> 62  0036A00000Pt0qfQAB                      <NA>
#> 63  0036A00000Pt0qgQAB                      <NA>
#> 64  0036A00000Pt15oQAB                      <NA>
#> 65  0036A00000Pt15pQAB                      <NA>
#> 66  0036A00000Pt19vQAB                      <NA>
#> 67  0036A00000PsxmoQAB                      <NA>
#> 68  0036A00000Pt0LTQAZ                      <NA>
#> 69  0036A00000Pt0LUQAZ                      <NA>
#> 70  0036A00000Pt0mDQAR                      <NA>
#> 71  0036A00000Pt0yYQAR                      <NA>
#> 72  0036A00000Pt0VCQAZ                      <NA>
#> 73  0036A00000PsxrtQAB                      <NA>
#> 74  0036A00000Pt0wIQAR                      <NA>
#> 75  0036A00000Pt0wJQAR                      <NA>
#> 76  0036A00000PsxrKQAR                      <NA>
#> 77  0036A00000PsxofQAB                      <NA>
#> 78  0036A00000Pt0LlQAJ                      <NA>
#> 79  0036A00000PsyDGQAZ                      <NA>
#> 80  0036A00000Pt0m8QAB                      <NA>
#> 81  0036A00000Pt0PEQAZ                      <NA>
#> 82  0036A00000Pt0PFQAZ                      <NA>
#> 83  0036A00000Pt0spQAB                      <NA>
#> 84  0036A00000Pt0sqQAB                      <NA>
#> 85  0036A00000PsxjMQAR                      <NA>
#> 86  0036A00000Psxm5QAB                      <NA>
#> 87  0036A00000Pt13sQAB                      <NA>
#> 88  0036A00000Pt13tQAB                      <NA>
#> 89  0036A00000Pt0P4QAJ                      <NA>
#> 90  0036A00000Pt0P5QAJ                      <NA>
#> 91  0036A00000Pt0w8QAB                      <NA>
#> 92  0036A00000Pt12SQAR                      <NA>
#> 93  0036A00000Pt12TQAR                      <NA>
#> 94  0036A00000PsxqCQAR                      <NA>
#> 95  0036A00000PsyEdQAJ                      <NA>
#> 96  0036A00000Pt0sfQAB                      <NA>
#> 97  0036A00000Pt147QAB                      <NA>
#> 98  0036A00000Pt15AQAR                      <NA>
#> 99  0036A00000Pt1CBQAZ                      <NA>
#> 100 0036A00000Pt1ZeQAJ                      <NA>
#> 101 0036A00000Pt1o0QAB                      <NA>
#> 102 0036A00000Pt1o1QAB                      <NA>
#> 103 0036A00000PsxswQAB                      <NA>
#> 104 0036A00000Pt0LvQAJ                      <NA>
#> 105 0036A00000Pt0LwQAJ                      <NA>
#> 106 0036A00000Pt0MjQAJ                      <NA>
#> 107 0036A00000PsxnSQAR                      <NA>
#> 108 0036A00000Psxo1QAB                      <NA>
#> 109 0036A00000Psxo6QAB                      <NA>
#> 110 0036A00000PsxpEQAR                      <NA>
#> 111 0036A00000PsxnnQAB                      <NA>
#> 112 0036A00000PsxqgQAB                      <NA>
#> 113 0036A00000PsxsrQAB                      <NA>
#> 114 0036A00000Psy1eQAB                      <NA>
#> 115 0036A00000Psy2hQAB                      <NA>
#> 116 0036A00000Psy1fQAB                      <NA>
#> 117 0036A00000PsyDbQAJ                      <NA>
#> 118 0036A00000Pt0NmQAJ                      <NA>
#> 119 0036A00000Pt0MCQAZ                      <NA>
#> 120 0036A00000Pt0MDQAZ                      <NA>
#> 121 0036A00000Pt1ZjQAJ                      <NA>
#> 122 0036A00000Pt0VqQAJ                      <NA>
#> 123 0036A00000Pt0VrQAJ                      <NA>
#> 124 0036A00000Pt0m3QAB                      <NA>
#> 125 0036A00000Pt0mIQAR                      <NA>
#> 126 0036A00000Pt0mJQAR                      <NA>
#> 127 0036A00000Pt0mXQAR                      <NA>
#> 128 0036A00000Pt0mYQAR                      <NA>
#> 129 0036A00000Pt0rSQAR                      <NA>
#> 130 0036A00000Pt0rrQAB                      <NA>
#> 131 0036A00000Pt0rsQAB                      <NA>
#> 132 0036A00000Pt0suQAB                      <NA>
#> 133 0036A00000Pt0svQAB                      <NA>
#> 134 0036A00000Pt0szQAB                      <NA>
#> 135 0036A00000Pt0t0QAB                      <NA>
#> 136 0036A00000Pt0w3QAB                      <NA>
#> 137 0036A00000Pt13YQAR                      <NA>
#> 138 0036A00000Pt15PQAR                      <NA>
#> 139 0036A00000Pt1A0QAJ                      <NA>
#> 140 0036A00000Pt1A1QAJ                      <NA>
#> 141 0036A00000Pt1ZoQAJ                      <NA>
#> 142 0036A00000Pt1aDQAR                      <NA>
#> 143 0036A00000Pt1aEQAR                      <NA>
#> 144 0036A00000Pt1aNQAR                      <NA>
#> 145 0036A00000Pt1aOQAR                      <NA>
#> 146 0036A00000PsyEaQAJ                      <NA>
#> 147 0036A00000Pt0VbQAJ                      <NA>
#> 148 0036A00000Pt0VcQAJ                      <NA>
#> 149 0036A00000Pt0wDQAR                      <NA>
#> 150 0036A00000Pt0wEQAR                      <NA>
#> 151 0036A00000Pt11rQAB                      <NA>
#> 152 0036A00000Pt1nlQAB                      <NA>
#> 153 0036A00000Psxm0QAB                      <NA>
#> 154 0036A00000Psy2DQAR                      <NA>
#> 155 0036A00000PsyCmQAJ                      <NA>
#> 156 0036A00000PsxsIQAR                      <NA>
#> 157 0036A00000PsxuiQAB                      <NA>
#> 158 0036A00000PsyFCQAZ                      <NA>
#> 159 0036A00000Pt0M0QAJ                      <NA>
#> 160 0036A00000Pt0M1QAJ                      <NA>
#> 161 0036A00000Pt0OpQAJ                      <NA>
#> 162 0036A00000Pt0OuQAJ                      <NA>
#> 163 0036A00000Pt0M5QAJ                      <NA>
#> 164 0036A00000Pt0M6QAJ                      <NA>
#> 165 0036A00000Pt0NwQAJ                      <NA>
#> 166 0036A00000Pt0VWQAZ                      <NA>
#> 167 0036A00000Pt0lzQAB                      <NA>
#> 168 0036A00000Pt15UQAR                      <NA>
#> 169 0036A00000Pt15VQAR                      <NA>
#> 170 0036A00000Pt0rNQAR                      <NA>
#> 171 0036A00000Pt0sVQAR                      <NA>
#> 172 0036A00000Pt0rJQAR                      <NA>
#> 173 0036A00000Pt13OQAR                      <NA>
#> 174 0036A00000Pt15FQAR                      <NA>
#> 175 0036A00000PsxrFQAR                      <NA>
#> 176 0036A00000Psy3uQAB                      <NA>
#> 177 0036A00000Psxp9QAB                      <NA>
#> 178 0036A00000Psy28QAB                      <NA>
#> 179 0036A00000PsyChQAJ                      <NA>
#> 180 0036A00000Pt0NrQAJ                      <NA>
#> 181 0036A00000Pt0O1QAJ                      <NA>
#> 182 0036A00000Pt0OBQAZ                      <NA>
#> 183 0036A00000Pt0OCQAZ                      <NA>
#> 184 0036A00000Pt0VMQAZ                      <NA>
#> 185 0036A00000PsyC8QAJ                      <NA>
#> 186 0036A00000Pt0LqQAJ                      <NA>
#> 187 0036A00000Pt0N8QAJ                      <NA>
#> 188 0036A00000Pt0N9QAJ                      <NA>
#> 189 0036A00000Pt0O6QAJ                      <NA>
#> 190 0036A00000Pt0O7QAJ                      <NA>
#> 191 0036A00000Pt0VRQAZ                      <NA>
#> 192 0036A00000Pt0mcQAB                      <NA>
#> 193 0036A00000Pt0mdQAB                      <NA>
#> 194 0036A00000Pt0N3QAJ                      <NA>
#> 195 0036A00000Pt0N4QAJ                      <NA>
#> 196 0036A00000Pt0rXQAR                      <NA>
#> 197 0036A00000Pt0rhQAB                      <NA>
#> 198 0036A00000Pt0riQAB                      <NA>
#> 199 0036A00000Pt0skQAB                      <NA>
#> 200 0036A00000Pt0wNQAR                      <NA>
#> 201 0036A00000Pt0wOQAR                      <NA>
#> 202 0036A00000Pt14HQAR                      <NA>
#> 203 0036A00000Pt15KQAR                      <NA>

# replicated in salesforcer package
result2 <- salesforcer::rforcecom.query(session, soqlQuery = this_soql)
result2
#> # A tibble: 203 x 2
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
#> # ... with 193 more rows

# the better way in salesforcer to do multiple records
salesforcer_results <- sf_query(this_soql)
salesforcer_results
#> # A tibble: 203 x 2
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
#> # ... with 193 more rows
```

In the future more features will be migrated from **RForcecom** to make the 
transition as seamless as possible.
