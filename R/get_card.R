#' Get Card
#'
#' Returns a flat \code{data.frame} with card-related data.
#'
#' @param id Card ID
#' @param ... Additional arguments passed to \code{\link{get_resource}}
#' @seealso \code{\link{get_resource}}
#' @name get_card
NULL

#' @export
#' @rdname get_card
get_card_actions = function(id, ...) {
  get_resource(parent = "card", child = "actions", id = id, ...)
}

#' @export
#' @rdname get_card
get_card_checklists = function(id, ...) {
  get_resource(parent = "card", child = "checklists", id = id, ...)
}

#' @export
#' @rdname get_card
get_card_comments = function(id, ...) {
  get_resource(parent = "card", child = "actions", id = id,
               filter = "commentCard", ...)
}

#' @export
#' @rdname get_card
get_card_labels = function(id, ...) {
  get_resource(parent = "card", child = "labels", id = id, ...)
}

#' @export
#' @rdname get_card
get_card_members = function(id, ...) {
  get_resource(parent = "card", child = "members", id = id, ...)
}

#' @export
#' @rdname get_card
get_card_fields = function(id, ...) {
  get_resource(parent = "card", child = "customFields", id = id, ...)
}
