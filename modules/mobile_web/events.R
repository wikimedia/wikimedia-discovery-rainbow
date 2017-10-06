output$mobile_event_user_session <- renderValueBox(
  valueBox(
    value = mobile_session_mean["Total user sessions"],
    subtitle = "User sessions per day*",
    icon = icon("search"),
    color = "green"
  )
)

output$mobile_event_searches <- renderValueBox(
  valueBox(
    value = mobile_dygraph_means["search start"],
    subtitle = "Search sessions per day*",
    icon = icon("search"),
    color = "green"
  )
)

output$mobile_event_resultsets <- renderValueBox(
  valueBox(
    value = mobile_dygraph_means["Result pages opened"],
    subtitle = "Result pages opened per day*",
    icon = icon("list", lib = "glyphicon"),
    color = "green"
  )
)

output$mobile_event_clickthroughs <- renderValueBox(
  valueBox(
    value = mobile_dygraph_means["clickthroughs"],
    subtitle = "Clickthroughs per day*",
    icon = icon("hand-up", lib = "glyphicon"),
    color = "green"
  )
)

output$mobile_event_plot <- renderDygraph({
  mobile_dygraph_set %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_mobile_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Mobile search events, by day") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-03-29"), "H (new header)", labelLoc = "bottom")
})

output$mobile_session_plot <- renderDygraph({
  mobile_session %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_mobile_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Mobile user sessions, by volume") %>%
    dyRangeSelector
})
