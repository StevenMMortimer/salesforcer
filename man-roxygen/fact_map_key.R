#' @param fact_map_key \code{character}; string providing an index into each 
#' section of a fact map, from which you can access summary and detailed data. 
#' The pattern for the fact map keys varies by report format so it is important 
#' to know what the \code{reportFormat} property of the target report is. See the 
#' note below for more details. 
#' 
#' @note Below are the fact map key patterns for three report types: 
#' \describe{
#'   \item{TABULAR}{\code{T!T}: The grand total of a report. Both record data 
#'   values and the grand total are represented by this key.}
#'   \item{SUMMARY}{\code{<First level row grouping_second level row grouping_third 
#'   level row grouping>!T}: T refers to the row grand total.}
#'   \item{MATRIX}{\code{<First level row grouping_second level row grouping>!<First 
#'   level column grouping_second level column grouping>.}}
#' }
#' 
#' Each item in a row or column grouping is numbered starting with 0. Here are 
#' some examples of fact map keys:
#' 
#' \describe{
#'   \item{0!T}{The first item in the first-level grouping.}
#'   \item{1!T}{The second item in the first-level grouping.}
#'   \item{0_0!T}{The first item in the first-level grouping and the first item 
#'   in the second-level grouping.}
#'   \item{0_1!T}{The first item in the first-level grouping and the second item 
#'   in the second-level grouping.}   
#' }
