#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' It accepts JSON responses and uses \code{\link[jsonlite]{fromJSON}} to convert them into flat \code{data.frame}s. It hrows an error if non-JSON type of data is received. It also takes care of paging (if \code{paginate = TRUE}), setting the query parameter \code{before} to the earliest date from the previous result, essentially getting all there is for the given request.
#'
#' For unsuccessfull requests, server error messages are extracted from the response header and reprinted on the console.
#'
#' Functions such as \code{\link{get_board_cards}} or \code{\link{get_card_comments}} are convenience wrappers for this function. They remove the need for specifying the query parameters and optionally simplify the result so as to give you more consistent and easy to work with data.
#' @param url url for the GET request, see \code{\link[httr]{GET}} for details
#' @param query url parameters that form the query, see \code{\link[httr]{GET}} for details
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paginate logical whether paging should be used (if not, results will be limited to 1000 rows)
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{get_token}}
#' @importFrom dplyr bind_rows
#' @importFrom httr GET content config http_status headers
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
                      paginate = FALSE) {

    if (paginate) {

        # Get first batch
        flat = get_flat(url = url, token = token, query = query)

        # If the result is not a data.frame, it cannot be bound by bind_rows,
        # and most likely is not a sensible request anyway - return whatever
        # came back and print a message
        if (!is.data.frame(flat)) {
            message("Empty or complex JSON: no paging")
            return(flat)
        }

        # If it is shorter than 1000 rows, no paging is needed - return result
        if (nrow(flat) < 1000) {
            return(flat)
        } else {
            message("Received results 1-", nrow(flat), "\n", sep = "")
        }

        # If not, paginate over the rest and append
        repeat {

            # Find the lowest date and use the corresponding id
            query$before = flat$id[flat$date == min(flat$date)]
            batch = get_flat(url = url, token = token, query = query)

            # Show some info
            message("Received results ",
                    nrow(flat) + 1, "-", nrow(flat) + nrow(batch),
                    "\n", sep = "")

            # Append the batch to the previous results
            flat = bind_rows(flat, batch)

            # Stop the loop if the batch is less than 1000 rows (or is empty
            # i.e. of length 0), because this means that there is no more
            # results to retrieve
            if (nrow(batch) < 1000) break
        }
    } else {

        # Build url and get flattened data
        flat = get_flat(url = url, token = token, query = query)

        # Comment on results:
        # - List responses do not fit into the package scheme, but can be subset
        #   manually
        # - If 1000 rows is obtained, the true response may be larger - suggest
        #   the use of paging
        # - Otherwise just return the result as is
        if (!is.data.frame(flat)) {
            message("Empty or complex JSON: subset manually for flat data")
        } else if (is.data.frame(flat) & nrow(flat) >= 1000) {
            message("Reached 1000 results; use 'paginate = TRUE' to get more")
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
    cat("Using URL:\n", req$url, "\n", sep = "")

    # If the status is not 200 (=OK), throw an error
    if (req$status != 200) {
        stop(http_status(req)$message)
    } else {
        cat(http_status(req)$message)
    }

    # If the content is not a valid JSON, throw an error
    if (!is_json(req)) stop(headers(req)$`content-type`, " is not JSON")

    # For successfull requests, flatten the JSON results
    json = content(req, as = "text")
    flat = fromJSON(json, flatten = T)

    # In case they're empty, convert into an empty data.frame
    if (length(flat) == 0) flat = data.frame()

    # Return the result
    return(flat)
}

is_json = function(req) {
    cont   = headers(req)$`content-type`
    isjson = grepl("application/json", cont)
    return(isjson)
}
