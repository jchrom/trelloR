#' PUT data to Trello API
#'
#' Issues [httr::PUT] requests for Trello API endpoints.
#'
#' See [Trello API reference](https://developers.trello.com/v1.0/reference)
#' for more info about what arguments can be passed to POST requests.
#'
#' @param model Model name, eg. `"card"`.
#' @param id Model id.
#' @param path Path.
#' @param body A named list.
#' @param token Secure token, see [get_token] (scope must include write
#'   permissions).
#' @param verbose Whether to pass [httr::verbose] to [httr::PUT].
#' @param response Can return `"content"` (the default), `"headers"`
#'   or response object.
#' @param on.error Issues a warning, a message or an error on API error.
#' @param encode,handle Passed to [httr::PUT].
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
#' # Content for the new card
#' payload = list(
#'   id = cid,
#'   name = "A new card name",
#'   desc = "Description - updated by trelloR",
#'   pos = "top" #put card on the top of a list
#' )
#'
#' # Update card's name, descriptionand position
#' put_model(model = "card", id = cid, body = payload, token = token)
#' }


put_model = function(model, id = NULL, path = NULL, body = NULL,
                     token = NULL, response = "content",
                     on.error = c("stop", "warn", "message"),
                     verbose = FALSE,
                     encode = "json", handle = NULL) {

  url = httr::modify_url(
    url = "https://api.trello.com",
    path = c(1, paste0(model, "s"), id, path)
  )

  message(
    "Request URL:\n", url, "\n"
  )

  message(
    "Request body: ",
    paste(names(body), collapse = ", "),
    "\n"
  )

  if (!is.null(body))
    body = lapply(body, tolower_if_logical)

  if (is.null(token) && file.exists(".httr-oauth"))
    token = read_last_token()

  if (verbose) {

    res = httr::PUT(
      url    = url,
      body   = body,
      httr::config(token = token),
      encode = encode,
      handle = handle,
      httr::verbose(),
      httr::user_agent("https://github.com/jchrom/trelloR"))

  } else {

    res = httr::PUT(
      url    = url,
      body   = body,
      httr::config(token = token),
      encode = encode,
      handle = handle,
      httr::user_agent("https://github.com/jchrom/trelloR"))

  }

  switch(
    match.arg(on.error, several.ok = FALSE),
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
    res)
}
