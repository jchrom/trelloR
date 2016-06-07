# Plan:

# 1. Function to connect to trello api using keys (and perhaps storing oauth token in the work dir)

# 2. Function to download content and parse data
#    - included by default: labels
#    - optional chocies (logical): archived, members, comments

# 3. More functions
#    - organization-centered overview: teams, boards, members
#    - member-centered overview: teams, boards, cards
#    - comments per card
#    - board-centered overview: members, cards

# 4. stats
#    - cards per member, members per card, list with most/least cards
#    - count: cards per list, labels
#    - flow: how many cards in what list at every time (actions...?)

library(httr)
library(jsonlite)
# library(dplyr)

# Authorization: get token
source("keys/keys_elf.R")
source("keys/keys.R")
token = get_token(key, secret)

# Get data from a board
url   = "https://trello.com/b/4rm75Nol/evidence-kurzu.json"
board = get_board(url, token)

# Get cards
cards = board$cards

# List member's boards/organizations/cards
id   = "kancelar_elearningu"
what = "cards"
data = get_members(id, what, token)
View(data)





