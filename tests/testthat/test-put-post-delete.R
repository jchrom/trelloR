# TEST POST/PUT/DELETE REQUESTS
# =============================

# This requires a path to a token stored in an environment variable. To do this,
# authorize the app and let httr store it locally. Then add this to ~/.profile:
#
#   export TOKEN_PATH=~/path/to/.httr-oauth
#
# The value will become available on the next login, use `Sys.getenv` to check.

skip_if_no_token <- function() {
  if (identical(Sys.getenv("TOKEN_PATH"), "")) {
    skip("No authentication available")
  }
}

if (!identical(Sys.getenv("TOKEN_PATH"), "")) {

  token = utils::tail(readRDS(Sys.getenv("TOKEN_PATH")))[[1]]

  board = trelloR::add_board(
    name  = paste0("trelloR testing: ", Sys.Date()),
    body  = list(defaultLists = TRUE,
                 desc = "Test trelloR with testthat"),
    token = token
  )

}

test_that("new board can be created", {

  skip_if_no_token()

  expect_is(board, "list")
  expect_equal(board$desc, "Test trelloR with testthat")

})

test_that("board description can be updated", {

  skip_if_no_token()

  updated = trelloR::put_model(
    "board",
    id    = board$id,
    body  = list(desc = "Updated description"),
    token = token
  )

  expect_is(updated, "list")
  expect_equal(updated$desc, "Updated description")

})

test_that("card can be created and deleted", {

  skip_if_no_token()

  lists = trelloR::get_board_lists(board$id, token = token)

  created = trelloR::add_card(
    list  = lists$id[1],
    body  = list(name = "A New Card!",
                 desc = "New description"),
    token = token
  )

  expect_is(created, "list")
  expect_equal(created$name, "A New Card!")

  deleted = trelloR::delete_card(created$id, token = token)

  expect_is(deleted, "list")

  cards  = trelloR::get_board_cards(board$id, token = token)

  expect_is(cards, "data.frame")
  expect_equal(nrow(cards), 0)

})
