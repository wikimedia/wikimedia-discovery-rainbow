How long Wikipedia searchers stay on the search result pages
=======

When someone is randomly selected for search satisfaction tracking (using our [TSS2 schema](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2)), we use a check-in system and survival analysis to estimate how long users stay on visited pages. When a Wikipedia visitor searches using autocomplete and ends up on a **full-text _search results page_** (SRP), we can track how long that page is "alive" before the user either closes the tab, clicks on a result, or navigates elsewhere.

To summarize the results on a daily basis, we record a set of statistics based on a measure formally known as "[median lethal dose](https://en.wikipedia.org/wiki/Median_lethal_dose)". This graph shows the length of time that must pass before N% of the users leave the search results page. When the number goes up, we can infer that users are staying on the pages longer.

Notes
-----
These summary statistics are the same between the three categories of languages we have.

* Half of the searchers stay on the full-text SRP for 25 or more seconds -- this is consistent day-to-day even after sister project search deployment.
* 3/4 of searchers have left the full-text SRP by the 35s mark. Since the deployment of the sister project search, we appear to have more days when this statistic is at 45s, _indicating that users are staying on the page a little longer_ -- possibly due to reading the cross-wiki snippets we're presenting them with.
* 90% of searchers are done with the full-text SRP by the 1m15s mark, although on some days it's 1m45s. We've observed more days like that before the deployment of sister project search, although there was one day post-deployment in particular (2017-06-29) on which it took 2m45s for 90% of the searchers to leave the page.

Annotations
------
* '__S__': on 2017-04-25 we changed the rates at which users are put into event logging (see [T163273](https://phabricator.wikimedia.org/T163273)). Specifically, we decreased the rate on English Wikipedia ("EnWiki") and increased it everywhere else.
* '__SS__': [on 2017-06-15](https://lists.wikimedia.org/pipermail/discovery/2017-June/001536.html) we deployed the sister search feature to all Wikipedia in all languages. Sister project (cross-wiki) snippets is a feature that adds search results from sister projects of Wikipedia to a sidebar on the search engine results page (SERP). If a query results in matches from the sister projects, users will be shown snippets from Wiktionary, Wikisource, Wikiquote and/or other projects. See [T162276](https://phabricator.wikimedia.org/T162276) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#srp_surv">https://discovery.wmflabs.org/metrics/#srp_surv</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
