output$mobile_load_plot <- renderDygraph({
  mobile_load_data %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_mobile_load)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Mobile search events, by day", use_si = FALSE) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
