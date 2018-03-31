
<!-- README.md is generated from README.Rmd. Please edit that file -->
R API for Trello
----------------

[![Build Status](https://travis-ci.org/jchrom/trelloR.svg?branch=master)](https://travis-ci.org/jchrom/trelloR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/trelloR)](https://cran.r-project.org/package=trelloR) [![Rdoc](http://www.rdocumentation.org/badges/version/trelloR)](http://www.rdocumentation.org/packages/trelloR)

The purpose of `trelloR` is to easily access [Trello API](https://developers.trello.com/) from R. It can retrieve cards, labels, checklists and other data from Trello boards, using functions with predictable names. The following snippet fetches cards from a public board:

``` r
library(trelloR)
board = get_id_board("https://trello.com/b/nC8QJJoZ/trello-development-roadmap")
cards = get_board_cards(board)
```

Support for PUT, POST and DELETE requests is implemented in the development version (see below). Private boards are accessed with secure token (see [Trello developer keys](https://developers.trello.com/get-started/start-building#connect)). For more information, check the [docs](https://jchrom.github.io/trelloR/) or the [vignette](https://jchrom.github.io/trelloR/articles/R_API_for_Trello.html).

### Get it from CRAN (version 0.1)

``` r
install.packages("trelloR")
```

### ...or from GitHub (current)

``` r
devtools::install_github("jchrom/trelloR")
```

**Note.** `trelloR` is built using Hadley Wickham's [httr](https://cran.r-project.org/package=httr) and Jeroen Ooms' [jsonlite](https://cran.r-project.org/package=jsonlite).

**Disclaimer:** `trelloR` is not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (<http://www.trello.com>).
