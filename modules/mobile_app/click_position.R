output$click_position_plot <- renderDygraph({
  position_prop %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_click_position)) %>%
    polloi::make_dygraph(xlab = "", ylab = "Proportion of Clicks (%)", title = "Proportion of Clicks on Nth Result") %>%
    dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
    dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
           axisLabelWidth = 100, pixelsPerLabel = 80) %>%
    dyLegend(labelsDiv = "app_click_position_legend") %>%
    dyRangeSelector(fillColor = "", strokeColor = "")
})
