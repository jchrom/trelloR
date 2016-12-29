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

  if (!is.null(query[["limit"]]))
    limit = query[["limit"]]
  else
    limit = 1000

  if (limit < 0)
    stop("'limit' cannot be negative", call. = FALSE)

  result = list()

  if (limit == 0) {

    repeat {

      query[["limit"]] = 1000
      batch = get_flat(url = url, token = token, query = query)
      result = append(result, list(batch))

      if (!is.data.frame(batch)) {
        # message("Result is not a data.frame - stopping...")
        break
      } else if (nrow(batch) < 1000) {
        break
      } else {
        query[["before"]] = min(batch$id)
        message("Received 1000 results\n")
      }
    }

  } else {

    limits = c(rep(1000, trunc(limit/1000)), limit %% 1000)

    for (lim in limits[limits > 0]) {

      query[["limit"]] = lim
      batch = get_flat(url = url, token = token, query = query)
      result = append(result, list(batch))

      if (!is.data.frame(batch)) {
        # message("Result is not a data.frame - stopping...")
        break
      } else if (nrow(batch) < 1000) {
        break
      } else {
        query[["before"]] = min(batch$id)
        message("Received 1000 results\n")
      }
    }
  }

  if (is.data.frame(result[[1]])) {
    total = ((length(result) - 1) * 1000) + nrow(batch)
    message("Received ", nrow(batch), " results")
    message("Request complete: ", total," results")
  } else {
    message("Request complete")
  }
  result
}

# url = "https://api.trello.com/1/board/54212b5181d0b59cfbff6de0/cards"
# d = get_pages(url, token = t, query = list(limit = -5, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 5, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 1000, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 1750, filter = "all"))
