# Search Metrics Dashboard

This project is part of the [Discovery Dashboards](https://discovery.wmflabs.org/) project, using datasets publicly available at [analytics.wikimedia.org/datasets/discovery](https://analytics.wikimedia.org/datasets/discovery/). For more information on the datasets, refer to [README on the GitHub mirror](https://github.com/wikimedia/wikimedia-discovery-golden/blob/master/docs/README.md).

## Quick start

Install the dependencies:

```R
install.packages(c("devtools", "shiny", "reshape2", "data.table"))
devtools::install_git("https://gerrit.wikimedia.org/r/wikimedia/discovery/polloi")
```

Run the app:

```R
shiny::runApp(launch.browser = 0)
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
