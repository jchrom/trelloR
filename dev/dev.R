# Libs
library(dplyr)
library(tidyr)
library(trelloR)

# Get token
source(file.choose())
t = trello_get_token(.key, .secret, "trelloR-dev")

# Tests ----

# 1. Get board ID
# empty = "https://trello.com/b/DOFs1cap/empty-board"
# av    = "https://trello.com/b/QnY5i1l7/av-asistence"
# tdr   = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
emi   = "https://trello.com/b/9bSB10VT/emaily"

# idav  = get_id_board(av, t)
# idemp = get_id_board(empty, t)
# idpub = get_id_board(tdr)
idpri = get_id_board(emi, t)

# 2. Get cards
# cav  = get_board_cards(idav, t, limit = 5)
# cemp = get_board_cards(idemp, t, limit = 5) # returns NULL
# cpub = get_board_cards(idpub, limit = 5)
cemi = get_board_cards(idpri, token = t, filter = "all", limit = 200)
comi = get_board_comments(idpri, token = t, limit = 200)
chmi = get_board_checklists(idpri, token = t, filter = "all", limit = 200)
aemi = get_board_actions(idpri, token = t, filter = "all", limit = 200)
lemi = get_board_labels(idpri, token = t, filter = "all", limit = 200)

# 3. Get cards by long call
cav = trello_get(parent = "board", child = "cards", id = idav,
                 token = t, limit = 5)

# 4. Get checklists
chl = get_board_checklists(idpri, t)
chl = get_card_checklists(cemi$id[5], t)

fix_checklist = function(checklist) {
    chl = checklist %>%
        select(checklist_name = name,
               checklist_id = id,
               card_id = idCard,
               item = checkItems) %>%
        unnest(.sep = "_") %>%
        select(-c(item_idChecklist, item_nameData))
    return(chl)
}

chl_fixed = fix_checklist(chl)

# Delay fun ----
library(trelloR)
library(httr)
url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
idb = get_id_board(url)


delay_by = function(delay, f) {
    function(...) {
        Sys.sleep(delay)
        f(...)
    }
}

r = GET(url = "https://api.trello.com/1/card/123/labels?limit=1000")
try_times = 1

a = 4
while (a <= 3) { print(a); a = a + 1}

# Search
url = "https://api.trello.com/1/search?query=idOrganizations:56d73a36ec5c714fc5ee7eb9 label:green"
url = "https://api.trello.com/1/search/members?query=chromeC"
url = "https://api.trello.com/1/search?query=trelloR"
x = httr::GET(url = url, httr::config(token = t)); httr::http_status(x)
jsonlite::fromJSON(httr::content(x, as = "text"))

string = "trelloR"

