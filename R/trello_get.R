#' Get Data From Trello API
#'
#' Deprecated. Use \code{\link{get_model}} instead.
#' @param parent,child,id,token,query,url,filter,limit,paging,bind.rows
#'   Use \code{\link{get_model}}.
#' @export

trello_get = function(parent = NULL, child = NULL, id = NULL, token = NULL,
                      query = NULL, url = NULL, filter = NULL, limit = 1000,
                      paging = FALSE, bind.rows = TRUE) {

    .Deprecated("get_model")
    get_model(
      parent = parent, child =child, id = id, token = token,
      query = query, url = url, filter = filter, limit = limit,
      paging = paging, bind.rows = bind.rows)
}
