# Visualization of the AV board
library(trellor)
library(tidyr)

# Get token and data ----
source(file.choose())
token = get_token(key, secret, app = "trello-ct")

# get_my_boards
mb = get_my_boards(token)
id = mb$board_id[1]

# Get cards and members
cards_raw = get_board_cards(id, token)
membs_raw = get_board_members(id, token)

# Add member names ----
cards_mem = cards_raw %>%
    dplyr::select(
        card_id,
        member_id) %>%
    unnest(
        member_id) %>%
    dplyr::left_join(
        membs_raw, by = "member_id") %>%
    dplyr::select(
        card_id, member_name)

# Unnest labels ----
cards_lab = cards_raw %>%
    dplyr::select(
        card_name,
        card_id,
        card_labels,
        card_url) %>%
    unnest(
        card_labels)

# Join unnested members ----
cards = cards_lab %>%
    dplyr::left_join(
        cards_mem, by = "card_id") %>%
    dplyr::select(
        -c(id, idBoard, uses, color),
        label_name = name,
        card_id, card_name, member_name)

# Subset labels & members ----
clean = cards %>%
    dplyr::filter(member_name %in% c("Risto Ilič", "Jakub Tesařík",
                                     "Martin Koláček", "Filip Sikora",
                                     "Daniela Masiariková", "Helena Brunnerova",
                                     "Marek Litoš", "Jonáš Bezděčka",
                                     "Marek Andrýsek"))
zprac = clean %>%
    dplyr::filter(
        label_name %in% c("Zpracováno bez problémů", "Zpracováno s problémy"))

probehlo = clean %>%
    dplyr::filter(
        label_name %in% c("Proběhlo bez problémů", "Proběhlo s problémy"))

nezprac = clean %>%
    dplyr::filter(label_name %in% "Nezpracováno")


# Make plot ----
library(ggplot2)

ggplot() +
    geom_bar(aes(x = label_name, fill = label_name), probehlo,
             position = "dodge") +
    facet_wrap(~ member_name)
