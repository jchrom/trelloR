#' Get Board Cards
#'
#' Given a board ID, returns a flat \code{data.frame} with card-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param filter whether to return "all" (the default), archived ("closed") or "open" cards
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as is. Defaults to \code{TRUE}
#' @seealso \code{\link{get_token}}, \code{\link{get_trello}}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' cards = get_board_cards(id, token)

get_board_cards = function(id,
                           token,
                           filter = "all",
                           paging = FALSE,
                           simplify = TRUE) {

    # Build url and query
    url   = paste0("https://api.trello.com/1/boards/", id, "/cards")
    query = list(filter = filter, limit = "1000")

    # Get data
    cards = get_trello(url = url, token = token, query = query,
                        paging = paging)

    # Tidy up a bit
    if (simplify) cards = simplify_cards(cards)

    # Return result
    return(cards)
}

#' Get Board Actions
#'
#' Given a board ID, returns a flat \code{data.frame} with actions-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{get_token}}, \code{\link{get_trello}}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' actions = get_board_actions(id, token)

get_board_actions = function(id,
                             token,
                             paging = FALSE,
                             simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/actions")

    # Get data
    actions = get_trello(url = url, token = token,
                         paging = paging)

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
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{get_token}}, \code{\link{get_trello}}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' lists = get_board_lists(id, token)

get_board_lists = function(id,
                           token,
                           filter = "all",
                           paging = FALSE,
                           simplify = TRUE) {

    # Build url & query
    url   = paste0("https://api.trello.com/1/board/", id, "/lists")
    query = list(filter = filter, limit = "1000")

    # Get data
    lists = get_trello(url = url, token = token, query = query,
                        paging = paging)

    # Tidy up a bit
    if (simplify) lists = simplify_lists(lists)

    # Return result
    return(lists)
}

#' Get Board Members
#'
#' Given a board ID, returns a flat \code{data.frame} with members-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{get_token}}, \code{\link{get_trello}}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' members = get_board_members(id, token)

get_board_members = function(id,
                             token,
                             paging = FALSE,
                             simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/members")

    # Get data
    members = get_trello(url = url, token = token,
                          paging = paging)

    # Tidy up a bit
    if (simplify) members = simplify_members(members)

    # Return result
    return(members)
}

#' Get Board Labels
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id id of the desired board
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{get_token}}, \code{\link{get_trello}}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' labels = get_board_labels(id, token)

get_board_labels = function(id,
                            token,
                            paging = FALSE,
                            simplify = TRUE) {

    # Build url & query
    url = paste0("https://api.trello.com/1/board/", id, "/labels")

    # Get data
    labels = get_trello(url = url, token = token,
                         paging = paging)

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
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param simplify drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{get_token}}, \code{\link{get_trello}}
#' @importFrom dplyr %>% select
#' @export
#' @examples
#' comments = get_board_comments(id, token)

get_board_comments = function(id,
                              token,
                              paging = FALSE,
                              simplify = TRUE) {

    # Build url & query
    url   = paste0("https://api.trello.com/1/board/", id, "/actions")
    query = list(limit = "1000", filter = "commentCard")

    # Get data
    comments = get_trello(url = url, token = token, query = query,
                           paging = paging)

    # Tidy up a bit
    if (simplify) comments = simplify_comments(comments)

    # Return result
    return(comments)
}
