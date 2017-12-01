# trelloR 0.4.0

**New features**

* You can now issue PUT and DELETE requests
* Calling wrappers update_ and delete_ is going to make it easier for you
* you can decide whether you want to obtain content of a response (data.frame for get_,  list for the others) or a complete response object including headers, statuses etc.

**Deprecated arguments**

* bind.rows in get_token() has been deprecated, will always try to return a single data.frame if content is returned

**Other stuff**

* refactored GET-related code to make use of httr function for repeated requests, stopping/warning/messaging on errors
* updated vignette and pkg docs
