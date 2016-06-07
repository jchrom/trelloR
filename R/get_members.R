#' Overview of member data
#'
#' Get member's organizations, boards, cards via API using an oauth1 token (see ?get_token for how to get one)
#' @param id member's id
#' @param what accepted values are 'boards' (defualt), 'organizations', 'cards'
#' @param token previously generated token (see ?get_token for how to get one)
#' @importFrom httr GET config content
#' @importFrom jsonlite fromJSON
#' @export
#' @examples
#' # Source credentials from non-shared location (important!)
#' source("mykeys.R")
#' token = get_token(key, secret)
#'
#' # You will be prompted to confirm the authorization in a browser. You will also be offered an option to store the authentication in your working directory, in a hidden '.httr-oauth' file (do NOT share it with anyone!).

get_members = function(id, what = "boards", token) {

    # Construct call
    api  = "https://api.trello.com/1/members"
    call = paste0(api, "/", id, "/", what, "?key=", key)

    req  = GET(call, config(token = token))
    json = content(req, as = "text")
    data = fromJSON(json)

    return(data)
}
