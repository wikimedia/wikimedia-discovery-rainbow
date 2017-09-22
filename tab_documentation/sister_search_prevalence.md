Sister project search results prevalence
=======
Sister project (cross-wiki) snippets is a feature that adds search results from sister projects of Wikipedia to a sidebar on the search engine results page (SERP). If a query results in matches from the sister projects, users will be shown snippets from Wiktionary, Wikisource, Wikiquote and/or other projects. See [T162276](https://phabricator.wikimedia.org/T162276) for more details.

General trends
-----
* English Wikipedia has the highest prevalence with 75% of searches showing sister project results on average, followed by Chinese (73%) and French (70%) Wikipedias.
* 38% of languages show the sister project results in at least 50% of the searches made.

Notes, outages, and inaccuracies
-----
* English Wikipedia has a different display than all the other languages due to community feedback. Specifically, it does not show results from Commons/multimedia, Wikinews, and Wikiversity. Refer to [T162276#3278689](https://phabricator.wikimedia.org/T162276#3278689) for more details.
* Languages without a lot of traffic also yield less (sampled) event logging data. In order to show somewhat-reliable numbers, languages with less than 20 recorded searches per day were excluded. Data on them is still available, though.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#sister_search_prevalence">https://discovery.wmflabs.org/metrics/#sister_search_prevalence</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
  | Data available at <a href="https://analytics.wikimedia.org/datasets/discovery/" title="Specifically: metrics/search/sister_search_traffic.tsv">Wikimedia Analytics</a>
</p>
