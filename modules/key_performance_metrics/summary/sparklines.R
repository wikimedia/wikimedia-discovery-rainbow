output$sparkline_load_time <- sparkline:::renderSparkline({
  if (input$kpi_summary_date_range_selector == "all") {
    output_sl <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data)
  } else {
    output_sl <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      lapply(polloi::subset_by_date_range, from = Sys.Date() - 91, to = Sys.Date() - 1)
  }
  output_sl <- output_sl %>%
    dplyr::bind_rows(.id = "platform") %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(Median = median(Median)) %>%
    dplyr::select(Median) %>%
    unlist(use.names = FALSE) %>%
    round(2)
  sl1 <- sparkline::sparkline(values = output_sl, type = "line",
                              height = 50, width = '100%',
                              lineColor = 'black', fillColor = 'transparent',
                              chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              highlightLineColor = 'orange', highlightSpotColor = 'orange')
  # highlight selected date range
  if (input$kpi_summary_date_range_selector == "weekly"){
    output_highlight <- c(rep(NA, length(output_sl)-7), output_sl[(length(output_sl)-6):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "monthly"){
    output_highlight <- c(rep(NA, length(output_sl)-30), output_sl[(length(output_sl)-29):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "quarterly"){
    output_highlight <- output_sl
  } else {
    return(sl1)
  }
  sl2 <- sparkline::sparkline(values = output_highlight, type = "line",
                              height = 50, width = '100%', lineWidth = 2,
                              lineColor = 'red', chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              minSpotColor = FALSE, maxSpotColor = FALSE, disableInteraction = TRUE,
                              highlightLineColor = NULL, highlightSpotColor = NULL)
  return(sparkline::spk_composite(sl1, sl2))
})
output$sparkline_zero_results <- sparkline:::renderSparkline({
  if (input$kpi_summary_date_range_selector == "all") {
    output_sl <- failure_data_with_automata
  } else {
    output_sl <- failure_data_with_automata %>%
      polloi::subset_by_date_range(from = Sys.Date() - 91, to = Sys.Date() - 1)
  }
  output_sl <- output_sl %>%
    dplyr::select(rate) %>%
    unlist(use.names = FALSE) %>%
    round(2)
  sl1 <- sparkline::sparkline(values = output_sl, type = "line",
                              height = 50, width = '100%',
                              lineColor = 'black', fillColor = 'transparent',
                              chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              highlightLineColor = 'orange', highlightSpotColor = 'orange')
  # highlight selected date range
  if (input$kpi_summary_date_range_selector == "weekly") {
    output_highlight <- c(rep(NA, length(output_sl)-7), output_sl[(length(output_sl)-6):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "monthly") {
    output_highlight <- c(rep(NA, length(output_sl)-30), output_sl[(length(output_sl)-29):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "quarterly") {
    output_highlight <- output_sl
  } else {
    return(sl1)
  }
  sl2 <- sparkline::sparkline(values = output_highlight, type = "line",
                              height = 50, width = '100%', lineWidth = 2,
                              lineColor = 'red', chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              minSpotColor = FALSE, maxSpotColor = FALSE, disableInteraction = TRUE,
                              highlightLineColor = NULL, highlightSpotColor = NULL)
  return(sparkline::spk_composite(sl1, sl2))
})
output$sparkline_api_usage <- sparkline:::renderSparkline({
  if (input$kpi_summary_date_range_selector == "all") {
    output_sl <- split_dataset
  } else {
    output_sl <- split_dataset %>%
      lapply(polloi::subset_by_date_range, from = Sys.Date() - 91, to = Sys.Date() - 1)
  }
  output_sl <- output_sl %>%
    dplyr::bind_rows(.id = "api") %>%
    dplyr::filter(referrer == "All") %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(total = sum(calls)) %>%
    dplyr::select(total) %>%
    unlist(use.names = FALSE)
  sl1 <- sparkline::sparkline(values = output_sl, type = "line",
                              height = 50, width = '100%',
                              lineColor = 'black', fillColor = 'transparent',
                              chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              highlightLineColor = 'orange', highlightSpotColor = 'orange')
  # highlight selected date range
  if (input$kpi_summary_date_range_selector == "weekly") {
    output_highlight <- c(rep(NA, length(output_sl)-7), output_sl[(length(output_sl)-6):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "monthly") {
    output_highlight <- c(rep(NA, length(output_sl)-30), output_sl[(length(output_sl)-29):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "quarterly") {
    output_highlight <- output_sl
  } else {
    return(sl1)
  }
  sl2 <- sparkline::sparkline(values = output_highlight, type = "line",
                              height = 50, width = '100%', lineWidth = 2,
                              lineColor = 'red', chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              minSpotColor = FALSE, maxSpotColor = FALSE, disableInteraction = TRUE,
                              highlightLineColor = NULL, highlightSpotColor = NULL)
  return(sparkline::spk_composite(sl1, sl2))
})
output$sparkline_augmented_clickthroughs <- sparkline:::renderSparkline({
  if(input$kpi_summary_date_range_selector == "all") {
    output_sl <- augmented_clickthroughs
  } else {
    output_sl <- augmented_clickthroughs %>%
      polloi::subset_by_date_range(from = Sys.Date() - 91, to = Sys.Date() - 1)
  }
  output_sl <- output_sl %>%
    dplyr::select(`User engagement`) %>%
    unlist(use.names = FALSE) %>%
    round(2)
  sl1 <- sparkline::sparkline(values = output_sl, type = "line",
                              height = 50, width = '100%',
                              lineColor = 'black', fillColor = 'transparent',
                              chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              highlightLineColor = 'orange', highlightSpotColor = 'orange')
  # highlight selected date range
  if (input$kpi_summary_date_range_selector == "weekly") {
    output_highlight <- c(rep(NA, length(output_sl)-7), output_sl[(length(output_sl)-6):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "monthly") {
    output_highlight <- c(rep(NA, length(output_sl)-30), output_sl[(length(output_sl)-29):length(output_sl)])
  } else if (input$kpi_summary_date_range_selector == "quarterly") {
    output_highlight <- output_sl
  } else {
    return(sl1)
  }
  sl2 <- sparkline::sparkline(values = output_highlight, type = "line",
                              height = 50, width = '100%', lineWidth = 2,
                              lineColor = 'red', chartRangeMin = min(output_sl), chartRangeMax = max(output_sl),
                              minSpotColor = FALSE, maxSpotColor = FALSE, disableInteraction = TRUE,
                              highlightLineColor = NULL, highlightSpotColor = NULL)
  return(sparkline::spk_composite(sl1, sl2))
})
