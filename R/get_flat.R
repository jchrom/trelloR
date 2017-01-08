#' GET url and return data.frame
#'
#' GET url and return data.frame
#' @param url Url to get
#' @param token Secure token
#' @param query Additional url parameters (defaults to NULL)
#' @param retry How many tries in case of server-side error
#' @param wait How long to sleep between retries (sec)
#' @importFrom httr GET content config http_status headers http_type http_error user_agent status_code
#' @importFrom dplyr as.tbl
#' @importFrom jsonlite fromJSON

get_flat = function(url, token = NULL, query = NULL,
                    retry = 3, wait = 1.5) {

  stopifnot(retry > 0)

  message("Request URL:\n", url, "\n")
  for (try in retry:1) {

    req  = GET(url = url, config(token = token),
               query = query,
               user_agent("https://github.com/jchrom/trelloR"))

    if (http_error(req) && status_code(req) < 500)
      stop(http_status(req)$message, " : ", req, call. = FALSE)
    else if (http_error(req) && status_code(req) >= 500)
      message(http_status(req)$message, "\n", try - 1, " attempt(s) left\n")
    else
      break

    if (try > 1)
      Sys.sleep(wait)
  }

  if (http_error(req) && status_code(req) >= 500)
    stop(http_status(req)$message, "; stopping after ", retry, " attempts",
         call. = FALSE)

  # Handle response (only JSON is accepted)
  if (http_type(req) == "application/json") {
    json = content(req, as = "text")
    flat = fromJSON(json, flatten = TRUE)
  } else {
    req_trim = paste0(strtrim(content(req, as = "text"), 50), "...")
    stop(http_type(req), " is not JSON : \n", req_trim)
  }

  # If the result is an empty list, convert into NULL
  if (length(flat) == 0) {
    flat = NULL
    message("Response was empty")
  }

  flat
}
