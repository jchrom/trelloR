# Libs
library(dplyr)
library(tidyr)
library(trelloR)

# Get token
source(file.choose())
t = trello_get_token(.key, .secret, "trelloR-dev")

# Tests ----

# 1. Get board ID ----
# ----

# empty = "https://trello.com/b/DOFs1cap/empty-board"
# av    = "https://trello.com/b/QnY5i1l7/av-asistence"
# tdr   = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
emi   = "https://trello.com/b/9bSB10VT/emaily"

# idav  = get_id_board(av, t)
# idemp = get_id_board(empty, t)
# idpub = get_id_board(tdr)
idpri = get_id_board(emi, t)

# 2. Get cards ----
# ----

# cav  = get_board_cards(idav, t, limit = 5)
# cemp = get_board_cards(idemp, t, limit = 5) # returns NULL
# cpub = get_board_cards(idpub, limit = 5)
cemi = get_board_cards(idpri, token = t, filter = "all", limit = 1005)
comi = get_board_comments(idpri, token = t, limit = 200)
chmi = get_board_checklists(idpri, token = t, filter = "all", limit = 200)
aemi = get_board_actions(idpri, token = t, filter = "all", limit = 200)
lemi = get_board_labels(idpri, token = t, filter = "all", limit = 200)

# 3. Trello dev. rodmap ----
# --------------------------

tdr_u = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
tdr_id = get_id_board(tdr_u)
tdr_ls = get_board_lists(tdr_id)
info = tdr_ls$id[tdr_ls$name == "Info"]
lst_id = "53f4c48a94f780435b611ce9"

get_list

# 4. unit tests ----
# ------------------

# url = "https://api.trello.com/1/board/54212b5181d0b59cfbff6de0/cards"
# d = get_pages(url, token = t, query = list(limit = -5, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 5, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 1000, filter = "all"))
# d = get_pages(url, token = t, query = list(limit = 1750, filter = "all"))
