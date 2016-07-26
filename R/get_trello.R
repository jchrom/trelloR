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
#' @importFrom httr GET content config http_status headers http_type http_error
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
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

get_trello = function(url,
                      token,
                      query = list(limit = "1000"),
                      paging = FALSE) {

    cat("Sending request...\n")

    if (paging) {

        # Create placeholder for results
        flat = data.frame()

        repeat {

            # Get a batch of data and append to the previous results
            batch = get_flat(url = url, token = token, query = query)
            flat  = bind_rows(flat, batch)

            # Check whether paging is needed; if so, set the 'before' parameter
            # Also, print out a message
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

        # Comment on results:
        # - Responses containing lists do not fit into the package scheme, but
        #   can be subset manually
        # - If 1000 rows is obtained, the true response may be larger - suggest
        #   the use of paging
        # - Otherwise just return the result as is
        if (!is.data.frame(flat)) {
            cat("Returning empty or complex JSON: subset manually")
        } else if (is.data.frame(flat) & nrow(flat) >= 1000) {
            message("Reached 1000 results; use 'paging = TRUE' to get more")
        } else if (is.data.frame(flat)) {
            message("Received ", nrow(flat), " results")
        }
    }
    return(flat)
}

get_flat = function(url,
                    token,
                    query = NULL) {

    # Issue request and print out the complete url
    req  = GET(url, config(token = token), query = query)
    cat("Request URL:\n", req$url, "\n", sep = "")

    # If the status is not 200 (=OK), throw an error
    if (http_error(req)) stop(http_status(req)$message, " : ", req)

    # If the content is JSON, convert into a flat data.frame, otherwise error
    if (http_type(req) == "application/json") {
        json = content(req, as = "text")
        flat = fromJSON(json, flatten = T)
    } else {
        req_trim = paste0(strtrim(content(req, as = "text"), 50), "...")
        stop(http_type(req), " is not JSON : ", req_trim)
    }

    # If the result is an empty list, convert into an empty data.frame
    if (length(flat) == 0) flat = data.frame()

    # Return the result
    return(flat)
}

set_before = function(batch) {
    # Get ID that corresponds with the earliest date
    before = batch$id[batch$date == min(batch$date)]
    return(before)
}

keep_going = function(flat) {

    # By default, my heart must go on...
    go_on = TRUE

    # If the result is not a data.frame, it cannot be bound by bind_rows; return
    # whatever came back and print out a message
    if (!is.data.frame(flat)) {
        message("Returning empty or complex JSON: will not use paging")
        go_on = FALSE
    }

    # Also, if it is shorter than 1000 rows, no paging is needed since there
    # are no more results to be fetched
    if (nrow(flat) < 1000) go_on = FALSE

    return(go_on)
}
