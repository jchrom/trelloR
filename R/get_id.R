############################################
#                                          #
#    Retrieve resource id                  #
#                                          #
############################################

#' Get ID
#'
#' Get ID of a resource.
#' @param url Complete url, short url or just the url ID part of a Trello board
#' @name get_id
#' @export
#' @examples
#' # Get Trello Development Roadmap board ID
#' url    = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
#' tdr_id = get_board_id(url)
#'
#' # Also works:
#' url    = "nC8QJJoZ"
#' tdr_id = get_board_id(url)

#' @rdname get_id
get_id_board = function(url) {

    # Parse URL
    parsed = parse_url(url)

    # Define closure and call
    fun = trello_req(parent = "board")
    dat = fun(parsed, query = list(fields = "name"))

    # Format vector
    id = dat$id
    names(id) = dat$name
    class(id) = c("character")

    # Comment on results
    cat("Converted into character vector of length 1 with name")

    return(id)
}

#' @rdname get_id
get_id_card = function(url) {

    # Parse URL
    parsed = parse_url(url)

    # Define closure and call
    fun = trello_req(parent = "card")
    dat = fun(parsed, query = list(fields = "name"))

    # Format vector
    id = dat$id
    names(id) = dat$name
    class(id) = c("character")

    # Comment on results
    cat("Converted into character vector of length 1 with name")

    return(id)
}

parse_url = function(url) {

    path = unlist(strsplit(url, "/"))

    if (length(path) >= 5) {
        id = path[5]
    } else if (length(path) != 1) {
        stop("This is probably not a valid Trello board URL")
    } else {
        id = path
    }
    return(id)
}
