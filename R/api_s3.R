# Class constructor

add_class = function(x, child) {
  if (!is.data.frame(x)) stop("Not a data frame")
  class_api = paste0(child, "_df")
  structure(x, class = c(class_api, "trello_api", class(x)))
}

#' Trello API objects
#'
#' Test for Trello API objects.
#' @param x Object to be tested
#' @name is.trello_api
NULL

#' @export
#' @rdname is.trello_api
is.trello_api = function(x) inherits(x, "trello_api")

#' @export
#' @rdname is.trello_api
is.boards_df = function(x) inherits(x, "boards_df")

#' @export
#' @rdname is.trello_api
is.cards_df = function(x) inherits(x, "cards_df")

#' @export
#' @rdname is.trello_api
is.lists_df = function(x) inherits(x, "lists_df")

#' @export
#' @rdname is.trello_api
is.actions_df = function(x) inherits(x, "actions_df")

#' @export
#' @rdname is.trello_api
is.comments_df = function(x) inherits(x, "comments_df")

#' @export
#' @rdname is.trello_api
is.labels_df = function(x) inherits(x, "labels_df")

#' @export
#' @rdname is.trello_api
is.members_df = function(x) inherits(x, "members_df")

#' @export
#' @rdname is.trello_api
is.checklists_df = function(x) inherits(x, "checklists_df")

#' @export
#' @rdname is.trello_api
is.fields_df = function(x) inherits(x, "fields_df")

#' @export
#' @rdname is.trello_api
is.teams_df = function(x) inherits(x, "teams_df")
