#' Get Board
#'
#' Returns a flat \code{data.frame} with board-related data.
#'
#' @param id Board ID
#' @param ... Additional arguments passed to \code{\link{get_resource}}
#' @seealso \code{\link{get_resource}}
#' @name get_board
#' @examples
#' \dontrun{
#' #Get cards with custom fields
#' cards = get_board_cards(board_id, query = list(customFieldItems = "true"))
#' }
NULL

#' @export
#' @rdname get_board
get_board_actions = function(id, ...) {
  dat = get_resource(parent = "board", child = "actions", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_cards = function(id, ...) {
  dat = get_resource(parent = "board", child = "cards", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_checklists = function(id, ...) {
  dat = get_resource(parent = "board", child = "checklists", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_comments = function(id, ...) {
  dat = get_resource(parent = "board", child = "actions", id = id,
                  filter = "commentCard", ...)
  dat
}

#' @export
#' @rdname get_board
get_board_labels = function(id, ...) {
  dat = get_resource(parent = "board", child = "labels", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_lists = function(id, ...) {
  dat = get_resource(parent = "board", child = "lists", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_members = function(id, ...) {
  dat = get_resource(parent = "board", child = "members", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_fields = function(id, ...) {
  dat = get_resource(parent = "board", child = "customFields", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_prefs = function(id, ...) {

  dat  = get_resource(parent = "board", id = id, ...)

  pref = dat[["prefs"]][[1]]
  misc = dat[setdiff(names(diff), "prefs")]

  result = structure(
    wrap_list(c(pref, misc)),
    class     = "data.frame",
    row.names = .set_row_names(1))

  if (requireNamespace("tibble", quietly = TRUE)) {
    return(tibble::as_tibble(result))
  }

  result
}
