# Bind Data Frames By Row
#
# Bind data frames by row. This is used to bind paged responses from Trello API,
# parsed by jsonlite::fromJSON(). It is not safe for other types of inputs,
# for example data frames containing factor or date-time columns. It is only
# used internally and not exported.
#
# @param dfs A list of data frames.
#
# @return A data frame.

rbind_vector = function(dfs) {

  if (is.data.frame(dfs)) return(dfs)

  stopifnot(is.list(dfs))

  dfs = Filter(length, dfs)

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
