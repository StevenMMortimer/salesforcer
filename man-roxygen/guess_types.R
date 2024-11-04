#' @param guess_types \code{logical}; indicating whether or not to use \code{col_guess()}
#' to try and cast the data returned in the recordset. If \code{TRUE} then
#' \code{col_guess()} is used along with \code{anytime()} and \code{anydate()}.
#' If \code{FALSE} then all fields will be returned as character. Specifying
#' \code{FALSE} helpful when guessing the column data type will result in NA
#' values and you would like to return the results as strings and then cast in
#' your script according to your unique specifications.
