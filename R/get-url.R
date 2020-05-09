# GET data from Trello API
#
# GET data from Trello API using a complete http request.
#
# @param url Url to get
# @param token Secure token, see `[trelloR::get_token]` for how to obtain it
# @param retry.times Maximum number of requests to attempt.
# @param on.error Whether to stop, fail or message on error.
# @param handle The handle to use with this request, see `[httr::RETRY]`.
# @param verbose Set to `TRUE` for verbose output.
#
# @return A data frame or NULL.

get_url = function(url, token = NULL, retry.times = 3,
                   on.error = c("stop", "warn", "message"),
                   handle = NULL, verbose = FALSE) {

  message("\nGET URL:\n", url, "\n")

  if (verbose)

    res = httr::RETRY(
      verb   = "GET",
      url    = url,
      httr::config(token = token),
      httr::verbose(),
      httr::user_agent("https://github.com/jchrom/trelloR"),
      httr::accept_json(),
      httr::progress(),
      times  = retry.times,
      handle = handle)

  else

    res = httr::RETRY(
      verb = "GET",
      url  = url,
      httr::config(token = token),
      httr::user_agent("https://github.com/jchrom/trelloR"),
      httr::accept_json(),
      httr::progress(),
      times = retry.times, handle = handle)

  switch(
    match.arg(on.error, several.ok = FALSE),
    message = httr::message_for_status(res),
    warn    = httr::warn_for_status(res),
    httr::stop_for_status(res)
  )

  if (httr::status_code(res) >= 300) {

    error_df = data.frame(
      failed.url     = url,
      failed.status  = httr::status_code(res),
      failed.message = httr::content(res),
      stringsAsFactors = FALSE)

    return(error_df)
  }

  jsonlite::fromJSON(httr::content(
    res, as = "text"), flatten  = TRUE)
}
