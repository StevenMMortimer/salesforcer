#' Format Datetimes for Create and Update operations
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @importFrom lubridate as_datetime
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_datetime <- function(x){
  format(as_datetime(x), "%Y-%m-%dT%H:%M:%SZ")  
}

#' Format Dates for Create and Update operations
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_date <- function(x){
  x <- as_datetime(format(x, "%Y-%m-%d 00:00:00"), tz=Sys.timezone())
  sf_format_datetime(x)
}

sf_format_time <- function (x, ...) {
  UseMethod("sf_format_time", x)
}

#' Format all Date and Datetime columns in a list
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
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
#' @note This function is meant to be used internally. Only use when debugging.
#' @importFrom dplyr mutate_if
#' @importFrom lubridate is.POSIXct is.POSIXlt is.POSIXt is.Date
#' @keywords internal
#' @seealso \url{https://developer.salesforce.com/docs/atlas.en-us.api_bulk_v2.meta/api_bulk_v2/datafiles_date_format.htm}
#' @export
sf_format_time.data.frame <- function(x){
  x %>%
    mutate_if(is.POSIXct, sf_format_datetime) %>% 
    mutate_if(is.POSIXlt, sf_format_datetime) %>% 
    mutate_if(is.POSIXt, sf_format_datetime) %>% 
    mutate_if(is.Date, sf_format_date)
}


#' @export
sf_format_time.Date <- function(x){ 
  sf_format_date(x)
}

#' @export
sf_format_time.POSIXct <- function(x){ 
  sf_format_datetime(x)
}

#' @export
sf_format_time.POSIXlt <- function(x){ 
  sf_format_datetime(x)
}

#' @export
sf_format_time.POSIXt <- function(x){ 
  sf_format_datetime(x)
}

#' @export
sf_format_time.character <- function(x){ 
  x
}

#' @export
sf_format_time.numeric <- function(x){ 
  x
}

#' @export
sf_format_time.logical <- function(x){ 
  x
}

#' @export
sf_format_time.NULL <- function(x){ 
  x
}

#' @export
sf_format_time.AsIs <- function(x){ 
  x
}
