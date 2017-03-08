Automated survival analysis: page visit times
=======

This shows the length of time that must pass before we lose N% of the test population. In general, it appears it takes 15s to lose 10%, 25-35s to lose 25%, and 55-75s to lose 50%. When the number goes up, we can infer that users are staying on the pages longer.

On most days, we retain at least 20% of the test population past the 7 minute mark (the point at which the user's browser stops checking in), so on those days we cannot calculate the time it takes to lose 90/95/99% of the users.

There are some days when we CAN calculate those times, and it can take anywhere between 270s (4m30s) and 390s (6m30s) for 90% of the users to have closed the page they clicked through from the search results page.

Outages and inaccuracies
------
* '__R__': on 2017-01-01 we started calculating all of Discovery's metrics using a new version of [our data retrieval and processing codebase](https://phabricator.wikimedia.org/diffusion/WDGO/) that we migrated to [Wikimedia Analytics](https://www.mediawiki.org/wiki/Analytics)' [Reportupdater infrastructure](https://wikitech.wikimedia.org/wiki/Analytics/Reportupdater). See [T150915](https://phabricator.wikimedia.org/T150915) for more details.

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Deb](mailto:deb@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#survival">
    http://discovery.wmflabs.org/metrics/#survival
  </a>
</p>
