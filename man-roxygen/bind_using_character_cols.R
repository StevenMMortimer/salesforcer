#' @param bind_using_character_cols \code{logical}; an indicator of whether to 
#' cast the data to all character columns to ensure that \code{\link[dplyr:bind]{bind_rows}}
#' does not fail because two paginated recordsets have differing datatypes for the 
#' same column. Set this to \code{TRUE} rarely, typically only when having this 
#' set to \code{FALSE} returns an error or you want all columns in the data to be 
#' character.
