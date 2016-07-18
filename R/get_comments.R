#' Get All Comments From Trello Board
#'
#' Complete record can only be obtained by API (due to the limit of 1000 actions), so you will need to use get_token to get it.
#' @param id id of...
#' @param token previously generated token (see ?get_token for help)
#' @importFrom httr GET config content
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' cardid = "..."
#' get_comments(cardid, token)

get_comments = function(id, token) {

    # Get url
    url_pref = "https://trello.com/1/cards/"
    url_suff = "/actions?filter=commentCard"
    url_call  = paste(url_pref, id, url_suff, sep = "")

    # Send request
    req = GET(url_call, config(token = token))
    res = content(req, as = "text")

    # Parse and format response (if any)
    if (res == "[]") {
        # If there are no comments
        d = "No comment."
    } else {
        # If there are comments or error messages
        d = tryCatch(
            expr = {
                d = fromJSON(res)
                d = data.frame(
                    id   = d$data$card$id,
                    name = d$data$card$name,
                    date = d$date,
                    auth = d$memberCreator$fullName,
                    text = d$data$text,
                    stringsAsFactors = F)
            },
            error = function(e) {
                return(res)
            })
    }
    return(d)
}
