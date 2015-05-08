library(readr)
library(xts)

shinyServer(function(input, output) {
  output$desktop_event_plot <- renderDygraph(
    dygraph(xts(data, data$timestamp), main = "example dygraph", group = "action")
  )
})