# Plan:

# [ok] Function to connect to trello api using keys

# Organization functions
# [  ] Get list of:
#    - all boards
#    - all teams
#    - all members

# Board functions
# [  ] Function to download content and parse data
#    - included by default: labels
#    - optional choices (logical): archived, members
#    - additional API CALL: comments

# [  ] More functions
#    - organization-centered overview: teams, boards, members
#    - member-centered overview: teams, boards, cards
#    - comments per card
#    - board-centered overview: members, cards

# [  ] stats
#    - cards per member, members per card, list with most/least cards
#    - count: cards per list, labels
#    - flow: how many cards in what list at every time (actions...?)

# ...
#    - determine when card changed lists: http://stackoverflow.com/a/9812454/2416535

library(httr)
library(jsonlite)
library(extr)
library(dplyr)
library(purrr)

# Authorization: get token
source("keys/keys_elf.R")
source("keys/keys.R")
token = get_token(key, secret)

# Get data from a board
url   = "https://trello.com/b/4rm75Nol/evidence-kurzu.json"
board = get_board(url, token)

# Get cards
cards = board$cards

# Munge
paste_labels = function(x, column) {
    x = as.data.frame.list(x)
    if (nrow(x) > 0) {
        x = paste(x[, column], collapse = ", ")
    } else {x = ""}
}

cards2 = cards %>%
    group_by(
        id) %>%
    mutate(
        lab_colors = paste_labels(labels, "color"),
        lab_names  = paste_labels(labels, "name"))


# List member's boards/organizations/cards
id   = "kancelar_elearningu"
what = "cards"
data = get_members(id, what, token)
View(data)

api  = "https://api.trello.com/1/actions/"
id   = ""
call = paste0(api, "/", id, "/", what, "?key=", key)



