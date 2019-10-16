#' Get OAuth1.0 Token
#'
#' Authorize access to Trello API.
#'
#' To access private data, a secure token is required. In order to create it, you will need your developer credentials ('key' and 'secret'). These can be obtained visiting `https://trello.com/app-key` after logging in to Trello.
#'
#' First time you create a token, you will be prompted to confirm the authorization in a browser (you only need to do this once). You will also be offered an option to store the authentication data in your working directory. Keep in mind you have to store your credentials in a \strong{secure, non-shared} location.
#'
#' \code{\link{get_token}} uses authentication functions from \code{\link{httr}}.
#' @param key developer key
#' @param secret developer secret
#' @param appname optional app name, defaults to "trello-app"
#' @param scope defaults to \code{"read"}; allowed are \code{c("read", "write", "account")} or \code{"read,write,account"} if you prefer
#' @param expiration defaults to \code{"30days"}; also allowed \code{"1hour"}, \code{"1day"} and \code{"never"}
#' @seealso \code{\link[httr]{oauth_app}}, \code{\link[httr]{oauth_endpoint}}, \code{\link[httr]{oauth1.0_token}}
#' @importFrom httr oauth_app oauth_endpoint oauth1.0_token
#' @export
#' @examples
#' # Source credentials from non-shared location (important!)
#'
#' \dontrun{
#'
#' source("mykeys.R")
#' token = get_token(key, secret, scope = "read,write")
#' }

get_token = function(key, secret, appname = "trello-app", scope = "read",
                     expiration = "30days") {

  stopifnot(
    is.character(key),
    is.character(secret),
    is.character(scope),
    expiration %in% c("1hour", "1day", "30days", "never")
  )

  url.params = paste0(
    "?scope=", paste(scope, collapse = ","),
    "&expiration=", expiration,
    "&name=", appname
    )

  trello.app = oauth_app(
    appname = appname,
    key = key,
    secret = secret)

  trello.urls = oauth_endpoint(
    request = "OAuthGetRequestToken",
    authorize = paste0("OAuthAuthorizeToken", url.params),
    access = "OAuthGetAccessToken",
    base_url = "https://trello.com/1")

  oauth1.0_token(
    endpoint = trello.urls,
    app = trello.app)
}
