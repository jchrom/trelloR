
<!-- README.md is generated from README.Rmd. Please edit that file -->

## API client for Trello

[![Build
Status](https://travis-ci.org/jchrom/trelloR.svg?branch=master)](https://travis-ci.org/jchrom/trelloR)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/trelloR)](https://cran.r-project.org/package=trelloR)
[![Rdoc](http://www.rdocumentation.org/badges/version/trelloR)](http://www.rdocumentation.org/packages/trelloR)

The purpose of `trelloR` is to help you interact with the [Trello
API](https://developer.atlassian.com/cloud/trello/rest) from R.

### Example

Request cards from a public board and return a data frame:

``` r
library(trelloR)
#> R API for Trello
#> Disclaimer: trelloR is not affiliated, associated, authorized, endorsed by or
#> in any way officially connected to Trello, Inc. (www.trello.com).
board = "https://trello.com/b/wVWPK9I4/r-client-for-the-trello-api"
get_board_cards(board)[, 1:5]
#> GET: https://api.trello.com/1/board/wVWPK9I4/cards?limit=100
#> NULL
#> Downloading: 3 kB     Downloading: 3 kB     Downloading: 3 kB     Downloading: 3 kB
#> OK (HTTP 200).
#> 
#> Fetched 11 results
#> 
#> Request complete: 11 results.
#> # A tibble: 11 x 5
#>    id         checkItemStates closed dateLastActivity    desc                   
#>    <chr>      <lgl>           <lgl>  <chr>               <chr>                  
#>  1 600f54e86… NA              FALSE  2021-01-25T23:34:2… "#This is a testing bo…
#>  2 600f54e86… NA              FALSE  2021-01-25T23:31:5… "#[trelloR](https://gi…
#>  3 600f54e86… NA              FALSE  2021-01-25T23:31:5… "#It can change things…
#>  4 600f54e86… NA              FALSE  2021-01-25T23:31:5… "This card is demoing …
#>  5 600f54e86… NA              FALSE  2021-01-25T23:31:5… "This card has a due d…
#>  6 600f54e86… NA              FALSE  2021-01-25T23:31:5… "Due date has been add…
#>  7 600f54e86… NA              FALSE  2021-01-25T23:31:5… "You can get custom fi…
#>  8 600f54e86… NA              FALSE  2021-01-25T23:31:5… "Card with comments. C…
#>  9 600f54e86… NA              FALSE  2021-01-25T23:31:5… "#Get it from GitHub\n…
#> 10 600f54e86… NA              FALSE  2021-01-25T23:36:3… "#A very basic example…
#> 11 600f54e86… NA              FALSE  2021-01-25T23:31:5… "If you have found a b…
```

Private and team boards can be accessed using a secure token. Check the
vignettes to [get
started](https://jchrom.github.io/trelloR/articles/getting-public-data.html).

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
Inc. (<http://www.trello.com>).
