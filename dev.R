# Plan:

# 1. Function to connect to trello api using keys (and perhaps storing oauth token in the work dir)

# 2. Function to download content and parse data
#    - included by default: labels
#    - optional chocies (logical): archived, members, comments

library(httr)
library(jsonlite)
# library(dplyr)

# Authorization: get token
source("keys/keys.R")
token = get_token(key, secret)

# Get data from a board
url   = "https://trello.com/b/4rm75Nol/evidence-kurzu.json"
board = get_board(url, token)

# Get cards
cards = board$cards
