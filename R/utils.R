# FOR EXPORT

#' Convert hex string into POSIXct
#'
#' Convert hex string into POSIXct
#' @param x Vector of strings, each 8 characters long
#' @export

as_POSIXct_hex = function(x) {

  stopifnot(is.character(x))

  if (!all(nchar(x) == 8))
    x = strtrim(x, 8)

  # Convert into POSIXct
  as.POSIXct(strtoi(x, 16L), origin = "1970-01-01")
}

#' Exctract ID
#'
#' Exctract model ID from model URL. If input is not a valid URL, it is returned
#' as is.
#' @param x character vector of length 1
#' @export

extract_id = function(x) {

  if (is.null(x)) return(NULL)

  is_url = function(x) !is.null(httr::parse_url(x)$hostname)

  if (is_url(x)) {
    path = httr::parse_url(x)$path
    x = unlist(strsplit(path, "/"))[2]
  }
  x
}

# NOT FOR EXPORT

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "R API for Trello\n",
    paste(strwrap("Disclaimer: trelloR is not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (www.trello.com).\n"), collapse = "\n"))
}

tolower_if_logical = function(x) {
  if (inherits(x, "logical")) tolower(x) else x
}

read_last_token = function() {
  cached_tokens = readRDS(".httr-oauth")
  utils::tail(cached_tokens)[[1]]
}
