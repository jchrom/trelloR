#' Get Data From Trello API
#'
#' Deprecated. Use \code{\link{get_model}} instead.
#' @param parent Parent structure (e.g. \code{"board"})
#' @param child Child structure (e.g. \code{"card"})
#' @param id Model ID
#' @param token Peviously generated secure token, see \code{\link{trello_get_token}} for how to obtain it
#' @param query key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @param url Url for the GET request, use instead of specifying see \code{parent}, see \code{id} and see \code{child}; see \code{\link[httr]{GET}} for details
#' @param filter Query value
#' @param limit Query value (defaults to 1000; if reached, paging is suggested)
#' @param paging Logical whether paging should be used
#' @param bind.rows By default, pages will be combined into one \code{data.frame} by \code{\link[dplyr]{bind_rows}}. Set to \code{FALSE} if you want \code{list} instead. This is useful on the rare occasion that the JSON response is not formatted correctly and makes \code{\link[dplyr]{bind_rows}} fail
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{trello_get_token}}, \code{\link{get_id}}
#' @importFrom dplyr bind_rows as_data_frame
#' @export

trello_get = function(parent = NULL,
                      child = NULL,
                      id = NULL,
                      token = NULL,
                      query = NULL,
                      url = NULL,
                      filter = NULL,
                      limit = 1000,
                      paging = FALSE,
                      bind.rows = TRUE
                      ) {

    .Deprecated("get_model")

    get_model(parent = parent, child =child, id = id, token = token,
              query = query, url = url, filter = filter, limit = limit,
              paging = paging, bind.rows = bind.rows)
}
