###########################################
#                                         #
#    Retrieve data related to a card      #
#                                         #
###########################################

#' Get Card
#'
#' Returns a flat \code{data.frame} with card-related data.
#'
#' @param id Card ID
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @name get_card
NULL

#' @export
#' @rdname get_card
get_card_actions = function(id, ...) {
  dat = get_model(parent = "card", child = "actions", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_card_checklists = function(id, ...) {
  dat = get_model(parent = "card", child = "checklists", id = id, ...)
  dat
}

#' @export
#' @rdname get_card
get_card_comments = function(id, ...) {
  dat = get_model(parent = "card", child = "actions", id = id,
                  filter = "commentCard", ...)
  dat
}

#' @export
#' @rdname get_card
get_card_labels = function(id, ...) {
  dat = get_model(parent = "card", child = "labels", id = id, ...)
  dat
}

#' @export
#' @rdname get_card
get_card_members = function(id, ...) {
  dat = get_model(parent = "card", child = "members", id = id, ...)
  dat
}

#' @export
#' @rdname get_card
get_card_fields = function(id, ...) {
  dat = get_model(parent = "card", child = "customFields", id = id, ...)
  dat
}
