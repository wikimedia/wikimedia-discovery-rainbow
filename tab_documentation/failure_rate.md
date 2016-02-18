Search Queries with Zero Results
=======

Sometimes, searches return zero results. What we're visualising here is the proportion of the time that happens.

Zero results doesn't actually mean a failure for the user, of course: some of these events are from "prefix search" in the search box, where the system attempts to match the user's already-typed characters to an existing page name. Others are from typos, resulting in a search page with no results, but *also* resulting in a spelling correction the user could use to get genuine results.

We've also broken out the daily rate of change - the failure proportion's increase or decrease per day. We expect the failure rate to monotonically decrease over time once we start with projects and patches aimed at decreasing this rate.

General trends
------

Outages and inaccuracies
------
* On 15 July 2015 we updated our heuristics to avoid counting maintenance tasks as search requests. The historic data on the dashboards is being backfilled to reflect this - until it's done, the dashboards may look somewhat strange.
* On 15 January 2016 there was an [issue](https://phabricator.wikimedia.org/T123541) with Avro serialization that prevented data from entering the Hadoop cluster. A [patch](https://gerrit.wikimedia.org/r/#/c/264989/) was deployed on 19 January 2016. As a result, there are no recorded zero results rates for 01/15-01/19. The values you may see on those dates are estimates computed with [statistical models](https://github.com/bearloga/branch/blob/master/zero%20results%20rate%20estimation/report.pdf).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#failure_rate">
    http://discovery.wmflabs.org/metrics/#failure_rate
  </a>
</p>