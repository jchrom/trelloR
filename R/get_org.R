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
#' @param ... Additional arguments passed to \code{\link{get_model}}
#' @seealso \code{\link{get_model}}
#' @name get_team
NULL

#' @export
#' @rdname get_team
get_team_members = function(id, ...) {

    id = extract_shortname(id, pos = 4)
    dat = get_model(parent = "organization", child = "members", id = id, ...)
    return(dat)
}

#' @export
#' @rdname get_team
get_team_boards = function(id, ...) {

    id = extract_shortname(id, pos = 4)
    dat = get_model(parent = "organization", child = "boards", id = id, ...)
    return(dat)
}
