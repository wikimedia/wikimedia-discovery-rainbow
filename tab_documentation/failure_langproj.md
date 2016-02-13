Usage and Zero Results Rate by Languages and Projects
=======

Sometimes, searches return zero results. What we're visualising here is the percentage of the time
a search query returns zero results, split out by language (e.g. English vs Russian) and project (e.g. Wikipedia vs Wiktionary). For each arbitrary combination, the zero results rate is the overall rate (full-text AND prefix, web AND api). Due to the high number of language-project combinations, we have restricted ourselves to only storing the last 30 days of data.

Notes/Tips
------
* The percentages next to the language and project names represent the proportion of the total volume.
* The language picker will automatically choose "(None)" if you select a non-multilingual project such as Wikidata.
* If you're interested in the overall ZRR for a multilingual project such as Wikipedia, make sure only "(None)" is selected in the languages picker.

Outages and inaccuracies
------
* On 15 January 2016 there was an [issue](https://phabricator.wikimedia.org/T123541) with Avro serialization that prevented data from entering the Hadoop cluster. A [patch](https://gerrit.wikimedia.org/r/#/c/264989/) was deployed on 19 January 2016. As a result, there are no recorded zero results rates for 01/15-01/19. The values you may see on those dates are estimates computed with [statistical models](https://github.com/bearloga/branch/blob/master/zero%20results%20rate%20estimation/report.pdf).

Questions, bug reports, and feature suggestions
------
For technical, non-bug questions, [email Mikhail](mailto:mpopov@wikimedia.org?subject=Dashboard%20Question). If you experience a bug or notice something wrong or have a suggestion, [open a ticket in Phabricator](https://phabricator.wikimedia.org/maniphest/task/create/?projects=Discovery) in the Discovery board or [email Dan](mailto:dgarry@wikimedia.org?subject=Dashboard%20Question).

<hr style="border-color: gray;">
<p style="font-size: small; color: gray;">
  <strong>Link to this dashboard:</strong>
  <a href="http://discovery.wmflabs.org/metrics/#failure_breakdown">
    http://discovery.wmflabs.org/metrics/#failure_breakdown
  </a>
</p>
