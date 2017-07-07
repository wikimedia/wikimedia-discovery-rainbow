output$desktop_event_searches <- renderValueBox(
  valueBox(
    value = desktop_dygraph_means["search sessions"],
    subtitle = "Tracked search sessions per day*",
    icon = icon("search"),
    color = "green"
  )
)

output$desktop_event_resultsets <- renderValueBox(
  valueBox(
    value = desktop_dygraph_means["Result pages opened"],
    subtitle = "Result pages opened per day*",
    icon = icon("list", lib = "glyphicon"),
    color = "green"
  )
)

output$desktop_event_clickthroughs <- renderValueBox(
  valueBox(
    value = desktop_dygraph_means["clickthroughs"],
    subtitle = "Clickthroughs per day*",
    icon = icon("hand-up", lib = "glyphicon"),
    color = "green"
  )
)


output$desktop_event_plot <- renderDygraph({
  desktop_dygraph_set %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_desktop_event)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Desktop search events, by day") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2016-07-12"), "A (schema switch)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
