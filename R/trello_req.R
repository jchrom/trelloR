#' Build Requests For Trello API
#'
#' Creates a function that retirevs data from Trello API.
#' @param parent e.g. \code{"board"}, \code{"card"}, \code{"member"}
#' @param child e.g. \code{"cards"}, \code{"actions"}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

trello_req = function(parent, child) {

    # Note: "parent", "child" are used in its body
    trello_fun = function(id, token,
                          query,
                          paging = FALSE,
                          fix = TRUE) {

        # Build url & query and send request
        url = paste0("https://api.trello.com/1/", parent, "/", id, "/", child)
        res = trello_get(url = url, token = token, query = query,
                         paging = paging)

        # Assign a class depending on what has been returned
        class(res) = c(child, "trello.api", class(res))

        # Simplify the response
        if (fix) trello_fix(res)

        # Return result
        return(res)
    }
    return(trello_fun)
}

# For now just a placeholder; later a wrapper for the trello_fix family
trello_fix = function(res) {
    return(res)
}


