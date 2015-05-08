Desktop search
=======

User actions that we track around search on the desktop website generally fall into three categories:

1. The start of a user's search session;
2. The presentation of the user with a results page, and;
3. A user clicking through to an article in the results page.

These three things are tracked via the [EventLogging 'search' schema](https://meta.wikimedia.org/wiki/Schema:Search), and stored to
a database. The results are then aggregated and anonymised, and presented on this page.

General trends
------
This is where text about what we're seeing will go. Obvious early things are "the result set to clickthroughs dropoff approximately follows the rule of 10" and "there's a biiig difference between search sessions and result sets". Dan, is this where the instability/unreliability you were talking about comes in?

Also: all of the text you're seeing here? Like, everything below the graph? It's a markdown document. Absolutely no code required to modify it outside markdown syntax.


Outages and inaccuracies
------
We can display outage information and notes here. Poetic justice being what it is, there was an eventlogging outage *as I was writing this*. So we'd have an entry like:

* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging)