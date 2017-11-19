#########################
#                       #
#    DELETE wrappers    #
#                       #
#########################

#' Delete card
#'
#' DELETE card.
#' @param card Card id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{DELETE}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{DELETE}}
#' @export

delete_card = function(card, token, verbose = FALSE, ...) {
  delete_model(
    model = "card", id = card, token = token, verbose = verbose, ...
  )
}

#' Delete checklist
#'
#' DELETE checklist.
#' @param checklist Checklist id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{DELETE}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{DELETE}}
#' @export

delete_checklist = function(checklist, token, verbose = FALSE, ...) {
  delete_model(
    model = "checklist", id = checklist, token = token,
    verbose = verbose, ...
  )
}

#' Delete item
#'
#' DELETE checklist item.
#' @param checklist Checklist id
#' @param item Checklist item id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{DELETE}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{DELETE}}
#' @export

delete_item = function(checklist, item, token, verbose = FALSE, ...) {
  delete_model(
    model = "checklist", id = checklist, path = c("checkItems", item),
    token = token, verbose = verbose, ...
  )
}
