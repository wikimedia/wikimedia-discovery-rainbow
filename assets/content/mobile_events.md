Mobile search
=======

User actions that we track around search on the mobile website generally fall into three categories:

1. The start of a user's search session;
2. The presentation of the user with a results page, and;
3. A user clicking through to an article in the results page.

These three things are tracked via the [EventLogging 'MobileWebSearch' schema](https://meta.wikimedia.org/wiki/Schema:MobileWebSearch), and stored to a database. The results are then aggregated and anonymised, and presented on this page. For performance/privacy reasons we randomly sample what we store, so the actual numbers are a vast understatement of how many user actions our servers receive - what's more interesting is how they change over time. In the case of Mobile Web search, this sampling rate is *going* to be **0.1%**: it's currently turned off entirely but should be enabled soon.

General trends
------
It's hard to tell because we have too little data and there's clearly something screwy in the data we're provided with.


Outages and inaccuracies
------
There are occasionally going to be outages that will affect the accuracy of data. To make it easier to rely on the data (or not!) they are listed here, from most- to least-recent.

* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).
