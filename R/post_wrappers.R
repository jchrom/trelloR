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
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_card = function(list, body = list(name = "New card"), ...) {
  post_model(
    model = "card", body = c(list(idList = list), body), ...
  )
}

#' Add comment
#'
#' POST comment to a card.
#' @param card Card id
#' @param text Comment text
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_comment = function(card, text, ...) {
  post_model(
    model = "card", path = c("actions", "comments"), id = card,
    body = list(text = text), ...
  )
}

#' Add label
#'
#' POST label to a card.
#' @param card Card id
#' @param color Label color
#' @param name Label name; choosing different non-existing name will create new label (defaults to \code{NULL})
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_label = function(card, color, name = NULL, ...) {
  post_model(
    model = "card", path = "labels", id = card,
    body = list(color = color, name = name), ...
  )
}

#' Add checklist
#'
#' POST checklist to a card.
#' @param card Card id
#' @param name Checklist name
#' @param source Items from this checklist id will be copied to the new one (defaults to \code{NULL})
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_checklist = function(card, name, source = NULL, ...) {
  post_model(
    model = "card", path = "checklists", id = card,
    body = list(name = name, idChecklistSource = source), ...
  )
}

#' Add member
#'
#' POST member to a card.
#' @param card Card id
#' @param member Member id
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_member = function(card, member, ...) {
  post_model(
    model = "card", path = "idMembers", id = card,
    body = list(value = member), ...
  )
}

#' Add board
#'
#' POST board.
#' @param name Name of the board
#' @param body A named list of query paramters (will be passed as body)
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_board = function(name, body = NULL, ...) {
  post_model(
    model = "board", body = c(list(name = name), body), ...
  )
}

#' Add list
#'
#' POST list to a board.
#' @param board Board id
#' @param name List name
#' @param position List position (defaults to \code{NULL}); legal values are \code{"top"}, \code{"bottom"}
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_list = function(board, name, position = NULL, ...) {
  post_model(
    model = "board", path = "lists", id = board,
    body = list(name = name, pos = position), ...
  )
}

#' Add checklist item
#'
#' POST item to a checklist.
#' @param checklist Checklist id
#' @param name Item name (text)
#' @param position Position in the checklist; defaults to \code{"bottom"}
#' @param checked Whether item should be checked; defaults to \code{FALSE}
#' @param ... Additional arguments passed to \code{\link{post_model}}
#' @export

add_checkitem = function(checklist, name, checked = FALSE, position = "bottom",
                         ...) {
  post_model(
    model = "checklist", id = checklist, path = "checkItems",
    body = list(name = name, pos = position, checked = tolower(checked)),
    ...
  )
}
