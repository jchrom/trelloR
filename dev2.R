# To do ----
# 1. [DONE] Pagination
# 2. []     'Raw' option for all functions (=response as flat data.frame without tidying)

# Libs ----
library(httr)
library(jsonlite)
library(extr)
library(dplyr)
library(tidyr)

# Get token and data ----
source(file.choose())
token = get_token(key, secret)

# Get data from a board
url = "https://trello.com/b/QnY5i1l7/av-asistence.json"
brd = get_board(url, token)

# Get boards
my_b = get_my_boards(token)
id_b = my_b$board_id[1]

# Get cards
crd = get_board_cards(id_b, token)







