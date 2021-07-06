#' Format Datetimes for Create and Update operations
#' 
#' @importFrom lubridate as_datetime
#' @param x a value representing a datetime
#' @return \code{character}; a datetime string formatted in ISO8601 per the 
#' requirements of the Salesforce APIs.
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/datafiles_date_format.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_format_datetime <- function(x){
  format(as_datetime(x), "%Y-%m-%dT%H:%M:%SZ")  
}

#' Format Dates for Create and Update operations
#' 
#' @param x a value representing a datetime
#' @return \code{character}; a date string with the time set to midnight in the 
#' user's system timezone and then formatted in ISO8601 per the requirements of 
#' the Salesforce APIs.
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/datafiles_date_format.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_format_date <- function(x){
  x <- as_datetime(format(x, "%Y-%m-%d 00:00:00"), tz=Sys.timezone())
  sf_format_datetime(x)
}

#' Format all Date and Datetime columns in a list
#' 
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @param x data which may or may not have values, elements, columns that 
#' represent a datetime. If so, each of those are cast to the ISO8601 standard 
#' per the requirements of Salesforce APIs.
#' @return the same data object with datetime values formatted.
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/datafiles_date_format.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_format_time <- function (x, ...) {
  UseMethod("sf_format_time", x)
}

#' Format all Date and Datetime columns in a list
#' 
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @param x \code{list}; a list object which may or may not have values 
#' that represent a datetime. If so, they are cast to the ISO8601 standard per 
#' the requirements of Salesforce APIs.
#' @return \code{list}; the same list object with datetime values formatted.
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/datafiles_date_format.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_format_time.list <- function(x){
  lapply(x, FUN=function(xx){
    if(is.list(xx)){
      lapply(xx, sf_format_time)
    } else {
      sf_format_time(xx)  
    }
  })
}

#' Format all Date and Datetime columns in a dataset
#' 
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @param x \code{tbl_df}; a data frame object which may or may not have columns 
#' that represent a datetime. If so, they are cast to the ISO8601 standard per 
#' the requirements of Salesforce APIs.
#' @return \code{tbl_df}; the same data frame object with datetime values formatted.
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_asynch.meta/api_asynch/datafiles_date_format.htm}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_format_time.data.frame <- function(x){
  x %>%
    mutate_if(is.POSIXct, sf_format_datetime) %>% 
    mutate_if(is.POSIXlt, sf_format_datetime) %>% 
    mutate_if(is.POSIXt, sf_format_datetime) %>% 
    mutate_if(is.Date, sf_format_date)
}

#' @keywords internal
sf_format_time.Date <- function(x){ 
  sf_format_date(x)
}

#' @keywords internal
sf_format_time.POSIXct <- function(x){ 
  sf_format_datetime(x)
}

#' @keywords internal
sf_format_time.POSIXlt <- function(x){ 
  sf_format_datetime(x)
}

#' @keywords internal
sf_format_time.POSIXt <- function(x){ 
  sf_format_datetime(x)
}

#' @keywords internal
sf_format_time.character <- function(x){ 
  x
}

#' @keywords internal
sf_format_time.numeric <- function(x){ 
  x
}

#' @keywords internal
sf_format_time.logical <- function(x){ 
  x
}

#' @keywords internal
sf_format_time.NULL <- function(x){ 
  x
}

#' @keywords internal
sf_format_time.AsIs <- function(x){ 
  if("AsIs" %in% class(x)){
    if(length(class(x)[-match("AsIs", class(x))]) == 0){
      x <- unclass(x)
    } else {
      class(x) <- class(x)[-match("AsIs", class(x))]
    }
  }
  sf_format_time(x)
}
