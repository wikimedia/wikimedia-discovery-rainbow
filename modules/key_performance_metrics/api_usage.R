output$kpi_api_usage_series <- renderDygraph({
  smooth_level <- input$smoothing_kpi_api_usage
  start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
  api_usage <- split_dataset %>%
  {
    if (!is.na(start_date)) {
      lapply(., polloi::subset_by_date_range, from = start_date, to = Sys.Date() - 1)
    } else {
      .
    }
  } %>%
    dplyr::bind_rows(.id = "api") %>%
    tidyr::spread("api", "calls")
  if ( input$kpi_api_usage_series_include_open ) {
    api_usage <- dplyr::mutate(api_usage, all = cirrus + geo + language + open + prefix)
  } else {
    api_usage <- dplyr::mutate(api_usage, all = cirrus + geo + language + prefix)
  }
  if ( input$kpi_api_usage_series_data == "raw" ) {
    api_usage %<>%
      polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE) %>%
      { xts::xts(.[, -1], order.by = .$date) }
    if (!input$kpi_api_usage_series_include_open) {
      colnames(api_usage)[6] <- "all except open"
    }
    return(dygraph(api_usage, main = "Calls over time", xlab = "Date",
                   ylab = ifelse(input$kpi_api_usage_series_log_scale, "Calls (log10 scale)", "Calls")) %>%
             dySeries("cirrus", label = "full-text via API") %>%
             dyLegend(width = 400, show = "always") %>%
             dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(6, "Set2")[6:1],
                       drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                       includeZero = input$kpi_api_usage_series_log_scale,
                       logscale = input$kpi_api_usage_series_log_scale
             ) %>%
             dyCSS(css = system.file("custom.css", package = "polloi")) %>%
             dyRangeSelector %>%
             dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom"))
  }
  api_usage_change <- api_usage %>%
    dplyr::mutate(
      cirrus = polloi::percent_change(cirrus),
      geo = polloi::percent_change(geo),
      language = polloi::percent_change(language),
      open = polloi::percent_change(open),
      prefix = polloi::percent_change(prefix),
      all = polloi::percent_change(all)
    ) %>%
    { .[-1, ] } %>%
    polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE) %>%
    { xts::xts(.[, -1], .$date) }
  if (!input$kpi_api_usage_series_include_open) colnames(api_usage_change)[6] <- "all except open"
  return(dygraph(api_usage_change, main = "Day-to-day % change over time", xlab = "Date", ylab = "% change") %>%
           dyLegend(width = 400, show = "always") %>%
           dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(6, "Set2"),
                     drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE, includeZero = TRUE) %>%
           dyCSS(css = system.file("custom.css", package = "polloi")) %>%
           dyRangeSelector %>%
           dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom"))
})
