## ----setup, include = FALSE----------------------------------------------
library(httr)
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)

## ---- results='hide'-----------------------------------------------------
library(trelloR)
board_url = "https://trello.com/b/Pw3EioMM/trellor-r-api-for-trello"
param = list(fields = "id,name,idList,labels")
cards = get_board_cards(board_url, query = param, limit = 5)

## ------------------------------------------------------------------------
cards

## ------------------------------------------------------------------------
get_card_updates = function(id, ...) {
    get_model(parent = "card", child  = "actions", id = id, filter = "updateCard", ...)
}

## ---- results='hide'-----------------------------------------------------
card_id = cards$id[4]
card_updates = get_card_updates(card_id)

## ------------------------------------------------------------------------
card_updates

## ---- results='hide'-----------------------------------------------------
tryCatch(
    expr  = get_card_actions(id = "ThisIsGoingToFail"),
    error = function(e) message(e$message)
)

## ----eval=FALSE----------------------------------------------------------
#  search_members("Tony Stark", token = my_token)

## ------------------------------------------------------------------------
sessionInfo()

