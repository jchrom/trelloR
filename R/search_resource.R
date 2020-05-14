#' Search Trello
#'
#' Search for resources.
#'
#' Search can be narrowed down by resource type and will return a single data
#' frame per each type (if anything is found). The value of the `resource`
#' argument is passed on `modelTypes` - see other attributes
#' at [search API reference](https://developer.atlassian.com/cloud/trello/rest/#api-search-get).
#'
#' @param string Text to search for.
#' @param resource Type of resource to return; typically `"cards"`. Defaults to
#'   `"all"`.
#' @param boards Boards to limit the search to - defaults to `"mine"`.
#' @param partial Should partial matching be used? Defaults to `FALSE`.
#' @param query Name list of additional query parameters; consult [search API reference](https://developer.atlassian.com/cloud/trello/rest/#api-search-get)
#' @param ... Additional arguments passed to [get_resource()].
#' @param modeltype Deprecated, use `resource` instead.
#'
#' @seealso [get_resource()], [get_token()]
#'
#' @return A data frame.
#'
#' @name search_resource
#' @examples
#'
#' \dontrun{
#'
#' search_resource("Anything with this text")
#' search_cards("A card with this text")
#'
#' }
NULL

#' @export
#' @rdname search_resource
search_resource = function(string, resource = "all", boards = "mine",
                           partial = FALSE, query = list(), modeltype, ...) {

  if (!missing(modeltype)) {
    message("`modeltype` is deprecated. Use `resource` instead.")
    resource = modeltype
  }

  get_resource(
    parent = "search",
    query = c(
      list(
        query = string,
        modelTypes = paste(resource, collapse = ","),
        idBoards = paste(boards, collapse = ","),
        partial = tolower(partial)
      ),
      query
    ),
    ...
  )
}

#' @export
#' @rdname search_resource
search_cards = function(string, boards = "mine", partial = FALSE,
                        query = list(), ...) {
  search_resource(
    string = string, resource = "cards", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_resource
search_actions = function(string, boards = "mine", partial = FALSE,
                          query = list(), ...) {
  search_resource(
    string = string, resource = "actions", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_resource
search_boards = function(string, boards = "mine", partial = FALSE,
                         query = list(), ...) {
  search_resource(
    string = string, resource = "boards", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_resource
search_members = function(string, boards = "mine", partial = FALSE,
                          query = list(), ...) {
  search_resource(
    string = string, resource = "members", boards = boards,
    partial = partial, query = query, ...
  )
}

#' @export
#' @rdname search_resource
search_teams = function(string, boards = "mine", partial = FALSE,
                        query = list(), ...) {
  search_resource(
    string = string, resource = "organizations", boards = boards,
    partial = partial, query = query, ...
  )
}
