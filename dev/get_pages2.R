# Playground
# Cases: a vector with given length
#        condition

user_vec = c(1000, 1000, 1000, 450)
user_vec = 0
user_vec = 250

real_vec = c(1000, 1000, 1000, 1000, 750)
real_vec = c(1000, 1000, 450)
real_ind = 1

# There is probably no way around using two kinds of loop...

if (length(user_vec) > 1) {

  for (i in seq_along(user_vec)) {
    result = real_vec[i]
    print(paste0(i, " user vector: ", user_vec[i], ", real vector: ", result))
    if (result < 1000)
      break
  }

} else {

  less_1000 = FALSE
  i = 1

  while (!less_1000) {

    result = real_vec[i]
    i = i + 1
    less_1000 = result < 1000
    print(paste0(i, " user vector: ", user_vec[i], ", real vector: ", result))
  }

}


get_pages = function(url, token, query = NULL) {

  # Prefer user-set limit even though it may provoke an error
  if (!is.null(query[["limit"]]))
    user_limit = query[["limit"]]
  else
    user_limit = 1000

  # We could also make limit=0 if negative value is supplied by the user,
  # but I think error is better
  if (user_limit < 0)
    stop("'limit' cannot be negative", call. = FALSE)

  # Let's assume that Trello's API will keep 1000 as the maximum request length
  if (user_limit > 0) {
    limit_vec = c(rep(1000, trunc(user_limit/1000)), user_limit %% 1000)
    limit_vec = limit_vec[limit_vec > 0]
  } else {
    limit_vec = 1000 #because user_limit=0 means "keep using highest limit"
  }

  result = list()

  # use [for] when the limit over 1000, use [while] when its < 1000 (incl. 0)
  if (length(user_vec) > 1) {

    for (i in seq_along(user_vec)) {

      query[["limit"]] = user_vec[i]
      batch = get_flat(url = url, token = token, query = query)
      result = append(result, list(batch))

      if (!is.data.frame(batch))
        break

      message("Received ", nrow(batch), " results")
      query[["before"]] = min(batch$id)

      if (nrow(batch) < 1000)
        break

    } else {

      query[["limit"]] = limit_vec

      repeat {

        batch = get_flat(url = url, token = token, query = query)
        result = append(result, list(batch))

        if (!is.data.frame(batch))
          break

        message("Received ", nrow(batch), " results")
        query[["before"]] = min(batch$id)

        if (nrow(batch) < 1000)
          break

      }
    }
  }
}

