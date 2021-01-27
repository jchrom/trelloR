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

#' Extract ID
#'
#' Extract resource ID from its URL. If input is not a valid URL, it is
#' returned as is.
#'
#' @param x character vector of length 1
#' @export

extract_id = function(x) {

  if (is.null(x)) return()

  is_url = function(x) !is.null(httr::parse_url(x)$hostname)

  if (is_url(x)) {
    path = httr::parse_url(x)$path
    x = unlist(strsplit(path, "/"))[2]
  }
  x
}

# NOT FOR EXPORT

require_tibble = function(x) {
  if (requireNamespace("tibble", quietly = TRUE))
    x = tibble::as_tibble(x)
  x
}

warn_for_argument = function(x) {

  if (!missing(x)) {
    msg = sprintf("`%s`: argument is deprecated", as.character(substitute(x)))
    warning(msg, call. = FALSE)
  }

  NULL

}
