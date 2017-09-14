output$kpi_api_usage_series <- renderDygraph({
  start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
  api_usage <- split_dataset %>%
    dplyr::bind_rows(.id = "api") %>%
    dplyr::filter(referrer == "All") %>%
    dplyr::select(-referrer) %>%
    {
      if (!is.na(start_date)) {
        polloi::subset_by_date_range(., from = start_date, to = Sys.Date() - 1)
      } else {
        .
      }
    } %>%
    tidyr::spread("api", "calls") %>%
    dplyr::mutate(all = open + `full-text via API` + dplyr::if_else(is.na(`morelike via API`), 0, `morelike via API`) + geo + language + prefix) %>%
    polloi::reorder_columns()
  if (input$kpi_api_usage_series_prop) {
    api_usage <- cbind(api_usage[, "date"], purrr::map_df(api_usage[, -c(1, 2)], function(x) round(100 * x / api_usage$all, 2)))
  }
  if ( input$kpi_api_usage_series_data == "raw" ) {
    api_usage %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_kpi_api_usage)) %>%
      polloi::make_dygraph(xlab = "Date",
                           ylab = dplyr::case_when(
                             input$kpi_api_usage_series_prop ~ "API Calls Share (%)",
                             input$kpi_api_usage_series_log_scale ~ "Calls (log10 scale)",
                             TRUE ~ "API Calls"
                           ),
                           title = "Calls over time",
                           legend_name = "API Calls",
                           logscale = input$kpi_api_usage_series_log_scale) %>%
      dyLegend(labelsDiv = "kpi_api_usage_series_legend", width = 600) %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
  } else {
    cbind(api_usage[, "date"], purrr::map_df(api_usage[, -1], polloi::percent_change)) %>%
      { .[-1, ] } %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_kpi_api_usage)) %>%
      polloi::make_dygraph(xlab = "Date",
                           ylab = "% change",
                           title = "Day-to-day % change over time",
                           legend_name = "API Calls") %>%
      dyLegend(labelsDiv = "kpi_api_usage_series_legend", width = 600) %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
   }
})
