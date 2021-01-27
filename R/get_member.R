#' Get Own Boards
#'
#' Returns a flat data frame, containing the authenticated user's boards.
#'
#' @param ... Additional arguments passed to [get_resource()]
#' @seealso [get_resource()]
#'
#' @export

get_my_boards = function(...) {
  get_resource(parent = "member", child = "boards", id = "me",...)
}

#' Get Member's Boards
#'
#' Returns a flat data frame with member-related data.
#'
#' @param id member ID or username
#' @param ... Additional arguments passed to [get_resource()]
#' @seealso [get_resource()]
#'
#' @export
get_member_boards = function(id, ...) {
  get_resource(parent = "member", child = "boards", id = id, ...)
}

#' Get Member Info
#'
#' Returns a flat data frame with member-related data.
#'
#' @param id member ID or username
#' @param fields by default fetches fullName, username, memberType, bio
#' @param ... Additional arguments passed to [get_resource()]
#' @seealso [get_resource()]
#'
#' @export
get_member_fields = function(id,
                             fields = c("fullName", "username", "memberType",
                                        "bio"),
                             ...) {

  get_resource(parent = "member", child = NULL, id = id,
               query = list(fields = paste0(fields, collapse = ",")),
               ...)
}
