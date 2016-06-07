#' Get Trello Board
#'
#' Download
#' @param key key
#' @param secret secret
#' @importFrom httr oauth_app oauth_endpoint oauth1.0_token
#' @export
#' @examples
#'
#' # Source credentials from non-shared location (important!)
#' source("mykeys.R")
#' token = get_token(key, secret)
#'
#' You will be prompted to confirm the authorization in a browser. You will also be offered an option to store the authentication in your working directory, in a hidden '.httr-oauth' file (do NOT share it with anyone!).

get_board = function(url, token) {

    # check whether the url has the .json suffix and if not, add it (for convenience...)

    # also, it should accept local url - for already downloaded json files

}
