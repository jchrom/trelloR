# Retrieve data related to a board

#' Get Board Cards
#'
#' Given a board ID, returns a flat \code{data.frame} with card-related data.
#' @param id board id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param filter whether to return "open" (the default), archived ("closed") or "all" cards
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_board_cards = function(id, token,
                           filter = "open",
                           paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "board", child = "cards")
    dat = fun(id,
              token = token,
              query = list(filter = filter),
              paging = paging, fix = fix)

    return(dat)
}

#' Get Board Actions
#'
#' Given a board ID, returns a flat \code{data.frame} with actions-related data.
#' @param id board id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param filter limit to just one type of action, e.g. "addMemberToCard"
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_board_actions = function(id, token,
                             filter = NULL,
                             paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "board", child = "actions")
    dat = fun(id,
              token = token,
              query = list(filter = filter),
              paging = paging, fix = fix)

    return(dat)
}

#' Get Board Lists
#'
#' Given a board ID, returns a flat \code{data.frame} with lists-related data.
#' @param id board id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_board_lists = function(id, token,
                           paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "board", child = "lists")
    dat = fun(id,
              token = token,
              query = NULL,
              paging = paging, fix = fix)

    return(dat)
}

#' Get Board Members
#'
#' Given a board ID, returns a flat \code{data.frame} with members-related data.
#' @param id board id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}

get_board_members = function(id, token,
                             paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "board", child = "members")
    dat = fun(id,
              token = token,
              query = NULL,
              paging = paging, fix = fix)

    return(dat)
}

#' Get Board Labels
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id board id
#' @param token previously generated token, see \code{\link{trello_get_token}} for info on how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_board_labels = function(id, token,
                            paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "board", child = "labels")
    dat = fun(id,
              token = token,
              query = NULL,
              paging = paging, fix = fix)

    return(dat)
}

#' Get Board Comments
#'
#' Given a board ID, returns a flat \code{data.frame} with labels-related data.
#' @param id board id
#' @param token previously generated token, see \code{\link{trello_get_token}} for info on how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_board_comments = function(id, token,
                              paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "board", child = "actions")
    dat = fun(id,
              token = token,
              query = list(filter = "commentCard"),
              paging = paging, fix = fix)

    return(dat)
}
