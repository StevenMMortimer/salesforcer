#' @param session \code{list}; a list containing \code{"sessionID"}, 
#' \code{"instanceURL"}, and \code{"apiVersion"} as returned by 
#' \code{\link[RForcecom]{rforcecom.login}}. This argument is ignored in all 
#' backward compatible calls because the authorization credentials are stored 
#' in an environment internal to the salesforcer package, so it is no longer 
#' necessary to pass the session in each function call.
