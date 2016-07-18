#' Get Trello Board
#'
#' Read in data either via API using oauth1 token or from a local file (which you can get by downloading data from Trello and saving as a text file)
#' @param url url of the Trello board, or a local file downloaded via Trello JSON export
#' @param token previously generated token (see ?get_token for help)
#' @importFrom httr GET config content
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' # Source credentials from non-shared location (important!)
#' url = "url_of_your_trello_board"
#' b = get_board(url, token)

get_board = function(url, token = NULL) {

    # Check url type (web/local)
    is_url = .check_url(url)
    if (is_url & is.null(token)) stop("Please provide a valid oauth token (see ?get_token for help)")

    # Append .json suffix if necessary
    if (!grepl(".+json", url)) { url = paste0(url, ".json") }

    # Get data
    if (is_url) {
        req   = GET(url, config(token = token))
        json  = content(req, as = "text")
        board = fromJSON(json, flatten = T)
    } else {
        board = fromJSON(url, flatten = T)
    }

    class(board) = "trello.board"
    return(board)
}
