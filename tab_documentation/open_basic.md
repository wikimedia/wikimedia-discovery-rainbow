OpenSearch API usage
=======

[OpenSearch](https://en.wikipedia.org/wiki/OpenSearch) is a search format optimised for syndication and aggregation. MediaWiki has OpenSearch support, and so does its API; that's what's tracked here. OpenSearch allows you to retrieve full content as well as snippets, and allows you to *search* full content for your search term.

On this dashboard, we breakdown API calls by the following class of referrer:

* **None** is direct traffic that has empty referrer header. 
* **Internal** is traffic referred by Wikimedia sites, specifically: mediawiki.org, wikibooks.org, wikidata.org, wikinews.org, wikimedia.org, wikimediafoundation.org, wikipedia.org, wikiquote.org, wikisource.org, wikiversity.org, wikivoyage.org, and wiktionary.org (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/Webrequest.java$212-223) for more information.).
* **Search engine** is traffic referred by Google, Bing, Yandex, Yahoo, DuckDuckGo or Baidu (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/SearchEngineClassifier.java$41) for more information.).
* **Unknown** is traffic that does not have a HTTP referrer or has unusual referrer header (See [Webrequest source](https://phabricator.wikimedia.org/diffusion/ANRS/browse/master/refinery-core/src/main/java/org/wikimedia/analytics/refinery/core/Webrequest.java$189-211) for more information.).
* **External** is traffic referred by something other than search engine.

For overall break down by referrer class, see [http://discovery.wmflabs.org/metrics/#referer_breakdown](http://discovery.wmflabs.org/metrics/#referer_breakdown); for overall breakdown by search request type, see [http://discovery.wmflabs.org/metrics/#api_usage](http://discovery.wmflabs.org/metrics/#api_usage).

General findings
------

* Almost all of the open search are done on desktop. We have more traffic during the weekdays because users generally spend more time on their desktop on weekdays.

Outages and inaccuracies
------

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.
* '__U__': on 2017-06-29 we started to use a new UDF to get the type of search API (see [Gerrit change 345863](https://gerrit.wikimedia.org/r/#/c/345863/) for more details) and break down the API calls by referer class.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#open_search">https://discovery.wmflabs.org/metrics/#open_search</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
