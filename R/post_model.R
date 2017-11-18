#' POST data to Trello API
#'
#' Issues \code{\link[httr]{POST}} requests for Trello API endpoints.
#'
#' See \href{https://developers.trello.com/v1.0/reference}{Trello API reference}
#' for more info about what arguments can be passed to post models.
#' @param model Model
#' @param id Model id
#' @param path Path
#' @param body A named list of query paramters (will be passed as body)
#' @param token Secure token, see \code{\link{get_token}} (scope must include write permissions)
#' @param verbose Wether to pass \code{verbose()} to \code{\link[httr]{POST}}
#' @param ... Additional arguments passed to \code{\link[httr]{POST}}
#' @importFrom httr modify_url POST
#' @export

post_model = function(model, id = NULL, path = NULL,
                      body = list(name = "New Card"), token,
                      verbose = FALSE, ...) {

  url = modify_url(
    url = "https://api.trello.com",
    path = c(1, paste0(model, "s"), id, path)
  )

  if (verbose)
    POST(
      url = url, body = body, config = config(token = token),
      verbose(),
      ...)
  else
    POST(
      url = url, body = body, config = config(token = token),
      ...)
}
