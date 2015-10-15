Prefix Search API usage
=======

Prefix Search is simply run over page titles, and lets a user find pages that start with ("prefix") a particular term. This is tremendously useful and is where the dropdown box in Wikipedia's user-facing search comes from. It's also exposed via the API, and hits to that service are what we're tracking here.

General trends
------

Prefix Search isn't tremendously used, which makes sense; for external services, the cost of making the call to us is too high to provide seamless dropdowns in the fashion we can on Wikipedia proper.

Outages and inaccuracies
------

  * None so far!

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#prefix_search">
    http://discovery.wmflabs.org/metrics/#prefix_search
  </a>
</p>
