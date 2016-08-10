############################################
#                                          #
#    Retrieve data related to a board      #
#                                          #
############################################

#' Get Board
#'
#' Returns a flat \code{data.frame} with board-related data.
#' @param id Board ID
#' @param ... Additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @name get_board
NULL

#' @export
#' @rdname get_board
get_board_actions = function(id, ...) {

    dat = trello_get(parent = "board", child = "actions", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_board_cards = function(id, ...) {

    dat = trello_get(parent = "board", child = "cards", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_board_checklists = function(id, ...) {

    dat = trello_get(parent = "board", child = "checklists", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_board_comments = function(id, ...) {

    dat = trello_get(parent = "board", child = "actions", id = id,
                     filter = "commentCard", ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_board_labels = function(id, ...) {

    dat = trello_get(parent = "board", child = "labels", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_board_lists = function(id, ...) {

    dat = trello_get(parent = "board", child = "lists", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_board
get_board_members = function(id, ...) {

    dat = trello_get(parent = "board", child = "members", id = id, ...)
    return(dat)
}
