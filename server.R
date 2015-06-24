#Version 0.1.1
source("utils.R")

existing_date <- (Sys.Date()-1)

#Read in desktop data and generate means for the value boxes, along with a time-series appropriate form for
#dygraphs.
read_desktop <- function(){
  data <- download_set("desktop_event_counts.tsv")
  interim <- reshape2::dcast(data, formula = timestamp ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  desktop_dygraph_set <<- interim
  desktop_dygraph_means <<- round(colMeans(desktop_dygraph_set[,2:5]))

  data <- download_set("desktop_load_times.tsv")
  desktop_load_data <<- data
  return(invisible())
}

read_web <- function(){
  data <- download_set("mobile_event_counts.tsv")
  interim <- reshape2::dcast(data, formula = timestamp ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  mobile_dygraph_set <<- interim
  mobile_dygraph_means <<- round(colMeans(mobile_dygraph_set[,2:4]))

  mobile_load_data <<- download_set("mobile_load_times.tsv")
  return(invisible())
}

read_apps <- function(){
  data <- download_set("app_event_counts.tsv")

  ios <- reshape2::dcast(data[data$platform == "iOS",], formula = timestamp ~ action, fun.aggregate = sum)
  android <- reshape2::dcast(data[data$platform == "Android",], formula = timestamp ~ action, fun.aggregate = sum)
  ios_dygraph_set <<- ios
  ios_dygraph_means <<- round(colMeans(ios[,2:4]))

  android_dygraph_set <<- android
  android_dygraph_means <<- round(colMeans(android[,2:4]))

  app_load_data <- download_set("app_load_times.tsv")
  ios_load_data <<- app_load_data[app_load_data$platform == "iOS",]
  android_load_data <<- app_load_data[app_load_data$platform == "Android",]

  return(invisible())
}

read_api <- function(){
  data <- download_set("search_api_aggregates.tsv")
  data <- data[order(data$event_type),]
  split_dataset <<- split(data, f = data$event_type)
  return(invisible())
}

read_failures <- function(date){
  data <- download_set("cirrus_query_aggregates.tsv")
  interim_data <- reshape2::dcast(data, formula = date ~ variable, fun.aggregate = sum)
  failure_dygraph_set <<- interim_data
  return(invisible())
}

shinyServer(function(input, output) {

  if(Sys.Date() != existing_date){
    read_desktop()
    read_apps()
    read_web()
    read_api()
    read_failures(existing_date)
    existing_date <<- Sys.Date()
  }

  #Desktop value boxes
  output$desktop_event_searches <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means[4],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )

  output$desktop_event_resultsets <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means[3],
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
  output$desktop_event_plot <- make_dygraph(
    desktop_dygraph_set, "Date", "Events",
    "Desktop search events, by day"
  )
  output$desktop_load_plot <- make_dygraph(
    desktop_load_data, "Date", "Load time (ms)",
    "Desktop result load times, by day"
  )

  #Mobile value boxes
  output$mobile_event_searches <- renderValueBox(
    valueBox(
      value = mobile_dygraph_means[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )

  output$mobile_event_resultsets <- renderValueBox(
    valueBox(
      value = mobile_dygraph_means[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )

  output$mobile_event_clickthroughs <- renderValueBox(
    valueBox(
      value = mobile_dygraph_means[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )

  #Mobile plots
  output$mobile_event_plot <- make_dygraph(
    mobile_dygraph_set, "Date", "Events",
    "Mobile search events, by day"
  )
  output$mobile_load_plot <- make_dygraph(
    mobile_load_data, "Date", "Load time (ms)",
    "Mobile result load times, by day"
  )

  #App value boxes
  output$app_event_searches <- renderValueBox(
    valueBox(
      value = android_dygraph_means[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )

  output$app_event_resultsets <- renderValueBox(
    valueBox(
      value = android_dygraph_means[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )

  output$app_event_clickthroughs <- renderValueBox(
    valueBox(
      value = android_dygraph_means[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )

  #App plots
  output$android_event_plot <- make_dygraph(
    android_dygraph_set, "Date", "Events",
    "Android mobile app search events, by day"
  )
  output$android_load_plot <- make_dygraph(
    android_load_data, "Date", "Load time (ms)",
    "Android result load times, by day"
  )
  output$ios_event_plot <- make_dygraph(
    ios_dygraph_set, "Date", "Events",
    "iOS mobile app search events, by day"
  )
  output$ios_load_plot <- make_dygraph(
    ios_load_data, "Date", "Load time (ms)",
    "iOS result load times, by day"
  )

  #API plots
  output$cirrus_aggregate <- make_dygraph(
    split_dataset[[1]], "Date", "Events",
    "Cirrus Search API usage by day", TRUE
  )
  output$open_aggregate <- make_dygraph(
    split_dataset[[4]], "Date", "Events",
    "OpenSearch API usage by day", TRUE
  )
  output$geo_aggregate <- make_dygraph(
    split_dataset[[2]], "Date", "Events",
    "Geo Search API usage by day", TRUE
  )
  output$language_aggregate <- make_dygraph(
    split_dataset[[3]], "Date", "Events",
    "Language Search API usage by day", TRUE
  )
  output$prefix_aggregate <- make_dygraph(
    split_dataset[[5]], "Date", "Events",
    "Language Search API usage by day", TRUE
  )

  #Failure plots
  output$failure_rate_plot <- make_dygraph(
    failure_dygraph_set, "Date", "Queries",
    "Search Queries with Zero Results, by day"
  )
})
