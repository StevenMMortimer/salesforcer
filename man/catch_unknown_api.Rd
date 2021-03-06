% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-input-validation.R
\name{catch_unknown_api}
\alias{catch_unknown_api}
\title{Catch unknown API type}
\usage{
catch_unknown_api(x, supported = c(character(0)))
}
\arguments{
\item{x}{\code{character}; The value of the \code{api_type} argument provided
by the user.}
}
\value{
\code{simpleError}
}
\description{
This function will alert the user that the supplied value to the argument
\code{api_type} is not one of the valid options.
}
\note{
This function is meant to be used internally. Only use when debugging.
}
\keyword{internal}
