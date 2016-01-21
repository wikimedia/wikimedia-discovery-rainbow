Prefix and Full-Text Search Result Rate
=======

Sometimes, searches return zero results - both full-text and prefix searches. What we're visualising here is the percentage of the time
a search query returns zero results, split out for prefix and full-text search.

Zero results doesn't actually mean a failure for the user, of course: the "prefix search" events represent the system attempting to match the user's already-typed characters to an existing page name. Some full-text failures are from typos, resulting in a search page with no results, but *also* resulting in a spelling correction the user could use to get genuine results.

General trends
------

Outages and inaccuracies
------
* On 15 July 2015 we updated our heuristics to avoid counting maintenance tasks as search requests.
* On 15 January 2016 there was an [issue](https://phabricator.wikimedia.org/T123541) with Avro serialization that prevented data from entering the Hadoop cluster. A [patch](https://gerrit.wikimedia.org/r/#/c/264989/) was deployed on 19 January 2016. As a result, there are no recorded zero results rates for 01/15-01/19. The values you may see on those dates are estimates computed with [statistical models](https://github.com/bearloga/branch/blob/master/zero%20results%20rate%20estimation/report.pdf).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#failure_breakdown">
    http://discovery.wmflabs.org/metrics/#failure_breakdown
  </a>
</p>
