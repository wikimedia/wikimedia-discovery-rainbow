# Search Metrics Dashboard - ARCHIVED

This codebase is part of the legacy [Discovery Dashboards](https://discovery.wmflabs.org/) project. It is kept for archival purposes. It was maintained by [Mikhail Popov](https://meta.wikimedia.org/wiki%2fUser%3aMPopov_%28WMF%29).

## Quick start

Install the dependencies:

```R
install.packages(c("remotes", "shiny", "reshape2", "data.table"))
remotes::install_git("https://gerrit.wikimedia.org/r/wikimedia/discovery/polloi")
```

Run the app:

```R
shiny::runApp(launch.browser = 0)
```

Please note that this project is licensed under [MIT License](LICENSE.md) and released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms. [Wikimedia technical spaces code of conduct](https://www.mediawiki.org/wiki/Special:MyLanguage/Code_of_Conduct) also applies.
