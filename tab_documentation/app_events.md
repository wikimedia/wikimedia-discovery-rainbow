Mobile App search
=======

User actions that we track around search on the mobile apps generally fall into three categories:

1. The start of a user's search session;
2. The presentation of the user with a results page, and;
3. A user clicking through to an article in the results page.

These three things are tracked via the [EventLogging 'MobileWikiAppSearch' schema](https://meta.wikimedia.org/wiki/Schema:MobileWikiAppSearch), and stored to a database. The results are then aggregated and anonymised, and presented on this page. For performance/privacy reasons we randomly sample what we store, so the actual numbers are a vast understatement of how many user actions our servers receive - what's more interesting is how they change over time. In the case of app search, this sampling rate is **1%**.

Due to a bug in the iOS EventLogging system, iOS events are currently being tracked much more frequently than Android ones and so are displayed in a different graph to avoid confusion.

\* This number represents the median of the last 90 days.

Notes
------
* There is a spike in events on 2 June 2015 because of a release of the iOS app that added search logging. This has been [confirmed](https://phabricator.wikimedia.org/T102098) by a mobile apps software engineer.

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Outages and inaccuracies
------
* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#app_events">
    http://discovery.wmflabs.org/metrics/#app_events
  </a>
</p>
