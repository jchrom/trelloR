#' Add card
#'
#' Add card to a list.
#'
#' @param list List id.
#' @param body A named list of query parameters.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_card = function(list, body = list(name = "New card"), ...) {
  create_resource(
    resource = "card", body = c(list(idList = list), body), ...
  )
}

#' Add comment
#'
#' Add comment to a card.
#'
#' @param card Card id.
#' @param text Comment text.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_comment = function(card, text, ...) {
  create_resource(
    resource = "card", path = c("actions", "comments"), id = card,
    body = list(text = text), ...
  )
}

#' Add label
#'
#' Add label to a card.
#'
#' @param card Card id.
#' @param color Label color.
#' @param name Label name; choosing different non-existing name will create new
#'   label. Defaults to `NULL`.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_label = function(card, color, name = NULL, ...) {
  create_resource(
    resource = "card", path = "labels", id = card,
    body = list(color = color, name = name), ...
  )
}

#' Add checklist
#'
#' Add checklist to a card.
#'
#' @param card Card id.
#' @param name Checklist name.
#' @param source Items from this checklist id will be copied to the new one.
#'   Defaults to `NULL`.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_checklist = function(card, name, source = NULL, ...) {
  create_resource(
    resource = "card", path = "checklists", id = card,
    body = list(name = name, idChecklistSource = source), ...
  )
}

#' Add member
#'
#' Add member to a card.
#'
#' @param card Card id.
#' @param member Member id.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_member = function(card, member, ...) {
  create_resource(
    resource = "card", path = "idMembers", id = card,
    body = list(value = member), ...
  )
}

#' Add board
#'
#' Add board.
#'
#' @param name Name of the board.
#' @param body A named list of query parameters.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_board = function(name, body = NULL, ...) {
  create_resource(
    resource = "board", body = c(list(name = name), body), ...
  )
}

#' Add list
#'
#' Add list to a board.
#'
#' @param board Board id.
#' @param name List name.
#' @param position List position. One of `"top"`, `"bottom"` or `NULL`.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_list = function(board, name, position = NULL, ...) {
  create_resource(
    resource = "board", path = "lists", id = board,
    body = list(name = name, pos = position), ...
  )
}

#' Add checklist item
#'
#' Add item to a checklist.
#'
#' @param checklist Checklist id.
#' @param name Item name (text).
#' @param position Position in the checklist; defaults to `"bottom"`.
#' @param checked Whether item should be checked; defaults to `FALSE`.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_checkitem = function(checklist, name, checked = FALSE, position = "bottom",
                         ...) {
  create_resource(
    resource = "checklist", id = checklist, path = "checkItems",
    body = list(name = name, pos = position, checked = tolower(checked)),
    ...
  )
}

#' Add card attachment
#'
#' Add attachment to a card.
#'
#' @param card Card id.
#' @param file,url Path to a file to be attached, or a URL.
#' @param cover Whether the attached file should be set as cover.
#' @param name Name of the attachment, shown inside the card.
#' @param ... Additional arguments passed to [create_resource()].
#' @export
#'
#' @family functions to create resources

add_card_attachment = function(card, file = NULL, url = NULL, cover = FALSE,
                               name = NULL, ...) {
  create_resource(
    resource = "card", path = "attachments", id = card,
    body = list(name = name, file = httr::upload_file(file), url = url,
                setCover = cover),
    ...)
}
