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
#' @param label \code{logical}; an indicator of whether the returned data should 
#' be the label (i.e. formatted value) or the actual value. By default, the labels  
#' are returned because these are what appear in the Salesforce dashboard and 
#' more closely align with the column names. For example, "Account.Name" label 
#' may be \code{"Account B"} and the value \code{0016A0000035mJEQAY}. The former 
#' (label) more accurately reflects the "Account.Name".
#' @return \code{tbl_df}; a single row data frame with the data for the row that 
#' the supplied list represented in the report's fact map.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
format_report_row <- function(x, label = TRUE){
  stopifnot(is.list(x), names(x) == "dataCells")
  element_name <- if(label) "label" else "value"
  x$dataCells %>% 
    map(~pluck(.x, element_name)) %>% 
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
#' @importFrom purrr map pluck
#' @importFrom dplyr as_tibble
#' @importFrom vctrs vec_as_names
#' @param x \code{list}; the list returned from the \code{\link[httr]{content}} 
#' function that parses the JSON response to a \code{list}.
#' @param label \code{logical}; an indicator of whether the returned data should 
#' be the label (i.e. formatted value) or the actual value. By default, the labels  
#' are returned because these are what appear in the Salesforce dashboard and 
#' more closely align with the column names. For example, "Account.Name" label 
#' may be \code{"Account B"} and the value \code{0016A0000035mJEQAY}. The former 
#' (label) more accurately reflects the "Account.Name".
#' @return \code{tbl_df}; a data frame representing the detail rows of a parsed 
#' report result HTTP response where the rows represent each row in the report 
#' and the columns represent the detail columns.
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
parse_report_detail_rows <- function(content, label = TRUE){
  
  if(!content$allData){
    warning(paste0("Results are the same number of rows as a report run in ", 
                   "Salesforce which is the only allowed behavior. Consider ", 
                   "using filters to refine results."))
  }
  
  if(is.null(content$reportExtendedMetadata$detailColumnInfo)){
    stop(paste0("Please set `include_details=TRUE` when executing the report. ", 
                "It appears that there is no detail information (data) for this ", 
                "report."), call.=FALSE)
  }
  
  if(is.null(content$factMap$`T!T`)){
    stop(paste0("No 'T!T' fact map detected. Please check the report before ", 
                "requesting again."), call.=FALSE)   
  }
  
  result_colnames <- content$reportExtendedMetadata$detailColumnInfo %>% 
    map_chr(pluck, "entityColumnName") %>% 
    unname()
  
  resultset <- content$factMap$`T!T`$rows %>% 
    drop_empty_recursively() %>% 
    map_df(format_report_row, label = label) %>% 
    set_names(nm = result_colnames)

  return(resultset)  
}
