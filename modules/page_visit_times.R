output$lethal_dose_plot <- renderDygraph({
  req(length(input$filter_lethal_dose_plot) > 0)
  user_page_visit_dataset[, c("date", input$filter_lethal_dose_plot)] %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_lethal_dose_plot), rename = FALSE) %>%
    polloi::make_dygraph(xlab = "", ylab = "Time (s)", title = "Time at which N% users leave the visited page") %>%
    dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter, axisLabelWidth = 100, pixelsPerLabel = 80) %>%
    dyRoller(rollPeriod = input$rolling_lethal_dose_plot) %>%
    dyLegend(labelsDiv = "lethal_dose_plot_legend", width = 600) %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-04-25"), "S (rates)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-07-19"), "B (bug fixed)", labelLoc = "bottom")
})

output$srp_ld_plot <- renderDygraph({
  req(length(input$filter_srp_ld_plot) > 0 && length(input$language_srp_ld_plot) > 0)
  serp_page_visit_dataset[, c("date", "language", input$filter_srp_ld_plot)] %>%
    tidyr::gather(LD, time, -c(date, language)) %>%
    dplyr::filter(language %in% input$language_srp_ld_plot) %>%
    dplyr::transmute(date = date, time = time, label = paste0(LD, " (", language, ")")) %>%
    tidyr::spread(label, time) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_srp_ld_plot), rename = FALSE) %>%
    polloi::make_dygraph(xlab = "", ylab = "Time (s)", title = "Time at which N% users leave the search results page") %>%
    dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter, axisLabelWidth = 100, pixelsPerLabel = 80) %>%
    dyRoller(rollPeriod = input$rolling_srp_ld_plot) %>%
    dyLegend(labelsDiv = "srp_ld_plot_legend", width = 600) %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2017-04-25"), "S (sampling rates)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-15"), "SS (sister search)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-07-05"), "B (bug fixed)", labelLoc = "bottom")
})
