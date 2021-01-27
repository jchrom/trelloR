#' Add a custom field
#'
#' Create a new custom field definition and attach it to the board.
#'
#' For `add_field_dropdown` - options can be provided using a single (optionally
#' named) vector:
#' `body = list(options = c(red = "Alert", green = "Ok", "Nothing"))`
#'
#' @param id Board ID
#' @param type Custom field type
#' @param name Custom field name
#' @param body Named list with additional parameters
#' @param ... Additional arguments passed to [create_resource()]
#'
#' @family functions to handle custom fields
#'
#' @name add_field
NULL

#' @export
#' @rdname add_field
add_field = function(id, type, name = "New field", body = NULL, ...) {
  if (is.null(body))
    body = list()
  default_body = list(
    idModel = id, modelType = "board", type = type, pos = 1,
    name = name, display_cardFront = "true")
  body = utils::modifyList(default_body, body, keep.null = TRUE)
  create_resource("customField", body = body, ...)
}

#' @export
#' @rdname add_field
add_field_checkbox = function(id, name = "New checkbox", body = NULL, ...) {
  add_field(id = id, type = "checkbox", name = name, body = body, ...)
}

#' @export
#' @rdname add_field
add_field_date = function(id, name = "New date", body = NULL, ...) {
  add_field(id = id, type = "date", name = name, body = body, ...)
}

#' @export
#' @rdname add_field
add_field_dropdown = function(id, name = "New dropdown", body = NULL, ...) {
  if (!is.null(body$options) && is.atomic(body$options))
    body$options = format_items(body$options)
  add_field(id = id, type = "list", name = name, body = body, ...)
}

# Build the nested structure for options.
format_items = function(x) {
  if (is.null(x)) {
    warning("x is NULL - no options set")
    return(NULL)
  }
  if (is.null(names(x)))
    names(x) = rep("none", length(x))
  names(x)[!nzchar(x)] = "none"
  items = list()
  for (i in seq_along(x)) {
    items[[i]] = list(
      pos = i,
      color = names(x)[i],
      value = list(text = as.character(x[[i]]))
    )
  }
  items
}

#' @export
#' @rdname add_field
add_field_number = function(id, name = "New number", body = NULL, ...) {
  add_field(id = id, type = "number", name = name, body = body, ...)
}

#' @export
#' @rdname add_field
add_field_text = function(id, name = "New text", body = NULL, ...) {
  add_field(id = id, type = "text", name = name, body = body, ...)
}

#' Add dropdown option
#'
#' Add dropdown (custom field) option.
#'
#' @param id Custom field ID (see [get_board_fields()])
#' @param text Option text
#' @param color Option color
#' @param position Option position
#' @param ... Additional arguments passed to [create_resource()]
#'
#' @family functions to handle custom fields
#'
#' @export

add_field_option = function(id, text, color = "none", position = "bottom", ...) {
  pars = list(pos = position, color = color, value = list(text = text))
  create_resource("customField", id = id, path = "options", body = pars, ...)
}

#' Delete custom field
#'
#' Delete custom field - this will remove it from all cards on the board.
#'
#' @param id Custom field ID (see [get_board_fields()])
#' @param ... Additional arguments passed to [create_resource()]
#'
#' @family functions to handle custom fields
#'
#' @export

delete_field = function(id, ...) {
  delete_resource("customField", id = id, ...)
}

#' Delete dropdown option
#'
#' Delete dropdown (custom field) option - this will remove it from all cards
#' on the board.
#'
#' @param id Custom field ID (see [get_board_fields()]
#' @param option Dropdown option ID
#' @param ... Additional arguments passed to [create_resource()]
#'
#' @family functions to handle custom fields
#'
#' @export

delete_field_option = function(id, option, ...) {
  delete_resource("customField", id = id, path = c("options", option), ...)
}

#' Update custom field
#'
#' Update custom field definition.
#'
#' @param id Board ID
#' @param body Named list with additional parameters
#' @param ... Additional arguments passed to [update_resource()]
#'
#' @family functions to handle custom fields
#'
#' @export

update_field = function(id, body = list(name = "New name"), ...) {
  update_resource("customField", id = id, body = body, ...)
}

#' Update card field value
#'
#' Set custom field value on a single card.
#'
#' `update_card_date` requires ISO Formatted Datetime String. `"YYYY-MM-DD"` is
#' fine, but if you want also hour and timezone, use `"YYYY-MM-DD hh:mm UTC+X"`,
#' e.g. `"2018-12-24 16:00 UTC+1"`
#'
#' \code{clear_card_field} does not remove the field, but replaces its value with
#' the equivalent of "No selection"
#'
#' @param card Card ID
#' @param field Custom field ID
#' @param key Key for the value, e.g. `"number"` or `"checked"`
#' @param value New value
#' @param ... Additional arguments passed to [update_resource()]
#'
#' @family functions to handle custom fields
#'
#' @name update_card_field
NULL

#' @export
#' @rdname update_card_field
update_card_field = function(card, field, key, value, ...) {
  #The convenience call restructures data to Trello's liking - see comment below
  if (is.logical(value))
    value = tolower(value)
  pars = list(value = structure(list(value), names = key))
  update_resource("card", id = card, path = c("customField", field, "item"),
                  body = pars, ...)
}

# In order to set the custom field value on a card, Trello API requires the body
# to have the following structure:
# Text { "value": { "text": "Hello, world!" } }
# Number { "value": { "number": "42" } }
# Date { "value": { "date": "2018-03-13T16:00:00.000Z" } }
# Checkbox { "value": { "checked": "true" } }
# List { "idValue": "5ab10be237846c43015f108f" } (id of the list option)

#' @export
#' @rdname update_card_field
update_card_checkbox = function(card, field, value, ...) {
  update_card_field(card = card, field = field, value = value, key = "checked", ...)
}

#' @export
#' @rdname update_card_field
update_card_date = function(card, field, value, ...) {
  update_card_field(card = card, field = field, value = value, key = "date", ...)
}

#' @export
#' @rdname update_card_field
update_card_dropdown = function(card, field, value, ...) {
  update_resource("card", id = card, path = c("customField", field, "item"),
                  body = list(idValue = value), ...)
}

#' @export
#' @rdname update_card_field
update_card_number = function(card, field, value, ...) {
  update_card_field(card = card, field = field, value = value, key = "number", ...)
}

#' @export
#' @rdname update_card_field
update_card_text = function(card, field, value, ...) {
  update_card_field(card = card, field = field, value = value, key = "text", ...)
}

#' @export
#' @rdname update_card_field
clear_card_field = function(card, field, ...) {
  update_resource("card", id = card, path = c("customField", field, "item"),
                  body = list(value = "", key = ""), ...)
}
