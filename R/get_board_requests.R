#' Get All Trello Board Cards
#'
#' Returns a flat \code{data.frame} with all cards from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @param filter character whether to return only archived ("closed"), "open" or "all" (which is the default)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to 'FALSE'
#' @param simplify logical drop and rename some columns to make the result simpler or leave it as it is. Defaults to 'TRUE'
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' cards = get_board_cards(url, token)

get_board_cards = function(boardid,
                           token,
                           filter = "all",
                           paginate = FALSE,
                           simplify = TRUE) {

    # Check input
    if (!is.character(boardid)) stop(("'boardid' must be of class 'character'"))
    if (!class(token)[1] == "Token1.0") stop(("Needs a valid token"))

    # Add filter
    if (!filter %in% c("all", "open", "closed")) stop("Invalid filter value (can only be 'all', 'open' or 'closed')")
    query = paste0("cards?filter=", filter)

    # Get data
    cards = get_request(endpoint = "board", id = boardid, query = query,
                        token = token, paginate = paginate)

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

# set_filter = function(query, filter) {
#
#     if (!grepl("filter", query) & (!grepl("\\?", query))) {
#         query = paste0(query, "?filter=", filter)
#     } else if (!grepl("filter", query)) {
#         query = paste0(query, "&filter=", filter)
#     }
#     return(query)
# }

#' Get All Trello Board Lists
#'
#' Returns a flat \code{data.frame} with all lists from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @param filter character whether to return only archived ("closed"), "open" or "all" (which is the default)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to 'FALSE'
#' @param simplify logical drop and rename some columns to make the result simpler
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' cards = get_board_lists(url, token)

get_board_lists = function(boardid,
                           token,
                           filter = "all",
                           paginate = FALSE,
                           simplify = TRUE) {

    # Check input
    if (!is.character(boardid)) stop(("'boardid' must be of class 'character'"))
    if (!class(token)[1] == "Token1.0") stop(("Needs a valid token"))

    # Add filter
    if (!filter %in% c("all", "open", "closed")) stop("Invalid filter value (can only be 'all', 'open' or 'closed')")
    query = paste0("cards?filter=", filter)

    # Get data
    lists = get_request(endpoint = "board", id = boardid, query = "lists",
                        token = token, paginate = paginate)

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
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to 'FALSE'
#' @param simplify logical drop and rename some columns to make the result simpler
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' lists = get_board_members(url, token)

get_board_members = function(boardid,
                             token,
                             paginate = FALSE,
                             simplify = TRUE) {

    # Get data
    members = get_request(endpoint = "board", id = boardid, query = "members",
                          token = token, paginate = paginate)

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
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to 'FALSE'
#' @param simplify logical drop and rename some columns to make the result simpler
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(url, token)

get_board_labels = function(boardid,
                            token,
                            paginate = FALSE,
                            simplify = TRUE) {

    # Get data
    labels = get_request(endpoint = "board", id = boardid, query = "labels",
                         token = token, paginate = paginate)

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
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @param paginate logical whether to use pagination (for requests returning more than 1000 rows). Defaults to 'False'
#' @param simplify logical drop and rename some columns to make the result simpler
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(url, token)

get_board_comments = function(boardid,
                              token,
                              paginate = FALSE,
                              simplify = TRUE) {

    # Get data
    comments = get_request(endpoint = "board", id = boardid,
                           query = "actions?filter=commentCard",
                           token = token, paginate = paginate)

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
