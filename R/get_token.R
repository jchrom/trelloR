#' Authorize API access to Trello
#'
#' Token is needed in order to get data directly from Trello via API. To create it, get your 'key' and 'secret' here: https://trello.com/app-key.
#' @param key key
#' @param secret secret
#' @param app optional app name, defaults to "trello"
#' @importFrom httr oauth_app oauth_endpoint oauth1.0_token
#' @export
#' @examples
#' # Source credentials from non-shared location (important!)
#' source("mykeys.R")
#' token = get_token(key, secret)
#'
#' # You will be prompted to confirm the authorization in a browser. You will
#' # also be offered an option to store the authentication in your working
#' # directory, in a hidden '.httr-oauth' file (do NOT share it with anyone!).

get_token = function(key, secret, app = "trello") {

    # 1. Create an app
    trello.app = oauth_app(
        app,
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
