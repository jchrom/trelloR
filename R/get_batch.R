#' Dispatch a Batch Request
#'
#' Perform 1 to 10 GET requests at once.
#'
#' @param parent Parent resource, e.g. `"board"`.
#' @param child Child resource, eg. `"card"`.
#' @param ids A vector of resource IDs, with maximum length of 10.
#' @param token An object of class `"Trello_API_token"`, a path or `NULL`.
#'
#'   * If a `Token`, it is passed as is.
#'   * If `NULL` and a cache file called `".httr-oauth"` exists, the newest token
#'     is read from it. If the file is not found, an error is thrown.
#'   * If a character vector of length 1, it will be used as an alternative path
#'     to the cache file.
#'
#' @param query Named list of key-value pairs, appended to each component
#'   of the batch request. See [httr::GET()] for details. NOTE: If you require
#'   different query with each batch component, build the list of URLs
#'   yourself using [get_resource()], as per [Trello API reference](https://developer.atlassian.com/cloud/trello/rest/api-group-batch/#api-group-batch).
#' @param on.error Whether to `"stop"`, `"warn"` or `"message"` on API error.
#' @param retry.times How many times to re-try when a request fails. Defaults
#'   to 1.
#' @param handle The handle to use with this request, see [httr::RETRY()].
#' @param verbose Set to `TRUE` for verbose output.
#'
#' @seealso [get_token()], [get_id()], [httr::GET()], [jsonlite::fromJSON()]
#'
#' @return A data frame (or a tibble, if installed).
#' @export
#'
#' @examples
#'
#' demo_board <- "https://trello.com/b/wVWPK9I4/r-client-for-the-trello-api"
#'
#' if (FALSE) {
#' # Download custom field values for 10 cards.
#' cards <- get_board_cards(demo_board, limit = 10)
#' values <- get_batch(
#'   parent = "card",
#'   child = "customFieldItems",
#'   ids = cards$id
#' )
#' values
#' }

get_batch = function(parent, child, ids, token = NULL, query = NULL,
                     on.error = c("stop", "warn", "message"),
                     retry.times = 1, handle = NULL, verbose = FALSE)
{
  stopifnot("`ids` must be a character vector" = is.character(ids))
  stopifnot("`ids` must be of length 1 to 10" = length(ids) > 1 && length(ids) < 11)

  on.error = match.arg(on.error, several.ok = FALSE)

  paths = sprintf("/%s/%s/%s", parent, vapply(ids, extract_id, ""), child)

  if (!is.null(query)) {
    paths <- paste0(paths, "?", compose_query(query))
  }

  result <- trello_api_verb(
    verb = "GET",
    url = "https://api.trello.com/1/batch",
    token = NULL,
    times = 1,
    handle = NULL,
    verbose = FALSE,
    query = list(urls = paste(paths, collapse = ","))
  )

  require_tibble(cbind(card.id = ids, result))
}

compose_query <- function(query) {
  names <- curl::curl_escape(names(query))
  encode <- function(x) {
    if (inherits(x, "AsIs"))
      return(x)
    curl::curl_escape(x)
  }
  values <- vapply(query, encode, character(1))
  paste0(names, "=", values, collapse = "&")
}
