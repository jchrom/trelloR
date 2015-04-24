#' Export Trello board
#'
#' This function takes JSON object obtained by Trello's native export function and converts it into an R data frame.
#' @param path.json path to your JSON file
#' @param archived whether to export archived cards as well. Defaults to \code{FALSE}
#' @param comments whether to export comments as well. Defaults to \code{FALSE}
#' @export
#' @example
#'
#' # Download a Trello Board by pasting ".json" in the browser and save it as
#' # myboard.json in your working directory.
#'
#' board = getBoard("myboard.json")
#'
#' # To get archived cards and comments, do:
#'
#' board = getBoard("myboard.json", archvied = T, comments = T)
#'

getBoard = function(path.json, archived = F, comments = F) {

    require(RJSONIO)
    data.json = readLines(con = path.json)
    data.list = fromJSON(data.json)

    # EXPORT
    cards   = getCards(data.list)
    lists   = getLists(data.list)
    chlists = getChlists(data.list)
    members = getMembers(data.list)

    # ADD
    cards$list.id      = addLists(cards, lists)
    cards$member.id    = addMembers(cards, members)
    cards$checklist.id = addChlists(cards, chlists)

    # Change names
    names(cards)[c(1, 7, 10)] = c("list", "checklists", "members")

    # if comments == T, add comments as well
    if (comments) cards$comments = addComments(cards, data.list)

    # remove auxiliary column
    cards$card.id = NULL

    return(cards)

}

# HELPER FUNCTIONS --------------------------------------------------------

getCards = function(data.list, archived = F) {

    # Subset cards
    if (archived) cards = data.list$cards else {
        subset.cards = sapply(data.list$cards, function(x) { x$closed == F } )
        cards = data.list$cards[subset.cards]
    }

    x = sapply(cards, function(x) {

        # check whether everything optional is present; if not, set to ""
        if (is.null(x$due) == T) { x$due = "" }
        if (is.null(x$idMembers) == T) { x$idMembers = "" }

        # get label names:
        lab.names = sapply(x$labels, "[[", "name")
        lab.names = paste(lab.names, collapse = ", ")

        # get checklist IDs
        chlist = paste(x$idChecklists, collapse = "\n")

        # get attachments - names plus links
        att.names = sapply(x$attachments, "[[", "name")
        att.links = sapply(x$attachments, "[[", "url")
        att.links = paste("(", att.links, ")", sep = "")
        atts = paste(att.names, att.links, collapse = "\n")
        atts = sub(" \\(\\)", "", atts) # remove brackets from empty elements

        # get members
        membs = paste(x$idMembers, collapse = ", ")

        # combine everything together
        x = c(x$idList, x$idShort, x$name, x$closed, x$shortUrl, x$desc, chlist,
              atts, x$due, membs, lab.names, x$id)
    })

    cards = data.frame(t(x), stringsAsFactors = F)
    names(cards) = c("list.id", "card#", "name", "archived", "url", "description",
                     "checklist.id", "attachments", "duedate", "member.id", "labels",
                     "card.id")
    return(cards)
}

getChlists = function(data.list) {

    item.text = sapply(data.list$checklists, function(x) {

        y = sapply(x$checkItems, function(y) {

            y = c(y$state, y$name)
            y = paste(y, collapse = ": ")
            return(y)

        })

        y = paste(y, collapse = "\n")
        y = paste(x$name, y, sep = "\n")
        return(y)

    })

    checklist.id = sapply(data.list$checklists, "[[", "id")
    chlists = data.frame(checklist.id, item.text)

    return(chlists)

}

addChlists = function(cards, chlists) {

    checklists = sapply(cards$checklist.id, function(x) {

        # break down multiple IDs within one cell
        x = unlist(strsplit(as.character(x), "\n"))

        # merge with member list
        x = merge(chlists, x, by = 1)
        x = x$item.text

        # collapse back into one cell
        x = paste(x, collapse = "\n\n")
        return(x)
    })

    return(checklists)
}

getMembers = function(data.list) {

    x = sapply(data.list$members, function(x) { x = c(x$id, x$fullName) })
    members = data.frame(t(x))
    names(members) = c("id", "full.name")

    return(members)

}

addMembers = function(cards, members) {

    x = sapply(cards$member.id, function(x) {

        # break down multiple IDs within one cell
        x = as.character(x)
        x = unlist(strsplit(x, ", "))

        # merge with member list
        x = merge(members, x, by = 1)
        x = x$full.name

        # collapse back into one cell
        x = paste(x, collapse = ", ")

        return(x)

    })
}

getLists = function(data.list) {

    x = sapply(data.list$lists, function(x) { x = c(x$name, x$id) })
    lists = data.frame(t(x), stringsAsFactors = F)
    names(lists) = c("list.name", "list.id")

    return(lists)

}

addLists = function(cards, lists) {

    x = merge(cards, lists, by = "list.id", all.x = T)
    x = x$list.name

    return(x)
}

addComments = function(cards, data.list) {

    # subset actions
    subset = sapply(data.list$actions, function(x) {x$type == "commentCard"} )
    comments = data.list$actions[subset]

    # get id, date, member, text
    comments = sapply(comments, function(x) {

        id = x$data$card$id
        item = paste("[", x$date, " - ", x$memberCreator[["username"]], "] ",
                     x$data$text,
                     collapse = "")
        comment = c(id, item)
        return(comment)

    })

    comments = data.frame(t(comments))
    names(comments) = c("card.id", "item")

    y = by(comments, comments$card.id, function (x) {

        a = unique(as.character(x[,1]))
        b = paste(as.character(x[,2]), collapse = "\n")
        c = c(a, b)

        return(c)
    })

    x = sapply(y, function(x) { out = c(x[1], x[2]) })
    comments = data.frame(t(x), row.names = NULL)
    names(comments) = c("card.id", "comments")

    # Add COMMENTS to the CARDS table
    x = merge(cards, comments, by = "card.id", all.x = T)
    x = x$comments

    return(x)

}
