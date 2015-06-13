library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)
source("utils.R")

data_env <- new.env()
assign("existing_date", Sys.Date()-1, envir = data_env)

read_desktop <- function(){
  data <- download_set("http://datasets.wikimedia.org/aggregate-datasets/search/desktop_event_counts.tsv")
  interim <- reshape2::dcast(data, formula = timestamp ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  assign("desktop_dygraph_set", interim, envir = data_env)
  assign("desktop_dygraph_means", round(colMeans(get("desktop_dygraph_set", envir = data_env)[,2:4])),
         envir = data_env)
  
  data <- download_set("http://datasets.wikimedia.org/aggregate-datasets/search/desktop_load_times.tsv")
  assign("desktop_load_data", data,
         envir = data_env)
  return(invisible())
}

read_web <- function(){
  con <- url("http://datasets.wikimedia.org/aggregate-datasets/search/mobile_event_counts.tsv")
  data <- readr::read_delim(con, delim = "\t")
  interim <- reshape2::dcast(data, formula = timestamp ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  assign("mobile_dygraph_set", interim, envir = data_env)
  assign("mobile_dygraph_set", reshape2::dcast(data, formula = timestamp ~ action, fun.aggregate = sum), envir = data_env)
  assign("mobile_dygraph_means", round(colMeans(get("mobile_dygraph_set", envir = data_env)[,2:4])),
         envir = data_env)
  con <- url("http://datasets.wikimedia.org/aggregate-datasets/search/mobile_load_times.tsv")
  assign("mobile_load_data", readr::read_delim(con, delim = "\t"),
         envir = data_env)
  return(invisible())
}

read_apps <- function(){
  con <- url("http://datasets.wikimedia.org/aggregate-datasets/search/app_event_counts.tsv")
  data <- readr::read_delim(con, delim = "\t")
  interim <- reshape2::dcast(data, formula = timestamp ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  assign("app_dygraph_set", interim, envir = data_env)
  assign("app_dygraph_means", round(colMeans(get("app_dygraph_set", envir = data_env)[,2:4])),
         envir = data_env)
  con <- url("http://datasets.wikimedia.org/aggregate-datasets/search/app_load_times.tsv")
  assign("app_load_data", readr::read_delim(con, delim = "\t"),
         envir = data_env)
  return(invisible())
}

read_failures <- function(date){
  con <- url("http://datasets.wikimedia.org/aggregate-datasets/search/cirrus_query_aggregates.tsv")
  data <- readr::read_delim(con, delim = "\t")
  interim_data <- reshape2::dcast(data, formula = date ~ variable, fun.aggregate = sum)
  assign("failure_dygraph_set", interim_data, envir = data_env)
  
#   date <- gsub(x = date, pattern = "-", replacement="")
#   con <- url(paste0("http://datasets.wikimedia.org/aggregate-datasets/search/daily_pages/zero_resulting_queries",
#                     date, ".tsv"))
#   data <- readr::read_delim(con, delim = "\t")
#   assign("failure_table_set", data, envir = data_env)
}

shinyServer(function(input, output) {
  
  if(Sys.Date() != get("existing_date", envir = data_env)){
    read_desktop()
    read_apps()
    read_web()
    read_failures(get("existing_date", envir = data_env))
    assign("existing_date", Sys.Date(), envir = data_env)
  }
  
  #Desktop value boxes
  output$desktop_event_searches <- renderValueBox(
    valueBox(
      value = get("desktop_dygraph_means", envir = data_env)[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )
  
  output$desktop_event_resultsets <- renderValueBox(
    valueBox(
      value = get("desktop_dygraph_means", envir = data_env)[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$desktop_event_clickthroughs <- renderValueBox(
    valueBox(
      value = get("desktop_dygraph_means", envir = data_env)[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )
  
  #The dynamic graphs of events on desktop
  output$desktop_event_plot <- make_dygraph(
    get("desktop_dygraph_set", envir = data_env), "Date", "Events",
    "Desktop search events, by day"
  )
  output$desktop_load_plot <- make_dygraph(
    get("desktop_load_data", envir = data_env), "Date", "Load time (ms)",
    "Desktop result load times, by day"
  )
  
  
  #Mobile value boxes
  output$mobile_event_searches <- renderValueBox(
    valueBox(
      value = get("mobile_dygraph_means", envir = data_env)[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )
  
  output$mobile_event_resultsets <- renderValueBox(
    valueBox(
      value = get("mobile_dygraph_means", envir = data_env)[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$mobile_event_clickthroughs <- renderValueBox(
    valueBox(
      value = get("mobile_dygraph_means", envir = data_env)[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )
  
  #Mobile plots
  output$mobile_event_plot <- make_dygraph(
    get("mobile_dygraph_set", envir = data_env), "Date", "Events",
    "Mobile search events, by day"
  )
  output$mobile_load_plot <- make_dygraph(
    get("mobile_load_data", envir = data_env), "Date", "Load time (ms)",
    "Mobile result load times, by day"
  )
  
  #App value boxes
  output$app_event_searches <- renderValueBox(
    valueBox(
      value = get("app_dygraph_means", envir = data_env)[3],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )
  
  output$app_event_resultsets <- renderValueBox(
    valueBox(
      value = get("app_dygraph_means", envir = data_env)[2],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )
  
  output$app_event_clickthroughs <- renderValueBox(
    valueBox(
      value = get("app_dygraph_means", envir = data_env)[1],
      subtitle = "Clickthroughs per day",
      icon = icon("hand-up", lib = "glyphicon"),
      color = "green"
    )
  )
  
  #App plots
  output$app_event_plot <- make_dygraph(
    get("app_dygraph_set", envir = data_env), "Date", "Events",
    "Mobile App search events, by day"
  )
  output$app_load_plot <- make_dygraph(
    get("app_load_data", envir = data_env), "Date", "Load time (ms)",
    "Mobile App result load times, by day"
  )
  
  #Failure plots
  output$failure_rate_plot <- make_dygraph(
    get("failure_dygraph_set", envir = data_env), "Date", "Queries",
    "Search Queries with Zero Results, by day"
  )
})