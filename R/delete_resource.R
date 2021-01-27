#' Delete Resources
#'
#' Delete resources via Trello API.
#'
#' See [Trello API reference](https://developer.atlassian.com/cloud/trello/rest)
#' for more info about DELETE requests.
#'
#' @param resource,id Resource name (eg. `"card"`) and id.
#' @param path Path (optional).
#' @param token An object of class `"Trello_API_token"`, a path or `NULL`.
#'
#'   * If a `Token`, it is passed as is.
#'   * If `NULL` and a cache file called `".httr-oauth"` exists, the newest token
#'     is read from it. If the file is not found, an error is thrown.
#'   * If a character vector of length 1, it will be used as an alternative path
#'     to the cache file.
#'
#' @param verbose Whether to pass [httr::verbose()] to [httr::RETRY()].
#' @param on.error Behavior when HTTP status >= 300, defaults to `"stop"`.
#' @param handle Passed to [httr::RETRY()].
#' @param encode,response Deprecated.
#'
#' @return See `response`.
#'
#' @export
#' @examples
#'
#' \dontrun{
#'
#' # Get token with write access
#' key = Sys.getenv("MY_TRELLO_KEY")
#' secret = Sys.getenv("MY_TRELLO_SECRET")
#'
#' token = get_token("my_app", key = key, secret = secret,
#'                   scope = c("read", "write"))
#'
#' # Get board ID
#' url = "Your board URL"
#' bid = get_id_board(url, token)
#'
#' # Get cards and extract ID of the first one
#' cid = get_board_cards(bid, token)$id[1]
#'
#' # Delete it
#' delete_resource(resource = "card", id = cid, token = token)
#' }

delete_resource = function(resource, id = NULL, path = NULL, token = NULL,
                           on.error = c("stop", "warn", "message"),
                           verbose = FALSE, handle = NULL,
                           encode, response) {

  warn_for_argument(encode)
  warn_for_argument(response)

  url = httr::modify_url(
    url = "https://api.trello.com",
    path = c(1, paste0(resource, "s"), id, path)
  )

  trello_api_verb("DELETE", url = url, times = 1L, handle = handle,
                  token = token, verbose = verbose,
                  on.error = on.error)

}
