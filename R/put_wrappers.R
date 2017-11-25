######################
#                    #
#    PUT wrappers    #
#                    #
######################

#' Update card
#'
#' Update name, description, assigned members and other fields.
#' @param card Card id
#' @param body A named list of query parameters (will be passed as body with \code{encoding = "json"})
#' @param ... Additional arguments passed to \code{\link{put_model}}
#' @export

update_card = function(card, body = NULL, ...) {
  put_model(
    model = "card", id = card, token = token, body = body, ...
  )
}

#' Update card members
#'
#' Replace currently assigned members.
#' @param card Card id
#' @param members A character vector of one or more member id
#' @param ... Additional arguments passed to \code{\link{put_model}}
#' @export

update_card_members = function(card, members, ...) {
  stopifnot(is.character(members))
  put_model(
    model = "card", id = card,
    body = list(idMembers = paste(members, collapse = ",")), ...
  )
}

#' Update card labels
#'
#' Replace currently assigned labels.
#' @param card Card id
#' @param labels A character vector of one or more label id
#' @param ... Additional arguments passed to \code{\link{put_model}}
#' @export

update_card_labels = function(card, labels, ...) {
  stopifnot(is.character(labels))
  put_model(
    model = "card", id = card,
    body = list(idLabels = paste(labels, collapse = ",")), ...
  )
}

#' Move card
#'
#' Move card to another list.
#' @param card Card id
#' @param list List id
#' @param ... Additional arguments passed to \code{\link{put_model}}
#' @export

move_card = function(card, list, ...) {
  stopifnot(is.character(list))
  put_model(
    model = "card", id = card, body = list(idList = list), ...
  )
}

#' Update item
#'
#' Update checklist item state, name, position and which chekclist it is in.
#' @param card Card id
#' @param checkitem Checklist item id
#' @param body A named list of query parameters (will be passed as body with \code{encoding = "json"}); defaults to \code{list(state = "complete")}, which checks the item out
#' @param ... Additional arguments passed to \code{\link{put_model}}
#' @export

update_checkitem = function(card, checkitem, body = list(state = "complete"),
                            ...) {
  r = put_model(
    model = "card", id = card, path = c("checkItem", checkitem),
    body = body, ...
  )
}
