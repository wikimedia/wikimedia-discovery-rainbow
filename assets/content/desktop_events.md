Desktop search
=======

User actions that we track around search on the desktop website generally fall into three categories:

1. The start of a user's search session;
2. The presentation of the user with a results page, and;
3. A user clicking through to an article in the results page.

These three things are tracked via the [EventLogging 'search' schema](https://meta.wikimedia.org/wiki/Schema:Search), and stored to
a database. The results are then aggregated and anonymised, and presented on this page. For performance/privacy reasons we randomly sample what we store, so the actual numbers are a vast understatement of how many user actions our servers receive - what's more interesting is how they change over time. In the case of desktop search, this sampling rate is **0.1%**.

General trends
------
This is where text about what we're seeing will go. Obvious early things are "the result set to clickthroughs dropoff approximately follows the rule of 10" and "there's a biiig difference between search sessions and result sets". Dan, is this where the instability/unreliability you were talking about comes in?

Also: all of the text you're seeing here? Like, everything below the graph? It's a markdown document. Absolutely no code required to modify it outside markdown syntax.


Outages and inaccuracies
------
There are occasionally going to be outages that will affect the accuracy of data. To make it easier to rely on the data (or not!) they are listed here, from most- to least-recent.

* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Oliver](mailto:okeyes@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong, [create an issue on GitHub](https://github.com/Ironholds/rainbow/issues). If you have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://searchdata.wmflabs.org/metrics/#desktop_events">
    http://searchdata.wmflabs.org/metrics/#desktop_events
  </a>
</p>
