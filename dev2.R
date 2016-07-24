# To do ----
# 1. [DONE] Pagination
# 2. [DONE] simplify = FALSE option for all functions (=response as flat data.frame without tidying)
# 3. [DONE] Proper error handling for get_flat (use the request headers etc. to get the code and its meaning)
#    [DONE] Build query using the key-value pairs as described in https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html
# 4. []     Add get_card_ functions (and tests)
# 5. []     Update intro
# 6. []     Make a list of things necessary to submit to CRAN

# Libs ----
# library(httr)
# library(jsonlite)
library(trello)
# library(dplyr)
# library(tidyr)

# Get token and data ----
source(file.choose())
token = get_token(key, secret, app = "trello")

# get_my_boards ----
my_b = get_my_boards(token)
id_b = my_b$board_id[1]

# get_board_ ----
crd      = get_board_cards(id_b, token, filter = "open")
act_1000 = get_board_actions(id_b, token)
act_all  = get_board_actions(id_b, token, paginate = TRUE)
lists    = get_board_lists(id_b, token)
members  = get_board_members(id_b, token)
labels   = get_board_labels(id_b, token)
comments = get_board_comments(id_b, token)

# get_card_ ----
crd_comments = get_card_comments(crd$card_id[18], token)




