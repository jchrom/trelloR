## ----setup, include = FALSE----------------------------------------------
library(httr)
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)

## ---- results='hide'-----------------------------------------------------
library(trelloR)
url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
idb = get_id_board(url = url)
cards = get_board_cards(idb, limit = 5)

## ------------------------------------------------------------------------
cards

## ------------------------------------------------------------------------
cards[1:5, c("name", "closed", "shortUrl")]

## ------------------------------------------------------------------------
get_card_updates = function(id, ...) {
    get_model(parent = "card", child  = "actions", id = id, filter = "updateCard", ...)
}

## ---- results='hide'-----------------------------------------------------
idc = cards$id[1]
card_updates = get_card_updates(idc, limit = 5)

## ---- results='hide'-----------------------------------------------------
board_comments = get_model(parent = "board", child = "actions", id = idb,
                           filter = "commentCard", limit = 5)

## ---- results='hide'-----------------------------------------------------
tryCatch(
    expr  = get_card_actions(id = "I_have_a_bad_feeling_about_this"),
    error = function(e) message(e$message)
)

## ------------------------------------------------------------------------
sessionInfo()

