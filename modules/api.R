output$cirrus_aggregate <- renderDygraph({
  split_dataset$`full-text via API` %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_fulltext_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Full-text search API usage by referrer", legend_name = "Searches") %>%
    dyLegend(labelsDiv = "cirrus_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$morelike_aggregate <- renderDygraph({
  split_dataset$`morelike via API` %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_morelike_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Morelike search API usage by referrer", legend_name = "Searches") %>%
    dyLegend(labelsDiv = "morelike_aggregate_legend", width = 600) %>%
    dyRangeSelector
})

output$open_aggregate <- renderDygraph({
  split_dataset$open %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_open_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily OpenSearch API usage by referrer", legend_name = "Searches") %>%
    dyLegend(labelsDiv = "open_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$geo_aggregate <- renderDygraph({
  split_dataset$geo %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geo_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Geo Search API usage by referrer", legend_name = "Searches") %>%
    dyLegend(labelsDiv = "geo_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$language_aggregate <- renderDygraph({
  split_dataset$language %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_language_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Language search API usage by referrer", legend_name = "Searches") %>%
    dyLegend(labelsDiv = "language_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$prefix_aggregate <- renderDygraph({
  split_dataset$prefix %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prefix_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Prefix search API usage by referrer", legend_name = "Searches") %>%
    dyLegend(labelsDiv = "prefix_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$referer_breakdown_plot <- renderDygraph({
  temp <- split_dataset %>%
    dplyr::bind_rows(.id = "api") %>%
    dplyr::filter(date >= "2017-06-29") %>%
    dplyr::group_by(date, referrer) %>%
    dplyr::summarize(calls = sum(calls, na.rm = TRUE)) %>%
    tidyr::spread(referrer, calls)
  if (input$referer_breakdown_prop) {
    temp <- cbind(temp$date, purrr::map_df(temp[, -c(1, 2)], function(x) round(100 * x / temp$All, 2)))
  }
  temp %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_referer_breakdown)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = ifelse(input$referer_breakdown_prop, "API Calls Share (%)", "API Calls"),
                         title = "Daily API usage by referrer", legend_name = "API Calls") %>%
    dyLegend(labelsDiv = "referer_breakdown_plot_legend", width = 600) %>%
    dyRangeSelector
})
