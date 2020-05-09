#' Get OAuth1.0 Token
#'
#' Authorize access to Trello API.
#'
#' @section Developer credentials:
#'
#' To access private data, a secure token is required. In order to create it,
#' get your developer credentials, 'key' and 'secret'. These can be obtained
#' visiting `https://trello.com/app-key` after logging in to Trello. You may
#' want to set at least one _allowed origin_ there. If you are using trelloR
#' locally (ie. from your laptop or PC), `http://localhost:1410` is a good value
#' to use.
#'
#' @section Create token:
#'
#' Once back in R, see examples below for how to run this function. First time
#' you create a token, you will be prompted to confirm the authorization
#' in a browser (you only need to do this once). You will also be offered
#' an option to store the authentication data in your working directory. Keep
#' in mind you have to store your credentials in a **secure, non-shared**
#' location.
#'
#' @param key Developer key.
#' @param secret Developer secret.
#' @param appname App name. Choose something meaningful (it does not have to be
#'   very short) that will distinguish tokens for different projects. Default
#'   is `"trello-app"`.
#' @param scope Can be `"read"`, `"write"`, `"account"` or `"read,write,account"`
#'   if you prefer. Defaults to `"read"`.
#' @param expiration Can be `"1hour"`, `"1day"`, `"30days"` or `"never"`.
#'   Defaults to `"30days"`.
#' @param force.new Should cached tokens be deleted and new token created?
#'   Defaults to `FALSE`, ie. last cached token will be reused if it exists.
#'
#' @seealso [httr::oauth_app], [httr::oauth_endpoint], [httr::oauth1.0_token]
#'
#' @export
#'
#' @examples
#' # Source credentials from non-shared location (important!)
#'
#' \dontrun{
#'
#' source("mykeys.R")
#' token = get_token(key, secret, scope = "read,write")
#' }

get_token = function(key = NULL, secret = NULL, appname = "trello-app",
                     scope      = c("read", "write", "account"),
                     expiration = c("30days", "1day", "1hour", "never"),
                     force.new  = FALSE) {

  if (file.exists(".httr-oauth") && !force.new) {
    return(read_last_token())
  }

  if (is.null(key)) {
    stop("Key cannot be NULL if there are no tokens cached", call. = FALSE)
  }

  if (is.null(secret)) {
    stop("Secret cannot be NULL if there are no tokens cached", call. = FALSE)
  }

  if (file.exists(".httr-oauth") && force.new) {
    file.remove(".httr-oauth")
  }

  scope = match.arg(scope, several.ok = TRUE)
  expiration = match.arg(expiration, several.ok = TRUE)

  url.params = paste0(
    "?scope=", paste(scope, collapse = ","),
    "&expiration=", expiration,
    "&name=", appname
    )

  trello.app = httr::oauth_app(
    appname = appname,
    key     = key,
    secret  = secret)

  trello.urls = httr::oauth_endpoint(
    request   = "OAuthGetRequestToken",
    authorize = paste0("OAuthAuthorizeToken", url.params),
    access    = "OAuthGetAccessToken",
    base_url  = "https://trello.com/1")

  trello.token = httr::oauth1.0_token(
    endpoint = trello.urls,
    app = trello.app)

  structure(trello.token, class = c("trello_api_token", class(trello.token)))
}

#' Trello API Tokens
#'
#' @param x An object of class `"trello_api_token"`.
#' @param ... Unused.
#'
#' @export

print.trello_api_token = function(x, ...) {

  ep = httr::parse_url(x$endpoint$authorize)$query

  app_name    = ep$name
  app_expires = ep$expiration
  app_scope   = ep$scope

  cat("<trello_api_token>\n")
  cat("  App name:    ", app_name, "\n")
  cat("  Permissions: ", app_scope, "\n")
  cat("  Expires:      see https://trello.com/username/account")

}
