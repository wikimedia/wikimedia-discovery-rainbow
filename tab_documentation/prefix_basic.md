Prefix Search API usage
=======

Prefix Search is simply run over page titles, and lets a user find pages that start with ("prefix") a particular term. This is tremendously useful and is where the dropdown box in Wikipedia's user-facing search comes from. It's also exposed via the API, and hits to that service are what we're tracking here.

General trends
------

Prefix Search isn't tremendously used, which makes sense; for external services, the cost of making the call to us is too high to provide seamless dropdowns in the fashion we can on Wikipedia proper.

Notes
------
* After learning of a change to the search API call, we patched the Analytics Hive UDF refinery (see [287264](https://gerrit.wikimedia.org/r/#/c/287264/)) to check for generator=prefixsearch as well, not just list=prefixsearch. The data was backfilled from 20 March 2016 using the updated Prefix API detection.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#prefix_search">
    http://discovery.wmflabs.org/metrics/#prefix_search
  </a>
</p>
