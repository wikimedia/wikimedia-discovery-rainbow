library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)

data_env <- new.env()
assign("existing_date", Sys.Date()-1, envir = data_env)

read_desktop <- function(){
  #download.file()
  data <- readr::read_delim("./data/desktop_event_counts.tsv", delim = "\t")
  assign("desktop_dygraph_set", reshape2::dcast(data, formula = timestamp ~ action), envir = data_env)
  assign("desktop_dygraph_means", round(colMeans(get("desktop_dygraph_set", envir = data_env)[,2:4])),
         envir = data_env)
  assign("desktop_load_data", readr::read_delim("./data/desktop_load_times.tsv", delim = "\t"),
         envir = data_env)
  return(invisible())
}

read_web <- function(){
  #download.file()
  data <- readr::read_delim("./data/mobile_event_counts.tsv", delim = "\t")
  assign("mobile_dygraph_set", reshape2::dcast(data, formula = timestamp ~ action), envir = data_env)
  assign("mobile_dygraph_means", round(colMeans(get("mobile_dygraph_set", envir = data_env)[,2:4])),
         envir = data_env)
  assign("mobile_load_data", readr::read_delim("./data/mobile_load_times.tsv", delim = "\t"),
         envir = data_env)
  return(invisible())
}

read_apps <- function(){
  #download.file()
  data <- readr::read_delim("./data/app_event_counts.tsv", delim = "\t")
  assign("app_dygraph_set", reshape2::dcast(data, formula = timestamp ~ action), envir = data_env)
  assign("app_dygraph_means", round(colMeans(get("app_dygraph_set", envir = data_env)[,2:4])),
         envir = data_env)
  assign("app_load_data", readr::read_delim("./data/app_load_times.tsv", delim = "\t"),
         envir = data_env)
  return(invisible())
}

shinyServer(function(input, output) {
  
  if(Sys.Date() != get("existing_date", envir = data_env)){
    read_desktop()
    read_apps()
    read_web()
    assign("existing_date", Sys.Date(), envir = data_env)
  }
  
  output$desktop_event_searches <- renderValueBox(
    valueBox(
      value = get("desktop_dygraph_means", envir= data_env)[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )
  
  output$desktop_event_resultsets <- renderValueBox(
    valueBox(
      value = get("desktop_dygraph_means", envir= data_env)[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$desktop_event_clickthroughs <- renderValueBox(
    valueBox(
      value = get("desktop_dygraph_means", envir= data_env)[1],
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
          dygraph(xts(get("desktop_dygraph_set", envir= data_env)[,-1],
                      get("desktop_dygraph_set", envir= data_env)[,1]),
                  main = "Desktop search events, by day",
                xlab = "Date", ylab = "Events"),
          width = 400, show = "onmouseover"
        ), strokeWidth = 3, colors = brewer.pal(3, "Set2"),
        drawPoints = TRUE, pointSize = 3
      )
    ,css = "./assets/css/custom.css")
  })
  
  output$desktop_load_plot <- renderDygraph({
    dyCSS(
      dyOptions(
        dyLegend(
          dygraph(xts(get("desktop_load_data", envir= data_env)[,-1],
                      get("desktop_load_data", envir= data_env)[,1]),
                  main = "Desktop result load times, by day",
                  xlab = "Date", ylab = "Events"),
          width = 400, show = "onmouseover"
        ), strokeWidth = 3, colors = brewer.pal(4, "Set2"),
        drawPoints = TRUE, pointSize = 3
      )
      ,css = "./assets/css/custom.css")
  })
  
  output$mobile_event_plot <- renderDygraph({
    dyCSS(
      dyOptions(
        dyLegend(
          dygraph(xts(get("mobile_dygraph_set", envir= data_env)[,-1],
                      get("mobile_dygraph_set", envir= data_env)[,1]),
                  main = "Mobile search events, by day",
                  xlab = "Date", ylab = "Events"),
          width = 400, show = "onmouseover"
        ), strokeWidth = 3, colors = brewer.pal(3, "Set2"),
        drawPoints = TRUE, pointSize = 3
      )
      ,css = "./assets/css/custom.css")
  })
  
  output$mobile_event_searches <- renderValueBox(
    valueBox(
      value = get("mobile_dygraph_means", envir= data_env)[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )
  
  output$mobile_event_resultsets <- renderValueBox(
    valueBox(
      value = get("mobile_dygraph_means", envir= data_env)[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$mobile_event_clickthroughs <- renderValueBox(
    valueBox(
      value = get("mobile_dygraph_means", envir= data_env)[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$mobile_load_plot <- renderDygraph({
    dyCSS(
      dyOptions(
        dyLegend(
          dygraph(xts(get("mobile_load_data", envir= data_env)[,-1],
                      get("mobile_load_data", envir= data_env)[,1]),
                  main = "Mobile result load times, by day",
                  xlab = "Date", ylab = "Events"),
          width = 400, show = "onmouseover"
        ), strokeWidth = 3, colors = brewer.pal(3, "Set2"),
        drawPoints = TRUE, pointSize = 3
      )
      ,css = "./assets/css/custom.css")
  })
})