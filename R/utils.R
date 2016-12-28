# FOR EXPORT

#' Convert hex string into POSIXct
#'
#' Convert hex string into POSIXct
#' @param x Vector of strings, each 8 characters long
#' @export

as_POSIXct_hex = function(x) {

  # Check input
  stopifnot(is.character(x))
  if (!all(nchar(x) == 8))
    stop("Each element must have 8 characters", call. = FALSE)

  # Convert into POSIXct
  as.POSIXct(strtoi(x, 16L), origin = "1970-01-01")
}

# NOT FOR EXPORT ----
# -------------------

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "R API for Trello\n",
    "Disclaimer: trelloR is not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (www.trello.com).\n")
}
