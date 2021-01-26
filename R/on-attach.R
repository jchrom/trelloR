.onAttach <- function(libname, pkgname) {

  text = strwrap(width = getOption("width"), paste(
    "Disclaimer: trelloR is not affiliated, associated, authorized, endorsed",
    "by or in any way officially connected to Trello, Inc. (www.trello.com)."
  ))

  packageStartupMessage("R API for Trello\n", paste(text, collapse = "\n"),
                        appendLF = TRUE)
}
