Mobile web search
=======

User actions that we track around prefix search on the mobile website generally fall into three categories:

1. **search start (aka search session)**: An API request is being made to retrieve search results whenever the user types enough characters to perform a search (3 or more). A search session is identified by searchSessionToken. For example, if a user types "Bara", then a new search session is started; if they then type "ck" (Barack), then a new search session is started;
2. **Result pages opened**: The API request has finished and the results have been rendered;
3. **clickthroughs**: A user clicking through to an article in the results page.

When a user opens the search overlay, a **user session** start. We use a random generated userSessionToken to identify this search funnel. A user session can have multiple search sessions. We split user sessions into “low volume”, "medium volume" and “high-volume” sessions. A “high-volume” session is a user session whose search sessions are equal to or greater than the 90th percentile for the whole population on any particular day. A “low-volume” session is a user session whose search sessions are equal to or less than the 5th percentile. The rest are categorized as "medium-volume".

We use the [EventLogging 'MobileWebSearch' schema](https://meta.wikimedia.org/wiki/Schema:MobileWebSearch) to track these activities, and stored to a database. Currently the schema tracks prefix search only. The results are then aggregated and anonymised, and presented on this page. For performance/privacy reasons we randomly sample what we store, so the actual numbers are a vast understatement of how many user actions our servers receive - what's more interesting is how they change over time. In the case of Mobile Web search, this sampling rate is **0.1%**.

\* This number represents the median of the last 90 days.

General trends
------

It's hard to tell because we have too little data and there's clearly something screwy in the data we're provided with.

Outages and inaccuracies
------

There are occasionally going to be outages that will affect the accuracy of data. To make it easier to rely on the data (or not!) they are listed here, from most- to least-recent.

* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.
* '__H__': on 2017-03-29 we deployed the new mobile header treatment (including the search box) which may result in the decrease of search. See [T176464](https://phabricator.wikimedia.org/T176464) for more information.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question) or [Chelsy](mailto:cxie@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small;">
  <strong>Link to this dashboard:</strong> <a href="https://discovery.wmflabs.org/metrics/#mobile_events">https://discovery.wmflabs.org/metrics/#mobile_events</a>
  | Page is available under <a href="https://creativecommons.org/licenses/by-sa/3.0/" title="Creative Commons Attribution-ShareAlike License">CC-BY-SA 3.0</a>
  | <a href="https://phabricator.wikimedia.org/diffusion/WDRN/" title="Search Metrics Dashboard source code repository">Code</a> is licensed under <a href="https://phabricator.wikimedia.org/diffusion/WDRN/browse/master/LICENSE.md" title="MIT License">MIT</a>
  | Part of <a href="https://discovery.wmflabs.org/">Discovery Dashboards</a>
</p>
