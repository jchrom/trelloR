#' Request Data From Trello
#'
#' This is a generic function to perform query via trello API. Other function such as 'get_board_cards' or 'get_board_lists' are convenience wrappers for this function.
#' @param endpoint character ("organization", "board", "card"...)
#' @param id id of the given endpoint
#' @param query url query, such as '?lists=open'
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' all_cards = get_request("boards", 123456789, "cards", token)

get_request = function(endpoint, id, query, token) {

    # Get url
    url = .build_url(endpoint, id, query)

    # Get data
    req  = GET(url, config(token = token))
    json = content(req, as = "text")
    flat = fromJSON(json, flatten = T)

    # Return flattened
    return(flat)
}

.build_url = function(endpoint, id, query) {

    # Construct url
    url = paste0("https://api.trello.com/1/",
                 endpoint, "/",
                 id, "/",
                 query)
    return(url)
}
