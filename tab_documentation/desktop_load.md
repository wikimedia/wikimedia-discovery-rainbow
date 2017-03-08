Desktop full-text result load times
=======

When a user types in a search query, it's sent off to the servers which identify and rank probable articles and then return them in a list. In an ideal world this would be instantaneous, but realistically, even with all the caching in the world it's going to take *some* time.

One of the things we anonymously track is how long it takes search results to be provided to the user, after they've sent the request. Here we're displaying the mean, or average, the median, the 95th percentile and the 99th percentile. A caveat when interpreting the results is that the mean may sometimes be *higher* than the 99th percentile, in the case that that last percentile consists of requests that take a truly ludicrously long time to display. *Caveat emptor*.

General trends
------

Load times for results are remarkably consistent, absent the situation, mentioned above, where a tiny number of users face a really slow service. Other than that, there's little interesting to see here unless we decide to start focusing specifically on speeding up the service.

Outages and inaccuracies
------
There are occasionally going to be outages that will affect the accuracy of data. To make it easier to rely on the data (or not!) they will be listed here, from most- to least-recent.

* Between 2 October 2015 and 28 October 2015 we were not logging any events from the Search schema. There was a change in core that broke the code being inserted into pages. Those pages were cached into varnish so an alternate solution had to be taken. that was delayed because of deployment freezes. The change in core only broke it because the way the code was added from our side was technically wrong, but happened to work anyways.
* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).
* Data in late September/early October 2015 is unavailable due to another bug in EventLogging as a whole, which impacted data collection.
* '__A__': we switched to using data from [Schema:TestSearchSatisfaction2](https://meta.wikimedia.org/wiki/Schema:TestSearchSatisfaction2) instead of [Schema:Search](https://meta.wikimedia.org/wiki/Schema:Search) for Desktop event counts and load times on 12 July 2016.
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#desktop_load">
    http://discovery.wmflabs.org/metrics/#desktop_load
  </a>
</p>
