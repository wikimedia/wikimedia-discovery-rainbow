output$invoke_source_plot <- renderDygraph({
  source_prop %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_invoke_source)) %>%
    polloi::make_dygraph(xlab = "", ylab = "Proportion of Search Sessions (%)", title = "Proportion of Search Sessions, by Invoke Source") %>%
    dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
    dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
           axisLabelWidth = 100, pixelsPerLabel = 80) %>%
    dyLegend(labelsDiv = "app_invoke_source_legend") %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
