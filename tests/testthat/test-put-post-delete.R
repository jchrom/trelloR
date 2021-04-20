# TEST POST/PUT/DELETE REQUESTS
# =============================

# This requires a path to a token stored in an environment variable. To do this,
# authorize the app and let httr store it locally. Then add this to ~/.profile:
#
#   export TOKEN_PATH=~/path/to/.httr-oauth
#
# The value will become available on the next login, use `Sys.getenv` to check.

# Avoid running when auth is not available.
skip_if_no_token <- function() {
  if (identical(Sys.getenv("TOKEN_PATH"), "")) {
    skip("No authentication available")
  } else {
    tokens <- readRDS(Sys.getenv("TOKEN_PATH"))
    tokens[[length(tokens)]]
  }
}

token <- skip_if_no_token()

# In the below, some of the tests rely on the results from the other tests,
# which could be considered bad practice. A setup-teardown approach would be most
# appropriate, with resources created beforehand. This would allow for tests
# like "attach file to a card" to be performed independently from card creation
# tests. On the other hand, it is better to have suboptimal tests rather than
# no tests at all.

testthat::test_that("create, update, upload file, delete", {

  skip_if_no_token()

  board <- trelloR::add_board(
    name = paste0("trelloR testing: ", Sys.Date()),
    body = list(defaultLists = TRUE, desc = "Test trelloR with testthat"),
    token = token
  )

  testthat::expect_is(board, "list")
  testthat::expect_equal(board$desc, "Test trelloR with testthat")

  updated <- trelloR::update_resource(
    "board",
    id    = board$id,
    body  = list(desc = "Updated description"),
    token = token
  )

  testthat::expect_is(updated, "list")
  testthat::expect_equal(updated$desc, "Updated description")

  list_ <-  trelloR::add_list(
    board$id,
    name = "Testing",
    pos = 1L,
    token = token
  )

  testthat::expect_is(list_, "list")
  testthat::expect_equal(list_$name, "Testing")

  card <-  trelloR::add_card(
    list_$id,
    body = list(
      name = "Testing",
      desc = "A testing card."
    ),
    token = token
  )

  testthat::expect_is(card, "list")
  testthat::expect_equal(card$desc, "A testing card.")

  attachment <- trelloR::create_resource(
    resource = "card",
    path = "attachments",
    id = card$id,
    body = list(
      name = "A dog in yellow tuque",
      file = httr::upload_file("attachment.jpg"),
      setCover = TRUE
    ),
    token = token
  )

  cover <- get_resource("card", id = card$id, token = token)

  testthat::expect_is(attachment, "list")
  testthat::expect_equal(cover$idAttachmentCover, attachment$id)

  deleted <- trelloR::delete_resource("board", board$id, token = token)

  testthat::expect_is(deleted, "list")
  testthat::expect_null(deleted[["_value"]])

})
