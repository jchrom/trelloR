#' Get All Trello Card Comments
#'
#' Returns a flat \code{data.frame} with all comments from a given Trello card.
#' @param id id of the desired card
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler or leave it as it is. Defaults to \code{TRUE}
#' @export
#' @examples
#' comments = get_card_comments(cardid, token)

get_card_comments = function(id,
                             token,
                             paginate = FALSE,
                             simplify = TRUE) {

    # Build url and query
    url   = paste0("https://api.trello.com/1/cards/", id, "/actions")
    query = list(limit = "1000", filter = "commentCard")

    # Get data
    comments = get_trello(url = url, token = token, query = query,
                           paginate = paginate)

    # Tidy up a bit
    if (simplify) {
        comments$date = as.POSIXct(strptime(comments$date, "%Y-%m-%dT%H:%M:%OS"))
        comments = comments %>%
            select(
                comment = data.text,
                comment_date = date,
                card_id = data.card.id,
                member_name = memberCreator.fullName)
    }
    return(comments)
}
