######################################################
#                                                    #
#    Retrieve data related to a team/organization    #
#                                                    #
######################################################

#' Get Team
#'
#' Returns a flat \code{data.frame} with team/organization-related data
#'
#' Previously, teams were called "organizations", and the correct parent/child name in API calls remains "organization", "organizations".
#'
#' @param id team ID, short name or URL
#' @param ... Additional arguments passed to \code{\link{trello_get}}
#' @seealso \code{\link{trello_get}}
#' @name get_team
NULL

#' @export
#' @rdname get_team
get_team_members = function(id, ...) {

    id = parse_url(id, pos = 4)
    dat = trello_get(parent = "organization", child = "members", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_team
get_team_boards = function(id, ...) {

    id = parse_url(id, pos = 4)
    dat = trello_get(parent = "organization", child = "boards", id = id, ...)
    return(dat)
}
