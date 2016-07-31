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

    fun = trello_req(parent = "card", child = "actions")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_card
get_card_comments = function(id, ...) {

    fun = trello_req(parent = "card", child = "actions", filter = "commentCard")
    dat = fun(id, ...)

    return(dat)
}

#' @export
#' @rdname get_card
get_card_members = function(id, ...) {

    fun = trello_req(parent = "card", child = "members")
    dat = fun(id, ...)

    return(dat)
}
