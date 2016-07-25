#' Get Board Cards
#'
#' Given a board ID, returns a flat \code{data.frame} with card-related data.
#' board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param filter whether to return "all" (the default), archived ("closed") or "open" cards
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' cards = get_board_cards(id, token)

get_board_cards = function(id,
                           token,
                           filter = "all",
                           paginate = FALSE,
                           simplify = TRUE) {

    # Build url and query
    url   = paste0("https://api.trello.com/1/boards/", id, "/cards")
    query = list(filter = filter, limit = "1000")

    # Get data
    cards = get_trello(url = url, token = token, query = query,
                        paginate = paginate)

    # Tidy up a bit
    if (simplify) {
        # timestamp = strtoi(strtrim(cards$id, 8), 16L)
        # cards$card_created = as.POSIXct(timestamp, origin = "1970-01-01")
        cards$card_created = cards$id %>% strtrim(8) %>% as_POSIXct_hex()
        cards = cards %>%
            select(
                card_name = name,
                card_id = id,
                card_url = url,
                card_labels = labels,
                card_desc = desc,
                card_arch = closed,
                card_url_short = shortUrl,
                card_last_act = dateLastActivity,
                card_due = due,
                card_created,
                board_id = idBoard,
                list_id = idList,
                checklist_id = idChecklists,
                member_id = idMembers)
    }
    return(cards)
}

#' Get Board Actions
#'
#' Given a board ID, returns a flat \code{data.frame} with actions-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' actions = get_board_actions(id, token)

get_board_actions = function(id,
                             token,
                             paginate = FALSE,
                             simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/actions")

    # Get data
    actions = get_trello(url = url, token = token,
                         paginate = paginate)

    # Tidy up a bit
    if (simplify) actions = simplify_actions(actions)

    # Return result
    return(actions)
}

#' Get Board Lists
#'
#' Given a board ID, returns a flat \code{data.frame} with lists-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param filter whether to return "all" (the default), archived ("closed") or "open" cards
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' lists = get_board_lists(id, token)

get_board_lists = function(id,
                           token,
                           filter = "all",
                           paginate = FALSE,
                           simplify = TRUE) {

    # Build url & query
    url   = paste0("https://api.trello.com/1/board/", id, "/lists")
    query = list(filter = filter, limit = "1000")

    # Get data
    lists = get_trello(url = url, token = token, query = query,
                        paginate = paginate)

    # Tidy up a bit
    if (simplify) {
        lists = lists %>%
            select(
                list_id = id,
                list_name = name,
                list_arch = closed,
                board_id = idBoard)
    }
    return(lists)
}

#' Get Board Members
#'
#' Given a board ID, returns a flat \code{data.frame} with members-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(id, token)

get_board_members = function(id,
                             token,
                             paginate = FALSE,
                             simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/members")

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

#' Get Board Labels
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' labels = get_board_labels(id, token)

get_board_labels = function(id,
                            token,
                            paginate = FALSE,
                            simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/labels")

    # Get data
    labels = get_trello(url = url, token = token,
                         paginate = paginate)

    # Tidy up a bit
    if (simplify) {
        labels = labels %>%
            select(
                label_id = id,
                label_name = name,
                label_color = color)
    }
    return(labels)
}

#' Get Board Comments
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' comments = get_board_comments(id, token)

get_board_comments = function(id,
                              token,
                              paginate = FALSE,
                              simplify = TRUE) {

    # Build url & query
    url   = paste0("https://api.trello.com/1/board/", id, "/actions")
    query = list(limit = "1000", filter = "commentCard")

    # Get data
    comments = get_trello(url = url, token = token, query = query,
                           paginate = paginate)

    # Tidy up a bit
    if (simplify) {
        comments = comments %>%
            select(
                comment_id      = id,
                card_id         = data.card.id,
                card_name       = data.card.name,
                comment_created = date,
                comment_last_ed = data.dateLastEdited,
                comment_text    = data.text,
                member_name     = memberCreator.fullName)
    }
    return(comments)
}
