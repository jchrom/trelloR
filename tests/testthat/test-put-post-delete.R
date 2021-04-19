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
  } else {
    tokens <- readRDS(Sys.getenv("TOKEN_PATH"))
    tokens[[length(tokens)]]
  }
}

testthat::test_that("new board can be created", {

  token <<- skip_if_no_token()

  board <<- trelloR::add_board(
    name = paste0("trelloR testing: ", Sys.Date()),
    body = list(defaultLists = TRUE, desc = "Test trelloR with testthat"),
    token = token
  )

  testthat::expect_is(board, "list")
  testthat::expect_equal(board$desc, "Test trelloR with testthat")

})

testthat::test_that("board description can be updated", {

  skip_if_no_token()

  updated <- trelloR::update_resource(
    "board",
    id    = board$id,
    body  = list(desc = "Updated description"),
    token = token
  )

  testthat::expect_is(updated, "list")
  testthat::expect_equal(updated$desc, "Updated description")

})

testthat::test_that("card can be created", {

  skip_if_no_token()

  list_testing <-  trelloR::add_list(board$id, name = "Testing", pos = 1L,
                                     token = token)

  card_testing <<- trelloR::add_card(
    list_testing$id,
    body = list(
      name = "Testing",
      desc = "A testing card."
    ),
    token = token
  )

  testthat::expect_is(card_testing, "list")
  testthat::expect_equal(card_testing$desc, "A testing card.")

})

testthat::test_that("file can be attached to a card", {

  skip_if_no_token()

  attachment <- trelloR::create_resource(
    resource = "card",
    path = "attachments",
    id = card_testing$id,
    body = list(
      name = "A dog in yellow tuque",
      file = httr::upload_file("attachment.jpg"),
      setCover = TRUE
    ),
    token = token
  )

  testthat::expect_is(card_testing, "list")
  testthat::expect_equal(card_testing$desc, "A testing card.")

})

testthat::test_that("board can be deleted", {

  skip_if_no_token()

  deleted <- trelloR::delete_resource("board", board$id, token = token)

  testthat::expect_is(deleted, "list")
  testthat::expect_null(deleted[["_value"]])

})
