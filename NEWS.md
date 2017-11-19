# trelloR 0.3.0

**New features**

* you can now get a token with write and account permissions
* and you can specify its expiration (incl. never for never expiring tokens)
* you can now issue POST requests to add cards, comments, members to cards etc.
* you can use the add_ family of functions, which are wrappers for post_model()

** Deprecated functions **

* trello_get_token() has been deprecated, use get_token() instead
* trello_get_model() has been deprecated, use get_model() instead

** Other stuff**

* greater reliance on httr - eg. when building URLs or convert status codes to messages/warnings/errors in R (this is true only for the newly added code, but in time I will rewrite the older code too)
* updated vignette
