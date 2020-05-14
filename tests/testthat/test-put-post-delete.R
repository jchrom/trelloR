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
    utils::tail(readRDS(Sys.getenv("TOKEN_PATH")))[[1]]
  }
}

if (!identical(Sys.getenv("TOKEN_PATH"), "")) {

  token = skip_if_no_token()

  board = trelloR::add_board(
    name  = paste0("trelloR testing: ", Sys.Date()),
    body  = list(defaultLists = TRUE,
                 desc = "Test trelloR with testthat"),
    token = token
  )

}

test_that("new board can be created", {

  token = skip_if_no_token()

  expect_is(board, "list")
  expect_equal(board$desc, "Test trelloR with testthat")

})

test_that("board description can be updated", {

  token = skip_if_no_token()

  updated = trelloR::update_resource(
    "board",
    id    = board$id,
    body  = list(desc = "Updated description"),
    token = token
  )

  expect_is(updated, "list")
  expect_equal(updated$desc, "Updated description")

})

test_that("board can be deleted", {

  token = skip_if_no_token()

  deleted = trelloR::delete_resource("board", board$id, token = token)

  expect_is(deleted, "list")
  expect_null(deleted[["_value"]])

})
