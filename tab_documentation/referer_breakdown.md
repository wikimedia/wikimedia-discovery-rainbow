API Calls by Referrer Class
=======

All types of API calls are aggregated by date and the following referrer class:

* **None** is direct traffic that has empty referrer header. 
* **Internal** is traffic referred by Wikimedia sites, specifically: mediawiki.org, wikibooks.org, wikidata.org, wikinews.org, wikimedia.org, wikimediafoundation.org, wikipedia.org, wikiquote.org, wikisource.org, wikiversity.org, wikivoyage.org, and wiktionary.org (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/Webrequest.java$212-223) for more information.).
* **Search engine** is traffic referred by Google, Bing, Yandex, Yahoo, DuckDuckGo or Baidu (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/SearchEngineClassifier.java$41) for more information.).
* **Unknown** is traffic that does not have a HTTP referrer or has unusual referrer header (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/Webrequest.java$189-211) for more information.).
* **External** is traffic referred by something other than search engine.

For overall breakdown by search request type, see [http://discovery.wmflabs.org/metrics/#kpi_api_usage](http://discovery.wmflabs.org/metrics/#kpi_api_usage).

General findings
------

* About 50% of API calls are internal traffic. 63% of internal traffic are from mobile web and the rest 37% are from desktop.
* About 49% of API calls are direct traffic. 73% of direct traffic are from mobile (apps and mobile web) and the rest 27% are from desktop.

Outages and inaccuracies
------

On 2017-06-29 we started to break down the API calls by referer class. 

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#referer_breakdown">https://discovery.wmflabs.org/metrics/#referer_breakdown</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
