# Release summary

## Note for CRAN Maintainers upon Submission of salesforcer 1.0.0

Per the request of Julia Haider, I have added \value{} specs to the .Rd files 
for all exported methods and explained those values in detail.

In addition, she requested that I explain how the issues which caused this 
package to be archived have now been resolved. On June 8, 2021, CRAN archived the 
{RForcecom} package. Tests and vignettes in this package referenced {RForcecom} 
and it was listed in this package's DESCRIPTION file under 'Suggests'. On June 9, 
2021, CRAN sent an email that this package had failing check results. The 
failures were due to RForcecom having been archived on CRAN. To resolve, I 
removed all executing references to the RForcecom library in the code, because 
I cannot anticipate whether the author of the package will restore it to CRAN. I 
was not able to complete this work by the stated deadline (June 23) because I was 
traveling without connection to the tools required to make the necessary changes. 
As such, CRAN archived this package.

## Test environments

* Local Mac OS install, R-release 4.0.2
* Ubuntu 16.04 (on GitHub Actions), R-release, R 4.1.2
* Mac OS 10.15.5 (on GitHub Actions) R-release, R 4.1.2
* Microsoft Windows Server 2019 10.0.17763 (on GitHub Actions) R-release, R 4.1.2
* win-builder (R-release 4.1.2)

## R CMD check results

* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Steven M. Mortimer <mortimer.steven.m@gmail.com>'

New submission

Package was archived on CRAN

Possibly mis-spelled words in DESCRIPTION:
  APIs (2:42, 5:64, 9:16)
  JSON (9:59)

CRAN repository db overrides:
  X-CRAN-Comment: Archived on 2021-06-23 as check problems were not
    corrected in time.

0 errors v | 0 warnings v | 1 note x

## revdepcheck results

Not done for this version because the prior version was removed from CRAN.
