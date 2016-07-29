# Retrieve data related to a board

#' Get Board Cards
#'
#' Given a board ID, returns a flat \code{data.frame} with card-related data.
#' @param id board id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_board_cards = function(id, ...) {

    fun = trello_req(parent = "board", child = "cards")
    dat = fun(id, ...)

    return(dat)
}

#' Get Board Actions
#'
#' Given a board ID, returns a flat \code{data.frame} with actions-related data.
#' @param id board id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_board_actions = function(id, ...) {

    fun = trello_req(parent = "board", child = "actions")
    dat = fun(id, ...)

    return(dat)
}

#' Get Board Lists
#'
#' Given a board ID, returns a flat \code{data.frame} with lists-related data.
#' @param id board id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_board_lists = function(id, ...) {

    fun = trello_req(parent = "board", child = "lists")
    dat = fun(id, ...)

    return(dat)
}

#' Get Board Members
#'
#' Given a board ID, returns a flat \code{data.frame} with members-related data.
#' @param id board id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_board_members = function(id, ...) {

    fun = trello_req(parent = "board", child = "members")
    dat = fun(id, ...)

    return(dat)
}

#' Get Board Labels
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id board id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_board_labels = function(id, ...) {

    fun = trello_req(parent = "board", child = "labels")
    dat = fun(id, ...)

    return(dat)
}

#' Get Board Comments
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id board id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_board_comments = function(id, ...) {

    fun = trello_req(parent = "board", child = "actions")
    dat = fun(id, filter = "commentCard", ...)

    return(dat)
}
