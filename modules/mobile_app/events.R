output$app_event_searches <- renderValueBox(
  valueBox(
    value = ios_dygraph_means["search sessions"] + android_dygraph_means["search sessions"],
    subtitle = "Search sessions per day*",
    icon = icon("search"),
    color = "green"
  )
)

output$app_event_resultsets <- renderValueBox(
  valueBox(
    value = ios_dygraph_means["Result pages opened"] + android_dygraph_means["Result pages opened"],
    subtitle = "Result pages opened per day*",
    icon = icon("list", lib = "glyphicon"),
    color = "green"
  )
)

output$app_event_clickthroughs <- renderValueBox(
  valueBox(
    value = ios_dygraph_means["clickthroughs"] + android_dygraph_means["clickthroughs"],
    subtitle = "Clickthroughs per day*",
    icon = icon("hand-up", lib = "glyphicon"),
    color = "green"
  )
)

output$android_event_plot <- renderDygraph({
  android_dygraph_set %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Android mobile app search events, by day") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})

output$android_ctr_plot <- renderDygraph({
  android_dygraph_set %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(`Clickthrough rate` = 100 * sum(clickthroughs, na.rm = TRUE) / sum(`Result pages opened`, na.rm = TRUE)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Clickthrough Rate (%)", title = "Android search clickthrough rate, by day") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})

output$ios_event_plot <- renderDygraph({
  ios_dygraph_set %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "iOS mobile app search events, by day") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-05-10"), "F (iOS bug fix)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-06-19"), "D (remove debounce delay)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-09-10"), "B (bug)", labelLoc = "bottom")
})

output$ios_ctr_plot <- renderDygraph({
  ios_dygraph_set %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(`Clickthrough rate` = 100 * sum(clickthroughs, na.rm = TRUE) / sum(`Result pages opened`, na.rm = TRUE)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Clickthrough Rate (%)", title = "iOS search clickthrough rate, by day") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-05-10"), "F (iOS bug fix)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-06-19"), "D (remove debounce delay)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-09-10"), "B (bug)", labelLoc = "bottom")
})
