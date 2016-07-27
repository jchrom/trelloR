# R API for Trello

The purpose of `trellor` is to provide easy access to the [Trello API](https://developers.trello.com/) from R. It can retrieve data from various levels of JSON hierarchy (e.g. cards that belong to a particular board, members assigned to a particular card etc.) and return a *flattened* `data.frame` which is easy to work with.

Requests are carried out by a family of simple functions with meaningful names, such as `get_my_boards()` or `get_card_comments()`. For large requests, there is an automated paging parameter which makes sure all the results will be acquired.

It also provides an intuitive way of authorizing your API access using [Trello developer keys](https://trello.com/app-key).

**Note.** `trellor` is a convenience wrapper for Hadley Wickham's [httr](https://cran.r-project.org/web/packages/httr/index.html) and Jeroen Ooms' [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html). If you like writing a lot of code, you could do everything it does by using these two packages; `trellor` will get you the same results with less code that is easier to read.

**Disclaimer:** `trellor` is not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (<http://www.trello.com>).

# Installation

You can install the development version from Github:

```{r, eval=FALSE, include=TRUE}
devtools::install_github("jchrom/trellor")
```

# Using R API for Trello

The first step is to open a new R project and authorize your API access. After that you can start calling Trello API to get the data you need.

## Step 1: Authorize your API access

Before you can start using the Trello API, you need to authorize an "app". An app uses a secure "token" to communicate with the Trello API. This will allow you to retrieve private data only you have the access to.

To create a token, visit <https://trello.com/app-key> and get your developer key and secret. Then, use the `get_token()` function to create a token for your project. This will also trigger first-time authorization (you only have to do it once):

```{r, eval=FALSE, include=TRUE}
library(trellor)
my_token = get_token(your_key, your_secret)
```

You will be prompted to confirm authorization in a browser. You will also be offered an option to store the authentication data in your working directory, in a hidden `'.httr-oauth'` file. This is useful, but **do NOT share this file with anyone!**

You should also make sure you keep your key and secret in a **safe, non-shared** location. Use `source()` if you wish to make it available from another directory.

## Step 2: Getting data out of Trello

### Get IDs of your boards

Once you have authorized your API access, you can start using the functions designed to retrieve data. A good starting point is the `get_my_boards()` function, which returns a `data.frame` with board names and IDs related to the user who authorized the app. Your previously created token is its only argument:

```{r, eval=FALSE, include=TRUE}
my_boards = get_my_boards(my_token)
```

IDs are important. If you want to retrieve a specific data point, you will need its ID or the ID of its parent structure.

### Available functions

#### The `get_board_` functions

You can obtain cards, labels, members, lists and other data related to a board ID using the family of `get_board_` functions. Each of these functions returns a `data.frame` with IDs and other related data. The following code retrieves all the cards from a particular board:

```{r, eval=FALSE, include=TRUE}
board_id = my_boards$id[1]
my_cards = get_board_cards(board_id, my_token)
```

#### The `get_card_` functions

Once you have ID of a specific card, you can use another family of functions, the `get_card_` functions. They do the same things as the `get_board_` functions but for cards. The following code returns all the comments related to a particular card:

```{r, eval=FALSE, include=TRUE}
card_id = my_cards$id[1]
my_comments = get_card_comments(card_id, my_token)
```

#### Function naming scheme

Every function name refers to the parent structure (the thing after the first underscore, such as `_board_`) and the child structure (such as `_actions`). This makes it easy to guess function names. If you need, say, list of members assigned to a card, simply call `get_card_members()`.

# Things to be aware of

There are several issues you should familiarize yourself with. They include handling large requests, formatting the response and building custom queries.

## Handling large requests a.k.a. "paging"

Trello limits the results of your requests to 1000 (which corresponds to 1000 rows in the resulting `data.frame`). This may not be sufficient when requesting larger amounts of data, e.g. all the actions related to a board ID.

To get more than 1000 results, you need to break down your request into several separate requests, each retrieving no more than 1000 results. This is called "paging", and `trellor` will do that for you automatically. In fact, it issues a warning everytime you reach 1000 results and suggests to use paging in that case.

Paging is activated by the `paging` argument which is a part of every function in the `trellor` package. Set `paging = TRUE`, and the resulting `data.frame` will contain combined results from all the separate requests.

```{r, eval=FALSE, include=TRUE}
my_actions = get_board_actions(card_id, my_token, paging = TRUE)
```

## The format of results

The data is always returned in form of a "flattened" `data.frame`, so you don't have to worry about formatting the JSON response. The job is done by the `jsonlite::fromJSON` function.

By default, some variables in the resulting `data.frame` are renamed and some dropped. This happens for two reasons:

1. If you want to work with results from multiple requests, the default naming scheme is not very useful. For instance, every column containing IDs is always called "id" no matter where it came from (board, card, member...). This is confusing and makes table joins laborious. The naming scheme imposed by `trellor` uses a preffix to indicate its parent structure. Thus the column containing the card IDs is called `card_id`, the column containing member IDs is called `member_id` etc.

2. Some columns are expected to be less frequently used than others and thus dropped.

If you dont think this is useful, set `fix = FALSE`. This will give you a flat `data.frame` with all the columns and original variable names.

## Calling your own queries

All the `get_` functions call the `get_trello` function which is basically a wrapper for `httr::GET` function.

This gradually strips away complexity in the following way:

1. `httr::GET` fetches results for exactly one request; it needs a complete URL, query parameters and a token. It does the heavy lifting but leaves error handling and paging to you.

2. `get_trello` makes the process a bit more cosy: it handles error messages, formats the response and takes care of paging; but you still have to build a complete URL and query parameters.

3. The remaining `get_` functions contain prepackaged URLs and query parameters, eliminating almost all the effort. On the other hand, if you want to use different URL query than those offered by the `get_` functions, you need to fall back to `get_trello` and do the work yourself.

You can find out more about what queries can be made at which URLs on [Trello API reference page](https://developers.trello.com/advanced-reference).

