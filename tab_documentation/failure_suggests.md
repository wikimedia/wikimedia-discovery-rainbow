Zero Rate for Search Suggestions
=======

With a lot of "full-text" searches, the system provides not only results but also suggestions - corrections for typos, for example. These are more prominent with searches that returned few or no results, for fairly obvious reasons (if the suggestion is being provided it's because the system thinks you got something wrong).

This graph shows the zero results rate for searches with suggestions, compared to the zero results rate for full-text searches overall.

Notes
------

* '__A__': On 13 April 2016 we switched to a new data format for zero results rate (see [T132503](https://phabricator.wikimedia.org/T132503)) wherein we stopped lumping in different query types into just two categories ("Full-Text Search" and "Prefix Search"). The ZRR data were backfilled from 1 February 2016 under the new format which breaks down ZRR into the individual query types. We also began filtering out irrelevant query types (see [T131196#2200560](https://phabricator.wikimedia.org/T131196#2200560)) and requests with unknown number of hits ("-1" in the database).
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#failure_suggestions">https://discovery.wmflabs.org/metrics/#failure_suggestions</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
