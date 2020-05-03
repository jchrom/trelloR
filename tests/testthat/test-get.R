# TEST GET REQEUSTS
# =================

board = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"

test_that("getting a resource produces a data frame with 1 row", {

  prefs = trelloR::get_board_prefs(board)

  expect_is(prefs, "data.frame")
  expect_equal(nrow(prefs), 1)

})

test_that("getting a nested resource produces a data frame", {

  cards = trelloR::get_board_cards(board, filter = "all")

  expect_is(cards, "data.frame")

})

test_that("getting a nested resource respects limit > 1000", {

  actions = trelloR::get_board_actions(board, limit  = 1005, filter = "all")

  expect_equal(nrow(actions), 1005)
  expect_equal(length(unique(actions$id)), nrow(actions))

})

# Auth required ----
# ==================

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

test_that("search produces a data frame with 1 row", {

  skip_if_no_token()

  token = utils::tail(readRDS(Sys.getenv("TOKEN_PATH")))[[1]]

  results = trelloR::search_model("User", partial = TRUE, token = token)

  expect_is(results, "data.frame")
  expect_equal(nrow(results), 1)

})
