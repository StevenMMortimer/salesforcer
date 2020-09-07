#' Format a single "rows" element from a report fact map
#' 
#' This function accepts a list representing a single row from a report and 
#' selects either the value or label for the report columns to turn into a one 
#' row \code{tbl_df} that will usually be bound to the other rows in the report
#' 
#' @importFrom purrr map pluck
#' @importFrom dplyr as_tibble
#' @importFrom vctrs vec_as_names
#' @param x \code{list}; a single element from the \code{rows} element of a fact 
#' map. When the data is in a tabular format, this element usually has the same 
#' length as the number of columns with each element having a label and value 
#' element.
#' @template labels
#' @template guess_types
#' @template bind_using_character_cols
#' @return \code{tbl_df}; a single row data frame with the data for the row that 
#' the supplied list represented in the report's fact map.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
format_report_row <- function(x, 
                              labels = TRUE, 
                              guess_types = TRUE, 
                              bind_using_character_cols = FALSE){
  stopifnot(is.list(x), names(x) == "dataCells")
  element_name <- if(labels) "label" else "value"
  x$dataCells %>% 
    map(~pluck(.x, element_name)) %>% 
    modify_if(~(length(.x) == 0), .f=function(x){return(NA)}) %>% 
    {
      if(!guess_types | bind_using_character_cols){
        map(., as.character)
      } else {
        .
      }
    } %>% 
    as_tibble(.name_repair = 
                ~vec_as_names(names = paste0("v", seq_len(length(.))), 
                              repair = "unique", quiet = TRUE))
}

#' Format the detailed data from the "T!T" fact map in a tabular report
#' 
#' This function accepts a list that is directly returned by the API and further 
#' parses it to return a single \code{tbl_df} representing the detail rows and 
#' columns of the report without any filters, aggregates, or totals.
#' 
#' @importFrom stats setNames
#' @importFrom purrr map pluck
#' @importFrom dplyr as_tibble
#' @importFrom vctrs vec_as_names
#' @param content \code{list}; the list returned from the \code{\link[httr]{content}} 
#' function that parses the JSON response to a \code{list}.
#' @template fact_map_key
#' @template labels
#' @template guess_types
#' @template bind_using_character_cols
#' @return \code{tbl_df}; a data frame representing the detail rows of a parsed 
#' report result HTTP response where the rows represent each row in the report 
#' and the columns represent the detail columns.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
parse_report_detail_rows <- function(content,
                                     fact_map_key = "T!T",
                                     labels = TRUE, 
                                     guess_types = TRUE, 
                                     bind_using_character_cols = FALSE){
  
  # create a boolean that will be set whenever an offending issue is identified 
  # that can be used to stop the function execution only after all of the checks 
  # have been performed. This allows the user to receive all possible information 
  # at once on how to fix any issues rather than doing them one at a time only 
  # to discover each time that there is a new issue.
  stops_triggered <- character(0)
  
  if(!content$allData){
    warning(paste0("The data returned by the API does not contain all data for ", 
                   "this report. Per the Salesforce API documentation, the API ",
                   "returns the same number of rows as a report run within ", 
                   "Salesforce, which is limited to 2,000 records. As a workaround, ", 
                   "consider running this report multiple times with different ", 
                   "filters to paginate through all of the records."), call.=FALSE)
  }
  
  if(is.null(content$reportExtendedMetadata$detailColumnInfo)){
    warning(paste0("Please set `include_details=TRUE` when executing the report. ", 
                   "It appears that there is no detail-level data for this ", 
                   "report."), call.=FALSE)
    stops_triggered <- c(stops_triggered, "No detailColumnInfo")
  }
  
  if(fact_map_key != "T!T"){
    message(paste0("The `fact_map_key` argument must be 'T!T'. Currently it is the only ", 
                   "format that is supported as this feature is still under active ",
                   "development. In the future we will support fact map key patterns ",
                   "for 'Summary' and 'Matrix' reports as described in the Salesforce ", 
                   "documentation at ", 
                   "https://developer.salesforce.com/docs/atlas.en-us.api_analytics.meta/", 
                   "api_analytics/sforce_analytics_rest_api_factmap_example.htm"))
    stops_triggered <- c(stops_triggered, "Fact map key is not 'T!T'")
  }
  
  if(is.null(content$factMap$`T!T`)){
    warning(paste0("No 'T!T' fact map detected. Please check the report format is ", 
                   "'TABULAR' before requesting again."), call.=FALSE)
    stops_triggered <- c(stops_triggered, "Fact map key 'T!T' does not exist in the content.")
  }
  
  if(length(stops_triggered) > 0){
    stop_w_errors_listed(errors = stops_triggered)
  }
  
  result_colnames <- content$reportExtendedMetadata$detailColumnInfo %>% 
    map_chr(pluck, "label") %>% 
    unname()
  
  if(length(content$factMap$`T!T`$rows) == 0){
    resultset <- result_colnames %>% 
      map_dfc(setNames, object = list(character()))
  } else {
    resultset <- content$factMap$`T!T`$rows %>% 
      drop_empty_recursively() %>% 
      map_df(format_report_row, 
             labels = labels, 
             guess_types = guess_types,
             bind_using_character_cols = bind_using_character_cols) %>% 
      set_names(nm = result_colnames)
  }
  
  if(guess_types){
    result_datatypes <- content$reportExtendedMetadata$detailColumnInfo %>% 
      map_chr(pluck, "dataType") %>% 
      unname()
    resultset <- resultset %>% 
      sf_guess_cols(dataType = result_datatypes)
  }
  
  return(resultset)  
}

#' Simplify the \code{reportMetadata} property of a report
#' 
#' This function accepts the Id of a report in Salesforce and returns its
#' \code{reportMetadata} property with modifications made so that the report
#' will return a dataset that is closer to a tidy format. More specifically, the
#' data will be detailed data (not any report aggregates) in a tabular format
#' with no filters, grand totals, or subtotals.
#' 
#' @template report_id
#' @template verbose
#' @return \code{list}; a list representing the \code{reportMetadata} property of 
#' the report id provided, but with adjustments made.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
simplify_report_metadata <- function(report_id, verbose=FALSE){
  report_details <- sf_describe_report(report_id, verbose=verbose)
  # replace all empty lists with NA which will be translated to null
  report_metadata <- lapply(report_details$reportMetadata, 
                            function(x){ 
                              if(!is.null(x) && 
                                 ((is.list(x)) & (length(x) == 0))){
                                return(NA)
                              } else {
                                return(x)
                              }
                            })
  report_metadata <- list(reportMetadata = report_metadata)  
  report_metadata$reportMetadata$aggregates <- I(character(0))
  report_metadata$reportMetadata$hasDetailRows <- TRUE
  report_metadata$reportMetadata$reportBooleanFilter <- NA
  report_metadata$reportMetadata$reportFilters <- I(character(0))
  report_metadata$reportMetadata$reportFormat <- "TABULAR"
  report_metadata$reportMetadata$showGrandTotal <- FALSE
  report_metadata$reportMetadata$showSubtotals <- FALSE
  return(report_metadata)
}
