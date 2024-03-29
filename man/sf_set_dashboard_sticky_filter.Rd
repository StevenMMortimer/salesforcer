% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/analytics-dashboard.R
\name{sf_set_dashboard_sticky_filter}
\alias{sf_set_dashboard_sticky_filter}
\title{Set a sticky dashboard filter}
\usage{
sf_set_dashboard_sticky_filter(
  dashboard_id,
  dashboard_filters = c(character(0))
)
}
\arguments{
\item{dashboard_id}{\code{character}; the Salesforce Id assigned to a created
dashboard. It will start with \code{"01Z"}.}

\item{dashboard_filters}{\code{character}; Dashboard results are always
unfiltered, unless you have specified filter parameters in your request. Use
this argument to include up to three optional filter Ids. You can obtain the
list of defined filter Ids from the dashboard metadata using
\link{sf_describe_dashboard}.}
}
\value{
\code{list}
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}

Set a default filter value which gets applied to a dashboard when you open
it. The default filter value you specify only applies to you (other people
won’t see it when they open the dashboard). If you change the filter value
while viewing the dashboard, then the filter value you set in the user
interface overwrites the value you set via the API. To set sticky filters for
a dashboard, \code{canUseStickyFilter} must equal true.
Saves any dashboard filters set in the request so that they’re also set the
next time you open the dashboard. NOTE: You can only set dashboard filters for
yourself, not for other users.
}
