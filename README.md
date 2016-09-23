
<!-- README.md is generated from README.Rmd. Please edit that file -->
R API for Trello
================

[![Build Status](https://travis-ci.org/jchrom/trelloR.svg?branch=master)](https://travis-ci.org/jchrom/trelloR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/trelloR)](http://cran.r-project.org/package=trelloR)

The purpose of `trelloR` is to easily access [Trello API](https://developers.trello.com/) from R. It can retrieve cards, labels, checklists and other data from Trello boards, using functions with predictable names. The following snippet fetches cards from a particular board:

``` r
library(trelloR)
board = get_board_id("https://trello.com/b/nC8QJJoZ/trello-development-roadmap")
cards = get_board_cards(board)
```

Paging for large requests is automatic. Private boards are accessed by obtaining a secure token using [Trello developer keys](https://developers.trello.com/get-started/start-building#connect).

You can get it on CRAN:

``` r
install.packages("trelloR")
```

or can install the development version from Github:

``` r
devtools::install_github("jchrom/trelloR")
```

For more information, read the vignette.

**Note.** `trelloR` is built on top of the Hadley Wickham's [httr](https://cran.r-project.org/package=httr) and Jeroen Ooms' [jsonlite](https://cran.r-project.org/package=jsonlite).

**Disclaimer:** `trelloR` is not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (<http://www.trello.com>).
