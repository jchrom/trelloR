# Functions that retrieve data related to a member

#' Get Own Boards
#'
#' Returns a flat \code{data.frame} with all your boards.
#' @param token previously generated token, see \code{\link{trello_get_token}} for info on how to obtain it
#' @param ... Additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_my_boards = function(token, ...) {

    fun = trello_req(parent = "member", child = "boards")
    dat = fun(id = "me", token = token, ...)

    return(dat)
}

#' Get Member's Boards
#'
#' Returns a flat \code{data.frame} with all boards associated with a member.
#' @param id member ID
#' @param ... Additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_member_boards = function(id, ...) {

    fun = trello_req(parent = "member", child = "boards")
    dat = fun(id, ...)

    return(dat)
}
