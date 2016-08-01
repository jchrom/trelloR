#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints. \code{\link{get_board}} and \code{\link{get_card}} are convenience wrappers for this function.
#'
#' If the request fails, server error messages are extracted from the response header and reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s, while non-JSON type of response throws an error.
#'
#' When \code{paging = TRUE}, the ID of the earliest result is retrieved from every page and supplied to the next request as the value of the \code{"before"} parameter. Paging will continue until the number of results per page is smaller then 1000, indicating no more pages to get.?
#'
#' \code{filter} and \code{limit} are query parameters and can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#' @param parent Parent structure (e.g. \code{"board"})
#' @param child Child structure (e.g. \code{"card"})
#' @param id resource id
#' @param query url parameters that form the query, see \code{\link[httr]{GET}} for details
#' @param url url for the GET request, see \code{\link[httr]{GET}} for details
#' @param filter url parameter
#' @param limit url parameter (defaults to 1000; if reached, paging is suggested)
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param paging logical whether paging should be used
#' @param bind.rows by default, pages will be combined into one \code{data.frame} by \code{\link[dplyr]{bind_rows}}. Set to \code{FALSE} if you want \code{list} instead. This is useful on the rare occasion that the JSON response is not formatted correctly and makes \code{\link[dplyr]{bind_rows}} fail
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{trello_get_token}}, \code{\link{get_id}}
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' # No authorization is required to access public boards. Let's get the ID of
#' # Trello Development Roadmap board:
#' url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
#' bid = get_id_board(url)
#'
#' # Once we have the ID, we can use it to make specific queries:
#' lists  = get_board_lists(bid)            # Get all lists
#' labels = get_board_labels(bid)           # Get all labels
#' cards  = get_board_cards(bid, limit = 5) # Get 5 cards
#'
#' # Now we can extract card ID. As with boards, this allows us to to query
#' # cards for particular resources:
#' card1_id   = cards$id[1]
#' card1_comm = get_card_comments(card1_id) # Get all comments
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
                      query = NULL,
                      url = NULL,
                      token = NULL,
                      filter = NULL,
                      limit = 1000,
                      paging = FALSE,
                      bind.rows = TRUE
                      # , fix = TRUE
                      ) {

    url   = build_url(parent = parent, child = child, id = id)
    query = build_query(query = query, filter = filter, limit = limit)

    cat("Sending request...\n")

    if (paging) {
        result = get_pages(url = url, token = token,
                           query = query, bind.rows = bind.rows)
    } else {
        result = get_page(url = url, token = token,
                          query = query)
    }

    # if (fix) result = trello_fix(result)
    return(result)
}

get_page = function(url, token, query) {

    result = get_flat(url = url, token = token, query = query)
    message("Returning ", class(result))

    if (is.data.frame(result)) {
        if (nrow(result) >= 1000) {
            message("Reached 1000 results. Set 'paging = TRUE' to get more")
        } else {
            message("Received ", nrow(result), " results")}
    } else {
        message(length(result), " elements")}

    return(result)
}

get_pages = function(url, token, query, bind.rows) {

    result = list()

    repeat {

        batch  = get_flat(url = url, token = token, query = query)
        result = append(result, list(batch))

        if (!is.data.frame(batch)) {
            message("Cannot determine number of results - paging aborted")
            break
        } else if (nrow(batch) < 1000) {
            total = ((length(result) - 1) * 1000) + nrow(batch)
            message("Received last page, ", total," results in total")
            break
        } else {
            query$before = batch$id[1000]
            message("Received 1000 results, keep paging...")
        }
    }

    if (bind.rows) {
        result = tryCatch(
            expr  = bind_rows(result),
            error = function(e) {
                cat("Binding failed:", e$message)
                message("Returning list (", length(result), " elements)")
                result
            })
    }
    return(result)
}

build_url = function(url, parent, id, child) {
    if (is.null(url))  {
        url = paste0("https://api.trello.com/1/", parent, "/", id, "/", child)
    } else {
        url
    }
}

build_query = function(query = NULL, filter = NULL, limit = 1000) {

    if (is.null(query)) query = list()

    query$filter = filter
    query$limit  = limit

    return(query)
}

#' GET url and return data.frame
#'
#' GET url and return data.frame
#' @param url url to get
#' @param token a secure token
#' @param query additional url parameters (defaults to NULL)
#' @importFrom httr GET content config http_status headers http_type http_error user_agent
#' @importFrom jsonlite fromJSON

get_flat = function(url, token = NULL, query = NULL) {

    # Issue request
    req  = GET(url = url,
               config(token = token),
               query = query,
               user_agent("https://github.com/jchrom/trellor"))

    # Print out the complete url
    cat("Request URL:\n", req$url, "\n", sep = "")

    # Handle errors
    if (http_error(req)) stop(http_status(req)$message, " : ", req)

    # Handle response (only JSON is accepted)
    if (http_type(req) == "application/json") {
        json = content(req, as = "text")
        flat = fromJSON(json, flatten = TRUE)
    } else {
        req_trim = paste0(strtrim(content(req, as = "text"), 50), "...")
        stop(http_type(req), " is not JSON : \n", req_trim)
    }

    # If the result is an empty list, convert into an empty data.frame
    if (length(flat) == 0) {
        flat = data.frame()
        message("Response was empty")
    }

    # Return the result
    return(flat)
}
