
<!-- README.md is generated from README.Rmd. Please edit that file -->

## API client for Trello

[![Build
Status](https://travis-ci.org/jchrom/trelloR.svg?branch=master)](https://travis-ci.org/jchrom/trelloR/)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/trelloR)](https://cran.r-project.org/package=trelloR/)
[![Rdoc](https://www.rdocumentation.org/badges/version/trelloR)](https://www.rdocumentation.org/packages/trelloR/)

The purpose of `trelloR` is to help you interact with the [Trello
API](https://developer.atlassian.com/cloud/trello/rest) from R.

### Example

Request cards and return a data frame:

``` r
library(trelloR)
board = "https://trello.com/b/wVWPK9I4/r-client-for-the-trello-api"
cards = get_board_cards(board)
```

### Get it from GitHub

``` r
# install.packages("remotes")
remotes::install_github("jchrom/trelloR")
```

**CRAN (version 0.1)**

The CRAN version is in dire need of an update, which will happen when
0.7 is released (hopefully very soon). In the meantime, please use the
development version above.

### Imports

trelloR is built using [httr](https://cran.r-project.org/package=httr)
and [jsonlite](https://cran.r-project.org/package=jsonlite).

**Disclaimer:** `trelloR` is not affiliated, associated, authorized,
endorsed by or in any way officially connected to Trello,
Inc. (<https://trello.com/>).
