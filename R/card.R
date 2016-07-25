#' Get Card Comments
#'
#' Given a card ID, returns a flat \code{data.frame} with comments-related data.
#' @param id id of the desired card
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as is. Defaults to \code{TRUE}
#' @export
#' @examples
#' comments = get_card_comments(id, token)

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
    if (simplify) comments = simplify_comments(comments)

    # Return result
    return(comments)
}

#' Get Card Actions
#'
#' Given a card ID, returns a flat \code{data.frame} with actions-related data.
#' @param id id of the desired card
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select mutate matches everything
#' @export
#' @examples
#' actions = get_card_actions(id, token)

get_card_actions = function(id,
                            token,
                            paginate = FALSE,
                            simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/card/", id, "/actions")

    # Get data
    actions = get_trello(url = url, token = token,
                         paginate = paginate)

    # Tidy up a bit
    if (simplify) actions = simplify_actions(actions)

    # Return result
    return(actions)
}

#' Get Card Members
#'
#' Given a card ID, returns a flat \code{data.frame} with members-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(id, token)

get_card_members = function(id,
                            token,
                            paginate = FALSE,
                            simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/card/", id, "/members")

    # Get data
    members = get_trello(url = url, token = token,
                         paginate = paginate)

    # Tidy up a bit
    if (simplify) {
        members = members %>%
            select(
                member_id = id,
                member_name = fullName,
                member_uname = username)
    }
    return(members)
}
