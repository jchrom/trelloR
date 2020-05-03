#' DELETE data via Trello API
#'
#' Issues [httr::DELETE] requests for Trello API endpoints.
#'
#' See [Trello API reference](https://developers.trello.com/v1.0/reference)
#' for more info about what arguments can be passed to DELETE requests.
#'
#' @param model Model name, eg. `"card"`.
#' @param id Model id.
#' @param path Path.
#' @param token Secure token, see [get_token] (scope must include write
#'   permissions).
#' @param verbose Whether to pass [httr::verbose] to [httr::DELETE].
#' @param response Can return `"content"` (the default), `"headers"`
#'   or response object.
#' @param on.error Issues a warning, a message or an error on API error.
#' @param encode,handle Passed to [httr::DELETE].
#'
#' @export
#' @examples
#'
#' \dontrun{
#'
#' # Get token with write access
#' token = get_token(yourkey, yoursecret, scope = c("read", "write"))
#'
#' # Get board ID
#' url = "Your board URL"
#' bid = get_id_board(url, token)
#'
#' # Get cards and extract ID of the first one
#' cid = get_board_cards(bid, token)$id[1]
#'
#' # Delete it
#' delete_model(model = "card", id = cid, token = token)
#' }

delete_model = function(model, id = NULL, path = NULL, token = NULL,
                        response = c("content", "headers", "status", "response"),
                        on.error = c("stop", "warn", "message"),
                        verbose = FALSE,
                        encode   = "json", handle = NULL) {

  url = httr::modify_url(
    url = "https://api.trello.com",
    path = c(1, paste0(model, "s"), id, path)
  )

  message(
    "Request URL:\n", url, "\n"
  )

  on.error = match.arg(on.error, several.ok = FALSE)

  response = match.arg(response, several.ok = FALSE)

  if (is.null(token) && file.exists(".httr-oauth"))
    token = read_last_token()

  if (verbose) {

    res = httr::DELETE(
      url = url,
      httr::config(token = token),
      httr::verbose(),
      httr::user_agent("https://github.com/jchrom/trelloR"))

  } else {

    res = httr::DELETE(
      url = url,
      httr::config(token = token),
      httr::user_agent("https://github.com/jchrom/trelloR"))
  }

  switch(
    on.error,
    message = httr::message_for_status(res),
    warn    = httr::warn_for_status(res),
    httr::stop_for_status(res)
  )

  if (!on.error == "message" && !httr::status_code(res) >= 300)
    httr::message_for_status(res)

  switch(
    response,
    content = httr::content(res),
    headers = httr::headers(res),
    status  = httr::status_code(res),
    res
  )
}
