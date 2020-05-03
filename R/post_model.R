#' POST data to Trello API
#'
#' Issues [httr::POST] requests for Trello API endpoints.
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
#' @param verbose Whether to pass [httr::verbose] to [httr::POST].
#' @param response Can return `"content"` (the default), `"headers"`
#'   or response object.
#' @param on.error Issues a warning, a message or an error on API error.
#' @param encode,handle Passed to [httr::POST].
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
#' # of the newly created model)
#' r = post_model(model = "card", body = payload, token = token)
#'
#' # Get ID of the new card
#' r$id
#' }

post_model = function(model, id = NULL, path = NULL, body = list(name = "New"),
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

    res = httr::POST(
      url   = url,
      body  = body,
      httr::config(token = token),
      encode = encode,
      handle = handle,
      httr::verbose(),
      httr::user_agent("https://github.com/jchrom/trelloR"))

  } else {

    res = httr::POST(
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
