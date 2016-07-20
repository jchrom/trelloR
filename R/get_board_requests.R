#' Get All Trello Board Cards
#'
#' Returns a flat \code{data.frame} with all cards from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' cards = get_board_cards(url, token)

get_board_cards = function(boardid, token) {

    # Get data
    cards = get_request("board", boardid, "cards", token)

    # Tidy up a bit
    timestamp = strtoi(strtrim(cards$id, 8), 16L)
    cards$card_created = as.POSIXct(timestamp, origin = "1970-01-01")
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

    return(cards)
}

#' Get All Trello Board Lists
#'
#' Returns a flat \code{data.frame} with all lists from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' cards = get_board_lists(url, token)

get_board_lists = function(boardid, token) {

    # Get data
    lists = get_request("board", boardid, "lists", token)

    # Tidy up a bit
    lists = lists %>%
        select(
            list_id = id,
            list_name = name,
            list_arch = closed,
            board_id = idBoard)

    return(lists)
}

#' Get All Trello Board Memebers
#'
#' Returns a flat \code{data.frame} with all members from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' lists = get_board_members(url, token)

get_board_members = function(boardid, token) {

    # Get data
    members = get_request("board", boardid, "members", token)

    # Tidy up a bit
    members = members %>%
        select(
            member_id = id,
            member_name = fullName,
            member_uname = username)

    return(members)
}

#' Get All Trello Board Labels
#'
#' Returns a flat \code{data.frame} with all labels from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' members = get_board_members(url, token)

get_board_labels = function(boardid, token) {

    # Get data
    labels = get_request("board", boardid, "labels", token)

    # Tidy up a bit
    labels = labels %>%
        select(
            label_id = id,
            label_name = name,
            label_color = color)

    return(labels)
}

#' Get All Trello Board Comments
#'
#' Returns a flat \code{data.frame} with all comments from a given Trello board.
#' @param boardid id of the desired board
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' members = get_board_members(url, token)

get_board_comments = function(boardid, token) {

    # Get data
    comments = get_request("board", boardid, "actions?filter=commentCard", token)

    # Tidy up a bit


    return(comments)
}
