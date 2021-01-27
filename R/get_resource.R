#' Get Data From Trello API
#'
#' Fetch resources using Trello API.
#'
#' @section Request limits:
#'
#' At maximum, the API can retrieve 1000 results in a single call. Setting
#' `limit > 1000` will activate paging. When paging is used, the request will
#' be issued repeatedly, retrieving new batch of results each time until
#' the `limit` is reached or there is nothing else to fetch. Results are fetched
#' chronologically, ie. newest results are retrieved first (eg. newest cards).
#' Use `limit = Inf` to make sure you get all.
#'
#' @section Errors:
#'
#' If the request fails, server error messages are reprinted on the console.
#' Depending on the value of `on.error`, the request call can throw an error
#' in R (this is the default), or can issue a warning/message. If the latter,
#' the function returns a data frame containing the failed URL, HTTP status
#' and an informative message (produced by the server).
#'
#' @section Results:
#'
#' The API returns JSON objects which are parsed using [jsonlite::fromJSON()].
#' Non-JSON results throw an error, but these should never happen anyway. The
#' result is always a data frame, or a `tibble` if the package is installed.
#'
#' @section Filter:
#'
#' Both `filter` and `limit` exist as explicitly defined arguments, but you can
#' ignore them in favor of supplying their values as query parameters, eg.
#' `query = list(filter = "filter_value", limit = "limit_value")`.
#'
#' @param parent Parent resource, e.g. `"board"` or `NULL`.
#' @param child Child resource, eg. `"card"` or `NULL`.
#' @param id Resource ID or `NULL`.
#' @param token An object of class `"Trello_API_token"`, a path or `NULL`.
#'
#'   * If a `Token`, it is passed as is.
#'   * If `NULL` and a cache file called `".httr-oauth"` exists, the newest token
#'     is read from it. If the file is not found, an error is thrown.
#'   * If a character vector of length 1, it will be used as an alternative path
#'     to the cache file.
#'
#' @param query Named list of key-value pairs, see [httr::GET()] for details.
#' @param url Url for the GET request. Can be `NULL` if `parent` is specified,
#'   or a combination of `parent`, `child` and `id` is provided.
#' @param filter Defaults to `"all"` which includes both open and archived cards
#'   or all action types, depending on what resource is requested.
#' @param limit Defaults to `100`. Set to `Inf` to get everything.
#' @param on.error Whether to `"stop"`, `"warn"` or `"message"` on API error.
#' @param retry.times How many times to re-try when a request fails. Defaults
#'   to 1.
#' @param handle The handle to use with this request, see [httr::RETRY()].
#' @param verbose Set to `TRUE` for verbose output.
#' @param response,paging,bind.rows Deprecated.
#'
#' @seealso [get_token()], [get_id()], [httr::GET()], [jsonlite::fromJSON()]
#'
#' @return A data frame with API responses.
#'
#' @export
#'
#' @examples
#'
#' # Public boards can be accessed without authorization, so there is no need
#' # to create a token, just the board id:
#' url = "https://trello.com/b/wVWPK9I4/r-client-for-the-trello-api"
#' bid = get_id_board(url)
#'
#' # Getting resources from the whole board. `filter="all"` fetches archived
#' # cards as well.
#' labels = get_board_labels(bid)
#' cards = get_board_cards(bid, filter = "all")
#'
#' # It is possible to call `get_resource()` directly:
#' lists = get_resource(parent = "board", child = "lists", id = bid)
#'
#' # As with boards, cards can be queried for particular resources, in this case
#' # to obtain custom fields:
#' card = cards$id[5]
#' acts = get_card_fields(card)
#'
#' # Set `limit` to specify the number of results. Pagination will be used
#' # whenever limit exceeds 1000. Use `limit=Inf` to make sure you get all.
#'
#' \dontrun{
#' all_actions = get_board_actions(bid, limit = Inf)
#' }
#'
#' # For private and team boards, a secure token is required:
#'
#' \dontrun{
#' key = Sys.getenv("MY_TRELLO_KEY")
#' secret = Sys.getenv("MY_TRELLO_SECRET")
#'
#' token = get_token("my_app", key = key, secret = secret,
#'                   scope = c("read", "write"))
#'
#' # Token is now cached, no need to pass it explicitly.
#' cards_open = get_board_cards(board_id, filter = "open")
#' }

get_resource = function(parent = NULL, child = NULL, id = NULL, token = NULL,
                        query = NULL, url = NULL, filter = NULL, limit = 100,
                        on.error = c("stop", "warn", "message"),
                        retry.times = 1, handle = NULL,
                        verbose = FALSE, response, paging, bind.rows)
{

  warn_for_argument(paging)
  warn_for_argument(bind.rows)
  warn_for_argument(response)

  if (!missing(paging) && paging) {
    message("setting `limit` to Inf because `paging=TRUE`")
    limit = Inf
  } else if (!missing(paging)) {
    message("setting `limit` to 1000 (a single page) because `paging=FALSE`")
    limit = Inf
  }

  on.error = match.arg(on.error, several.ok = FALSE)

  if (is.null(url)) {

    path = c(1, parent, extract_id(id), child)

    query = utils::modifyList(
      as.list(query), list(limit = limit, filter = filter)
    )

    # NOTE: `path` overrides `url` if `url` includes `path`.
    url = httr::modify_url("https://api.trello.com", path = path,
                           query = query)

  }

  if (is_nested(url)) {

    result = get_nested(url, limit = limit, token = token,
                        on.error = on.error,
                        retry.times = retry.times, handle = handle,
                        verbose = verbose)

  } else {

    result = trello_api_verb("GET", url = url, times = retry.times,
                             handle = handle, token = token,
                             verbose = verbose, query = query,
                             on.error = on.error)

    if (is_search(url)) {
      result = quick_df_search(result)
    } else {
      result = structure(wrap_list(result), row.names = c(NA, -1),
                         class = "data.frame")
    }

  }

  require_tibble(result)

}

is_nested = function(url) {
  path = httr::parse_url(url)[["path"]]
  length(strsplit(path, "/")[[1]]) > 3
}

is_search = function(url) {
  path = httr::parse_url(url)[["path"]]
  identical(strsplit(path, "/")[[1]][2], "search")
}

quick_df_search = function(x) {

  search_options = x[["options"]][[1]]

  search_results = x[setdiff(names(x), "options")]

  message("Fetched ", sum(vapply(search_results, NROW, 1L)), " search results.")

  structure(wrap_list(c(search_options, search_results)),
            class = "data.frame",
            row.names = c(NA, -1))

}

wrap_list = function(x) {
  x[lengths(x) > 1] = lapply(x[lengths(x) > 1], list)
  Filter(length, x)
}
