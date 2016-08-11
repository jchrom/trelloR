############################################
#                                          #
#    Retrieve resource id                  #
#                                          #
############################################

#' Get model ID
#'
#' Get ID of a resource.
#' @param url Complete url, short url or just the url ID part of a Trello board
#' @param token Secure token - get it with \code{\link{trello_get_token}}
#' @name get_id
#' @examples
#' # Get Trello Development Roadmap board ID
#' url    = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
#' tdr_id = get_id_board(url)
#'
#' # Also works:
#' url    = "nC8QJJoZ"
#' tdr_id = get_id_board(url)

#' @export
#' @rdname get_id
get_id_board = function(url, token = NULL) {

    url = parse_url(url)
    dat = trello_get(parent = "board", id = url, token = token,
                     query = list(fields = "name"))

    id = dat$id
    names(id) = dat$name
    class(id) = c("character")

    cat('Converted into character vector of length 1 with name "',
        names(id), '"\n', sep = "")

    return(id)
}

#' @export
#' @rdname get_id
get_id_card = function(url, token = NULL) {

    url = parse_url(url)
    dat = trello_get(parent = "card", id = url, token = token,
                     query = list(fields = "name"))

    # Format vector
    id = dat$id
    names(id) = dat$name
    class(id) = c("character")

    # Comment on results
    cat('Converted into character vector of length 1 with name "',
        names(id), '"', sep = "")

    return(id)
}

parse_url = function(url, pos = 5) {

    path = unlist(strsplit(url, "/"))

    if (length(path) >= pos) {
        id = path[pos]
    } else if (length(path) != 1) {
        stop("This is probably not a valid Trello board URL")
    } else {
        id = path
    }
    return(id)
}
