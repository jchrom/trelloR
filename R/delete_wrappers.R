#########################
#                       #
#    DELETE wrappers    #
#                       #
#########################

#' Delete card
#'
#' DELETE card.
#' @param card Card id
#' @param ... Additional arguments passed to \code{\link{delete_model}}
#' @export

delete_card = function(card, ...) {
  delete_model(
    model = "card", id = card, ...
  )
}

#' Delete checklist
#'
#' DELETE checklist.
#' @param checklist Checklist id
#' @param ... Additional arguments passed to \code{\link{delete_model}}
#' @export

delete_checklist = function(checklist, ...) {
  delete_model(
    model = "checklist", id = checklist, ...
  )
}

#' Delete item
#'
#' DELETE checklist item.
#' @param checklist Checklist id
#' @param checkitem Checklist item id
#' @param ... Additional arguments passed to \code{\link{delete_model}}
#' @export

delete_checkitem = function(checklist, checkitem, ...) {
  delete_model(
    model = "checklist", id = checklist, path = c("checkItems", checkitem),
    ...
  )
}
