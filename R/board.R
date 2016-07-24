#' Get All Trello Board Cards
#'
#' Returns a flat \code{data.frame} with all cards from a given Trello board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param filter character whether to return only archived ("closed"), "open" or "all" (which is the default)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' cards = get_board_cards(url, token)

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

#' Get All Trello Board Actions
#'
#' Returns a flat \code{data.frame} with all actions from a given Trello board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(url, token)

get_board_actions = function(id,
                             token,
                             paginate = FALSE,
                             simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/actions")

    # Get data
    cards = get_trello(url = url, token = token, query = query,
                        paginate = paginate)

    # Tidy up a bit
    # if (simplify) {
    #     actions = actions %>%
    #         select()
    # }
    return(actions)
}

#' Get All Trello Board Lists
#'
#' Returns a flat \code{data.frame} with all lists from a given Trello board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param filter character whether to return only archived ("closed"), "open" or "all" (which is the default)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler or leave it as it is. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' cards = get_board_lists(url, token)

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

#' Get All Trello Board Memebers
#'
#' Returns a flat \code{data.frame} with all members from a given Trello board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' lists = get_board_members(url, token)

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

#' Get All Trello Board Labels
#'
#' Returns a flat \code{data.frame} with all labels from a given Trello board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(url, token)

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

#' Get All Trello Board Comments
#'
#' Returns a flat \code{data.frame} with all comments from a given Trello board.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify logical drop and rename some columns to make the result simpler. Defaults to \code{TRUE}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(url, token)

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
                comm_id = id,
                card_id = data.card.id,
                card_name = data.card.name,
                comm_added = date,
                comm_last_act = data.dateLastEdited,
                comm_body = data.text,
                comm_author = memberCreator.fullName)
    }
    return(comments)
}
