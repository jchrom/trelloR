#' Get Url With Paging
#'
#' Issue a GET request for Trello API with automated paging.
#'
#' Setting \code{limit = 0} or \code{limit > 1000} will activate paging. In the
#' former case, all available results will be fetched. Filter values bellow 0
#' are not allowed.
#'
#' @param url Url to get
#' @param token Peviously generated secure token, see \code{\link{trello_get_token}} for how to obtain it
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @seealso \code{\link{get_model}}
#' @export

get_pages = function(url, token, query = NULL) {

    if (!is.null(query[["limit"]])) limit = query[["limit"]] else limit = 1000
    print(limit)

    # If 0 is supplied for the limit, the value is always set to 1000,
    # effectively paginating until everything is downloaded.
    #
    # For other values of limit, a vector of limits is caculated, e.g.
    # limit = 2500 yields limit values c(1000, 1000, 500).
    #
    # Since paging stops when < 1000 results are returned, limit
    # values < 1000 will stop it in either case (which is what we want).

    if (limit < 0) {
        stop("'limit' cannot be negative", call. = FALSE)
    } else if (limit == 0) {
        # message("'limit' set to 0: paging will be used")
        limits = NULL
    } else if (limit > 0 & limit %% 1000 == 0) {
        limits = rep(1000, limit/1000)
    } else {
        limits = c(rep(1000, trunc(limit/1000)), limit %% 1000)
    }

    result = list()
    page = 0

    repeat {

        if (is.null(limits)) {
            query[["limit"]] = 1000
            last_page = FALSE
        } else {
            page = page + 1
            query[["limit"]] = limits[page]
            last_page = length(limits) == page
        }

        batch = tryCatch(
            expr = get_flat(url = url, token = token, query = query),
            error = function(e) {
                message("Failed batch: ", e$message)
                data.frame()
            }
        )

        result = append(result, list(batch))

        if (!is.data.frame(batch)) {
            message("Cannot determine number of results - stopping...")
            break
        } else if (nrow(batch) < 1000 | last_page) {
            total = ((length(result) - 1) * 1000) + nrow(batch)
            message("Received ", nrow(batch), " results")
            message("Request complete: ", total," results")
            break
        } else {
            query$before = batch$id[1000]
            message("Received 1000 results, keep paging...\n")
        }
    }
    return(result)
}

# url = "https://api.trello.com/1/board/54212b5181d0b59cfbff6de0/cards"
# d = get_pages(url, token = t, query = list(limit = -5, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 5, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 1000, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 1750, filter = "all"))
# d = get_pages(url, token = t, query = list(filter = "all"), paging = T)

