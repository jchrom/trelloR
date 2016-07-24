as_POSIXct_hex = function(x) {

    # Check input
    if (!is.character(x)) stop("Input must be of class 'character'")
    if (!all(nchar(x) == 8)) stop("Input must be a string of 8 characters")

    # Convert into POSIXct
    timestamp = strtoi(x, 16L)
    posix_ct  = as.POSIXct(timestamp, origin = "1970-01-01")
    return(posix_ct)
}

# set_filter = function(query, filter) {
#
#     if (!grepl("filter", query) & (!grepl("\\?", query))) {
#         query = paste0(query, "?filter=", filter)
#     } else if (!grepl("filter", query)) {
#         query = paste0(query, "&filter=", filter)
#     }
#     return(query)
# }

.onAttach <- function(libname, pkgname) {
    packageStartupMessage(
        "R API for Trello\n",
        "Not affiliated, associated, authorized, endorsed by or in any way officially connected to Trello, Inc. (www.trello.com)\n",
        "Visit https://github.com/jchrom/trello for introduction\n")
}
