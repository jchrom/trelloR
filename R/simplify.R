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
            comment_id      = id,
            comment_created,
            member_name     = memberCreator.fullName,
            member_init     = memberCreator.initials,
            card_id         = data.card.id,
            card_name       = data.card.name,
            comment_created = date,
            comment_last_ed = data.dateLastEdited,
            comment_text    = data.text)

    # Return result
    return(comments)
}

simplify_members = function(members) {

    # Rename/select columns
    members = members %>%
        select(
            member_id = id,
            member_name = fullName,
            member_uname = username)

    # Return result
    return(members)

}

simplify_lists = function(lists) {

    # Rename/select columns
    lists = lists %>%
        select(
            list_id = id,
            list_name = name,
            list_arch = closed,
            board_id = idBoard)

    # Return result
    return(lists)
}

simplify_cards = function(cards) {

    # Format date
    cards = cards %>%
        mutate(
            card_created  = as_POSIXct_hex(strtrim(id, 8)))

    # Rename/select columns
    cards = cards %>%
        select(
            card_name = name,
            card_id = id,
            card_url = url,
            card_labels = labels,
            card_desc = desc,
            card_arch = closed,
            card_url_short = shortUrl,
            card_last_act = dateLastActivity,
            card_due = due,
            card_created,
            # label_color = ,
            # label_name = ,
            board_id = idBoard,
            list_id = idList,
            checklist_id = idChecklists,
            member_id = idMembers)

    # Return result
    return(cards)

}
