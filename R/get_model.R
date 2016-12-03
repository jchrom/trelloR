#' Get Data From Trello API
#'
#' Issues \code{\link[httr]{GET}} requests for Trello API endpoints.
#'
#' If the request fails, server error messages are reprinted on the console.
#'
#' Only JSON responses are accepted. \code{\link[jsonlite]{fromJSON}} converts them into flat \code{data.frame}s or \code{list}s, while non-JSON type of response throws an error.
#'
#' When \code{paging = TRUE}, the ID of the earliest result is retrieved from every page and supplied to the next request as the value of the \code{"before"} parameter. Paging will continue until the number of results per page is smaller then 1000, indicating no more pages to get.
#'
#' \code{filter} and \code{limit} are query parameters and can be set individually; you could achieve the same result by using \code{query = list(filter = "filter_value", limit = "limit_value")}
#' @param parent Parent structure (e.g. \code{"board"})
#' @param child Child structure (e.g. \code{"card"})
#' @param id Model ID
#' @param token Peviously generated secure token, see \code{\link{trello_get_token}} for how to obtain it
#' @param query Key-value pairs which form the query, see \code{\link[httr]{GET}} for details
#' @param url Url for the GET request, use instead of specifying \code{parent}, \code{id} and \code{child}; see \code{\link[httr]{GET}} for details
#' @param filter Filter results by this string
#' @param limit Defaults to 1000; if reached, paging is suggested
#' @param paging Whether paging should be used (defaults to \code{FALSE})
#' @param bind.rows By default, pages will be combined into one \code{data.frame} by \code{\link[dplyr]{bind_rows}}. Set to \code{FALSE} if you want \code{list} instead. This is useful on the rare occasion that the JSON response is not formatted correctly and makes \code{\link[dplyr]{bind_rows}} fail
#' @seealso \code{\link[httr]{GET}}, \code{\link[jsonlite]{fromJSON}}, \code{\link{trello_get_token}}, \code{\link{get_id}}
#' @importFrom dplyr bind_rows as_data_frame
#' @export
#' @examples
#' # No authorization is required to access public boards. Let's get
#' # the ID of Trello Development Roadmap board:
#' url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
#' bid = get_id_board(url)
#'
#' # Once we have the ID, we can use it to make specific queries:
#' labels = get_board_labels(bid)           # Get all labels
#' cards = get_board_cards(bid, limit = 5)  # Get 5 cards
#'
#' # We can also call get_model() directly:
#' lists = get_model(parent = "board", child = "lists", id = bid)
#'
#' # As with boards, cards can be queried for particular resources:
#' card1id = cards$id[1]
#' card1act = get_card_actions(card1id) # Get all comments
#'
#' # To retrieve large results, paging might be necessary:
#'
#' \dontrun{
#'
#' tdr_actions = get_board_actions(bid, paging = TRUE)
#' }
#'
#' # For private boards, you need a secure token:
#'
#' \dontrun{
#'
#' token = get_token("your_key", "your_secret")
#' all_open_cards = get_board_cards(board_id, token, filter = "open")
#' }

get_model = function(parent = NULL,
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

    if (!missing("paging")) {
        warning("paging is deprecated - set filter to 0 to fetch all",
                call. = FALSE)
        if (missing(limit) & paging) limit = 0
    }

    url   = build_url(url = url, parent = parent, child = child, id = id)
    query = build_query(query = query, filter = filter, limit = limit)

    message("Sending request...\n")

    result = get_pages(url = url, token = token, query = query)

    for (i in seq_along(result)) {
        result[[i]] = tryCatch(
            expr = add_class(result[[i]], child),
            error = function(e) {
                warning("Could not assign additional S3 class.", call. = FALSE)
                result[[i]]
            }
        )
    }

    if (bind.rows) {
        result = tryCatch(
            expr  = bind_rows(result),
            error = function(e) {
                message("Binding failed: ", e$message)
                message("Returning list (", length(result), " elements)")
                result
            }
        )
    }
    return(result)
}

build_url = function(url, parent, id, child) {
    if (is.null(url))  {
        url = paste("https://api.trello.com/1", parent, id, child, sep = "/")
        url = gsub("[/]+$", "", url) #remove trailing /
    }
    url
}

build_query = function(query = NULL, filter = NULL, limit = 1000) {
    if (is.null(query)) query = list()
    query$filter = filter
    query$limit  = limit
    return(query)
}

#' GET url and return data.frame
#'
#' GET url and return data.frame
#' @param url Url to get
#' @param token Secure token
#' @param query Additional url parameters (defaults to NULL)
#' @importFrom httr GET content config http_status headers http_type http_error user_agent status_code
#' @importFrom jsonlite fromJSON

get_flat = function(url, token = NULL, query = NULL) {

    # Issue request
    req  = GET(url = url,
               config(token = token),
               query = query,
               user_agent("https://github.com/jchrom/trelloR"))

    # Print out the complete url
    message("Request URL:\n", req$url, "\n")

    # Handle errors
    attempts = 1
    while (http_error(req)) {
        if (status_code(req) < 500) {
            stop(http_status(req)$message, " : ", req)
        } else if (status_code(req) >= 500 & attempts < 3) {
            message(http_status(req)$message,
                    "\n", 3 - attempts, " attempt(s) left")
            Sys.sleep(1.5)
            attempts = attempts + 1
            req  = GET(url = url,
                       config(token = token),
                       query = query,
                       user_agent("https://github.com/jchrom/trelloR"))
        } else {
            stop(http_status(req)$message,
                 "; stopping after ", attempts, " attempts")
        }
    }

    # Handle response (only JSON is accepted)
    if (http_type(req) == "application/json") {
        json = content(req, as = "text")
        flat = fromJSON(json, flatten = TRUE)
        flat = tryCatch(
            expr = as_data_frame(flat),
            error = function(e) {
                flat
            }
        )
    } else {
        req_trim = paste0(strtrim(content(req, as = "text"), 50), "...")
        stop(http_type(req), " is not JSON : \n", req_trim)
    }

    # If the result is an empty list, convert into NULL
    if (length(flat) == 0) {
        flat = NULL
        message("Response was empty")
    }

    # Return the result
    return(flat)
}
