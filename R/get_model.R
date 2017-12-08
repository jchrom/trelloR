#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' If the request fails, server error messages are reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s or \code{list}s, while non-JSON type of response throws an error.
#'
#' When \code{limit > 1000}, paging is used. The ID of the earliest result is retrieved from every page and supplied to the next request as the value of the \code{"before"} parameter. PAging will stop after reaching the number of results specified by \code{limit}, or when there are no more data to get.
#'
#' \code{filter} and \code{limit} are query parameters that can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#' @param parent Parent structure (e.g. \code{"board"})
#' @param child Child structure (e.g. \code{"card"})
#' @param id Model ID
#' @param token Secure token, see \code{\link{get_token}} for how to obtain it
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @param url Url for the GET request, use instead of specifying \code{parent}, \code{id} and \code{child}; see \code{\link[httr]{GET}} for details
#' @param filter Filter results by this string
#' @param limit Defaults to \code{1000}; set to \code{0} to get everything
#' @param paging Deprecated, use \code{limit = 0} instead
#' @param response Can be either "content" (a \code{\link[dplyr]{tbl}}) or an object of class \code{\link[httr]{response}}
#' @param bind.rows Deprecated; will always bind rows unless \code{response} is not \code{"content"}
#' @param add.class Assign additional S3 class (defaults to \code{TRUE})
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{get_token}}, \code{\link{get_id}}
#' @importFrom dplyr bind_rows as_data_frame
#' @importFrom httr modify_url
#' @export
#' @examples
#' # No authorization is required to access public boards. Let's get
#' # the ID of Trello Development Roadmap board:
#' url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
#' bid = get_id_board(url)
#'
#' # Once we have the ID, we can use it to make specific queries:
#' labels = get_board_labels(bid)           # Get all labels
#' cards = get_board_cards(bid, limit = 5)  # Get 5 cards
#'
#' # We can also call get_model() directly:
#' lists = get_model(parent = "board", child = "lists", id = bid)
#'
#' # As with boards, cards can be queried for particular resources:
#' card1id = cards$id[1]
#' card1act = get_card_actions(card1id) # Get all actions performed on that card
#'
#' # To retrieve large results, paging might be necessary:
#'
#' \dontrun{
#'
#' tdr_actions = get_board_actions(bid, paging = TRUE)
#' }
#'
#' # For private boards, you need a secure token:
#'
#' \dontrun{
#'
#' token = get_token("your_key", "your_secret")
#' all_open_cards = get_board_cards(board_id, token, filter = "open")
#' }

get_model = function(parent = NULL, child = NULL, id = NULL, token = NULL,
                     query = NULL, url = NULL, filter = NULL, limit = 1000,
                     paging = FALSE, response = "content", bind.rows = TRUE,
                     add.class = TRUE)
{

  if (!missing("paging")) {

    warning(
      "paging is deprecated - set limit to 0 to fetch all",
      call. = FALSE
    )

    if (missing(limit) & paging)
      limit = 0
  }

  if (!missing("bind.rows")) {

    warning(
      "bind.rows is deprecated",
      call. = FALSE
    )
  }

  if (is.null(url)) {
    url = modify_url(
      url = "https://api.trello.com",
      path = c(1, parent, id, child), #path overrides url if url includes path
      query = c(query, list(limit = limit, filter = filter))
    )
  }

  paginate = all(
    request_type(url) == "iterative",
    any(
      result_limit(url) == 0,
      result_limit(url)  > 1000
    )
  )

  if (paginate) {

    result = paginate(
      url = url,
      token = token,
      response = response
    )

  } else {

    result = get_url(
      url = url,
      token = token,
      response = response
    )
  }

  if (response == "content" && length(result) == 0) {

    message("Nothing to coerce to a data.frame; returning NULL")
    NULL

  }

  else if (response == "content")

    tryCatch(
      expr  = add_class(x = bind_rows(result), child = child),
      error = function(e) {
        warning("Binding failed: ", e$message, "\nreturning list", call. = FALSE)
        result
      }
    )

  else

    result
}

result_limit = function(url) {

  limit = as.integer(
    httr::parse_url(url)$query$limit
  )

  if (identical(limit, integer(0))) return(NULL)

  if (is.na(limit)) stop("limit must be an integer of length 1", call. = FALSE)

  if (limit < 0) stop("limit must be 0 or higher", call. = FALSE)

  limit
}
