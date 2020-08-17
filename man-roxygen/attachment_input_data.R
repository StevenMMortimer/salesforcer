#' @param attachment_input_data \code{named vector}, \code{matrix},
#' \code{data.frame}, or \code{tbl_df}; data can be coerced into a
#' \code{data.frame}. The input must contain a column entitled 'Body' with an
#' absolute or relative file path (unless creating a Document using a Url)
#' along with other required fields depending on the object.If performing an 
#' \code{update} operation, then one column or field of the input must be 
#' the \code{Id} of the record to modify.
