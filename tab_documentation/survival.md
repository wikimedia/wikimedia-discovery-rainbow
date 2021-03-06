How long searchers stay on the visited search results
=======

When someone is randomly selected for search satisfaction tracking (using our [TSS2 schema](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2)), we use a check-in system and survival analysis to estimate how long users stay on visited pages. To summarize the results on a daily basis, we record a set of statistics based on a measure formally known as "[median lethal dose](https://en.wikipedia.org/wiki/Median_lethal_dose)".

This graph shows the length of time that must pass before N% of the users leave the page (e.g. article) they visited. When the number goes up, we can infer that users are staying on the pages longer. In general, it appears it takes 15s to lose 10%, 25-35s to lose 25%, and 55-75s to lose 50%.

On most days, we retain at least 20% of the test population past the 7 minute mark (the point at which the user's browser stops checking in), so on those days we cannot calculate the time it takes to lose 90/95/99% of the users.

There are some days when we CAN calculate those times, and it can take anywhere between 270s (4m30s) and 390s (6m30s) for 90% of the users to have closed the page they clicked through from the search results page.

Annotations
------
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.
* '__S__': on 2017-04-25 we changed the rates at which users are put into event logging (see [T163273](https://phabricator.wikimedia.org/T163273)). Specifically, we decreased the rate on English Wikipedia ("EnWiki") and increased it everywhere else.
* '__B__': on 2018-09-27 we fixed a bug in our data retrieval script ([change 462032](https://gerrit.wikimedia.org/r/#/c/wikimedia/discovery/golden/+/462032/)) that stopped the metrics to be created. We also removed sessions that don't contain SRP and included searches that ended within 10 seconds (no checkin event). We then backfilled the data since 2018-07-19.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#survival">https://discovery.wmflabs.org/metrics/#survival</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
