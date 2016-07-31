#' Build Requests For Trello API
#'
#' GET request function builder.
#' @param parent e.g. \code{"board"}, \code{"card"}, \code{"member"}
#' @param child e.g. \code{"cards"}, \code{"actions"}
#' @param filter character vector of length 1
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

trello_req = function(parent, child = NULL, filter = NULL) {

    # Note: "parent", "child" are used in its body
    trello_fun = function(id,
                          token = NULL,
                          # filter = NULL,
                          limit = NULL,
                          query = NULL,
                          paging = FALSE,
                          fix = TRUE,
                          bind.rows = TRUE) {

        # Build url
        url = paste0("https://api.trello.com/1/", parent, "/", id, "/", child)

        # Send request
        res = trello_get(url = url,
                         token = token,
                         filter = filter,
                         limit = limit,
                         query = query,
                         paging = paging,
                         bind.rows = bind.rows)

        # Assign a class depending on what has been returned
        if (is.null(child)) child == parent
        class(res) = c(child, "trello_api", class(res))

        # Simplify the response
        if (fix) trello_fix(res)

        # Return result
        return(res)
    }
    return(trello_fun)
}

build_query = function(filter, limit) {
    query = list()
    if (!is.null(filter)) query$filter = filter
    if (!is.null(limit))  query$limit  = limit
    return(query)
}

# For now just a placeholder; later a wrapper for the fix_ family
trello_fix = function(res) {
    return(res)
}
