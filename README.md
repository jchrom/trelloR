
<!-- README.md is generated from README.Rmd. Please edit that file -->

## R API for Trello

[![Build
Status](https://travis-ci.org/jchrom/trelloR.svg?branch=master)](https://travis-ci.org/jchrom/trelloR)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/trelloR)](https://cran.r-project.org/package=trelloR)
[![Rdoc](http://www.rdocumentation.org/badges/version/trelloR)](http://www.rdocumentation.org/packages/trelloR)

The purpose of `trelloR` is to easily interact with [Trello
API](https://developers.trello.com/) from R.

It can retrieve, create, update and delete data from Trello boards,
using functions with predictable names. The following snippet fetches
cards from a public board:

``` r
library(trelloR)
cards = get_board_cards("https://trello.com/b/Pw3EioMM/trellor-r-api-for-trello")
```

Private and team boards can be accessed using a secure token. Check the
vignettes to [get
started](https://jchrom.github.io/trelloR/docs/articles/get-public-data.html).

### Get it from CRAN (version 0.1)

The CRAN version can only download data. Support for PUT, POST and
DELETE requests is implemented in the development version (see below).

``` r
install.packages("trelloR")
```

**…or from GitHub (current)**

``` r
devtools::install_github("jchrom/trelloR")
```

Built on [httr](https://cran.r-project.org/package=httr) and
[jsonlite](https://cran.r-project.org/package=jsonlite).

**Disclaimer:** `trelloR` is not affiliated, associated, authorized,
endorsed by or in any way officially connected to Trello, Inc.
(<http://www.trello.com>).
