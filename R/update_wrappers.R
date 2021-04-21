#' Update card
#'
#' Update name, description, assigned members and other fields.
#' @param card Card id
#' @param body A named list of query parameters.
#' @param ... Additional arguments passed to [update_resource()].
#' @export

update_card = function(card, body = NULL, ...) {
  update_resource(
    resource = "card", id = card, body = body, ...
  )
}

#' Update card members
#'
#' Replace currently assigned members.
#' @param card Card id.
#' @param members A character vector of one or more member id.
#' @param ... Additional arguments passed to [update_resource()].
#' @export

update_card_members = function(card, members, ...) {
  stopifnot(is.character(members))
  update_resource(
    resource = "card", id = card,
    body = list(idMembers = paste(members, collapse = ",")), ...
  )
}

#' Update card labels
#'
#' Replace currently assigned labels.
#' @param card Card id.
#' @param labels A character vector of one or more label id.
#' @param ... Additional arguments passed to [update_resource()].
#' @export

update_card_labels = function(card, labels, ...) {
  stopifnot(is.character(labels))
  update_resource(
    resource = "card", id = card,
    body = list(idLabels = paste(labels, collapse = ",")), ...
  )
}

#' Move card
#'
#' Move card to another list.
#' @param card Card id.
#' @param list List id.
#' @param ... Additional arguments passed to [update_resource()].
#' @export

move_card = function(card, list, ...) {
  stopifnot(is.character(list))
  update_resource(
    resource = "card", id = card, body = list(idList = list), ...
  )
}

#' Update item
#'
#' Update checklist item state, name, position and which checklist it is in.
#' @param card Card id.
#' @param checkitem Checklist item id.
#' @param body A named list of query parameters. Defaults to
#'   `list(state = "complete")`, which makes the item complete.
#' @param ... Additional arguments passed to [update_resource()].
#' @export

update_checkitem = function(card, checkitem, body = list(state = "complete"),
                            ...) {
  r = update_resource(
    resource = "card", id = card, path = c("checkItem", checkitem),
    body = body, ...
  )
}
