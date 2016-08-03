
# Get token
source(file.choose())
token = trello_get_token(key, secret, "kancl-elf")

# Tests ----

# 1. Get board ID
empty = "https://trello.com/b/DOFs1cap/empty-board"
av    = "https://trello.com/b/QnY5i1l7/av-asistence"
tdr   = "https://trello.com/b/nC8QJJoZ/trello-development-roadmap"

idav  = get_id_board(av, token)
idemp = get_id_board(empty, token)
idpub = get_id_board(tdr)

# 2. Get cards
cav  = get_board_cards(idav, token = token, limit = 5)
cemp = get_board_cards(idemp, token = token, limit = 5) # returns NULL
cpub = get_board_cards(idpub, limit = 5)

# 3. Get cards by long call
cav = trello_get(parent = "board", child = "cards", id = idav,
                 token = token, limit = 5)
