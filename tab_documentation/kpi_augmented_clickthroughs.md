Key Performance Indicator: User Engagement (Augmented Clickthroughs)
=======

We are in the process of obtaining qualitative data from our users (their intent and satisfaction), so this metric is less akin to "user satisfaction" and more akin to "user engagement" we observe.

This metric combines the clickthrough rate and the proportion of users' session dwell times exceeding the threshold of 10s.

Notes
------
* '__A__': we switched to using data from [Schema:TestSearchSatisfaction2](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2) instead of [Schema:Search](https://meta.wikimedia.org/wiki/Schema:Search) for Desktop event counts and load times on 12 July 2016.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.
* '__B__': on 2018-05-10 the iOS app fixed a bug which prevent search events being sent to [MobileWikiAppSearch](https://meta.wikimedia.org/wiki/Schema:MobileWikiAppSearch) and adjust the sampling rate to 100%. See [T192520](https://phabricator.wikimedia.org/T192520) for more details. Please note that the iOS app only collects data from users who agree to share their usage report with us.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#kpi_augmented_clickthroughs">https://discovery.wmflabs.org/metrics/#kpi_augmented_clickthroughs</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
