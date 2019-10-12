#######################
#                     #
#    Trello search    #
#                     #
#######################

#' Search models
#'
#' Deprecated. Use \code{\link{search_model}}
#' @param string Text to search for
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}} \code{\link{get_token}}
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
    .Deprecated("search_model")
}

#' @export
#' @rdname trello_search
trello_search_actions = function(string, ...) {
  .Deprecated("search_actions")
}

#' @export
#' @rdname trello_search
trello_search_cards = function(string, ...) {
  .Deprecated("search_cards")
}

#' @export
#' @rdname trello_search
trello_search_boards = function(string, ...) {
  .Deprecated("search_boards")
}

#' @export
#' @rdname trello_search
trello_search_members = function(string, ...) {
  .Deprecated("search_members")
}

#' @export
#' @rdname trello_search
trello_search_teams = function(string, ...) {
  .Deprecated("search_teams")
}
