###########################################
#                                         #
#    Retrieve data related to a card      #
#                                         #
###########################################

#' Get Card
#'
#' Returns a flat \code{data.frame} with card-related data.
#'
#' As of now, Trello API does not allow recursion for custom fields, so they can
#' only be fetched one card at a time.
#' @param id Card ID
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @name get_card
NULL

#' @export
#' @rdname get_card
get_card_actions = function(id, ...) {

    dat = get_model(parent = "card", child = "actions", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_card_checklists = function(id, ...) {

    dat = get_model(parent = "card", child = "checklists", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_comments = function(id, ...) {

    dat = get_model(parent = "card", child = "actions", id = id,
                     filter = "commentCard", ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_labels = function(id, ...) {

    dat = get_model(parent = "card", child = "labels", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_members = function(id, ...) {

    dat = get_model(parent = "card", child = "members", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_fields = function(id, ...) {

  dat = get_model(
    parent = "card", id = id, child = "pluginData", ...
  )

  dat = jsonlite::fromJSON(dat$value)$fields

  data.frame(
    id = names(dat), o = unlist(dat),
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}
