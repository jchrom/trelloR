#######################
#                     #
#    Trello search    #
#                     #
#######################

#' Search models
#'
#' Returns a \code{list} with search results.
#' @param string Text to search for
#' @param ... Additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}} \code{\link{trello_get_token}}
#' @name trello_search
#' @examples
#' # Searches are only possible if authorized - a token is required:
#'
#' \dontrun{
#'
#' trello_search("Anything with this text", my_token)
#' trello_search_cards("A card with this text", my_token)
#'
#' }
NULL

#' @export
#' @rdname trello_search
trello_search = function(string, ...) {

    dat = trello_get(parent = "search", id = NULL, child = NULL,
                     query = list(query = string), ...)
    return(dat)
}

#' @export
#' @rdname trello_search
trello_search_actions = function(string, ...) {

    string = paste0(string, "?modelTypes:actions")
    dat = trello_get(parent = "search", id = NULL, child = NULL,
                     query = list(query = string), ...)
    return(dat)
}

#' @export
#' @rdname trello_search
trello_search_cards = function(string, ...) {

    string = paste0(string, "?modelTypes:cards")
    dat = trello_get(parent = "search", id = NULL, child = NULL,
                     query = list(query = string), ...)
    return(dat)
}

#' @export
#' @rdname trello_search
trello_search_boards = function(string, ...) {

    string = paste0(string, "?modelTypes:boards")
    dat = trello_get(parent = "search", id = NULL, child = NULL,
                     query = list(query = string), ...)
    return(dat)
}

#' @export
#' @rdname trello_search
trello_search_members = function(string, ...) {

    string = paste0(string, "?modelTypes:members")
    dat = trello_get(parent = "search", id = NULL, child = NULL,
                     query = list(query = string), ...)
    return(dat)
}

#' @export
#' @rdname trello_search
trello_search_teams = function(string, ...) {

    string = paste0(string, "?modelTypes:organizations")
    dat = trello_get(parent = "search", id = NULL, child = NULL,
                     query = list(query = string), ...)
    return(dat)
}
