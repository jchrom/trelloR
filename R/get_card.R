# Retrieve data related to a card

#' Get Card Actions
#'
#' Given a card ID, returns a flat \code{data.frame} with actions-related data.
#' @param id card id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_card_actions = function(id, ...) {

    fun = trello_req(parent = "card", child = "actions")
    dat = fun(id, ...)

    return(dat)
}

#' Get Card Comments
#'
#' Given a card ID, returns a flat \code{data.frame} with comments-related data.
#' @param id card id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_card_comments = function(id, ...) {

    fun = trello_req(parent = "card", child = "actions")
    dat = fun(id, filter = "commentCard", ...)

    return(dat)
}

#' Get Card Members
#'
#' Given a card ID, returns a flat \code{data.frame} with members-related data.
#' @param id card id
#' @param ... additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @export

get_card_members = function(id, ...) {

    fun = trello_req(parent = "card", child = "members")
    dat = fun(id, ...)

    return(dat)
}
