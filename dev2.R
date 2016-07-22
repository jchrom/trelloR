# To do ----
# 1. [DONE] Pagination
# 2. [DONE] simplify = FALSE option for all functions (=response as flat data.frame without tidying)
# 3. []     Proper error handling for get_flat (use the request headers etc. to get the code and its meaning)
#    []     Build query using the key-value pairs as described in https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html

# Libs ----
library(httr)
library(jsonlite)
library(extr)
library(dplyr)
library(tidyr)

# Get token and data ----
source(file.choose())
token = get_token(key, secret, app = "trello_elf")

# Get data from a board
# url = "https://trello.com/b/QnY5i1l7/av-asistence.json"
# brd = get_board(url, token)

# Get boards
my_b = get_my_boards(token)
id_b = my_b$board_id[14]

# Get cards
crd = get_board_cards(id_b, token)







