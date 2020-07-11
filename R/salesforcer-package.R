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
#' @keywords internal
#' @importFrom dplyr %>%
#' @importFrom lifecycle deprecate_soft
"_PACKAGE"

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
