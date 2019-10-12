#' Get Url With Paging
#'
#' Deprecated. Use \code{\link{paginate}}
#' @param url Url to get
#' @param token Peviously generated secure token, see \code{\link{get_token}} for how to obtain it
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @seealso \code{\link{get_model}}
#' @importFrom httr modify_url
#' @export

get_pages = function(url, token, query = NULL) {

  .Deprecated("paginate")

  paginate(
    url = modify_url(
      url = url,
      query = query),
    token = token
    )
}
