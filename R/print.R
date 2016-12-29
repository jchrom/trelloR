# PRINT METHODS FOR S3 OBJECTS

#' Printing Trello API objects
#'
#' Print data.frame containing cards.
#' @param x Object of class \code{cards_df}, \code{actions_df} etc
#' @param ... Further arguments passed to \code{\link[base]{print}}
#' @name print.trello_api
NULL

#' @export
#' @importFrom dplyr as_data_frame
#' @rdname print.trello_api
print.cards_df = function(x, ...) {
  stopifnot(is.cards_df(x))
  x = as_data_frame(
    list(
      n_cards = length(unique(x[["id"]])),
      closed = sum(x[["closed"]]),
      oldest = as_POSIXct_hex(strtrim(min(x[["id"]]), 8)),
      newest = as_POSIXct_hex(strtrim(max(x[["id"]]), 8))
    )
  )
  NextMethod("print")
}

#' @export
#' @importFrom dplyr %>% group_by_ summarise
#' @rdname print.trello_api
print.actions_df = function(x, ...) {
  stopifnot(is.actions_df(x))
  x = structure(
    as_data_frame(table(x[["type"]])),
    names = c("type", "n_actions")
  )
  NextMethod("print")
}

#' @export
#' @importFrom dplyr %>% select_
#' @rdname print.trello_api
print.labels_df = function(x, ...) {
  stopifnot(is.labels_df(x))
  x = select_(x, .dots =c("name", "color", "uses"))
  NextMethod("print")
}

#' @export
#' @importFrom tidyr unnest
#' @importFrom dplyr as_data_frame
#' @rdname print.trello_api
print.checklists_df = function(x, ...) {
  stopifnot(is.checklists_df(x))
  x = unnest(x, .sep = "_")
  x = as_data_frame(
      list(
        n_items = length(unique(x[["id"]])),
        complete = sum(x[["checkItems_state"]] == "complete"),
        incomplete = sum(x[["checkItems_state"]] == "incomplete")
      )
    )
  NextMethod("print")
}
