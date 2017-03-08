Full-text Search via API usage
=======

What we're talking about is "full text" search; searching for a particular
term via the API and getting back packages that contain that term in either the title *or* the page's content.

General trends
------

There's not enough data to be able to say much about the patterns inherrent to Full-text Search (via API) usage right now, but it's interesting to compare the values found to how much other search API forms are used. Full-text sits near the top of the pack; Open Search is used dramatically more, but everything else somewhat (or very much) less.

Outages and inaccuracies
------

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details. Furthermore, we switched to an updated UDF for counting API calls -- the previous version was undercounting full-text and geo search API calls (see [Gerrit change 315503](https://gerrit.wikimedia.org/r/#/c/315503/) for more details).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#fulltext_search">
    http://discovery.wmflabs.org/metrics/#fulltext_search
  </a>
</p>
