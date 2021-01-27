#' Get List
#'
#' Returns a flat data frame with list-related data.
#' @param id Board ID
#' @param ... Additional arguments passed to [get_resource()]
#' @seealso [get_resource()]
#' @name get_list
NULL

#' @export
#' @rdname get_list
get_list_actions = function(id, ...) {
    get_resource(parent = "list", child = "actions", id = id, ...)
}

#' @export
#' @rdname get_list
get_list_cards = function(id, ...) {
    get_resource(parent = "list", child = "cards", id = id, ...)
}

#' @export
#' @rdname get_list
get_list_comments = function(id, ...) {
    get_resource(parent = "list", child = "actions", id = id,
                 filter = "commentCard", ...)
}
