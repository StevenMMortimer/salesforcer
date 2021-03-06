% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils-org.R
\name{sf_set_password}
\alias{sf_set_password}
\title{Set User Password}
\usage{
sf_set_password(user_id, password, verbose = FALSE)
}
\arguments{
\item{user_id}{\code{character}; the unique Salesforce Id assigned to the User}

\item{password}{\code{character}; a new password that you would like to set for the
supplied user that complies to your organizations password requirements}

\item{verbose}{\code{logical}; an indicator of whether to print additional
detail for each API call, which is useful for debugging. More specifically, when
set to \code{TRUE} the URL, header, and body will be printed for each request,
along with additional diagnostic information where available.}
}
\value{
\code{list}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

Sets the specified user’s password to the specified value.
}
\examples{
\dontrun{
sf_set_password(user_id = "0056A000000ZZZaaBBB", password="password123")
}
}
