# Bind Data Frames By Row
#
# Row-bind data from Trello API processed by jsonlite::fromJSON. Assumes data
# frames with a mix of atomic vectors and lists. Not safe to use for other types
# of data and therefore not exported.
#
# @details
#
#   Responses from Trello API are parsed by jsonlite::fromJSON which produces
#   lists of data frames. Row-binding these with base::rbind often fails because
#   not all data frames always have the same set of columns.
#
#   Using dplyr::bind_rows is also not an option because often the same column
#   does not have the same type across all data frames (plus it introduces
#   an expensive dependency).
#
#   trelloR::rbind_vector can handle data frames composed of vectors, ie. atomic
#   vectors and lists, and follows standard coercion rules if mixed types are
#   present.
#
#   Objects for which base::is.vector returns FALSE will break in unexpected
#   ways. This is only accepted because no such objects will ever be returned
#   by jsonlite::fromJSON, and trelloR::rbind_vector is not exported to avoid
#   its use in other situations.
#
# @param dfs
#
# @return A data frame.

rbind_vector = function(dfs) {

  if (is.data.frame(dfs)) return(dfs)

  stopifnot(is.list(dfs))
  stopifnot(all(sapply(dfs, is.data.frame)))

  row_lengths = unlist(lapply(dfs, .row_names_info, 2L), use.names = FALSE)

  row_end   = cumsum(row_lengths)
  row_start = row_end - row_lengths + 1

  row_total = sum(row_lengths)

  col_names = unique(unlist(lapply(dfs, names), use.names = FALSE))

  out = lapply(
    stats::setNames(nm = col_names),
    function(.) rep(NA, row_total)
  )

  for (i in seq_along(dfs)) {

    for (source_name in names(dfs[[i]])) {

      out[[source_name]][
        row_start[i]:row_end[i]] = dfs[[i]][[source_name]]

    }

  }

  structure(out, row.names = .set_row_names(row_total), class = "data.frame")

}
