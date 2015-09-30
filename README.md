# Search Metrics Dashboard

This project is part of the [Discovery Dashboards](http://searchdata.wmflabs.org/) project.

## Quick start

Install the dependencies:

```
$ R
R> install.packages(c('reshape2', 'ggplot2', 'toOrdinal', 'devtools'))
R> devtools::install_git('https://gerrit.wikimedia.org/r/wikimedia/discovery/polloi')
```

Run the server:

```
$ R
R> shiny::runApp(launch.browser = 0)
```

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
