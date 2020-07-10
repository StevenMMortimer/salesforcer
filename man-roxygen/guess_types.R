#' @param guess_types \code{logical}; indicating whether or not to use \code{col_guess()} 
#' to try and cast the data returned in the recordset. If \code{TRUE} then 
#' \code{col_guess()} is used, if \code{FALSE} then all fields will be returned 
#' as character. This is helpful when \code{col_guess()} will mangle field values 
#' in Salesforce that you'd like to preserve during translation into a \code{tbl_df}, 
#' like numeric looking values that must be preserved as strings ("48.0").
