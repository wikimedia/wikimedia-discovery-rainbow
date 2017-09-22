Key Performance Indicator: API usage
=======

We want people, both within our movement and outside it, to be able to easily access our information. This dashboard break down API usage by search request type. For more information about each type of request, see the following dashboards:

* [Full-text search](http://discovery.wmflabs.org/metrics/#fulltext_search): searching for a particular term via the API and getting back packages that contain that term in either the title or the page's content (see [Help:CirrusSearch](https://www.mediawiki.org/wiki/Help:CirrusSearch#Full_text_search) for more details).
* [Morelike search](http://discovery.wmflabs.org/metrics/#morelike_search): morelike is a feature of CirrusSearch that is used in extensions like [RelatedArticles](https://www.mediawiki.org/wiki/Extension:RelatedArticles) (see [Help:CirrusSearch](https://www.mediawiki.org/wiki/Help:CirrusSearch#Morelike) for more details).
* [Open search](http://discovery.wmflabs.org/metrics/#open_search): [OpenSearch](https://en.wikipedia.org/wiki/OpenSearch) is a search format optimised for syndication and aggregation.
* [Geo search](http://discovery.wmflabs.org/metrics/#geo_search): Geo Search, or Geographic Search, refers to the ability to search for pages that are “near” a particular set of geographic coordinates, in the sense of being about subjects that have physical locations we track (see [Help:CirrusSearch](https://www.mediawiki.org/wiki/Help:CirrusSearch#Geo_Search) for more details).
* [Prefix search](http://discovery.wmflabs.org/metrics/#prefix_search): Prefix Search is simply run over page titles, and lets a user find pages that start with (“prefix”) a particular term.
* [Language search](http://discovery.wmflabs.org/metrics/#language_search): Language search allows you to search for a particular language name in different scripts.

For overall break down by referrer class, see [http://discovery.wmflabs.org/metrics/#referer_breakdown](http://discovery.wmflabs.org/metrics/#referer_breakdown).

General findings
------

* About 56% of all API calls are morelike search which is used by RelatedArticles on mobile. We have more traffic during the weekends since users generally spend more time on their mobile devices on weekends.
* About 22% of all API calls are open search on desktop. The usage is higher on weekdays like we see in other desktop usage pattern.
* About 14% of all API calls are prefix search. And about 75% of prefix search via API are done on mobile.
* About 8% of all API calls are full-text search. And about 80% of full-text search via API are from bots.

Outages and inaccuracies
------

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details. Furthermore, we switched to an updated UDF for counting API calls -- the previous version was undercounting full-text and geo search API calls (see [Gerrit change 315503](https://gerrit.wikimedia.org/r/#/c/315503/) for more details).
* '__U__': on 2017-06-29 we started to use a new UDF to get the type of search API (see [Gerrit change 345863](https://gerrit.wikimedia.org/r/#/c/345863/) for more details).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#kpi_api_usage">https://discovery.wmflabs.org/metrics/#kpi_api_usage</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
