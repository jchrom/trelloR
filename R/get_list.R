###########################################
#                                         #
#    Retrieve data related to a list      #
#                                         #
###########################################

#' Get List
#'
#' Returns a flat \code{data.frame} with list-related data.
#' @param id Board ID
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @name get_list
NULL

#' @export
#' @rdname get_list
get_list_actions = function(id, ...) {

    dat = get_model(parent = "list", child = "actions", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_list
get_list_cards = function(id, ...) {

    dat = get_model(parent = "list", child = "cards", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_list
get_list_comments = function(id, ...) {

    dat = get_model(parent = "list", child = "actions", id = id,
                     filter = "commentCard", ...)
    return(dat)
}
