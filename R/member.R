#' Get All Trello Member Boards
#'
#' Returns a flat \code{data.frame} with all your boards.
#' @param token previously generated token, see \code{\link{get_token}} for info on how to obtain it
#' @importFrom dplyr %>%
#' @export
#' @examples
#' myboards = get_my_boards(token)

get_my_boards = function(token) {

    # Get data
    url    = paste0("https://api.trello.com/1/member/me/boards")
    boards = get_trello(url, token)

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
