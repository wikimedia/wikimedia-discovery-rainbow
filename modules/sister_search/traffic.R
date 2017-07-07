output$sister_search_traffic_plot <- renderDygraph({
  # Code that prepares a custom data.frame 'sst'
  # that will then be processed in a generic way:
  if (length(input$sister_search_traffic_split) == 0) {
    sst <- sister_search_traffic %>%
      dplyr::mutate(split = "Sister search traffic")
  } else {
    split_by <- head(input$sister_search_traffic_split, 2)
    sst <- sister_search_traffic
    if ("language" %in% split_by) {
      sst <- dplyr::filter(sst, !is.na(language))
    }
    if ("destination" %in% split_by) {
      sst <- dplyr::mutate(sst, destination = dplyr::if_else(is_serp, "Search results page", "Article"))
    }
    if (length(split_by) == 1) {
      sst$split <- sst[[split_by[1]]]
    } else {
      sst$split <- paste0(sst[[split_by[1]]], " (", sst[[split_by[2]]], ")")
    }
  }
  # Code that works on the prepared dataet:
  sst %>%
    dplyr::group_by(date, split) %>%
    dplyr::summarize(pageviews = sum(pageviews)) %>%
    tidyr::spread(split, pageviews, fill = 0) %>%
    {
      # Reorder columns according to the last observed values:
      cols <- unlist(polloi::safe_tail(., 1)[, -1])
      .[, c(1, order(cols, decreasing = TRUE) + 1)]
    } %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_sister_search_traffic_plot), rename = FALSE) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Pageviews", title = "Traffic to sister projects from Wikipedia SERPs") %>%
    dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
           axisLabelWidth = 100, pixelsPerLabel = 80) %>%
    dyLegend(labelsDiv = "sister_search_traffic_plot_legend") %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2017-06-15"), "A (deployed)", labelLoc = "bottom")
})
