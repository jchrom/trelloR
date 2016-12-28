# PRINT METHODS FOR S3 OBJECTS

#' Printing Trello API objects
#'
#' Print data.frame containing cards.
#' @param x object of class cards_df, members_df etc
#' @name print.trello_api
NULL

#' @export
#' @importFrom dplyr data_frame
#' @rdname print.trello_api

print.cards_df = function(x) {
  stopifnot(is.cards_df(x))
  print(
    data_frame(
      n_cards = length(unique(x[["id"]])),
      closed = sum(x[["closed"]]),
      oldest = as_POSIXct_hex(strtrim(min(x[["id"]]), 8)),
      newest = as_POSIXct_hex(strtrim(max(x[["id"]]), 8))
    )
  )
}

#' @export
#' @importFrom dplyr %>% group_by summarise
#' @rdname print.trello_api

print.actions_df = function(x) {
  stopifnot(is.actions_df(x))
  print(
    x %>%
      group_by(type) %>%
      summarise(
        n_actions = length(unique(id)),
        n_cards = length(unique(data.card.id)),
        n_members = length(unique(memberCreator.id)))
  )
}

#' @export
#' @importFrom dplyr %>% select
#' @rdname print.trello_api

print.labels_df = function(x) {
  stopifnot(is.labels_df(x))
  print(
    x %>% select(name, color, uses)
  )
}
