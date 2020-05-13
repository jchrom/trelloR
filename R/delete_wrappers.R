#' Delete card
#'
#' DELETE card.
#' @param card Card id
#' @param ... Additional arguments passed to [delete_resource()]
#' @export

delete_card = function(card, ...) {
  delete_resource(
    resource = "card", id = card, ...
  )
}

#' Delete checklist
#'
#' DELETE checklist.
#' @param checklist Checklist id
#' @param ... Additional arguments passed to [delete_resource()]
#' @export

delete_checklist = function(checklist, ...) {
  delete_resource(
    resource = "checklist", id = checklist, ...
  )
}

#' Delete item
#'
#' DELETE checklist item.
#' @param checklist Checklist id
#' @param checkitem Checklist item id
#' @param ... Additional arguments passed to [delete_resource()]
#' @export

delete_checkitem = function(checklist, checkitem, ...) {
  delete_resource(
    resource = "checklist", id = checklist, path = c("checkItems", checkitem),
    ...
  )
}
