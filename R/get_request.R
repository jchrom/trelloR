#' Request Data From Trello
#'
#' This is a generic function to perform query via trello API. Other functions such as 'get_board_cards' or 'get_board_lists' are convenience wrappers for this function.
#' @param url url for the GET request, see \code{\link[httr]{GET}}
#' @param query url query see \code{\link[httr]{GET}}
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate logical whether pagination should be used (if not, results will be limited to 50 rows)
#' @importFrom dplyr bind_rows
#' @export
#' @examples
#' # First, build an URL including query parameters (in this case, filter = open)
#' id  = "id_of_a_given_board"
#' url = paste0("https://api.trello.com/1/boards/", id, "/cards?filter=open")
#'
#' # Obtain a secure token to communicate with Trello API
#' token = get_token("your_key", "your_secret")
#'
#' # Get all cards that are not archived
#' all_open = get_request(url, token)

get_request = function(url,
                       token,
                       query = list(limit = "1000"),
                       paginate = FALSE) {

    if (paginate) {

        # Get first batch
        flat = get_flat(url = url, token = token, query = query)
        message("Received results 1-", nrow(flat), "\n", sep = "")

        # If it is shorter than 1000 rows, no paging is needed - return result
        if (nrow(flat)  < 1000) return(flat)

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

            # Stop the loop if the batch is less than 1000 rows, because
            # this means that there is no more results to retrieve
            if (nrow(batch) < 1000) break
        }
    } else {

        # Build url and get flattened data
        flat = get_flat(url = url, token = token, query = query)

        # If the result reached 1000 rows, suggest using pagination
        if (nrow(flat) >= 1000) {
            message("Reached 1000 results; use 'paginate = TRUE' to get more but BEWARE: the results may be large!")
        } else {
            message("Received ", nrow(flat), " results")
        }
    }
    return(flat)
}

#' Get Data As A Flattened Data.frame
#'
#' This function uses http GET to download JSON via API, and returns a flat \code{data.frame}
#' @param url character url including query parameters
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param query a list of additional url parameters such as filter = "open"
#' @importFrom httr GET content config http_status headers
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' url = "https://api.trello.com/1/board/56d73a62e690ccd8d46fe5c6/cards"
#' all_cards = get_flat(url, token)

get_flat = function(url,
                    token,
                    query = NULL) {

    # Issue request and print out the complete url
    req  = GET(url, config(token = token), query = query)
    cat("Using URL:\n", req$url, "\n", sep = "")

    # If the status is not 200, throw an error
    if (req$status != 200) stop(http_status(req)$message)

    # If the content is not a valid JSON, throw an error
    if (!is_json(req)) stop(headers(req)$`content-type`, " is not JSON")

    # For successfull requests with JSON results, return flattened data.frame
    json = content(req, as = "text")
    flat = fromJSON(json, flatten = T)
    return(flat)
}

is_json = function(req) {
    cont   = headers(req)$`content-type`
    isjson = grepl("application/json", cont)
    return(isjson)
}
