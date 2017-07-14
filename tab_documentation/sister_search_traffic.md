<p style="text-align: right; font-size: small; color: #737373;">
  <span><strong>*</strong> Users can click on a cross-wiki result or view all the results at the sister project</span>
  <br>
  <span><strong>†</strong> This excludes the language-less Wikimedia Commons</span>
</p>

Sister project search results traffic
=======
Sister project (cross-wiki) snippets is a feature that adds search results from sister projects of Wikipedia to a sidebar on the search engine results page (SERP). If a query results in matches from the sister projects, users will be shown snippets from Wiktionary, Wikisource, Wikiquote and/or other projects. See [T162276](https://phabricator.wikimedia.org/T162276) for more details.

When viewing traffic split by project, these statistics include all languages and any click into a sister project snippet (either article or more results). Also, these are actual pageviews, not events from event logging.

Notes, outages, and inaccuracies
-----
* English Wikipedia has a different display than all the other languages due to community feedback. Specifically, it does not show results from Commons/multimedia, Wikinews, and Wikiversity. Refer to [T162276#3278689](https://phabricator.wikimedia.org/T162276#3278689) for more details.
* Some projects (e.g. French and Catalan Wikipedias) use a [community-developed sister project search sidebar](https://simple.wiktionary.org/wiki/Module:Sister_project), which is why we see some sister traffic before the deployment of the sister search feature across all Wikipedias.
* Wikisource had a unknown spike on 22 June 2017 that slightly skews that project's results and overall results for that day. Specifically, we calculated 5129 pageviews on Desktop from English Wikipedia, which is an extreme outlier that we removed and imputed.
* '__A__': [on 2017-06-15](https://lists.wikimedia.org/pipermail/discovery/2017-June/001536.html) we deployed the sister search feature to all Wikipedia in all languages.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#sister_search_traffic">https://discovery.wmflabs.org/metrics/#sister_search_traffic</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
  | Data available at <a href="https://analytics.wikimedia.org/datasets/discovery/" title="Specifically: metrics/search/sister_search_traffic.tsv">Wikimedia Analytics</a>
</p>
