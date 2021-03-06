Mobile App search
=======

User actions that we track around search on the mobile apps generally fall into three categories:

1. **search sessions**: The start of a user's search session;
2. **Result pages opened**: The presentation of the user with a results page, and;
3. **clickthroughs**: A user clicking through to an article in the results page.
4. **Clickthrough Rate**: Total number of clickthroughs divided by the number of result pages opened.

These three things are tracked via the [EventLogging 'MobileWikiAppSearch' schema](https://meta.wikimedia.org/wiki/Schema:MobileWikiAppSearch), and stored to a database. The results are then aggregated and anonymised, and presented on this page. For performance/privacy reasons we randomly sample what we store, so the actual numbers are a vast understatement of how many user actions our servers receive - what's more interesting is how they change over time. In the case of app search, this sampling rate is **1%**.

Due to differences in sample rate, iOS events are currently being tracked much more frequently than Android ones and so are displayed in a different graph to avoid confusion.

\* This number represents the median of the last 90 days.

Notes
------
* There is a spike in events on 2 June 2015 because of a release of the iOS app that added search logging. This has been [confirmed](https://phabricator.wikimedia.org/T102098) by a mobile apps software engineer.

* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.
* '__F__': on 2018-05-10 the iOS app fixed a bug which prevent search events being sent to [MobileWikiAppSearch](https://meta.wikimedia.org/wiki/Schema:MobileWikiAppSearch) and adjust the sampling rate to 100%. See [T192520](https://phabricator.wikimedia.org/T192520) for more details. Please note that the iOS app only collects data from users who agree to share their usage report with us.
* '__D__': on 2018-06-19 v5.8.2 of the iOS app was released. This version speeds up searches by removing pre-search debounce delay (see [T192494](https://phabricator.wikimedia.org/T192494)) so users will get more SRPs as they type.
* '__B__': on 2018-09-10 v6.0.1 of the iOS app was released. We started to use a new search eventlogging schema, but a bug stopped the events from being sent to the server (see [T195937](https://phabricator.wikimedia.org/T195937) and [T205551](https://phabricator.wikimedia.org/T205551)). The fix will be released in v6.1.

Outages and inaccuracies
------
* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#app_events">https://discovery.wmflabs.org/metrics/#app_events</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
