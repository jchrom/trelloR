#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' If the request fails, server error messages are reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s or \code{list}s, while non-JSON type of response throws an error.
#'
#' When \code{limit > 1000}, paging is used. The ID of the oldest result is retrieved from every page and supplied to the next request as the value of the \code{"before"} parameter. Paging will stop after reaching the number of results specified by \code{limit}, or when there are no more data to get.
#'
#' \code{filter} and \code{limit} are query parameters that can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#'
#' @param parent Parent resource (e.g. \code{"board"})
#' @param child Child resource (e.g. \code{"card"})
#' @param id Model ID
#' @param token Secure token, see \code{\link{get_token}} for how to obtain it; if NULL, it will check for a cached token
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @param url Url for the GET request, use instead of specifying \code{parent}, \code{id} and \code{child}; see \code{\link[httr]{GET}} for details
#' @param filter Defaults to \code{"all"} which fetches both open and archived cards or all action types
#' @param limit Defaults to \code{1000}; set to \code{0} to get everything
#' @param response Can be either "content" (a \code{\link[dplyr]{tbl}}) or an object of class \code{\link[httr]{response}}
#' @param paging Deprecated, use \code{limit = 0} instead
#' @param bind.rows Deprecated; will always try to bind rows unless \code{response} is not \code{"content"}
#' @param add.class Assign additional S3 class (defaults to \code{TRUE}). The additional class is currently not being used for anything, and might be dropped in the future.
#' @param on.error Whether to stop, fail or message on error
#' @param handle The handle to use with this request (see \code{\link[httr]{RETRY}})
#' @param verbose Set to \code{TRUE} for verbose output
#'
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}},
#'   \code{\link{get_token}}, \code{\link{get_id}}
#'
#' @importFrom httr modify_url
#'
#' @export
#'
#' @examples
#'
#' # No authorization is required to access public boards, so there is no need
#' # to create a token, just the board id:
#' url = "https://trello.com/b/Pw3EioMM/trellor-r-api-for-trello"
#' bid = get_id_board(url)
#'
#' # Once we have the ID, we can use it to make specific queries:
#' labels = get_board_labels(bid)                # Get all labels
#' cards = get_board_cards(bid, filter = "all")  # Get all cards, incl. archived
#'
#' # We can also call get_model() directly:
#' lists = get_model(parent = "board", child = "lists", id = bid)
#'
#' # As with boards, cards can be queried for particular resources:
#' card10 = cards$id[10]
#' acts10 = get_card_actions(card10)    # Get all actions performed on that card
#'
#' # To specify the number of results, use limit = number. If limit = 0, all
#' # results will be acquired eventually.
#'
#' \dontrun{
#' acts_all = get_board_actions(bid, limit = 0)
#' }
#'
#' # For private and team boards, you need a secure token:
#'
#' \dontrun{
#' token = get_token("your_key", "your_secret")
#' cards_open = get_board_cards(board_id, token, filter = "open")
#' }

get_model = function(parent = NULL, child = NULL, id = NULL, token = NULL,
                     query = NULL, url = NULL, filter = NULL, limit = 1000,
                     response = "content", paging = FALSE, bind.rows = TRUE,
                     add.class = TRUE, on.error = "error", handle = NULL,
                     verbose = FALSE)
{

  if (!missing("paging")) {
    warning("paging is deprecated - use limit=0 to fetch all",
            call. = FALSE)
    if (missing(limit) & paging) limit = 0
  }

  if (!missing("bind.rows")) {
    warning("bind.rows is deprecated",
            call. = FALSE)
  }

  if (is.null(url)) {
    url = modify_url(
      url = "https://api.trello.com",
      path = c(1, parent, extract_id(id), child), #path overrides url if url includes path
      query = c(lapply(query, tolower_if_logical),
                list(limit = limit,
                     filter = filter))
    )
  }

  if (is.null(token) && file.exists(".httr-oauth"))
    token = read_last_token()

  paginate = all(
    request_type(url) == "iterative",
    any(
      result_limit(url) == 0,
      result_limit(url)  > 1000
    )
  )

  if (paginate) {
    result = paginate(
      url = url, token = token, response = response, on.error = on.error,
      handle = handle, verbose = verbose)
  } else {
    result = get_url(
      url = url, token = token, response = response, on.error = on.error,
      handle = handle, verbose = verbose)
  }

  if (inherits(result, "response"))
    return(result)

  if (response == "content" && length(result) == 0) {
    message("Nothing to coerce to a data.frame; returning NULL")
    return(NULL)
  }

  if (response == "content") {
    result =  tryCatch(
      expr  = add_class(x = rbind_vector(result), child = child),
      error = function(e) {
        warning("Binding failed: ", e$message, "\nreturning list", call. = FALSE)
        result })
  }

  result
}

result_limit = function(url) {

  limit = as.integer(httr::parse_url(url)$query$limit)

  if (identical(limit, integer(0))) return(NULL)

  if (is.na(limit)) stop("limit must be an integer of length 1", call. = FALSE)

  if (limit < 0) stop("limit must be 0 or higher", call. = FALSE)

  limit
}
