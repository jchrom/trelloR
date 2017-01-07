#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' If the request fails, server error messages are reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s or \code{list}s, while non-JSON type of response throws an error.
#'
#' When \code{limit > 1000}, paging is used. The ID of the earliest result is retrieved from every page and supplied to the next request as the value of the \code{"before"} parameter. PAging will stop after reaching the number of results specified by \code{limit}, or when there are no more data to get.
#'
#' \code{filter} and \code{limit} are query parameters that can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#' @param parent Parent structure (e.g. \code{"board"})
#' @param child Child structure (e.g. \code{"card"})
#' @param id Model ID
#' @param token Secure token, see \code{\link{trello_get_token}} for how to obtain it
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @param url Url for the GET request, use instead of specifying \code{parent}, \code{id} and \code{child}; see \code{\link[httr]{GET}} for details
#' @param filter Filter results by this string
#' @param limit Defaults to \code{1000}; set to \code{0} to get everything
#' @param paging Deprecated, use \code{limit = 0} instead
#' @param bind.rows By default, pages will be combined into one \code{data.frame} by \code{\link[dplyr]{bind_rows}}. Set to \code{FALSE} if you want \code{list} instead. This is useful on the rare occasion that the JSON response is not formatted correctly and makes \code{\link[dplyr]{bind_rows}} fail
#' @param add.class Assign additional S3 class (defaults to \code{TRUE})
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{trello_get_token}}, \code{\link{get_id}}
#' @importFrom dplyr bind_rows as_data_frame
#' @export
#' @examples
#' # No authorization is required to access public boards. Let's get
#' # the ID of Trello Development Roadmap board:
#' url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
#' bid = get_id_board(url)
#'
#' # Once we have the ID, we can use it to make specific queries:
#' labels = get_board_labels(bid)           # Get all labels
#' cards = get_board_cards(bid, limit = 5)  # Get 5 cards
#'
#' # We can also call get_model() directly:
#' lists = get_model(parent = "board", child = "lists", id = bid)
#'
#' # As with boards, cards can be queried for particular resources:
#' card1id = cards$id[1]
#' card1act = get_card_actions(card1id) # Get all actions performed on that card
#'
#' # To retrieve large results, paging might be necessary:
#'
#' \dontrun{
#'
#' tdr_actions = get_board_actions(bid, paging = TRUE)
#' }
#'
#' # For private boards, you need a secure token:
#'
#' \dontrun{
#'
#' token = get_token("your_key", "your_secret")
#' all_open_cards = get_board_cards(board_id, token, filter = "open")
#' }

get_model = function(parent = NULL, child = NULL, id = NULL,
                     token = NULL, query = NULL,
                     url = NULL, filter = NULL, limit = 1000, paging = FALSE,
                     bind.rows = TRUE, add.class = TRUE
) {

  if (!missing("paging")) {
    warning("paging is deprecated - set filter to 0 to fetch all", call. = FALSE)
    if (missing(limit) & paging) limit = 0
  }

  url   = build_url(url = url, parent = parent, child = child, id = id)
  query = build_query(query = query, filter = filter, limit = limit)
  result = get_pages(url = url, token = token, query = query)

  if (all(add.class, !is.null(child), !is.null(parent)))
    for (i in seq_along(result)) {
      result[[i]] = tryCatch(
        expr = add_class(result[[i]], child = child),
        error = function(e) {
          warning("Could not assign additional S3 class.", call. = FALSE)
          result[[i]]
        })
    }

  if (bind.rows)
    result = tryCatch(
      expr  = bind_rows(result),
      error = function(e) {
        message("Binding failed: ", e$message)
        message("Returning list (", length(result), " elements)")
        result
      })
  result
}

build_url = function(url, parent, id, child) {
  if (is.null(url))  {
    url = paste("https://api.trello.com/1", parent, id, child, sep = "/")
    url = gsub("[/]+$", "", url) #remove trailing /
  }
  url
}

build_query = function(query = NULL, filter = NULL, limit = 1000) {
  if (is.null(query)) query = list()
  query$filter = filter
  query$limit  = limit
  return(query)
}
