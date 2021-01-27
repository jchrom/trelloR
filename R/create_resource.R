#' Create Resources
#'
#' Create resources via Trello API.
#'
#' See [Trello API reference](https://developer.atlassian.com/cloud/trello/rest)
#' for more info about what elements can be included in POST request body.
#'
#' @param resource Model name, eg. `"card"`.
#' @param id Model id.
#' @param path Path.
#' @param body A named list.
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
#' @family functions to create resources
#'
#' @export
#'
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
#' # Get lists on that board, extract ID of the first one
#' lid = get_board_lists(bid, token)$id[1]
#'
#' # Content for the new card
#' payload = list(
#'   idList = lid,
#'   name = "A new card",
#'   desc = "#This card has been created by trelloR",
#'   pos = "bottom"
#' )
#'
#' # Create card and store the response (to capture the ID
#' # of the newly created resource)
#' r = create_resource("card", body = payload, token = token)
#'
#' # Get ID of the new card
#' r$id
#' }

create_resource = function(resource, id = NULL, path = NULL,
                           body = list(name = "New"), token = NULL,
                           on.error = c("stop", "warn", "message"),
                           verbose = FALSE, handle = NULL,
                           encode, response) {

  warn_for_argument(encode)
  warn_for_argument(response)

  url = httr::modify_url(
    url = "https://api.trello.com",
    path = c(1, paste0(resource, "s"), id, path)
  )

  trello_api_verb("POST", url = url, times = 1L, handle = handle,
                  token = token, verbose = verbose, body = body,
                  on.error = on.error)

}
