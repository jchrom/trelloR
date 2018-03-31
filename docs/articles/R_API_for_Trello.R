## ----setup, include = FALSE----------------------------------------------
library(httr)
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)

## ---- results='hide'-----------------------------------------------------
library(trelloR)
roadmap_url = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"
cards = get_board_cards(roadmap_url, limit = 5)

## ------------------------------------------------------------------------
cards

## ------------------------------------------------------------------------
get_card_updates = function(id, ...) {
    get_model(parent = "card", child  = "actions", id = id, filter = "updateCard", ...)
}

## ---- results='hide'-----------------------------------------------------
card_id = cards$id[1]
card_updates = get_card_updates(card_id, limit = 5)

## ------------------------------------------------------------------------
card_updates

## ---- results='hide'-----------------------------------------------------
comments = get_model(parent = "board", child = "actions", id = roadmap_url,
                     filter = "commentCard", limit = 5)

## ----eval=FALSE----------------------------------------------------------
#  search_members("Tony Stark", token = my_token)

## ---- results='hide'-----------------------------------------------------
tryCatch(
    expr  = get_card_actions(id = "I_have_a_bad_feeling_about_this"),
    error = function(e) message(e$message)
)

## ------------------------------------------------------------------------
sessionInfo()

