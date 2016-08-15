Zero Rate for Search Suggestions
=======

With a lot of "full-text" searches, the system provides not only results but also suggestions - corrections for typos, for example. These are more prominent with searches that returned few or no results, for fairly obvious reasons (if the suggestion is being provided it's because the system thinks you got something wrong).

This graph shows the zero results rate for searches with suggestions, compared to the zero results rate for full-text searches overall.

Notes
------

* __Anotation "A"__: On 13 April 2016 we switched to a new data format for zero results rate (see [T132503](https://phabricator.wikimedia.org/T132503)) wherein we stopped lumping in different query types into just two categories ("Full-Text Search" and "Prefix Search"). The ZRR data were backfilled from 1 February 2016 under the new format which breaks down ZRR into the individual query types. We also began filtering out irrelevant query types (see [T131196#2200560](https://phabricator.wikimedia.org/T131196#2200560)) and requests with unknown number of hits ("-1" in the database).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#failure_suggestions">
    http://discovery.wmflabs.org/metrics/#failure_suggestions
  </a>
</p>
