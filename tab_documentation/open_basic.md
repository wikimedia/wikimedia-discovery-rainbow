OpenSearch API usage
=======

[OpenSearch](https://en.wikipedia.org/wiki/OpenSearch) is a search format optimised for syndication and aggregation.
MediaWiki has OpenSearch support, and so does its API; that's what's tracked here. OpenSearch allows you to retrieve
full content as well as snippets, and allows you to *search* full content for your search term.

General trends
------

There's not enough data to be able to say much about the patterns inherrent to OpenSearch usage right now, but it's clear from comparing
the results to other types of search event that OpenSearch is the most commonly used search format.

Outages and inaccuracies
------

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#open_search">
    http://discovery.wmflabs.org/metrics/#open_search
  </a>
</p>
