#' Get OAuth1.0 Token
#'
#' Authorize access to Trello API, required for private boards and write access
#' (see details).
#'
#' @section Getting developer access:
#'
#' To access private data, a secure token is required. In order to create it,
#' you will need your developer `key` and `secret` which you can get by visiting
#' `https://trello.com/app-key` after logging in to Trello. You may also
#' want to set at least one _allowed origin_ there. If you are using trelloR
#' locally (ie. from your laptop or PC), `http://localhost:1410` is a good value
#' to use.
#'
#' @section Creating tokens:
#'
#' Once back in R, run this function the following way:
#'
#'   `my_token = get_token("my_app", key = key, secret = secret)`
#'
#' passing the values you have obtained on the developer page. First time you
#' create a token, you will be prompted to confirm the authorization
#' in a browser. If you chose to store the token locally as prompted, you won't
#' have to do this anymore until your token expires (see `expiration`) or your
#' local cache file is deleted.
#'
#' Tokens are stored inside a hidden `.httr-oauth` cache file and automatically
#' read when any function in the package is called. Optionally, you can specify
#' a different cache path using the `cache` argument, or avoid caching the token
#' completely with `cache = FALSE`. See [httr::oauth1.0_token()] for details.
#'
#' If you opt out of storing the token, then it will only be held until your
#' R session is over, and you will have to pass it to the `token` argument, eg.
#' `get_my_boards(token = my_token)` each time you are fetching data.
#'
#' Remember to store your credentials in a **secure, non-shared** location. To
#' minimize the risk of unwanted disclosure when using remote code
#' repositories, `.httr-oauth` (or whatever cache path you have specified
#' using the `cache` argument) is automatically added to `.gitignore`.
#'
#' @param app A string, `NULL` or a Token.
#'
#'   * If `key` and `secret` are set, a new token will be initialized and its
#'     name set to this value. A meaningful name can help you to spot your token
#'     on the settings page `https://trello.com/username/account`. A token cannot
#'     be initialized without a name, so it will default to `"trello-app"` if it
#'     needs to.
#'   * If `key` and `secret` are not set, the value of `app` will be used
#'     as a path from which an existing token is read. If `NULL`, the token will
#'     be read from the working directory. `NULL` is returned if nothing is found.
#'   * If a Token, return as is.
#'
#' @param key,secret Developer credentials from `https://trello.com/app-key`
#'   (see details). If `NULL` and a cache file exists, the newest token is read
#'   from it, otherwise an error is thrown.
#' @param scope Can be one or several of `"read"`, `"write"` or `"account"`.
#'   Defaults to `"read"`.
#' @param expiration Can be `"1hour"`, `"1day"`, `"30days"` or `"never"`.
#'   Defaults to `"30days"`.
#' @param cache Passed to [httr::oauth1.0_token()]. Can specify whether
#'   the token should be cached locally (will ask the first time and then `TRUE`
#'   by default) or choose an alternative path for the cache file.
#' @param appname Deprecated, use `app`.
#'
#' @seealso [httr::oauth_app()], [httr::oauth_endpoint()],
#'   [httr::oauth1.0_token()]
#'
#' @return An object of class `"Trello_API_token"` (a Token).
#'
#' @export
#'
#' @examples
#' # This example assumes you are reading your key and secret from environment
#' # variables. This is not obligatory, but wherever you read them from, make
#' # sure it is a secure, non-shared location.
#'
#' \dontrun{
#'
#' key = Sys.getenv("MY_TRELLO_KEY")
#' secret = Sys.getenv("MY_TRELLO_SECRET")
#'
#' token = get_token("my_app", key = key, secret = secret,
#'                   scope = c("read", "write"))
#' }

get_token = function(app = NULL, key = NULL, secret = NULL,
                     scope = c("read", "write", "account"),
                     expiration = c("30days", "1day", "1hour", "never"),
                     cache = getOption("httr_oauth_cache"),
                     appname) {

  warn_for_argument(appname)

  if (!missing(appname) && is.null(app)) app = appname

  if (inherits(app, "Trello_API_token")) return(app)

  scope = match.arg(scope, several.ok = TRUE)

  expiration = match.arg(expiration, several.ok = FALSE)

  if (sum(is.null(key), is.null(secret)) == 1L) {
    stop("provide both `key` and `secret` or none of the two", call. = FALSE)
  }

  if (any(is.null(key), is.null(secret))) {

    if (is.null(app)) {
      if (file.exists(".httr-oauth")) return(read_cached_token())
      return()
    }

    stopifnot("`app` must be a string or NULL" = is.character(app))

    return(read_cached_token(app))

  }

  if (is.null(app)) app = "trello-app"

  params = paste0(
    "?scope=", paste(scope, collapse = ","),
    "&expiration=", expiration,
    "&name=", app)

  trello_app = httr::oauth_app(
    appname = app,
    key     = key,
    secret  = secret)

  trello_urls = httr::oauth_endpoint(
    request   = "OAuthGetRequestToken",
    authorize = paste0("OAuthAuthorizeToken", params),
    access    = "OAuthGetAccessToken",
    base_url  = "https://trello.com/1")

  token = httr::oauth1.0_token(endpoint = trello_urls,
                               app = trello_app,
                               cache = cache)

  set_trello_attr(token, cache = cache, expiration = expiration,
                  scope = scope)

}

# Set Token Attributes
#
# Set attributes for Trello tokens. Assigns a class that enables better printing
# as well as creation/expiration date.
#
# @param token Token, as generated/read by `httr::oauth1.0_token()`
# @param expiration,scope Taken from the current `get_token()` call.
#
# @return An object of class "Trello_API_token".

set_trello_attr = function(token, cache, expiration, scope) {

  token = structure(
    token,
    class   = c(setdiff("Trello_API_token", class(token)), class(token)),
    issued  = Sys.time(),
    expiration = expiration,
    scope = scope)

  if (is.character(cache)) {
    path = cache
  } else {
    path = ".httr-oauth"
  }

  if (file.exists(path)) {

    cached = readRDS(path)

    old = cached[[token$hash()]]

    # Base case: Token is not cached at all.
    if (is.null(old)) {
      return(token)
    }

    # Case #1: Token in cache has the right attributes already.
    if (inherits(old, "Trello_API_token")) {
      return(old)
    }

    # Case #2: Token has just been created, and the right attributes need to be
    # stored in cache.
    cached[[token$hash()]] = token

    saveRDS(cached, file = path)

  }

  token
}

read_cached_token = function(path = ".httr-oauth") {

  if (!length(path)) return()

  if (!file.exists(path)) {
    stop("file '", path, "' not found.", call. = FALSE)
  }

  tokens = tryCatch(readRDS(path), error = function(e) {
    stop(path, " is not a valid cache file", call. = FALSE)
  })

  token = utils::tail(tokens, 1)[[1]]

  if (!inherits(token, "Trello_API_token")) {
    stop(path, " is not a valid cache file", call. = FALSE)
  }

  token

}
