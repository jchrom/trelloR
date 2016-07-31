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
get_board_cards = function(id, ...) {

    fun = trello_req(parent = "board", child = "cards")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_board
get_board_actions = function(id, ...) {

    fun = trello_req(parent = "board", child = "actions")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_board
get_board_lists = function(id, ...) {

    fun = trello_req(parent = "board", child = "lists")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_board
get_board_members = function(id, ...) {

    fun = trello_req(parent = "board", child = "members")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_board
get_board_labels = function(id, ...) {

    fun = trello_req(parent = "board", child = "labels")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_board
get_board_comments = function(id, ...) {

    fun = trello_req(parent = "board", child = "actions", filter = "commentCard")
    dat = fun(id, ...)

    return(dat)
}
