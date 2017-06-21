Desktop full-text search
=======

User actions that we track around search on the desktop website generally fall into three categories:

1. The start of a user's search session;
2. The presentation of the user with a results page, and;
3. A user clicking through to an article in the results page.

These three things are tracked via the [EventLogging 'TestSearchSatisfaction2' schema](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2) (previously '[Search](https://meta.wikimedia.org/wiki/Schema:Search)', see note "A"), and stored to
a database. The results are then aggregated and anonymised, and presented on this page. For performance/privacy reasons we randomly sample what we store, so the actual numbers are a vast understatement of how many user actions our servers receive - what's more interesting is how they change over time. In the case of desktop search, this sampling rate varies by project (see [T163273](https://phabricator.wikimedia.org/T163273) for more details), but does not change day-to-day.

\* This number represents the median of the last 90 days.

Outages and inaccuracies
------
There are occasionally going to be outages that will affect the accuracy of data. To make it easier to rely on the data (or not!) they are listed here, from most- to least-recent.

* Between 2 October 2015 and 28 October 2015 we were not logging any events from the Search schema. There was a change in core that broke the code being inserted into pages. Those pages were cached into varnish so an alternate solution had to be taken. that was delayed because of deployment freezes. The change in core only broke it because the way the code was added from our side was technically wrong, but happened to work anyways.
* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).
* Data in late September/early October 2015 is unavailable due to another bug in EventLogging as a whole, which impacted data collection.
* '__A__': we switched to using data from [Schema:TestSearchSatisfaction2](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2) instead of [Schema:Search](https://meta.wikimedia.org/wiki/Schema:Search) for Desktop event counts and load times on 12 July 2016.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#desktop_events">https://discovery.wmflabs.org/metrics/#desktop_events</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
