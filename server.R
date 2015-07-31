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
    split_dataset$cirrus, "Date", "Events",
    "Full-text via API usage by day", TRUE
  )
  output$open_aggregate <- make_dygraph(
    split_dataset$open, "Date", "Events",
    "OpenSearch API usage by day", TRUE
  )
  output$geo_aggregate <- make_dygraph(
    split_dataset$geo, "Date", "Events",
    "Geo Search API usage by day", TRUE
  )
  output$language_aggregate <- make_dygraph(
    split_dataset$language, "Date", "Events",
    "Language Search API usage by day", TRUE
  )
  output$prefix_aggregate <- make_dygraph(
    split_dataset$prefix, "Date", "Events",
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
  output$kpi_summary_load_time <- renderValueBox({
    x <- lapply(list(desktop_load_data$Median, mobile_load_data$Median, android_load_data$Median, ios_load_data$Median), tail, n = 2)
    y2 <- median(sapply(x, function(xx) { xx[2] })) # median at t
    y1 <- median(sapply(x, function(xx) { xx[1] })) # median at t-1
    z <- 100 * (y2 - y1) / y1 # % change from t-1 to t
    valueBox(subtitle = sprintf("Median Load Time %s",
                                ifelse(abs(z) > 0,
                                       sprintf("(%.1f%% change)", z), "")),
             value = sprintf("%.0fms", y2),
             color = ifelse(z > 0, "red", "green"),
             icon = icon(ifelse(z > 0, "arrow-up", "arrow-down")))
  })
  output$kpi_summary_zero_results <- renderValueBox({
    x <- tail(failure_dygraph_set, 1)
    y <- tail(failure_roc_dygraph_set$change_by_week, 1)
    valueBox(
      subtitle = sprintf("Zero Results Rate (%.1f%% change)", y),
      value = sprintf("%.1f%%", 100*(x[3])/x[2]),
      icon = icon(ifelse(y > 0, "arrow-up", "arrow-down")),
      color = ifelse(y > 0, "red", "green")
    )
  })
  output$kpi_summary_api_usage_all <- renderValueBox({
    x <- lapply(split_dataset, function(x) {
      tail(x$events, 2)
    })
    y1 <- sum(unlist(x)[seq(1, 9, 2)])
    y2 <- sum(unlist(x)[seq(2, 10, 2)])
    z <- 100*(y2-y1)/y1
    valueBox(
      subtitle = sprintf("API Usage (%.1f%% change)", z),
      value = compress(y2, 0),
      color = ifelse(z > 0, "green", "red"),
      icon = icon(ifelse(z > 0, "arrow-up", "arrow-down"))
    )
  })
  output$kpi_summary_api_usage_proportions <- renderPlot({
    api_latest <- c("Full-text via API" = tail(split_dataset$cirrus$events, 1),
                    "Geo Search" = tail(split_dataset$geo$events, 1),
                    "OpenSearch" = tail(split_dataset$open$events, 1),
                    "Language" = tail(split_dataset$language$events, 1),
                    "Prefix" = tail(split_dataset$prefix$events, 1))
    api_latest <- data.frame(API = names(api_latest),
                             Events = api_latest,
                             Prop = api_latest/sum(api_latest))
    api_latest <- api_latest[api_latest$Prop > 0.01, ]
    api_latest$text_pos <- cumsum(api_latest$Prop) + (c(0, cumsum(api_latest$Prop)[-nrow(api_latest)]) - cumsum(api_latest$Prop))/2
    api_latest$label <- sprintf("%s (%.0f%%)", api_latest$API, 100*api_latest$Prop)
    i <- which(api_latest$Prop > 0.5) # Majority API usage type gets additional text (for clarity)
    if ( length(i) == 1 )
        api_latest$label[i] <- sprintf("%s (%.0f%% of total API usage)", api_latest$API[i], 100*api_latest$Prop[i])
    rm(i)
    ggplot(api_latest, aes(x = 1, fill = API)) +
      geom_bar(aes(y = Prop), stat="identity") +
      scale_fill_discrete(guide = FALSE, expand = c(0,0)) +
      scale_y_continuous(expand = c(0,0)) +
      scale_x_continuous(expand = c(0,0)) +
      labs(x = NULL, y = NULL) +
      coord_flip() +
      theme_bw() +
      theme(axis.ticks = element_blank(),
            axis.text = element_blank(),
            axis.title = element_blank(),
            plot.margin = grid::unit(c(0, 0, -0.5, -0.5), "lines"),
            panel.margin = grid::unit(0, "lines")) +
      geom_text(aes(label = label,
                    y = text_pos,
                    x = 1))
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
