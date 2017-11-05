#' Get Url With Paging
#'
#' Issue a GET request for Trello API with automated paging.
#'
#' Setting \code{limit = 0} or \code{limit > 1000} will activate paging. In the
#' former case, all available results will be fetched. Filter values bellow 0
#' are not allowed.
#'
#' @param url Url to get
#' @param token Peviously generated secure token, see \code{\link{trello_get_token}} for how to obtain it
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @seealso \code{\link{get_model}}
#' @export

get_pages = function(url, token, query = NULL) {

  # Prefer user-set limit even though it may provoke an error
  if (!is.null(query[["limit"]]))
    user_limit = query[["limit"]]
  else
    user_limit = 0

  # We could also make limit=0 if negative value is supplied by the user, but
  # I think error is better
  if (user_limit < 0)
    stop("'limit' cannot be negative", call. = FALSE)

  # Let's assume that Trello's API will keep 1000 as the maximum request length
  if (user_limit > 0) {
    limit_vec = c(rep(1000, trunc(user_limit/1000)), user_limit %% 1000)
    limit_vec = limit_vec[limit_vec > 0]
  } else {
    limit_vec = 0 #because user_limit=0 means "keep using highest limit"
  }

  result = list()

  # use [for] when the limit over 1000, use [while] when its < 1000 (incl. 0)
  if (limit_vec[1] > 0) {

    for (i in seq_along(limit_vec)) {

      query[["limit"]] = limit_vec[i]
      batch = get_flat(url = url, token = token, query = query)
      result = append(result, list(batch))

      if (!is.data.frame(batch))
        break

      message("Received ", nrow(batch), " results\n")
      query[["before"]] = min(batch$id)

      if (nrow(batch) < 1000)
        break
    }

  } else {

    query[["limit"]] = 1000

    repeat {

      batch = get_flat(url = url, token = token, query = query)
      result = append(result, list(batch))

      if (!is.data.frame(batch))
        break

      message("Received ", nrow(batch), " results\n")
      query[["before"]] = min(batch$id)

      if (nrow(batch) < 1000)
        break

    }
  }

  # Check result
  classes = unlist(lapply(result, class))
  dframes = sum(classes == "data.frame")
  allrows = sum(unlist(sapply(result, nrow)))

  if (dframes > 0)
    message("Request complete: ", allrows, " results")
  else
    message("Request complete")

  result
}
