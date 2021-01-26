trello_api_verb = function(verb, url, times, handle, token, verbose,
                           query = NULL, body = NULL,
                           on.error = c("stop", "warn", "message")) {

  on.error = match.arg(on.error, several.ok = FALSE)

  agent = "https://github.com/jchrom/trelloR"
  token = get_token(token)

  message(sprintf("%s: %s", verb, url))

  if (length(body)) {
    text = sprintf("Request body: %s", paste(names(body), collapse = ", "))
    message(text)
  }

  params = list(verb = verb, url = url, times = times, handle = handle,
                query = sanitize_params(query),
                body = sanitize_params(body),
                if (verbose) httr::verbose(),
                terminate_on = 429,
                encode = "json",
                httr::config(token = token),
                httr::user_agent(agent),
                httr::accept_json(),
                httr::progress())

  print(params[["query"]])

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

    text = sprintf("%s (HTTP %s)", httr::content(res), httr::status_code(res))

    switch(match.arg(on.error, several.ok = FALSE),
           stop = stop(text, call. = FALSE),
           warn = warning(text, call. = FALSE),
           message(text))

    error_df = data.frame(
      failed.url = url,
      failed.status = httr::status_code(res),
      failed.message = httr::content(res),
      stringsAsFactors = FALSE
    )

    error_df[["failed.headers"]] = res$all_headers

    return(require_tibble(error_df))

  }

  httr::message_for_status(res)

  content = httr::content(res, as = "text")

  jsonlite::fromJSON(content, flatten  = TRUE)

}

sanitize_params = function(x) {
  lgl = vapply(x, is.logical, FALSE)
  x[lgl] = lapply(x[lgl], tolower)
  Filter(length, x)
}
