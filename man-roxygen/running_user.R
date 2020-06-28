#' @param running_user \code{character}; the Salesforce Id that should be assigned 
#' as the runner of the job. This should be from a User record (i.e. the Id will 
#' start with "005"). Note that this will throw an error if the User is not 
#' allowed to change the running User, or if the selected running User is invalid.
