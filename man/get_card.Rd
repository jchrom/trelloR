% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_card.R
\name{get_card}
\alias{get_card}
\alias{get_card_actions}
\alias{get_card_checklists}
\alias{get_card_comments}
\alias{get_card_labels}
\alias{get_card_members}
\alias{get_card_fields}
\alias{get_card_fields_values}
\title{Get Card}
\usage{
get_card_actions(id, ...)

get_card_checklists(id, ...)

get_card_comments(id, ...)

get_card_labels(id, ...)

get_card_members(id, ...)

get_card_fields(id, ...)

get_card_fields_values(id, ...)
}
\arguments{
\item{id}{Card ID}

\item{...}{Additional arguments passed to \code{\link[=get_resource]{get_resource()}}}
}
\description{
Returns a flat data frame with card-related data.
}
\seealso{
\code{\link[=get_resource]{get_resource()}}
}
