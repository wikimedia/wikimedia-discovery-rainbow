Prefix and Full-Text Search Result Rate
=======

Sometimes, searches return zero results - both full-text and prefix searches. What we're visualising here is the percentage of the time
a search query returns zero results, split out for prefix and full-text search.

Zero results doesn't actually mean a failure for the user, of course: the "prefix search" events represent the system attempting to match the user's already-typed characters to an existing page name. Some full-text failures are from typos, resulting in a search page with no results, but *also* resulting in a spelling correction the user could use to get genuine results.

General trends
------

Outages and inaccuracies
------
* On 15 July 2015 we updated our heuristics to avoid counting maintenance tasks as search requests. The historic data on the dashboards is being backfilled to reflect this - until it's done, the dashboards may look somewhat strange.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Oliver](mailto:okeyes@wikimedia.org?subject=Dashboard%20Question). If you experience a technical issue or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question). 
