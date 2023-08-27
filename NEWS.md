# trelloR (development version)

# trelloR 0.8.0

**New features & bug fixes**

* Fixed missing -package alias.
* Added new function `get_batch()` to facilitate [batch requests](https://developer.atlassian.com/cloud/trello/rest/api-group-batch/#api-group-batch)
* Added new function `get_card_fields_values()` to fetch custom field values
  for a given card id.

**New dependency**

* Added dependency on curl, but since httr already depends on it, the dependency
  footprint has not really been increased.

# trelloR 0.7.1

**New features & bug fixes**

* Ensure elements created with `httr::upload_file()` are handled with correct encoding, and added unit test for file upload
* provide convenience wrapper `add_card_attachment()` which also can be used to change the card cover image with `cover=TRUE`

# trelloR 0.7.0

**New features**

* Can specify an alternate path for the token file

**Other stuff**

* No longer imports dplyr
* Updated vignettes and function docs

# trelloR 0.6.0

**New features**

* No need to use the `token` argument in all function calls, functions now check
  for a local .httr-oauth file first; you can still pass a Token object directly
  though
* New wrappers for retrieving custom fields
* New wrapper to get board preferences

**Other stuff**

* Updated package website and nicer vignettes

# trelloR 0.5.0

**New features**

* You can now use URL for model ID

**Other stuff**

* When nothing matches the request, a nice message is printed, instead of an
  ugly warning
* Updated vignette and pkg docs

# trelloR 0.4.0

**New features**

* You can now issue PUT and DELETE requests
* Calling wrappers update_ and delete_ is going to make it easier for you
* You can decide whether you want to return content of a response (data frame
  for get_, list for the others) or a complete response object including
  headers, statuses etc.

**Deprecated arguments**

* bind.rows in get_model() has been deprecated, will always try to return
  a single data.frame if content is returned

**Other stuff**

* refactored GET-related code to make use of httr function for repeated requests,
  stopping/warning/messaging on errors
* updated vignette and pkg docs

# trelloR 0.3.0

**New features**

* You can now get a token with permissions to write, and specify its expiration
  (incl. "never" for everlasting tokens)
* You can now issue POST requests to add cards, comments etc.
* You can use the add_ family of wrappers for doing so

**Deprecated functions**

* `trello_get_token()` has been deprecated, use `get_token()` instead
* `trello_get()` has been deprecated, use `get_model()` instead

**Other stuff**

* Greater reliance on httr - eg. when building URLs or convert status codes to
  messages/warnings/errors; this is true only for the newly added code,
  but in time I will rewrite the older code too
* Updated vignette

# trelloR 0.2.0

**New features**

* You can now specify values for limit larger than 1000
* Added S3 classes for results
* some classes (cards_df, actions_df, labels_df, checklists_df) now pretty-print
  on the console (**EDIT:** This is dropped in later releases!)

**Deprecated arguments**

* `paging` has been deprecated, use `limit=0` instead

**Bugfixes**

* The internal *before* parameter is now set correctly (preventing duplicates
  in results)
* All messages can now be suppressed (as `cat` was replaced with `message`
  everywhere)

# trelloR 0.1.0

First version of R API for Trello. Implements GET requests for Trello API.
