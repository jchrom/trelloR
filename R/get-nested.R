get_nested = function(url, limit = 1000, token = NULL, response = "content",
                     on.error = "error", retry.times = 3, handle = NULL,
                     verbose = FALSE) {

  limit = round(limit, 0) #conveniently fails for non-numeric values

  if (limit < 0) {
    stop("`limit` must be either a positive integer, zero, or Inf, not ", limit,
         call. = FALSE)
  }

  if (limit == 0) {
    limit = Inf
  }

  result = list()

  while (NROW(result) < limit) {

    .limit = limit - NROW(result)

    url = httr::modify_url(
      url, query = list(limit = if (.limit > 1000) 1000 else .limit))

    res = get_url(
      url,
      token       = token,
      on.error    = on.error,
      retry.times = retry.times,
      handle      = handle,
      verbose     = verbose)

    message("\nFetched ", NROW(res), " results")

    result = rbind_vector(list(result, res))

    if (NROW(res) < 1000) break

    url = httr::modify_url(
      url, query = list(before = min(result$id)))

  }

  message("\nRequest complete: ", NROW(result), " results.")

  result
}
