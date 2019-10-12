#' PUT data to Trello API
#'
#' Issues \code{\link[httr]{PUT}} requests for Trello API endpoints.
#'
#' See \href{https://developers.trello.com/v1.0/reference}{Trello API reference}
#' for more info about what arguments can be passed to PUT requests.
#' @param model Model
#' @param id Model id
#' @param path Path
#' @param body A named list of query paramters (will be passed as body)
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Whether to pass \code{verbose()} to \code{\link[httr]{PUT}}
#' @param response Can return \code{"content"} (default), \code{"headers"}, \code{"status"} code or the complete \code{"response"}
#' @param on.error Issues either \code{\link[base]{warning}} (default), \code{\link[base]{message}} or error (and \code{\link[base]{stop}}s)
#' @param encode Passed to \code{\link[httr]{PUT}}
#' @param handle Passed to \code{\link[httr]{PUT}}
#' @importFrom httr modify_url PUT content status_code headers message_for_status warn_for_status stop_for_status
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
                     token, response = "content", on.error = "warning",
                     encode = "json", handle = NULL, verbose = FALSE) {

  url = modify_url(
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

  if (verbose)
    req = PUT(
      url = url, body = body, config = config(token = token), encode = encode,
      handle = handle, verbose(),
      user_agent("https://github.com/jchrom/trelloR")
    )

  else
    req = PUT(
      url = url, body = body, config = config(token = token), encode = encode,
      handle = handle,
      user_agent("https://github.com/jchrom/trelloR")
    )

  switch(
    on.error,
    message = message_for_status(req),
    error = stop_for_status(req),
    warn_for_status(req)
  )

  if (!on.error == "message" && !status_code(req) >= 300)
    message_for_status(req)

  switch(
    response,
    content = content(req),
    headers = headers(req),
    status = status_code(req),
    req
  )
}
