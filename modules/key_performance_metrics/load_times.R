output$kpi_load_time_series <- renderDygraph({
  smooth_level <- input$smoothing_kpi_load_time
  date_range <- input$kpi_summary_date_range_selector
  start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector,
                                    all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
  load_times <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
  {
    if (!is.na(start_date)) {
      lapply(., polloi::subset_by_date_range, from = start_date, to = Sys.Date() - 1)
    } else {
      .
    }
  } %>%
    lapply(function(data_tail) return(data_tail[, c('date', 'Median')])) %>%
    { names(.) <- c("Desktop", "Mobile Web", "Android", "iOS"); . } %>%
    dplyr::bind_rows(.id = "Platform") %>%
    unique %>%
    tidyr::spread('Platform', 'Median')
  missing_values <- any(is.na(load_times))
  load_times %<>%
  {
    Median = apply(.[, -1], 1, median, na.rm = TRUE)
    cbind(., Median = Median)
  } %>%
    polloi::smoother(smooth_level = ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE) %>%
    { xts::xts(.[, -1], order.by = .[, 1]) }
  return(dygraph(load_times, xlab = "Date", ylab = "Load time (ms)",
                 main = ifelse(missing_values, "Approximate load times over time", "Load times over time")) %>%
           dySeries("Median", axis = 'y', strokeWidth = 4, label = "Cross-platform Median") %>%
           dyLegend(width = 500, show = "always", labelsDiv = "kpi_load_time_series_legend") %>%
           dyOptions(strokeWidth = 2, colors = RColorBrewer::brewer.pal(5, "Set2")[5:1],
                     drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                     includeZero = TRUE) %>%
           dyCSS(css = system.file("custom.css", package = "polloi")) %>%
           dyRangeSelector %>%
           dyEvent(as.Date("2016-07-12"), "A (schema switch)", labelLoc = "bottom") %>%
           dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
           dyEvent(as.Date("2017-06-15"), "B (sister search)", labelLoc = "bottom"))
})
