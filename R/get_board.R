#' Get Trello Board
#'
#' Read in data either via API using oauth1 token or from a local file (which you can get by downloading data from Trello and saving as a text file)
#' @param url url of the Trello board, or a local file downloaded from Trello
#' @param token previously generated token (see ?get_token for help)
#' @importFrom httr GET config content
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' # Source credentials from non-shared location (important!)
#' source("mykeys.R")
#' token = get_token(key, secret)
#'
#' You will be prompted to confirm the authorization in a browser. You will also be offered an option to store the authentication in your working directory, in a hidden '.httr-oauth' file (do NOT share it with anyone!).

get_board = function(url, token = NULL) {

    # Check url type (web/local)
    type = .check_url(url)
    if (type == "web" & is.null(token)) stop("Please provide a valid oauth token (see ?get_token for help)")

    # Append .json suffix if necessary
    if (!grepl(".+json", url)) { url = paste0(url, ".json") }

    # Get data
    if (type == "web") {
        req   = GET(url, config(token = token))
        json  = content(req, as = "text")
        board = fromJSON(json)
    } else {
        board = fromJSON(url)
    }

    return(board)
}

# Helper function ----

.check_url = function(url) {

    if (!is.character(url)) {
        stop("url must be of class 'character'")
    }

    if (grepl("(www|http)", url))  {
        type = "web"
    } else {
        type = "local"
    }

    return(type)

}
