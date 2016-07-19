#' Get All Trello Member Boards
#'
#' Returns a flat \code{data.frame} with all your boards.
#' @param token previously generated token (see ?get_token for help)
#' @export
#' @examples
#' myboards = get_my_boards(token)

get_my_boards = function(token) {

    # Get data
    boards = get_request("member", "me", "boards", token)

    # Tidy up a bit
    boards = boards %>%
        select(
            board_name = name,
            board_id = id,
            desc,
            org_id = idOrganization,
            board_url = url,
            board_arch = closed,
            board_perm = prefs.permissionLevel,
            board_members = memberships)

    return(boards)
}
