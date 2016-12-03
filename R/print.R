library(dplyr)
library(tidyr)

trim_equal = function(x, n = 20) {
    ifelse(nchar(x) > n + 3,
           paste0(gsub(" $", "", strtrim(x, n)), "..."),
           x)
}

print.members_df = function(x) {
    x = x %>%
        mutate(name2 = regmatches(fullName, gregexpr("([^ ]+)$", fullName)),
               name1 = substr(fullName, 1, nchar(fullName) - nchar(name2)),
               name1 = sub(" $", "", name1),
               name = paste0(name2, ", ", name1)) %>%
        select(name, username, id) %>%
        arrange(name) %>%
        as.data.frame()
    print(x, right = FALSE, row.names = FALSE)
}

print.lists_df = function(x) {
    cat("Board id:", unique(x[["idBoard"]]), "\n\n")
    x = x %>%
        select(list = name, position = pos, closed) %>%
        arrange(closed) %>%
        mutate(list = trim_equal(list),
               position = 1:n(),
               position = ifelse(closed, 0, position)) %>%
        as.data.frame()
    print(x, right = FALSE, row.names = FALSE)
}

print.boards_df = function(x, perms = c("org", "public", "private")) {
    cat("Team id:", paste(unique(x[["idOrganization"]]), collapse = ", "),
        "\n\n")
    x = x %>%
        select(board = name, closed,
               permissions = prefs.permissionLevel,
               url = shortUrl) %>%
        filter(permissions %in% perms) %>%
        mutate(board = trim_equal(board)) %>%
        arrange(closed, board) %>%
        as.data.frame()
    print(x, right = FALSE, row.names = FALSE)
}
