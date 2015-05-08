library(readr)
library(xts)
library(reshape2)
library(shinySignals)
library(RColorBrewer)

desktop_dygraph_set <- dcast(data, formula = timestamp ~ action)
desktop_dygraph_means <- round(colMeans(desktop_dygraph_set[,2:4]))
shinyServer(function(input, output) {
  
  output$desktop_event_searches <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )
  
  output$desktop_event_resultsets <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$desktop_event_clickthroughs <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )
  
  #The dynamic graphs of events on desktop
  output$desktop_event_plot <- renderDygraph({
    dyCSS(
      dyOptions(
        dyLegend(
          dygraph(xts(desktop_dygraph_set[,-1], desktop_dygraph_set[,1]), main = "Desktop search events, by day",
                xlab = "Date", ylab = "Events"),
          width = 400, show = "onmouseover"
        ), strokeWidth = 3, colors = brewer.pal(3, "Set2")
      )
    ,css = "./assets/css/custom.css")
  })
})