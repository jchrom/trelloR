# Libs
library(dplyr)
library(tidyr)

# Get token
source(file.choose())
t = trello_get_token(key, secret, "kancl-elf")

# Tests ----

# 1. Get board ID
empty = "https://trello.com/b/DOFs1cap/empty-board"
av    = "https://trello.com/b/QnY5i1l7/av-asistence"
tdr   = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"

idav  = get_id_board(av, t)
idemp = get_id_board(empty, t)
idpub = get_id_board(tdr)

# 2. Get cards
cav  = get_board_cards(idav, t, limit = 5)
cemp = get_board_cards(idemp, t, limit = 5) # returns NULL
cpub = get_board_cards(idpub, limit = 5)

# 3. Get cards by long call
cav = trello_get(parent = "board", child = "cards", id = idav,
                 token = t, limit = 5)

# 4. Get checklists
chl = get_board_checklists(idav, t)
chl = get_card_checklists(cav$id[5], t)

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



