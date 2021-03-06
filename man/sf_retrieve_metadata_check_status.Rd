% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retrieve-metadata.R
\name{sf_retrieve_metadata_check_status}
\alias{sf_retrieve_metadata_check_status}
\title{Check on Retrieve Calls and Get Contents If Available}
\usage{
sf_retrieve_metadata_check_status(
  id,
  include_zip = TRUE,
  filename = "package.zip",
  verbose = FALSE
)
}
\arguments{
\item{id}{\code{character}; string id returned from \link{sf_retrieve_metadata}}

\item{include_zip}{\code{logical}; Set to false to check the status of the retrieval without
attempting to retrieve the zip file. If omitted, this argument defaults to true.}

\item{filename}{a file path to save the zip file in the event that it is downloaded. The
name must have a .zip extension. The default behavior will be to save in the current
working directory as package.zip}

\item{verbose}{\code{logical}; an indicator of whether to print additional
detail for each API call, which is useful for debugging. More specifically, when
set to \code{TRUE} the URL, header, and body will be printed for each request,
along with additional diagnostic information where available.}
}
\value{
A \code{list} of the response
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

This function returns details about an initiated retrieveMetadata request
and saves the results into a zip file
}
\note{
This function is meant to be used internally. Only use when debugging.
}
\examples{
\dontrun{
retrieve_request <- list(unpackaged=list(types=list(members='*', name='CustomObject')))
retrieve_info <- sf_retrieve_metadata(retrieve_request)

# check on status, this will automatically download the contents to package.zip when ready
retrieve_status <- sf_retrieve_metadata_check_status(retrieve_info$id)
}
}
\references{
\url{https://developer.salesforce.com/docs/atlas.en-us.api_meta.meta/api_meta/meta_checkretrievestatus.htm}
}
\keyword{internal}
