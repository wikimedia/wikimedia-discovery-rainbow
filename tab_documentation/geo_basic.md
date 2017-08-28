Geographic Search API usage
=======

Geo Search, or Geographic Search, refers to the ability to search for pages that are "near" a particular set of geographic coordinates, in the sense of being about subjects that have physical locations we track. (places. Not people.)

General trends
------

It's early days, but the tiny adoption of Geographic Search, particularly compared to Cirrus or OpenSearch, suggests this isn't a tremendously useful feature to API users. We need to dig in and refine the heuristics for identifying requests as different types, however.

Outages and inaccuracies
------

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details. Furthermore, we switched to an updated UDF for counting API calls -- the previous version was undercounting full-text and geo search API calls (see [Gerrit change 315503](https://gerrit.wikimedia.org/r/#/c/315503/) for more details).
* '__U__': on 2017-08-14 we started to use a new UDF to get the type of search API (see [Gerrit change 345863](https://gerrit.wikimedia.org/r/#/c/345863/) for more details) and break down the API calls by referer class.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#geo_search">https://discovery.wmflabs.org/metrics/#geo_search</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
