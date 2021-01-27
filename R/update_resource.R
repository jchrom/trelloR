#' Update Resources
#'
#' Update resources via Trello API.
#'
#' See [Trello API reference](https://developers.trello.com/v1.0/reference)
#' for more info about what elements can be included in PUT request body.
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
#' # Content for the new card
#' payload = list(
#'   id = cid,
#'   name = "A new card name",
#'   desc = "Description - updated by trelloR",
#'   pos = "top" #put card on the top of a list
#' )
#'
#' # Update card's name, descriptionand position
#' update_resource("card", id = cid, body = payload, token = token)
#' }

update_resource = function(resource, id = NULL, path = NULL, body = NULL,
                           token = NULL, on.error = c("stop", "warn", "message"),
                           verbose = FALSE, handle = NULL,
                           encode, response) {

  warn_for_argument(encode)
  warn_for_argument(response)

  url = httr::modify_url(
    url = "https://api.trello.com",
    path = c(1, paste0(resource, "s"), id, path)
  )

  trello_api_verb("PUT", url = url, times = 1L, handle = handle,
                  token = token, verbose = verbose, body = body,
                  on.error = on.error)

}
