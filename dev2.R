# Libs
library(httr)
library(jsonlite)
library(extr)
library(dplyr)
library(tidyr)

# Get token and data
source(file.choose())
token = get_token(key, secret)

# Get data from a board
url = "https://trello.com/b/QnY5i1l7/av-asistence.json"
brd = get_board(url, token)

# Get cards
cards = brd$cards

