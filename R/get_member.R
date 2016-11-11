# Functions that retrieve data related to a member

#' Get Own Boards
#'
#' Returns a flat \code{data.frame} with all your boards.
#' @param token Secure token - get it with \code{\link{trello_get_token}}
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @export

get_my_boards = function(token, ...) {

    dat = get_model(parent = "member", child = "boards", id = "me",
                     token = token, ...)
    return(dat)
}

#' Get Member's Boards
#'
#' Returns a flat \code{data.frame} with member-related data.
#' @param id member ID or username
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @export
get_member_boards = function(id, ...) {

    dat = get_model(parent = "member", child = "boards", id = id, ...)
    return(dat)
}

#' Get Member Info
#'
#' Returns a flat \code{data.frame} with member-related data.
#' @param id member ID or username
#' @param fields by default fetches fullName, username, memberType, bio
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @export
get_member_fields = function(id,
                             fields = c("fullName", "username", "memberType",
                                        "bio"),
                             ...) {

    dat = get_model(parent = "member", child = NULL, id = id,
                     query = list(fields = paste0(fields, collapse = ",")),
                     ...)
    return(dat)
}
