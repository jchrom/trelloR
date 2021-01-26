get_nested = function(url, limit, token, on.error, retry.times, handle,
                      verbose) {

  if (!is.numeric(limit) || limit < 0) {
    stop("`limit` must be a positive integer or Inf", call. = FALSE)
  }

  if (limit == 0) {
    message("setting `limit` to Inf (cannot be zero)")
    limit = Inf
  }

  result = list()

  repeat {

    url = httr::modify_url(url, query = list(limit = pmin(1000, limit)))

    res = trello_api_verb("GET", url = url, times = retry.times,
                          handle = handle, token = token, verbose = verbose,
                          on.error = on.error)

    message("\nFetched ", NROW(res), " results")

    result = append(result, list(res))

    if (!is.data.frame(res) || nrow(res) < 1000) break

    limit = limit - nrow(res)

    if (!limit > 0) break

    url = httr::modify_url(url, query = list(before = min(res$id)))

  }

  result = tryCatch(rbind_vector(result), error = function(e) result)

  message("\nRequest complete: ", NROW(result), " results.")

  result

}
