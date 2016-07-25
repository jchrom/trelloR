# To do ----
# [DONE] Pagination
# [DONE] simplify = FALSE option for all functions (=response as flat data.frame without tidying)
# [DONE] Proper error handling for get_flat (use the request headers etc. to get the code and its meaning)
# [DONE] Build query using the key-value pairs as described in https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html
# [DONE] Add handling of empty results (= 0 rows)
# [DONE] Add actions if they exist (such as "data.attachment.url")
# [DONE] get_board_ and get_cards do the same simplification, come up with a solution
# [20% ] ALL the equivalent functions now share the same simplifying function
# [80% ]     Add get_card_ functions
# []     Add tests
# []     Update intro
# []     Make a list of things necessary to submit to CRAN

# Libs ----
# library(httr)
# library(jsonlite)
library(trello)
# library(dplyr)
# library(tidyr)

# Get token and data ----
source(file.choose())
token = get_token(key, secret, app = "trello-kancl")

# get_my_boards ----
mb = get_my_boards(token)
id = mb$board_id[1]

# get_board_ ----
crds     = get_board_cards(id, token, filter = "open")
act_1000 = get_board_actions(id, token)
act_all  = get_board_actions(id, token, paginate = TRUE)
lists    = get_board_lists(id, token)
members  = get_board_members(id, token)
labels   = get_board_labels(id, token)
comments = get_board_comments(id, token)

# get_card_ ----
crd_comments = get_card_comments(crd$card_id[18], token)




