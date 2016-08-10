###########################################
#                                         #
#    Retrieve data related to a card      #
#                                         #
###########################################

#' Get Card
#'
#' Returns a flat \code{data.frame} with card-related data.
#' @param id Card ID
#' @param ... Additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @name get_card
NULL

#' @export
#' @rdname get_card
get_card_actions = function(id, ...) {

    dat = trello_get(parent = "card", child = "actions", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_card_checklists = function(id, ...) {

    dat = trello_get(parent = "card", child = "checklists", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_comments = function(id, ...) {

    dat = trello_get(parent = "card", child = "actions", id = id,
                     filter = "commentCard", ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_labels = function(id, ...) {

    dat = trello_get(parent = "card", child = "labels", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_card
get_card_members = function(id, ...) {

    dat = trello_get(parent = "card", child = "members", id = id, ...)
    return(dat)
}
