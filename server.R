#Version 0.2.0
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

  interim_vector <- interim_data$`Zero Result Queries`/interim_data$`Search Queries`
  output_vector <- numeric(length(interim_vector)-1)
  for(i in 2:nrow(interim_data)){
    output_vector[i-1] <- interim_vector[i] - interim_vector[i-1]
  }

  failure_roc_dygraph_set <<- data.frame(date = interim_data$date[2:nrow(interim_data)],
                                         variable = "failure ROC",
                                         change_by_week = output_vector*100,
                                         stringsAsFactors = FALSE)

  interim_breakdown_data <- download_set("cirrus_query_breakdowns.tsv")
  interim_breakdown_data$value <- interim_breakdown_data$value*100
  failure_breakdown_dygraph_set <<- reshape2::dcast(interim_breakdown_data,
                                                    formula = date ~ variable, fun.aggregate = sum)

  suggestion_data <- download_set("cirrus_suggestion_breakdown.tsv")
  suggestion_data$variable <- "Full-Text with Suggestions"
  suggestion_data$value <- suggestion_data$value*100
  suggestion_data <- rbind(suggestion_data,
                           interim_breakdown_data[interim_breakdown_data$date %in% suggestion_data$date
                                                  & interim_breakdown_data$variable == "Full-Text Search",])
  suggestion_dygraph_set <<- reshape2::dcast(suggestion_data,
                                             formula = date ~ variable, fun.aggregate = sum)
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
    "Desktop result load times, by day", use_si = FALSE
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
    "Mobile result load times, by day", use_si = FALSE
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
    "Android result load times, by day", use_si = FALSE
  )
  output$ios_event_plot <- make_dygraph(
    ios_dygraph_set, "Date", "Events",
    "iOS mobile app search events, by day"
  )
  output$ios_load_plot <- make_dygraph(
    ios_load_data, "Date", "Load time (ms)",
    "iOS result load times, by day", use_si = FALSE
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
    "Prefix Search API usage by day", TRUE
  )

  #Failure plots
  output$failure_rate_plot <- make_dygraph(
    failure_dygraph_set, "Date", "Queries",
    "Search Queries with Zero Results, by day"
  )
  output$failure_rate_change_plot <- make_dygraph(
    failure_roc_dygraph_set, "Date", "Change (%)",
    "Zero result rate change, by day", TRUE,
    "Rate of Change"
  )
  output$failure_breakdown_plot <- make_dygraph(
    failure_breakdown_dygraph_set, "Date", "Zero Results Rate (%)",
    "Zero result rate by search type"
  )
  output$suggestion_dygraph_plot <- make_dygraph(
    suggestion_dygraph_set, "Date", "Zero Results Rate (%)",
    "Zero Result Rates with Search Suggestions"
  )

  # KPI module
  output$kpi_summary_api_usage_proportions <- renderPlot({
    api_latest <- c("Cirrus" = dplyr::select(dplyr::arrange(split_dataset[[1]], dplyr::desc(timestamp)), events)[[1]][1],
           "OpenSearch" = dplyr::select(dplyr::arrange(split_dataset[[2]], dplyr::desc(timestamp)), events)[[1]][1],
           "Geo" = dplyr::select(dplyr::arrange(split_dataset[[3]], dplyr::desc(timestamp)), events)[[1]][1],
           "Language" = dplyr::select(dplyr::arrange(split_dataset[[4]], dplyr::desc(timestamp)), events)[[1]][1],
           "Prefix" = dplyr::select(dplyr::arrange(split_dataset[[5]], dplyr::desc(timestamp)), events)[[1]][1]) %>%
           { data.frame(API = names(.), Events = ., Prop = ./sum(.)) }
    ggplot(api_latest, aes(x = 1, fill = API)) +
      geom_bar(aes(y = Prop), stat="identity") +
      scale_fill_discrete(guide = FALSE) +
      scale_y_continuous(expand = c(0,0)) + scale_x_continuous(expand = c(0,0)) +
      coord_flip() +
      theme_bw() +
      theme(axis.ticks = element_blank(),
            axis.text = element_blank(),
            axis.title = element_blank(),
            plot.margin = unit(rep(0, 4), "lines"),
            panel.margin = unit(0, "lines")) +
      geom_text(aes(label = API, x = seq(0.95, 1.05, length.out = 5),
                    y = cumsum(Prop) + (c(0, cumsum(Prop)[-5]) - cumsum(Prop))/2))
  })
  output$kpi_summary_zero_results_latest <- renderValueBox({
    valueBox(
      "Latest",
      "20%",
      color = "blue"
    )
  })
  output$kpi_summary_zero_results_week_avg <- renderValueBox({
    valueBox(
      "Wk Avg",
      "25%",
      color = "blue"
    )
  })
  output$kpi_summary_zero_results_rate_change <- renderValueBox({
    valueBox(
      "% Change",
      "-1%",
      icon = icon("arrow-down"),
      color = "green"
    )
  })
  output$kpi_summary_zero_results_rate_week_avg <- renderValueBox({
    valueBox(
      "Wk Avg % Change",
      "2%",
      icon = icon("arrow-up"),
      color = "red"
    )
  })
  output$kpi_summary_api_usage_all <- renderValueBox({
    valueBox(
      "All",
      "--%"
    )
  })
  output$kpi_summary_api_usage_cirrus <- renderValueBox({
    valueBox(
      "Cirrus Search",
      "--%"
    )
  })
  output$kpi_summary_api_usage_open <- renderValueBox({
    valueBox(
      "OpenSearch",
      "--%"
    )
  })
  output$kpi_summary_api_usage_geo <- renderValueBox({
    valueBox(
      "Geo Search",
      "--%"
    )
  })
  output$kpi_summary_api_usage_prefix <- renderValueBox({
    valueBox(
      "Prefix Search",
      "--%"
    )
  })
  output$kpi_summary_api_usage_language <- renderValueBox({
    valueBox(
      "Language Search",
      "--%"
    )
  })

  # Experimental feature
  output$custom_plot <- renderUI({
    list(radioButtons("data_type", "Type of Data",
                      choices = list("Events" = "events",
                                     "Load times" = "load_times"),
                      inline = TRUE),
         checkboxGroupInput("data_source", "Source of Data",
                            choices = list("Desktop" = "desktop",
                                           "Mobile Web" = "mobile_web",
                                           "Mobile Apps" = "mobile_apps"),
                            inline = TRUE),
         dygraphOutput("experimental")
    )
  })
#   output$experimental <- renderDygraph({
#     if ( input$data_source == "desktop" ) {
#       if ( input$data_type == "events" ) {
#         dygraph(desktop_dygraph_set)
#       } else { # load_times
#         dygraph(desktop_load_data)
#       }
#     }
#   })


})
