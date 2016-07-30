# R API for Trello

[![Build Status](https://travis-ci.org/jchrom/trellor.svg?branch=master)](https://travis-ci.org/jchrom/trellor)

The purpose of `trellor` is to provide easy access to the [Trello API](https://developers.trello.com/) from R. It can retrieve data from various levels of JSON hierarchy (e.g. cards that belong to a particular board or members assigned to a particular card).

Requests are carried out by simple functions with meaningful names, such as `get_my_boards()` or `get_card_comments()`. Automated paging makes sure that all the results will be acquired. Access to private boards is achieved by obtaining a secure token with [Trello developer keys](https://trello.com/app-key).

You can install the development version from Github:

```{r, eval=FALSE, include=TRUE}
devtools::install_github("jchrom/trellor")
```

**Note.** `trellor` is built on top of Hadley Wickham's [httr](https://cran.r-project.org/web/packages/httr/index.html) and Jeroen Ooms' [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html).

**Disclaimer:** `trellor` is not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (<http://www.trello.com>).
