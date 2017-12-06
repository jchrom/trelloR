###################################
#                                 #
#    Search using search_model    #
#                                 #
###################################

#' Search models
#'
#' Returns a (nested) \code{data.frame} with search results.
#'
#' Search results include one \code{data.frame} per each model type found. They
#' can be narrowed down by model type and other attributes (see \href{https://developers.trello.com/v1.0/reference}{Trello API reference})
#' @param string Text to search for
#' @param modeltype Type of model to return; typically \code{"cards"}; defaults to \code{"all"}
#' @param boards Boards to limit the search to - defaults to \code{"mine"}
#' @param partial Should partial matching be used? Defaults to \code{FALSE}
#' @param query Name list of additional query parameters; consult \href{https://developers.trello.com/v1.0/reference}{Trello API reference}
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}} \code{\link{get_token}}
#' @name search_model
#' @examples
#' # Searches are only possible if authorized - a token is required:
#'
#' \dontrun{
#'
#' search_model("Anything with this text", token = mytoken)
#' search_cards("A card with this text", token = mytoken)
#'
#' }
NULL

#' @export
#' @rdname search_model
search_model = function(string, modeltype = "all", boards = "mine",
                        partial = FALSE, query = list(), ...) {
  get_model(
    parent = "search",
    query = c(
      list(
        query = string,
        modelTypes = paste(modeltype, collapse = ","),
        idBoards = paste(boards, collapse = ","),
        partial = tolower(partial)
      ),
      query
    ),
    ...
  )
}

#' @export
#' @rdname search_model
search_cards = function(string, boards = "mine", partial = FALSE,
                        query = list(), ...) {
  search_model(
    string = string, modeltype = "cards", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_model
search_actions = function(string, boards = "mine", partial = FALSE,
                          query = list(), ...) {
  search_model(
    string = string, modeltype = "actions", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_model
search_boards = function(string, boards = "mine", partial = FALSE,
                         query = list(), ...) {
  search_model(
    string = string, modeltype = "boards", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_model
search_members = function(string, boards = "mine", partial = FALSE,
                          query = list(), ...) {
  search_model(
    string = string, modeltype = "members", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_model
search_teams = function(string, boards = "mine", partial = FALSE,
                        query = list(), ...) {
  search_model(
    string = string, modeltype = "organizations", boards = boards,
    partial = partial, query = query, ...
  )
}



