use_proportion <- function(data, use_prop) {
  if (use_prop) {
    return(cbind(data[, "date"], purrr::map_df(data[, -c(1, 2)], function(x) round(100 * x / data$All, 2))) %>%
             dplyr::filter(date >= "2017-06-29"))
  } else{
    return(data)
  }
}

output$cirrus_aggregate <- renderDygraph({
  split_dataset$`full-text via API` %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$fulltext_search_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_fulltext_search)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$fulltext_search_prop ~ "API Calls Share (%)",
                           input$fulltext_search_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily Full-text search via API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$fulltext_search_log_scale) %>%
    dyLegend(labelsDiv = "cirrus_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$morelike_aggregate <- renderDygraph({
  split_dataset$`morelike via API` %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$morelike_search_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_morelike_search)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$morelike_search_prop ~ "API Calls Share (%)",
                           input$morelike_search_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily Morelike search API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$morelike_search_log_scale) %>%
    dyLegend(labelsDiv = "morelike_aggregate_legend", width = 600) %>%
    dyRangeSelector
})

output$open_aggregate <- renderDygraph({
  split_dataset$open %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$open_search_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_open_search)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$open_search_prop ~ "API Calls Share (%)",
                           input$open_search_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily OpenSearch API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$open_search_log_scale) %>%
    dyLegend(labelsDiv = "open_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$geo_aggregate <- renderDygraph({
  split_dataset$geo %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$geo_search_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geo_search)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$geo_search_prop ~ "API Calls Share (%)",
                           input$geo_search_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily Geo Search API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$geo_search_log_scale) %>%
    dyLegend(labelsDiv = "geo_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$language_aggregate <- renderDygraph({
  split_dataset$language %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$language_search_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_language_search)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$language_search_prop ~ "API Calls Share (%)",
                           input$language_search_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily Language search API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$language_search_log_scale) %>%
    dyLegend(labelsDiv = "language_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$prefix_aggregate <- renderDygraph({
  split_dataset$prefix %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$prefix_search_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prefix_search)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$prefix_search_prop ~ "API Calls Share (%)",
                           input$prefix_search_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily Prefix search API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$prefix_search_log_scale) %>%
    dyLegend(labelsDiv = "prefix_aggregate_legend", width = 600) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$referer_breakdown_plot <- renderDygraph({
  split_dataset %>%
    dplyr::bind_rows(.id = "api") %>%
    dplyr::group_by(date, referrer) %>%
    dplyr::summarize(calls = sum(calls, na.rm = TRUE)) %>%
    dplyr::ungroup() %>%
    tidyr::spread(referrer, calls) %>%
    polloi::reorder_columns() %>%
    use_proportion(input$referer_breakdown_prop) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_referer_breakdown)) %>%
    polloi::make_dygraph(xlab = "Date",
                         ylab = dplyr::case_when(
                           input$referer_breakdown_prop ~ "API Calls Share (%)",
                           input$referer_breakdown_log_scale ~ "Calls (log10 scale)",
                           TRUE ~ "API Calls"
                         ),
                         title = "Daily API usage by referrer",
                         legend_name = "API Calls",
                         logscale = input$referer_breakdown_log_scale) %>%
    dyLegend(labelsDiv = "referer_breakdown_plot_legend", width = 600) %>%
    dyRangeSelector
})
