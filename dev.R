# Plan:

# 1. Function to connect to trello api using keys (and perhaps storing oauth token in the work dir)

# 2. Function to download content and parse data
#    - included by default: labels
#    - optional chocies (logical): archived, members, comments

library(httr)
library(jsonlite)

source("keys/keys.R")
token = get_token(key, secret)

url  = "https://trello.com/b/4rm75Nol/evidence-kurzu.json"
req  = GET(url, config(token = token))
json = content(req, as = "text")
board = fromJSON(json)

