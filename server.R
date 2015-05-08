library(readr)
library(xts)
library(reshape2)
library(shinySignals)
library(RColorBrewer)

shinyServer(function(input, output) {
  output$desktop_event_plot <- renderDygraph({
    dygraph_set <- dcast(data, formula = timestamp ~ action)
    dyOptions(
      dyLegend(
        dygraph(xts(dygraph_set[,-1], dygraph_set[,1]), main = "Desktop search events, by day",
              xlab = "Date", ylab = "Events"),
        labelsSeparateLines = TRUE
      ), strokeWidth = 2, colors = brewer.pal(3, "Set2")
    )
  })
})