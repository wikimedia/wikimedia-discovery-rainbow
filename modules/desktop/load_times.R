output$desktop_load_plot <- renderDygraph({
  desktop_load_data %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_desktop_load)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Desktop load times, by day", use_si = FALSE) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2016-07-12"), "A (schema switch)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-15"), "B (sister search)", labelLoc = "bottom")
})
