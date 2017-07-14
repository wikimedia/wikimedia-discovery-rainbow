output$android_load_plot <- renderDygraph({
  android_load_data %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_load)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Android result load times, by day", use_si = FALSE) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})

output$ios_load_plot <- renderDygraph({
  ios_load_data %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_load)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "iOS result load times, by day", use_si = FALSE) %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
