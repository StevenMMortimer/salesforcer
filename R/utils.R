#' Return the package's .state environment variable
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
salesforcer_state <- function(){
  .state
}

#' Determine the host operating system
#' 
#' This function determines whether the system running the R code
#' is Windows, Mac, or Linux
#'
#' @return A character string
#' @examples
#' \dontrun{
#' get_os()
#' }
#' @seealso \url{https://conjugateprior.org/2015/06/identifying-the-os-from-r}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin'){
      os <- "osx"
    }
  } else {
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os)){
      os <- "osx"
    }
    if (grepl("linux-gnu", R.version$os)){
      os <- "linux"
    }
  }
  return(unname(tolower(os)))
}

#' Create a temporary directory path without a double slash
#' 
#' This function fixes a long standing bug in R where the 
#' \code{\link[base:tempfile]{tempdir}} function will return a path with an 
#' extra slash.
#' 
#' @return \code{character}; a string representing the temp directory path 
#' without containing a double slash
#' @examples
#' \dontrun{
#' patched_tempdir()
#' }
#' @seealso \href{https://stat.ethz.ch/R-manual/R-devel/library/base/html/EnvVar.html}{R documentation on environment vars}, \href{https://stackoverflow.com/questions/15361980/why-does-tempdir-adds-extra-slash-at-end-of-directory-tree-on-osx/15362110#15362110}{Stack Overflow - Why does tempdir() adds extra slash...}
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
patched_tempdir <- function(){
  t <- tempdir(check=TRUE)
  return(file.path(normalizePath(Sys.getenv("TMPDIR")), basename(t)))
}

#' Return NA if NULL
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
merge_null_to_na <- function(x){
  if(is.null(x)){ 
    NA
  } else if(length(x) == 0){
    NA
  } else if(is.list(x) & length(x) == 1 & is.null(x[[1]])){
    NA
  } else {
    x
  }
}

#' Write a CSV file in format acceptable to Salesforce APIs
#' 
#' @importFrom readr write_csv
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
sf_write_csv <- function(x, path){
  write_csv(x=x, path=path, na="#N/A")
}

#' Remove NA Columns Created by Empty Related Entity Values
#' 
#' This function will detect if there are related entity columns coming back 
#' in the resultset and try to exclude an additional completely blank column 
#' created by records that don't have a relationship at all in that related entity.
#' 
#' @param dat data; a \code{tbl_df} or \code{data.frame} of a returned resultset
#' @template api_type
#' @importFrom dplyr select one_of
#' @keywords internal
#' @export
remove_empty_linked_object_cols <- function(dat, api_type = c("SOAP", "REST")){
  # try to remove references to empty linked entity objects
  # for example whenever a contact record isn't linked to an Account
  # then the record is included like this: <sf:Account xsi:nil="true"/>
  # which is very hard to discern if that is a Contact field called, "Account" that 
  # is NULL or it's a linked entity on an object called "Account" that is NULL. In 
  # our case we will try to remove if there are other fields in the result using that 
  # as a prefix to fields
  api_type <- match.arg(api_type)
  if(api_type == "REST"){
    # do nothing, typically fixed by itself
  } else if(api_type == "SOAP"){
    potential_object_prefixes <- grepl("^sf:[a-zA-Z]+\\.[a-zA-Z]+", names(dat))
    potential_object_prefixes <- names(dat)[potential_object_prefixes]
    potential_object_prefixes <- unique(gsub("(sf:)([a-zA-Z]+)\\.(.*)", "\\2", potential_object_prefixes))
    if(length(potential_object_prefixes) > 0){
      potential_null_object_fields_to_drop <- paste0("sf:", potential_object_prefixes)
      suppressWarnings(
        dat <- dat %>%
          # suppress the warning because it's possible that some of the 
          # columns are not actually in the data
          select(-one_of(potential_null_object_fields_to_drop))
      )
    }
  } else {
    catch_unknown_api(api_type)
  }
  return(dat)
}

#' Try to Guess the Object if User Does Not Specify for Bulk Queries
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
guess_object_name_from_soql <- function(soql){
  object_name <- gsub("SELECT (.*) FROM ([A-Za-z_]+)\\b(.*)", "\\2", soql, ignore.case = TRUE)
  if(is.null(object_name)){
    stop("The `object_name` argument is NULL. This argument must be provided when using the Bulk APIs.")
  }
  message(sprintf(paste0("Guessed '%s' as the object_name from supplied SOQL.\n", 
                         "Please set `object_name` explicitly if this is incorrect ", 
                         "because it is required by the Bulk APIs."), object_name))
  return(object_name)
}

#' Format Headers for Printing
#' 
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
format_headers_for_verbose <- function(request_headers){
  paste0(paste(names(request_headers), 
               unlist(request_headers), sep=': '), 
         collapse = "; ")
}

#' Format Verbose Call
#' 
#' @importFrom jsonlite prettify
#' @note This function is meant to be used internally. Only use when debugging.
#' @keywords internal
#' @export
make_verbose_httr_message <- function(method, 
                                      url, 
                                      headers = NULL, 
                                      body = NULL, 
                                      auto_unbox = TRUE,
                                      ...){
  message(sprintf("\n--HTTP Request----------------\n%s %s", method, url))
  
  if(!is.null(headers)){ 
    message(sprintf("--Headers---------------------\n%s", 
                    format_headers_for_verbose(headers)))
  }
  
  if(!is.null(body)){
    if(is.list(body)){
      body <- toJSON(body, pretty = TRUE, auto_unbox = auto_unbox, ...)
    }
    message(sprintf("--Body------------------------\n%s", 
                    body))
  }
  
  return(invisible(NULL))
}
