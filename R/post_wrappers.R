#######################
#                     #
#    POST wrappers    #
#                     #
#######################

#' Add card
#'
#' POST card to a list.
#' @param list List id
#' @param body A named list of query paramters (will be passed as body)
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_card = function(list, body = list(name = "New card"),
                    token, verbose = FALSE, ...) {
  post_model(
    model = "card", body = c(list(idList = list), body),
    token = token, verbose = verbose, ...
  )
}

#' Add comment
#'
#' POST comment to a card.
#' @param card Card id
#' @param text Comment text
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_comment = function(card, text, token, verbose = FALSE, ...) {
  post_model(
    model = "card", path = c("actions", "comments"), token = token,
    id = card, body = list(text = text), verbose = verbose,
    ...
  )
}

#' Add label
#'
#' POST label to a card.
#' @param card Card id
#' @param color Label color
#' @param name Label name; choosing different non-existing name will create new label (defaults to \code{NULL})
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_label = function(card, color, name = NULL, token, verbose = FALSE, ...) {
  post_model(
    model = "card", path = "labels", token = token,
    id = card, body = list(color = color, name = name), verbose = verbose,
    ...
  )
}

#' Add checklist
#'
#' POST checklist to a card.
#' @param card Card id
#' @param name Checklist name
#' @param source Items from this checklist id will be copied to the new one (defaults to \code{NULL})
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_checklist = function(card, name, source = NULL, token, verbose = FALSE, ...) {
  post_model(
    model = "card", path = "checklists", token = token,
    id = card, body = list(name = name, idChecklistSource = source),
    verbose = verbose,
    ...
  )
}

#' Add member
#'
#' POST member to a card.
#' @param card Card id
#' @param member Member id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_member = function(card, member, token, verbose = FALSE, ...) {
  post_model(
    model = "card", path = "idMembers", token = token,
    id = card, body = list(value = member), verbose = verbose,
    ...
  )
}

#' Add board
#'
#' POST board.
#' @param name Name of the board
#' @param body A named list of query paramters (will be passed as body)
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_board = function(name, body = NULL, token, verbose = FALSE, ...) {
  post_model(
    model = "board", token = token, body = c(list(name = name), body),
    verbose = verbose,
    ...
  )
}

#' Add list
#'
#' POST list to a board.
#' @param board Board id
#' @param name List name
#' @param position List position (defaults to \code{NULL}); legal values are \code{"top"}, \code{"bottom"}
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_list = function(board, name, position = NULL, token, verbose = FALSE, ...) {
  post_model(
    model = "board", path = "lists", token = token,
    id = board, body = list(name = name, pos = position),
    verbose = verbose,
    ...
  )
}

#' Add checklist item
#'
#' POST item to a checklist.
#' @param checklist Checklist id
#' @param name Item name (text)
#' @param position Position in the checklist; defaults to \code{"bottom"}
#' @param checked Whether item should be checked; defaults to \code{FALSE}
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{POST}} (for verbose output)
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @export

add_checkitem = function(checklist, name, checked = FALSE, position = "bottom",
                         token, verbose = FALSE, ...) {
  post_model(
    model = "checklist", id = checklist, path = "checkItems", token = token,
    body = list(name = name, pos = position, checked = tolower(checked)),
    verbose = verbose,
    ...
  )
}
