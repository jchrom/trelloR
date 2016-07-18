#' Get All Trello Card Comments
#'
#' Returns a flat \code{data.frame} with all comments from a given Trello card.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' comments = get_card_comments(cardid, token)

get_card_comments = function(cardid, token) {

    # Get data
    comments = get_request("card", cardid, "actions?filter=commentCard", token)

    # Tidy up a bit
    comments$date = as.POSIXct(strptime(comments$date, "%Y-%m-%dT%H:%M:%OS"))
    comments = comments %>%
        select(
            comment = data.text,
            comment_date = date,
            card_id = data.card.id,
            member_name = memberCreator.fullName)

    return(comments)
}
