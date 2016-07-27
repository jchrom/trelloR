# Functions that retrieve data related to a member

#' Get Own Boards
#'
#' Returns a flat \code{data.frame} with all your boards.
#' @param token previously generated token, see \code{\link{trello_get_token}} for info on how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or return it as is. Defaults to \code{TRUE}
#' @export

get_my_boards = function(token, paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "member", child = "boards")
    dat = fun(id = "me", token = token,
              query = NULL,
              paging = paging, fix = fix)

    return(dat)
}

#' Get Member's Boards
#'
#' Returns a flat \code{data.frame} with all your boards.
#' @param id member ID
#' @param token previously generated token, see \code{\link{trello_get_token}} for info on how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or return it as is. Defaults to \code{TRUE}
#' @export

get_member_boards = function(id, token, paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "member", child = "boards")
    dat = fun(id, token = token,
              query = NULL,
              paging = paging, fix = fix)

    return(dat)
}
