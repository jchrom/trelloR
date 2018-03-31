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
  limit = result_limit(url)

  invalid_limit = any(
    is.null(result_limit(url)),
    all(
      result_limit(url) <= 1000,
      result_limit(url) >  0
    )
  )

  if (invalid_limit) stop("Paging only if limit is 0 or over 1000", call. = FALSE)

  if (limit == 0) {

    result = list()
    req = url #only used in the first iteration

    repeat {

      req = get_url(
        url = modify_url(
          url = next_url(req),
          query = list(limit = 1000)
        ),
        token = token,
        response = response
      )

      result = append(result, list(req))

      if (page_length(req) < 1000)
        break
    }
  }

  else {

    result = list()
    req = url

    for (i in page_limits(limit)) {

      req = get_url(
        url = modify_url(
          url = next_url(req),
          query = list(limit = i)
        ),
        token = token,
        response = response
      )

      result = append(result, list(req))

      if (page_length(req) < 1000)
        break
    }
  }


  n_results = sum(
    vapply(
      result, attr, "page.length",
      FUN.VALUE = numeric(1)
    )
  )

  message("Request complete. Got ", n_results, " results.\n")

  switch(
    as.character(length(result)),
    "0" = list(),
    "1" = result[[1]],
    result
  )
}

next_url = function(x) {
  if (is.null(attributes(x)$next.url))
    x
  else
    attributes(x)$next.url
}

page_length = function(x)
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

  if (response == "content")

    res = as_tbl_response(req)

  else

    res = structure(
      .Data = req,
      next.url = attributes(as_tbl_response(req))[["next.url"]],
      page.length = attributes(as_tbl_response(req))[["page.length"]]
    )

  message("Fetched ", attributes(res)$page.length, " result(s)\n")

  res
}

#' Coerce response object to data.frame
#'
#' Coerce response object to data.frame.
#'
#' The exact shape of the data.frame depends on its content, and also on the
#' type of the GET request. Iterative requests can return data.frames with
#' multiple rows if there are more than 1 results; singleton requests return
#' a data.frame with 1 row (usually containing some list columns with nested
#' data); searches also return a data.frame with 1 row, including
#' @param x Object of class \code{"response"}
#' @importFrom httr content parse_url modify_url
#' @importFrom dplyr as_data_frame data_frame
#' @importFrom jsonlite fromJSON
#' @export

as_tbl_response = function(x) {

  stopifnot(inherits(x, "response"))

  response_is_empty = length(content(x)) == 0

  if (response_is_empty) {

    response_list = structure(
      list(),
      next.url = NA,
      page.length = 0
    )

    message("\nResponse was empty")

    return(response_list)

  }

  as_df_search = function(x) {

    response_text = content(x, as = "text")
    response_list = fromJSON(response_text)

    nrow_safe = function(x)
      if (inherits(x, "data.frame")) nrow(x) else 0

    response_lengths = vapply(
      X = response_list$options$modelType,
      FUN.VALUE = numeric(1),
      FUN = function(model_type) nrow_safe(response_list[[model_type]])
    )

    response_df = dplyr::as_data_frame(t(as.matrix(response_list)))
    response_df$options = NULL

    structure(
      response_df,
      next.url = NA,
      page.length = sum(response_lengths),
      search.options = response_list$options
    )
  }

  as_df_singleton = function(x) {

    response_list = httr::content(x)
    response_df = dplyr::as_data_frame(t(as.matrix(response_list)))

    response_df[] = lapply(
      response_df,
      function(col)
        if (length(unlist(col)) <= 1) unlist(col) else col
    )

    structure(
      response_df,
      next.url = NA,
      page.length = nrow(response_df)
    )
  }

  as_df_iterative = function(x) {

    response_text = content(x, as = "text")
    response_df = as_data_frame(fromJSON(response_text, flatten = TRUE))

    structure(
      response_df,
      next.url = modify_url(
        url = x$url,
        query = list(before = min(response_df$id))
      ),
      page.length = nrow(response_df)
    )
  }

  switch(
    request_type(x$url),
    search = as_df_search(x),
    singleton = as_df_singleton(x),
    iterative = as_df_iterative(x),
    as_df_singleton(x)
  )
}

request_type = function(url) {

  path = httr::parse_url(url)$path
  segments = unlist(strsplit(path, "/"))[-1] #Trello API path starts with /1/

  switch(
    length(segments),
    `1` = "search",
    `2` = "singleton",
    `3` = "iterative",
    "singleton"
  )
}
