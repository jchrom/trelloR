#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' It accepts JSON responses and uses \code{\link[jsonlite]{fromJSON}} to convert them into flat \code{data.frame}s. It hrows an error if non-JSON type of data is received. It also takes care of paging (if \code{paging = TRUE}), setting the query parameter \code{before} to the earliest date from the previous result, essentially getting all there is for the given request.
#'
#' For unsuccessfull requests, server error messages are extracted from the response header and reprinted on the console.
#'
#' Functions such as \code{\link{get_board_cards}} or \code{\link{get_card_comments}} are convenience wrappers for this function. They remove the need for specifying the query parameters and optionally simplify the result so as to give you more consistent and easy to work with data.
#' @param url url for the GET request, see \code{\link[httr]{GET}} for details
#' @param query url parameters that form the query, see \code{\link[httr]{GET}} for details
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paging logical whether paging should be used (if not, results will be limited to 1000 rows)
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{get_token}}
#' @importFrom dplyr bind_rows
#' @importFrom httr GET content config http_status headers http_type http_error user_agent
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' \dontrun{
#' # First, obtain a secure token to communicate with Trello API
#' token = get_token("your_key", "your_secret")
#'
#' # Second, build an URL
#' id  = "id_of_a_given_board"
#' url = paste0("https://api.trello.com/1/boards/", id, "/cards")
#'
#' # Third, store query parametrs in a list (see ?httr::GET for details)
#' query = list(filter = "open")
#'
#' # Get all cards that are not archived
#' all_open = get_request(url, token, query)
#' }

trello_get = function(url,
                      token,
                      query = NULL,
                      paging = FALSE) {

    cat("Sending request...\n")

    # In case of large results, server only returns 50; change to 1000 instead
    if (is.null(query))       query = list()
    if (is.null(query$limit)) query$limit = "1000"

    if (paging) {

        # Create placeholder for results
        flat = data.frame()

        repeat {

            # Get a batch of data and append to the previous results
            batch = get_flat(url = url, token = token, query = query)
            flat  = bind_rows(flat, batch)

            # If paging is needed, set 'before'; otherwise abort
            if (keep_going(batch)) {
                query$before = set_before(batch)
                message("Received 1000 results, keep paging...")
            } else {
                message("Received last page (", nrow(batch)," results)")
                break
            }
        }
    } else {

        # Build url and get flattened data
        flat = get_flat(url = url, token = token, query = query)

        # Show out
        if (!is.data.frame(flat)) {
            message("Returning", class(flat))
        } else if (is.data.frame(flat) & nrow(flat) >= 1000) {
            message("Reached 1000 results; use 'paging = TRUE' to get more")
        } else {
            message("Received ", nrow(flat), " results")
        }
    }
    return(flat)
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

get_flat = function(url, token, query = NULL) {

    # Issue request
    req  = GET(url, config(token = token), query = query,
               user_agent("https://github.com/jchrom/trellor"))

    # Print out the complete url
    cat("Request URL:\n", req$url, "\n", sep = "")

    # Handle errors
    if (http_error(req)) stop(http_status(req)$message, " : ", req)

    # Handle response (only JSON is accepted)
    if (http_type(req) == "application/json") {
        json = content(req, as = "text")
        flat = fromJSON(json, flatten = T)
        # print(headers(req))
    } else {
        req_trim = paste0(strtrim(content(req, as = "text"), 50), "...")
        stop(http_type(req), " is not JSON : ", req_trim)
    }

    # If the result is an empty list, convert into an empty data.frame
    if (length(flat) == 0) flat = data.frame()

    # Return the result
    return(flat)
}


