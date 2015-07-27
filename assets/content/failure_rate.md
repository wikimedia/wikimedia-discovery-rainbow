Search Queries with Zero Results
=======

Sometimes, searches return zero results. What we're visualising here is the number of times that happens, contrasted with the number of queries overall.

Zero results doesn't actually mean a failure for the user, of course: some of these events are from "prefix search" in the search box, where the system attempts to match the user's already-typed characters to an existing page name. Others are from typos, resulting in a search page with no results, but *also* resulting in a spelling correction the user could use to get genuine results.

We've also broken out the daily rate of change - the failure proportion's increase or decrease per day. We expect the failure rate to monotonically decrease over time once we start with projects and patches aimed at decreasing this rate.

General trends
------

Outages and inaccuracies
------
* On 15 July 2015 we updated our heuristics to avoid counting maintenance tasks as search requests. The historic data on the dashboards is being backfilled to reflect this - until it's done, the dashboards may look somewhat strange.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Oliver](mailto:okeyes@wikimedia.org?subject=Dashboard%20Question). If you experience a technical issue or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question). 
