############################################
#                                          #
#    Retrieve data related to a board      #
#                                          #
############################################

#' Get Board
#'
#' Returns a flat \code{data.frame} with board-related data.
#'
#' @param id Board ID
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
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
  dat = get_model(parent = "board", child = "actions", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_cards = function(id, ...) {
  dat = get_model(parent = "board", child = "cards", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_checklists = function(id, ...) {
  dat = get_model(parent = "board", child = "checklists", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_comments = function(id, ...) {
  dat = get_model(parent = "board", child = "actions", id = id,
                  filter = "commentCard", ...)
  dat
}

#' @export
#' @rdname get_board
get_board_labels = function(id, ...) {
  dat = get_model(parent = "board", child = "labels", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_lists = function(id, ...) {
  dat = get_model(parent = "board", child = "lists", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_members = function(id, ...) {
  dat = get_model(parent = "board", child = "members", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_fields = function(id, ...) {
  dat = get_model(parent = "board", child = "customFields", id = id, ...)
  dat
}

#' @export
#' @rdname get_board
get_board_prefs = function(id, ...) {

  dat = get_model(parent = "board", id = id, ...)

  prefs_li = Filter(Negate(is.null), dat$prefs[[1]])

  prefs_df = as.data.frame(prefs_li, stringsAsFactors = FALSE)

  board_df = dat[, !names(dat) %in% "prefs"]

  cbind(board_df, prefs_df)
}
