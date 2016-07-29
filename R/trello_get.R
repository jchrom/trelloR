#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints. Functions such as \code{\link{get_board_cards}} or \code{\link{get_card_comments}} are convenience wrappers for this function.
#'
#' If the request fails, server error messages are extracted from the response header and reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s. Non-JSON type of response throws an error.
#'
#' When \code{paging = TRUE}), then every batch of results is searched and the ID of the earliest result is retrieved. This is used as the \code{before} parameter to the next url request. This way Trello knows where to start fetching the next batch of results. Paging keeps going until there is nothing more to fetch (i.e., the number of results is smaller then 1000 which is the server response limit).
#'
#' \code{filter} and \code{limit} are query parameters that can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#' @param url url for the GET request, see \code{\link[httr]{GET}} for details
#' @param filter url parameter
#' @param limit url parameter (defaults to 1000; if reached, paging is suggested)
#' @param query url parameters that form the query, see \code{\link[httr]{GET}} for details
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param paging logical whether paging should be used
#' @param bind.rows by default, pages will be combined into one \code{data.frame} by \code{\link[dplyr]{bind_rows}}. Set to \code{FALSE} if you want \code{list} instead. This is useful on the rare occasion that the JSON response is not formatted correctly and makes \code{\link[dplyr]{bind_rows}} fail
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{trello_get_token}}
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' # For accessing public boards you don't need authorization; this example uses
#' # the publicly available Trello Development Roadmap board (notice the .json
#' # suffix):
#' url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap.json"
#' tdr = trello_get(url)
#'
#' # This gives you some useful content already, but you may want to do more
#' # specific queries. Let's start by getting the ID of the board:
#' bid = tdr$id
#'
#' # We can now use this ID to make specific queries using dedicated functions:
#' tdr_lists  = get_board_lists(bid)            # Get all lists
#' tdr_labels = get_board_labels(bid)           # Get all labels
#' tdr_cards  = get_board_cards(bid, limit = 5) # Get 5 cards
#'
#' # Having acquired card-related data, we can now make queries about specific
#' # cards. As before, we start by getting the ID of the first card:
#' card1_id   = tdr_cards$id[1]
#' card1_comm = get_card_comments(card1_id) # Get comments from the card
#'
#' # To retrieve large results, paging might be necessary:
#'
#' \dontrun{
#' tdr_actions = get_board_actions(bid, filter = "commentCard", paging = TRUE)
#'
#' # For private boards, you need a secure token to communicate with Trello API
#' token = get_token("your_key", "your_secret")
#'
#' # Get all cards that are not archived
#' all_open = get_request(url, token, query)
#' }

trello_get = function(url,
                      token = NULL,
                      filter = NULL,
                      limit = NULL,
                      query = NULL,
                      paging = FALSE,
                      bind.rows = TRUE) {

    cat("Sending request...\n")

    # In case of large results, server only returns 50; change to 1000 instead

    # Build query
    if (is.null(query)) query = build_query(filter = filter, limit = limit)
    if (is.null(query$limit)) query$limit = "1000"

    if (paging) {

        # Set placeholder for results and a result counter
        result = list()
        n_res  = 0

        repeat {

            # Get a batch of data
            batch = get_flat(url = url,
                             token = token,
                             query = query)
            n_res = n_res + nrow(batch)

            # Append to the previous results
            result[[length(result) + 1]] = batch

            # If paging is needed, set 'before'; otherwise abort
            if (keep_going(batch)) {
                query$before = set_before(batch)
                message("Received 1000 results, keep paging...")
            } else {
                message("Received last page, ", n_res," results in total")
                break
            }
        }

        if (bind.rows) {
            result = tryCatch(
                expr  = bind_rows(result),
                error = function(e) {
                    message("Binding failed, returning list")
                    message(length(result), " elements")
                    result
                })
        }
    } else {

        # Build url and get flattened data
        result = get_flat(url = url, token = token, query = query)
        message("Returning ", class(result))

        # Show out
        if (is.data.frame(result)) {
            if (nrow(result) >= 1000) {
                message("Reached 1000 results; use 'paging = TRUE' to get more")
            } else {
                message("Received ", nrow(result), " results")
            }
        } else {
            message(length(result), " elements")
        }
    }
    return(result)
}

set_before = function(batch) {
    # Get ID that corresponds with the earliest date
    before = batch$id[batch$date == min(batch$date)]
    return(before)
}

keep_going = function(flat) {

    # Only data.frames can be bound by bind_rows; if it isn't one, abort paging
    if (!is.data.frame(flat)) {
        message("Response format is not suitable for paging - finished.")
        go_on = FALSE
    } else go_on = TRUE

    # If the result is shorter than 1000, it is the last page; abort paging
    if (nrow(flat) < 1000) go_on = FALSE

    # My heart must
    return(go_on)
}

#' GET url and return data.frame
#'
#' GET url and return data.frame
#' @param url url to get
#' @param token a secure token
#' @param query additional url parameters (defaults to NULL)
#' @importFrom httr GET content config http_status headers http_type http_error user_agent
#' @importFrom jsonlite fromJSON

get_flat = function(url,
                    token = NULL,
                    query = NULL) {

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
        stop(http_type(req), " is not JSON : ", req_trim)
    }

    # If the result is an empty list, convert into an empty data.frame
    if (length(flat) == 0) {
        flat = data.frame()
        message("The response is empty")
    }

    # Return the result
    return(flat)
}


