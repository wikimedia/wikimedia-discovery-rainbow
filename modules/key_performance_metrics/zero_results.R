output$kpi_zero_results_series <- renderDygraph({
  smooth_level <- input$smoothing_kpi_zero_results
  start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
  zrr <- failure_data_with_automata %>%
  {
    if (!is.na(start_date)) {
      polloi::subset_by_date_range(., from = start_date, to = Sys.Date())
    } else {
      .
    }
  } %>%
    transform(`Rate` = rate)
  zrr_change <- 100 * (zrr$Rate[2:nrow(zrr)] - zrr$Rate[1:(nrow(zrr)-1)])/zrr$Rate[1:(nrow(zrr)-1)]
  zrr <- cbind(zrr[, c('date', 'Rate')], Change = c(NA, zrr_change)) %>%
    polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE)
  zrr <- xts::xts(zrr[, -1], zrr[, 1])
  return(dygraph(zrr, main = "Zero results rate over time", xlab = "Date",
                 ylab = "% of search queries that yield zero results") %>%
           dySeries("Change", axis = 'y2', label = "Day-to-day % change", strokeWidth = 1) %>%
           dyLimit(limit = 12.50, label = "Goal: 12.50% zero results rate",
                   color = RColorBrewer::brewer.pal(3, "Set2")[3]) %>%
           dyAxis("y2", label = "Day-to-day % change",
                  valueRange = c(-1, 1) * max(max(abs(as.numeric(zrr$Change)), na.rm = TRUE), 10),
                  axisLineColor = RColorBrewer::brewer.pal(3, "Set2")[2],
                  axisLabelColor = RColorBrewer::brewer.pal(3, "Set2")[2],
                  independentTicks = TRUE, drawGrid = FALSE,
                  axisLabelFormatter = "function(x) { return x + '%'; }",
                  valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
           dyAxis("y", drawGrid = FALSE,
                  axisLineColor = RColorBrewer::brewer.pal(3, "Set2")[1],
                  axisLabelColor = RColorBrewer::brewer.pal(3, "Set2")[1],
                  axisLabelFormatter = "function(x) { return x + '%'; }",
                  valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
           dyLimit(limit = 0, color = RColorBrewer::brewer.pal(3, "Set2")[2], strokePattern = "dashed") %>%
           dyLegend(width = 400, show = "always") %>%
           dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(3, "Set2"),
                     drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                     includeZero = TRUE) %>%
           dyCSS(css = system.file("custom.css", package = "polloi")) %>%
           dyRangeSelector(fillColor = "") %>%
           dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
           dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom") %>%
           dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom"))
})
