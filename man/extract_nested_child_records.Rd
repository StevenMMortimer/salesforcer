% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-query.R
\name{extract_nested_child_records}
\alias{extract_nested_child_records}
\title{Extract nested child records in a record}
\usage{
extract_nested_child_records(x)
}
\arguments{
\item{x}{\code{list}; a list parsed from an HTTP response and representing
one individual parent query record.}
}
\value{
\code{tbl_df}; a data frame with each row representing a child record.
}
\description{
This function accepts a single record from a nested query and "unpacks" the
"records" which represent the child records belonging to the parent.
}
\note{
This function is meant to be used internally. Only use when debugging.
}
\keyword{internal}
