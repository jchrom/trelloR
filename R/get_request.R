#' Request Data From Trello
#'
#' This is a generic function to perform query via trello API. Other function such as 'get_board_cards' or 'get_board_lists' are convenience wrappers for this function.
#' @param endpoint character ("organization", "board", "card"...)
#' @param id id of the given endpoint
#' @param query url query, such as '?lists=open'
#' @param token previously generated token (see ?get_token for help)
#' @param paginate logical whether pagination should be used (if not, results will be limited to 50 rows)
#' @export
#' @examples
#' all_cards = get_request("boards", 123456789, "cards", token)

get_request = function(endpoint, id, query, token, paginate = FALSE) {

    if (paginate) {

        # Get first batch
        url = .build_url(endpoint, id, query)
        rsp = get_flat(url, token)
        cat("Added results 1-", nrow(rsp), "\n", sep = "")
        if (nrow(rsp) < 1000) return(rsp)

        # Paginate over the rest and append
        repeat {

            # Find the lowest date and use the correcponding id
            before = rsp$id[rsp$date == min(rsp$date)]

            # Get current batch
            url   = .build_url(endpoint, id, query, limit = 1000, before)
            batch = get_flat(url, token)

            # Bind this batch to the previous results
            nrow_rsp = nrow(rsp)
            nrow_batch = nrow(batch)
            rsp = bind_rows(rsp, batch)

            # Show some info
            cat("Added results ", nrow_rsp + 1, "-", nrow_rsp + nrow_batch,
                "\n", sep = "")

            # Stop the loop when the batch is less than 1000 rows (= the end)
            if (nrow(batch) < 1000) break
        }
        return(rsp)
    } else {

        # Build url and get flattened data
        url = .build_url(endpoint, id, query)
        rsp = get_flat(url, token)

        # If the result reached 1000 rows, suggest using pagination
        if (nrow(rsp) >= 1000) {
            message("Reached 1000 results.")
            message("Use 'paginate = TRUE' to get more but BEWARE: the results may be large!")
        }
        return(rsp)
    }
}

#' Get Data As A Flattened Data.frame
#'
#' This function uses http GET to download JSON via API, and returns a flat data.frame
#' @param url character query url
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' url = "https://api.trello.com/1/board/56d73a62e690ccd8d46fe5c6/cards"
#' all_cards = get_flat(url, token)

get_flat = function(url, token) {

    cat("Using query:\n", url, "\n", sep = "")
    req  = GET(url, config(token = token))
    json = content(req, as = "text")
    flat = fromJSON(json, flatten = T)
    return(flat)
}

.build_url = function(endpoint, id, query, limit = 1000, before = NULL) {

    # Add limit=1000 if there isn't one already
    # This is to avoid the default behavior whereby only the last 50 actions are returned when there are more
    query = .set_limit(query, limit)

    # If pagination is applied, add the 'before' argument
    if (!is.null(before)) query = paste0(query, "&before=", before)

    # Construct url
    url = paste0("https://api.trello.com/1/",
                 endpoint, "/", id, "/",
                 query)

    # Print out and return
    return(url)
}

.set_limit = function(query, limit) {

    if (!grepl("limit", query) & (!grepl("\\?", query))) {
        query = paste0(query, "?limit=", limit)
    } else if (!grepl("limit", query)) {
        query = paste0(query, "&limit=", limit)
    }
    return(query)
}
