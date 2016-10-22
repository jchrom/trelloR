#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' If the request fails, server error messages are reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s or \code{list}s, while non-JSON type of response throws an error.
#'
#' When \code{paging = TRUE}, the ID of the earliest result is retrieved from every page and supplied to the next request as the value of the \code{"before"} parameter. Paging will continue until the number of results per page is smaller then 1000, indicating no more pages to get.
#'
#' \code{filter} and \code{limit} are query parameters and can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#' @param parent Parent structure (e.g. \code{"board"})
#' @param child Child structure (e.g. \code{"card"})
#' @param id Model ID
#' @param token Peviously generated secure token, see \code{\link{trello_get_token}} for how to obtain it
#' @param query key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @param url Url for the GET request, use instead of specifying see \code{parent}, see \code{id} and see \code{child}; see \code{\link[httr]{GET}} for details
#' @param filter Query value
#' @param limit Query value (defaults to 1000; if reached, paging is suggested)
#' @param paging Logical whether paging should be used
#' @param bind.rows By default, pages will be combined into one \code{data.frame} by \code{\link[dplyr]{bind_rows}}. Set to \code{FALSE} if you want \code{list} instead. This is useful on the rare occasion that the JSON response is not formatted correctly and makes \code{\link[dplyr]{bind_rows}} fail
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{trello_get_token}}, \code{\link{get_id}}
#' @importFrom dplyr bind_rows as_data_frame
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
#' # We can also call trello_get() directly:
#' lists = trello_get(parent = "board", child = "lists", id = bid)
#'
#' # As with boards, cards can be queried for particular resources:
#' card1id = cards$id[1]
#' card1act = get_card_actions(card1id) # Get all comments
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

trello_get = function(parent = NULL,
                      child = NULL,
                      id = NULL,
                      token = NULL,
                      query = NULL,
                      url = NULL,
                      filter = NULL,
                      limit = 1000,
                      paging = FALSE,
                      bind.rows = TRUE
                      ) {

    url   = build_url(url = url, parent = parent, child = child, id = id)
    query = build_query(query = query, filter = filter, limit = limit)

    cat("Sending request...\n")

    if (paging) {
        result = get_pages(url = url, token = token,
                           query = query, bind.rows = bind.rows)
    } else {
        result = get_page(url = url, token = token,
                          query = query)
    }

    return(result)
}
