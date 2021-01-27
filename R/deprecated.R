#' Deprecated functions
#'
#' * Use [get_resource()] instead of `get_model()` or `trello_get()`
#' * Use [update_resource()] instead of `put_model()`
#' * Use [create_resource()] instead of `post_model()`
#' * Use [delete_resource()] instead of `delete_model()`
#' * Use [get_token()] instead of `trello_get_token()`
#' * Use [search_resource()] instead of `trello_search()`
#'
#' @param ... See current functions for argument names and defaults.
#'
#' @name Deprecated
NULL

#' @rdname Deprecated
#' @export
trello_get = function(...) {
  .Deprecated("get_resource")
  get_resource(...)
}

#' @rdname Deprecated
#' @export
get_model = function(...) {
  .Deprecated("get_resource")
  get_resource(...)
}

#' @rdname Deprecated
#' @export
post_model = function(...) {
  .Deprecated("create_resource")
  create_resource(...)
}

#' @rdname Deprecated
#' @export
put_model = function(...) {
  .Deprecated("update_resource")
  update_resource(...)
}

#' @rdname Deprecated
#' @export
delete_model = function(...) {
  .Deprecated("delete_resource")
  delete_resource(...)
}

#' @rdname Deprecated
#' @export
trello_get_token = function(...) {
  .Deprecated("get_token")
  get_token(...)
}

#' @rdname Deprecated
#' @export
trello_search = function(...) {
  .Deprecated("search_resource")
  search_resource(...)
}

#' @rdname Deprecated
#' @export
search_model = function(...) {
  .Deprecated("search_resource")
  search_resource(...)
}

#' @rdname Deprecated
#' @export
trello_search_actions = function(...) {
  .Deprecated("search_actions")
  search_actions(...)
}

#' @rdname Deprecated
#' @export
trello_search_cards = function(...) {
  .Deprecated("search_cards")
  search_cards(...)
}

#' @rdname Deprecated
#' @export
trello_search_boards = function(...) {
  .Deprecated("search_boards")
  search_boards(...)
}

#' @rdname Deprecated
#' @export
trello_search_members = function(...) {
  .Deprecated("search_members")
  search_members(...)
}

#' @rdname Deprecated
#' @export
trello_search_teams = function(...) {
  .Deprecated("search_teams")
  search_teams(...)
}
