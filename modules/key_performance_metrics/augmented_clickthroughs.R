output$kpi_augmented_clickthroughs_series <- renderDygraph({
  start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
  smoothed_data <- augmented_clickthroughs %>%
  {
    if (!is.na(start_date)) {
      polloi::subset_by_date_range(., from = start_date, to = Sys.Date())
    } else {
      .
    }
  } %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_augmented_clickthroughs))
  polloi::make_dygraph(data = smoothed_data, xlab = "Date", ylab = "Rates", "User engagement (augmented clickthroughs) by day") %>%
    dySeries(name = colnames(smoothed_data)[2], strokeWidth = 1.5, strokePattern = "dashed") %>%
    dySeries(name = colnames(smoothed_data)[3], strokeWidth = 1.5, strokePattern = "dashed") %>%
    dyLegend(labelsDiv = "kpi_augmented_clickthroughs_series_legend") %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom") %>%
    dyEvent(as.Date("2016-07-12"), "A (schema switch)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-05-10"), "B (iOS bug fix)", labelLoc = "bottom")
})
