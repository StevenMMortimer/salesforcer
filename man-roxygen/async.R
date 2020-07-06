#' @param async \code{logical}; an indicator, by default set to \code{TRUE}, which 
#' executes the report asynchronously. If executed asynchronously, this function
#' will return a list of attributes of the created report instance. The results 
#' can be pulled down by providing the report id and instance id to 
#' the function \code{\link{sf_report_instance_results}}. Refer to the details 
#' of the documentation on why executing a report asynchronously is preferred.
