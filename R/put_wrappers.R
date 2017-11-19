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
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{PUT}}
#' @param ... Additional arguments passed to \code{\link[httr]{PUT}}
#' @export

update_card = function(card, body = NULL, token, verbose = FALSE, ...) {
  put_model(
    model = "card", id = card, token = token, body = body,
    verbose = verbose, ...
  )
}

#' Update card members
#'
#' Replace currently assigned members.
#' @param card Card id
#' @param members A character vector of one or more member id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{PUT}}
#' @param ... Additional arguments passed to \code{\link[httr]{PUT}}
#' @export

update_card_members = function(card, members, token, verbose = FALSE, ...) {
  stopifnot(is.character(members))
  put_model(
    model = "card", id = card, token = token,
    body = list(idMembers = paste(members, collapse = ",")),
    verbose = verbose, ...
  )
}

#' Update card labels
#'
#' Replace currently assigned labels.
#' @param card Card id
#' @param labels A character vector of one or more label id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{PUT}}
#' @param ... Additional arguments passed to \code{\link[httr]{PUT}}
#' @export

update_card_labels = function(card, labels, token, verbose = FALSE, ...) {
  stopifnot(is.character(labels))
  put_model(
    model = "card", id = card, token = token,
    body = list(idLabels = paste(labels, collapse = ",")),
    verbose = verbose, ...
  )
}

#' Move card
#'
#' Move card to another list.
#' @param card Card id
#' @param list List id
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{PUT}}
#' @param ... Additional arguments passed to \code{\link[httr]{PUT}}
#' @export

move_card = function(card, list, token, verbose = FALSE, ...) {
  stopifnot(is.character(list))
  put_model(
    model = "card", id = card, token = token, body = list(idList = list),
    verbose = verbose, ...
  )
}

#' Update item
#'
#' Update checklist item state, name, position and which chekclist it is in.
#' @param card Card id
#' @param item Checklist item id
#' @param body A named list of query parameters (will be passed as body with \code{encoding = "json"}); defaults to \code{list(state = "complete")}, which checks the item out
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{PUT}}
#' @param ... Additional arguments passed to \code{\link[httr]{PUT}}
#' @export

update_item = function(card, item, body = list(state = "complete"), token,
                       verbose = FALSE, ...) {
  r = put_model(
    model = "card", id = card, path = c("checkItem", item), token = token,
    body = body, verbose = verbose, ...
  )
}
