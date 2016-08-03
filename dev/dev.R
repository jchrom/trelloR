
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

# 4. Get ALL cards and comments from AV asistence ----
avcar = get_board_cards(idav, token = token, filter = "all")
avcom = get_board_comments(idav, token = token)
avmem = get_board_members(idav, token = token) %>%
    select(member_id = id, member_name = fullName)

# Extract label color and value ----
library(dplyr)
library(tidyr)

cards = avcar %>%
    as_data_frame() %>%
    unnest(labels, .sep = ".", .drop = F) %>%
    filter(!is.na(labels.color)) %>%
    select(
        card_id = id,
        member_id = idMembers,
        card_name = name,
        label_name = labels.name) %>%
    unnest(member_id, .sep = ".")

stats = cards %>%
    mutate(
        label_gen = ifelse(grepl("[Zz]prac", label_name),
                           "Zprac.", "Prubeh"),
        label_dir = ifelse(grepl("Ne", label_name),
                           -1, 1)) %>%
    group_by(label_dir, label_name, member_id) %>%
    summarise(
        label_gen = unique(label_gen),
        n = n())

exclude = c("Petra Hanušková", "Veronika Neničková", "Anna Czaschova", "Petr Sudicky", "Irina Matusevich")

membs = stats %>%
    left_join(avmem, by = "member_id") %>%
    filter(!member_name %in% exclude) %>%
    ungroup() %>%
    mutate(member_name = gsub(" ", "\n", member_name))

# Extract and format comments
comm1 = avcom %>%
    select(
        member_id = idMemberCreator,
        comm_text = data.text,
        comm_date = date,
        card_id   = data.card.id) %>%
    left_join(avmem, by = "member_id") %>%
    group_by(
        card_id) %>%
    arrange(comm_date)

comm2 = comm1 %>%
    summarise(
        comm_text = paste0(comm_text, collapse = "\n>> "))

# Vis ----
# library(ggplot2)
bars = ggplot() +
    geom_bar(
        mapping = aes(x = label_gen, y = n, fill = label_name),
        data = filter(membs, label_dir == 1),
        stat = "identity",
        width = 1,
        color = "white") +
    geom_bar(
        mapping = aes(x = label_gen, y = -n, fill = label_name),
        data = filter(membs, label_dir == -1),
        stat = "identity",
        width = 1,
        color = "white") +
    facet_wrap(~ member_name, nrow = 1) +
    scale_y_continuous(limits = c(-5, 25), breaks = seq(-5, 25, 5)) +
    labs(
        fill = "Status",
        y = "Pocet karet")

fill = bars + scale_fill_brewer(type = "qual", palette = 3)

final =
    fill +
    theme_minimal() +
    theme(
        legend.position = "bottom",
        axis.title.x = element_blank())
final

ggsave(filename = "dev/plot.png", dpi = 300, width = 12, height = 4)

