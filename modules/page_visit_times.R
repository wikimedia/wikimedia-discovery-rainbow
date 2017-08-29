output$lethal_dose_plot <- renderDygraph({
  user_page_visit_dataset %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_lethal_dose_plot)) %>%
    polloi::make_dygraph(xlab = "", ylab = "Time (s)", title = "Time at which we have lost N% of the users") %>%
    dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
           axisLabelWidth = 100, pixelsPerLabel = 80) %>%
    dyLegend(labelsDiv = "lethal_dose_plot_legend") %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-04-25"), "S (rates)", labelLoc = "bottom")
})
