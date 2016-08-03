#' Get A Secure Token
#'
#' Authorize access to Trello API.
#'
#' To access private data, a secure token is required. In order to create it, you will need your developer credentials ('key' and 'secret') - these can be obtained in \href{https://developers.trello.com/get-started/start-building#connect}{Trello developer guide} after login.
#'
#' First time you create a token, you will be prompted to confirm the authorization in a browser (you only need to do this once). You will also be offered an option to store the authentication data in your working directory. Keep in mind you have to store your credentials in a secure, non-shared location.
#'
#' \code{\link{trello_get_token}} call authentication functions from \code{\link{httr}}.
#' @param key developer key
#' @param secret developer secret
#' @param appname optional app name, defaults to "trello"
#' @seealso \code{\link[httr]{oauth_app}}, \code{\link[httr]{oauth_endpoint}}, \code{\link[httr]{oauth1.0_token}}
#' @importFrom httr oauth_app oauth_endpoint oauth1.0_token
#' @export
#' @examples
#' # Source credentials from non-shared location (important!)
#'
#' \dontrun{
#'
#' source("mykeys.R")
#' token = trello_get_token(key, secret)
#' }

trello_get_token = function(key, secret, appname = "trello") {

    trello.app = oauth_app(
        appname = appname,
        key = key,
        secret = secret)

    trello.urls = oauth_endpoint(
        "https://trello.com/1/OAuthGetRequestToken",
        "https://trello.com/1/OAuthAuthorizeToken",
        "https://trello.com/1/OAuthGetAccessToken")

    trello.token = oauth1.0_token(trello.urls, trello.app)

}
