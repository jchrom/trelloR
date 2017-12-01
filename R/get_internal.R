#' GET multiple pages
#'
#' GET multiple pages.
#' @param url Url for the GET request
#' @param token Secure token, see \code{\link{get_token}} for how to obtain it
#' @param response Can return \code{"content"} (a tibble, default), \code{"headers"}, \code{"status"} code or the complete \code{"response"}
#' @importFrom httr parse_url modify_url content

paginate = function(url, token = NULL, response = "content") {

  # This decides how pagination will be done. The default passed from get_model
  # is 1000 (ie ne full page) and this should also be used if not limit is set
  limit = get_limit(url)

  if (is.null(limit))

    result = get_url(
      url = modify_url(url, query = list(limit = 1000)),
      token = token,
      response = response
    )

  else if (limit < 0)

    stop("'limit' must be 0 or higher", call. = FALSE)

  else if (limit == 0) {

    result = list()
    req = url #only used in the first iteration

    repeat {

      req = get_url(
        url = modify_url(
          url = get_next_url(req),
          query = list(limit = 1000)
        ),
        token = token,
        response = response
      )

      result = append(result, list(req))

      if (get_page_length(req) < 1000)
        break
    }
  }

  else if (limit <= 1000)

    result = get_url(
      url = url,
      token = token,
      response = response
    )

  else {

    result = list()
    req = url

    for (i in page_limits(limit)) {

      req = get_url(
        url = modify_url(
          url = get_next_url(req),
          query = list(limit = i)
        ),
        token = token,
        response = response
      )

      result = append(result, list(req))

      if (get_page_length(req) < 1000)
        break
    }
  }

  if (inherits(result, "list"))

    message(
      "Request complete. Got ",
      sum(
        unlist(
          lapply(result, attr, "page.length")
        )
      ),
      " results.\n"
    )

  else

    message("Request complete")

  if (inherits(result, "list") && length(result) == 1)

    result[[1]]

  else

    result
}

get_limit = function(url) {
  limit = httr::parse_url(url)$query$limit
  if (is.null(limit)) NULL else as.numeric(limit)
}

get_next_url = function(x) {
  if (is.null(attributes(x)$next.page))
    x
  else
    attributes(x)$next.page
}

get_page_length = function(x)
  attributes(x)$page.length

page_limits = function(x) {
  y = c(rep(1000, trunc(x/1000)), x %% 1000)
  y[y > 0]
}

#' GET url from Trello API
#'
#' GET url from Trello API
#' @param url Url to get
#' @param token Secure token, see \code{\link{get_token}} for how to obtain it
#' @param response Can return \code{"content"} (a tibble, default), \code{"headers"}, \code{"status"} code or the complete \code{"response"}
#' @param retry.times Maximum number of requests to attempt
#' @importFrom httr RETRY config user_agent accept_json progress stop_for_status message_for_status content status_code headers
#' @importFrom dplyr as.tbl
#' @importFrom jsonlite fromJSON

get_url = function(url, token = NULL, response = "content", retry.times = 3) {

  message("\nGET URL:\n", url, "\n")

  req = RETRY(
    verb = "GET", url = url, config(token = token),
    user_agent("https://github.com/jchrom/trelloR"),
    accept_json(), progress(),
    times = retry.times
  )

  stop_for_status(req)

  if (response == "content" && length(content(req)) > 0)

    res = structure(
      .Data = as_tbl_response(req),
      next.page = set_next_url(req),
      page.length = nrow(as_tbl_response(req))
    )

  else

    res = structure(
      .Data = req,
      next.page = set_next_url(req),
      page.length = length(content(req))
    )

  message("Fetched ", attributes(res)$page.length, " result(s)\n")

  res
}

as_tbl_response = function(x, ...) {

  stopifnot(inherits(x, "response"))

  x = httr::content(x, as = "text")
  x = jsonlite::fromJSON(x, flatten = TRUE)

  # If the response is a malformed data (which cannot be flattened by the
  # previous step) we have to be content with unlisted version coerced into
  # tbl

  if (is.data.frame(x))

    dplyr::as.tbl(x)

  else

    squash_list(x)
}

set_next_url = function(x) {

  stopifnot(inherits(x, "response"))

  before = tryCatch(
    expr = {
      model_ids =
        unlist(
          lapply(
            httr::content(x), `[[`, "id"
          )
        )
      before = min(model_ids)
    },
    error = function(e)
      NULL
  )

  httr::modify_url(
    url = x$url,
    query = list(before = before)
  )
}

squash_list = function(x) {

  # replace NULL values
  replace_null = function(x, becomes = "") {
    x[sapply(x, is.null)] = becomes
    x
  }

  # single out shallow elements
  scalars = x[sapply(x, length) <= 1]
  vectors = x[sapply(x, length) >= 2]

  # make df out of scalars
  df = dplyr::as_data_frame(
    replace_null(scalars)
  )

  # add non-scalar elements
  for (i in names(vectors))
    df[i] = list(
      replace_null(vectors[i])
    )

  df
}
