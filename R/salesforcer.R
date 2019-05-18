#' \code{salesforcer} package
#'
#' An R package connecting to Salesforce APIs using tidy principles
#'
#' A package that connects to Salesforce via REST, SOAP, Bulk, and Metadata APIs 
#' and emphasizes the use of tidy data principles and the tidyverse.
#' 
#' Additional material can be found in the 
#' \href{https://github.com/reportmort/salesforcer}{README} on GitHub
#'
#' @docType package
#' @name salesforcer
#' @importFrom dplyr %>%
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c(".", 
                                                        "id", 
                                                        "success", 
                                                        "sObjectType",
                                                        "sObject",
                                                        "attributes.type", 
                                                        "sf:type"))