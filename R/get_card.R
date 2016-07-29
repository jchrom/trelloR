# Retrieve data related to a card

#' Get Card Actions
#'
#' Given a card ID, returns a flat \code{data.frame} with actions-related data.
#' @param id card id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param filter limit to just one type of action, e.g. "addMemberToCard"
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_card_actions = function(id, token = NULL,
                            filter = NULL,
                            paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "card", child = "actions")
    dat = fun(id,
              token = token,
              query = list(filter = filter),
              paging = paging, fix = fix)

    return(dat)
}

#' Get Card Comments
#'
#' Given a card ID, returns a flat \code{data.frame} with comments-related data.
#' @param id card id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @export

get_card_comments = function(id, token = NULL,
                             paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "card", child = "actions")
    dat = fun(id,
              token = token,
              query = list(filter = "commentCard"),
              paging = paging, fix = fix)

    return(dat)
}

#' Get Card Members
#'
#' Given a card ID, returns a flat \code{data.frame} with members-related data.
#' @param id card id
#' @param token previously generated token, see \code{\link{trello_get_token}} for how to obtain it
#' @param paging whether paging should be used (necessary for requests returning more than 1000 rows). Defaults to \code{FALSE}
#' @param fix drop and rename some columns or leave it as it is. Defaults to \code{TRUE}
#' @seealso \code{\link{trello_get_token}}, \code{\link{trello_get}}
#' @importFrom dplyr %>% select
#' @export

get_card_members = function(id, token = NULL,
                            paging = FALSE, fix = TRUE) {

    fun = trello_req(parent = "card", child = "members")
    dat = fun(id,
              token = token,
              query = NULL,
              paging = paging, fix = fix)

    return(dat)
}
