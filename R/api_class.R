# Class constructor

add_class = function(x, child) {
    if (!is.data.frame(x)) stop("Not a data frame")
    class_api = paste0(child, "_df")
    structure(x, class = c(class_api, "trello_api", class(x)))
}
