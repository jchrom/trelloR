# trelloR 0.2.0

* Added a `NEWS.md` file to track changes to the package.

**New features**

* you can now specify values for `limit` larger than 1000
* added S3 classes for results
* some classes (`cards_df`, `actions_df`, `labels_df`, `checklists_df`) now pretty-print on the console

**Deprecated arguments**

* `paging` has been deprecated, use `filter = 0` instead

**Bugfixes**

* `before` parameter is now set correctly (preventing duplicates in results)
* all messages can now be suppressed (replaced `cat` with `message` everywhere)

