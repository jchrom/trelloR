trello_api_verb = function(verb, url, times, handle, token, verbose,
                           on.error = c("stop", "warn", "message")) {

  message("\n", verb, " URL:\n", url, "\n")

  agent = "https://github.com/jchrom/trelloR"
  token = get_token(token)

  params = list(verb = verb, url = url, times = times, handle = handle,
                terminate_on = 429,
                httr::config(token = token),
                httr::user_agent(agent),
                if (verbose) httr::verbose(),
                httr::accept_json(),
                httr::progress())

  res = do.call(httr::RETRY, Filter(length, params))

  if (httr::status_code(res) == 429) {

    # Status 429 means rate limit has been reached. The limit is 100 requests
    # per 10 seconds (with a single token). Current time is taken, and rounded
    # to the next ten seconds. The difference between that time and now is used
    # as the waiting period.

    now = unclass(Sys.time())
    wait_s = ceiling(ceiling(now / 10) * 10 - now)

    for (i in seq_len(wait_s)) {
      message("\rRate limit reached, waiting for ", i, "s", appendLF = FALSE)
      Sys.sleep(1L)
    }

    res = do.call(httr::RETRY, Filter(length, params))

  }

  if (httr::status_code(res) >= 300) {

    switch(match.arg(on.error, several.ok = FALSE),
           stop = httr::stop_for_status(res),
           warn = httr::warn_for_status(res),
           httr::message_for_status(res))

    error_df = data.frame(
      failed.url = url,
      failed.status = httr::status_code(res),
      failed.message = httr::content(res),
      stringsAsFactors = FALSE
    )

    error_df[["failed.headers"]] = list(res$all_headers)

    return(require_tibble(error_df))

  }

  httr::message_for_status(res)

  content = httr::content(res, as = "text")

  jsonlite::fromJSON(content, flatten  = TRUE)

}
