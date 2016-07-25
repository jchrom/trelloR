.onAttach <- function(libname, pkgname) {
    packageStartupMessage(
        "R API for Trello\n",
        "Not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (www.trello.com)\n",
        "Visit https://github.com/jchrom/trello for introduction\n")
}

as_POSIXct_hex = function(x) {

    # Check input
    if (!is.character(x)) stop("Input must be of class 'character'")
    if (!all(nchar(x) == 8)) stop("Input must be a string of 8 characters")

    # Convert into POSIXct
    timestamp = strtoi(x, 16L)
    posix_ct  = as.POSIXct(timestamp, origin = "1970-01-01")
    return(posix_ct)
}

simplify_actions = function(actions) {

    # Check for optional columns and rename
    actions = actions %>%
        mutate(
            comment_text    = if (exists('data.text', where = actions)) {
                data.text } else { NA },
            item_update     = if (exists('data.checkItem.state', where = actions)) {
                data.checkItem.state } else { NA },
            item_name       = if (exists('data.checkItem.name', where = actions)) {
                data.checkItem.name } else { NA },
            checklist_name  = if (exists('data.checklist.name', where = actions)) {
                data.checklist.name } else { NA },
            attachment_name = if (exists('data.attachment.name', where = actions)) {
                data.attachment.name } else { NA },
            attachment_url  = if (exists('data.attachment.url', where = actions)) {
                data.attachment.url } else { NA })

    # Format date
    actions = actions %>%
        mutate(
            action_created  = as_POSIXct_hex(strtrim(id, 8)))

    # Rename/select
    actions = actions %>%
        select(
            action_type = type, action_created,
            member_id   = idMemberCreator,
            board_id    = data.board.id,
            card_id     = data.card.id,
            list_id        = data.list.id,
            list_before_id = data.listBefore.id,
            list_after_id  = data.listAfter.id,
            comment_text,
            attachment_name, attachment_url,
            item_update, item_name, checklist_name)

    # Drop columns with only NAs
    actions = Filter(function(x) any(!is.na(x)), actions)

    # Return the result
    return(actions)
}

simplify_comments = function(comments) {

    # Format date and rename/select columns
    comments = comments %>%
        mutate(
            comment_created = as_POSIXct_hex(strtrim(id, 8))) %>%
        select(
            comment = data.text,
            comment_created,
            card_id = data.card.id,
            member_name = memberCreator.fullName,
            member_init = memberCreator.initials)

    # Return result
    return(comments)
}
