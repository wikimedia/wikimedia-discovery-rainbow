Search Result Rate by Query Type
=======

Sometimes, searches return zero results - both full-text and prefix searches. What we're visualising here is the percentage of the time a search query returns zero results, split out for different query types (full-text, prefix, regex, more like, completion suggester, and geospatial). Zero results doesn't actually mean a failure for the user, of course: the "prefix search" events represent the system attempting to match the user's already-typed characters to an existing page name.

Notes
------

* '__A__': On 13 April 2016 we switched to a new data format for zero results rate (see [T132503](https://phabricator.wikimedia.org/T132503)) wherein we stopped lumping in different query types into just two categories ("Full-Text Search" and "Prefix Search"). The ZRR data were backfilled from 1 February 2016 under the new format which breaks down ZRR into the individual query types. We also began filtering out irrelevant query types (see [T131196#2200560](https://phabricator.wikimedia.org/T131196#2200560)) and requests with unknown number of hits ("-1" in the database).
* On 15 July 2015 we updated our heuristics to avoid counting maintenance tasks as search requests.
* On 15 January 2016 there was an [issue](https://phabricator.wikimedia.org/T123541) with Avro serialization that prevented data from entering the Hadoop cluster. A [patch](https://gerrit.wikimedia.org/r/#/c/264989/) was deployed on 19 January 2016. As a result, there are no recorded zero results rates for 01/15-01/19. The values you may see on those dates are estimates computed with [statistical models](https://github.com/bearloga/branch/blob/master/zero%20results%20rate%20estimation/report.pdf).
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#failure_breakdown">https://discovery.wmflabs.org/metrics/#failure_breakdown</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
