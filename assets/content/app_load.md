Desktop result load times
=======

When a user types in a search query, it's sent off to the servers which identify and rank probable articles and then return them in a list. In an ideal world this would be instantaneous, but realistically, even with all the caching in the world it's going to take *some* time.

One of the things we anonymously track is how long it takes search results to be provided to the user, after they've sent the request. Here we're displaying the median, the 95th percentile and the 99th percentile.

Due to a bug in the iOS EventLogging system, iOS events are currently being tracked much more frequently than Android ones and so are displayed in a different graph to avoid confusion.


General trends
------

Outages and inaccuracies
------
There are occasionally going to be outages that will affect the accuracy of data. To make it easier to rely on the data (or not!) they will be listed here, from most- to least-recent.

* Between 5 May and 6 May 2015, approximately 40% of incoming EventLogging data was lost due to a wider EventLogging outage. You can read more about the outage [here](https://wikitech.wikimedia.org/wiki/Incident_documentation/20150506-EventLogging).
* A bug in the app implementation led to the clocks being off, hence some claims of -38000 seconds as a completion time. This is now patched.
