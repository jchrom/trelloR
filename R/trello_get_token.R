#' Get A Secure Token
#'
#' Authorize access to Trello API
#'
#' In order to access private data, a secure token is required. In order to create it, you will need your developer 'key' and 'secret' - these can be obtained here: \url{https://trello.com/app-key}. \code{\link{trello_get_token}} takes these credentials, adds Trello API endpoints and feeds it all to authentication functions from \code{\link{httr}}.
#'
#' First time you create a token, you will be prompted to confirm the authorization in a browser (you only need to do this once). You will also be offered an option to store the authentication data in your working directory. Keep in mind you have to store your credentials in a secure, non-shared location.
#' @param key developer key as character string
#' @param secret developer secret as character string
#' @param app optional app name, defaults to "trello"
#' @seealso \code{\link[httr]{oauth_app}}, \code{\link[httr]{oauth_endpoint}}, \code{\link[httr]{oauth1.0_token}}
#' @importFrom httr oauth_app oauth_endpoint oauth1.0_token
#' @export
#' @examples
#' \dontrun{
#' # Source credentials from non-shared location (important!)
#' source("mykeys.R")
#' token = get_token(key, secret)
#' }

trello_get_token = function(key, secret, app = "trello") {

    # 1. Create an app
    trello.app = oauth_app(
        appname = app,
        key = key,
        secret = secret)

    # 2. URLs for "request token", "authorize token" and "access token"
    trello.urls = oauth_endpoint(
        "https://trello.com/1/OAuthGetRequestToken",
        "https://trello.com/1/OAuthAuthorizeToken",
        "https://trello.com/1/OAuthGetAccessToken")

    # 3. Get token
    trello.token = oauth1.0_token(trello.urls, trello.app)

}
