output$mobile_event_searches <- renderValueBox(
  valueBox(
    value = mobile_dygraph_means["search sessions"],
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
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
