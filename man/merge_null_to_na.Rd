% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{merge_null_to_na}
\alias{merge_null_to_na}
\title{Return NA if NULL}
\usage{
merge_null_to_na(x)
}
\arguments{
\item{x}{a value, typically a single element or a list to switch to NA if
its value appears to be NULL.}
}
\value{
the original value of parameter \code{x} or \code{NA} if the value
meets the criteria to be considered NULL.
}
\description{
A helper function to convert NULL values in API responses to a value of NA
which is allowed in data frames. Oftentimes, a NULL value creates issues when
binding and building data frames from parsed output, so we need to switch to NA.
}
\note{
This function is meant to be used internally. Only use when debugging.
}
\keyword{internal}
