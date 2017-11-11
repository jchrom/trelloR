#' Get A Secure Token
#'
#' Deprecated. Use \code{\link{get_token}} instead.
#'
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

  .Deprecated("get_token")
  get_token(key = key, secret = secret, appname = appname)

}
