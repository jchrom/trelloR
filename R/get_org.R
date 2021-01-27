#' Get Team
#'
#' Returns a flat data frame with team/organization-related data
#'
#' Previously, teams were called "organizations", and the correct parent/child name in API calls remains "organization", "organizations".
#'
#' @param id team ID, short name or URL
#' @param ... Additional arguments passed to [get_resource()]
#' @seealso [get_resource()]
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
