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
  output_vector <- (interim_vector[2:nrow(interim_data)] - interim_vector[1:(nrow(interim_data)-1)]) / interim_vector[1:(nrow(interim_data)-1)]

  failure_roc_dygraph_set <<- data.frame(date = interim_data$date[2:nrow(interim_data)],
                                         variable = "failure ROC",
                                         daily_change = output_vector*100,
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
      value = desktop_dygraph_means["search sessions"],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )

  output$desktop_event_resultsets <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means["Result pages opened"],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )

  output$desktop_event_clickthroughs <- renderValueBox(
    valueBox(
      value = desktop_dygraph_means["clickthroughs"],
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
      value = mobile_dygraph_means["search sessions"],
      subtitle = "Search sessions per day",
      icon = icon("search"),
      color = "green"
    )
  )

  output$mobile_event_resultsets <- renderValueBox(
    valueBox(
      value = mobile_dygraph_means["Result pages opened"],
      subtitle = "Result sets per day",
      icon = icon("list", lib = "glyphicon"),
      color = "green"
    )
  )

  output$mobile_event_clickthroughs <- renderValueBox(
    valueBox(
      value = mobile_dygraph_means["clickthroughs"],
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
  output$kpi_summary_date_range <- renderUI({
    date_range <- input$kpi_summary_date_range_selector
    switch(date_range,
           daily = {
             temp <- safe_tail(desktop_load_data, 2)$timestamp %>% {
               paste0(as.character(., "%A, %b "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(., "%e")), toOrdinal)))
             }
           },
           weekly = {
             date_range_index <- c(1, 7, 8, 14)
             temp <- safe_tail(desktop_load_data, date_range_index[4])$timestamp %>% {
               paste0(as.character(.[date_range_index], "%b "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(.[date_range_index], "%e")), toOrdinal)))
             } %>% {
               c(paste(.[1:2], collapse = "-"), paste(.[3:4], collapse = "-"))
             }
           },
           monthly = {
             date_range_index <- c(1, 31, 31, 60)
             temp <- safe_tail(desktop_load_data, date_range_index[4])$timestamp %>% {
               paste0(as.character(.[date_range_index], "%b "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(.[date_range_index], "%e")), toOrdinal)))
             } %>% {
               c(paste(.[1:2], collapse = "-"), paste(.[3:4], collapse = "-"))
             }
           },
           quarterly = {
             date_range_index <- c(1, 90)
             temp <- safe_tail(desktop_load_data, date_range_index[2])$timestamp %>% {
               paste0(as.character(.[date_range_index], "%B "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(.[date_range_index], "%e")), toOrdinal)))
             } %>% paste0(collapse = "—")
             return(HTML("<h3 class='kpi_date'>KPI summary for ", temp, ":</h3>"))
    })
    return(HTML("<h3 class='kpi_date'>KPI summary for ", temp[2], ", and % change from ", temp[1], ":</h3>"))
  })
  output$kpi_summary_box_load_time <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    switch(date_range,
           daily = {
             x <- lapply(list(desktop_load_data, mobile_load_data,
                              android_load_data, ios_load_data),
                         safe_tail, n = 2) %>%
               lapply(function(data_tail) return(data_tail$Median)) %>%
               do.call(cbind, .) %>%
               apply(MARGIN = 1, FUN = median)
           },
           weekly = {
             x <- lapply(list(desktop_load_data, mobile_load_data,
                              android_load_data, ios_load_data),
                         safe_tail, n = 14) %>%
               lapply(function(data_tail) return(data_tail$Median)) %>%
               do.call(cbind, .) %>%
               apply(MARGIN = 1, FUN = median)
           },
           monthly = {
             x <- lapply(list(desktop_load_data, mobile_load_data,
                              android_load_data, ios_load_data),
                         safe_tail, n = 60) %>%
               lapply(function(data_tail) return(data_tail$Median)) %>%
               do.call(cbind, .) %>%
               apply(MARGIN = 1, FUN = median)
           },
           quarterly = {
             x <- lapply(list(desktop_load_data, mobile_load_data,
                              android_load_data, ios_load_data),
                         safe_tail, n = 90) %>%
               lapply(function(data_tail) return(data_tail$Median))
             suppressWarnings(y <- median(apply(do.call(cbind, x), 1, median)))
             # ^ will soon be unnecessary. warning arises from iOS data being 88 days as of 2015-09-07
             return(valueBox(subtitle = "Load time", value = sprintf("%.0fms", y), color = "orange"))
           })
    y1 <- median(half(x, "top")); y2 <- median(half(x, "bottom")); z <- 100 * (y2 - y1) / y1
    if (abs(z) > 0) {
      return(valueBox(subtitle = sprintf("Load time (%.1f%%)", z),
                      value = sprintf("%.0fms", y2),
                      color = cond_color(z>0, "red"), icon = cond_icon(z>0)))
    }
    return(valueBox(subtitle = "Load time (no change)", value = sprintf("%.0fms", y2), color = "orange"))
  })
  output$kpi_summary_box_zero_results <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    switch(date_range,
           daily = {x <- safe_tail(failure_dygraph_set, 2)},
           weekly = {x <- safe_tail(failure_dygraph_set, 14)},
           monthly = {x <- safe_tail(failure_dygraph_set, 60)},
           quarterly = {x <- safe_tail(failure_dygraph_set, 90)})
    x <- transform(x, Rate = `Zero Result Queries` / `Search Queries`)$Rate
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "Zero results rate", color = "orange",
                      value = sprintf("%.1f%%", median(100 * x))))
    }
    y1 <- median(half(x, "top")); y2 <- median(half(x, "bottom")); z <- 100 * (y2 - y1)/y1
    if (abs(z) > 0) {
      return(valueBox(
        subtitle = sprintf("Zero results rate (%.1f%%)", z),
        value = sprintf("%.1f%%", 100 * y2),
        icon = cond_icon(z > 0), color = cond_color(z > 0, "red")
      ))
    }
    return(valueBox(subtitle = "Zero results rate (no change)",
                    value = sprintf("%.1f%%", 100 * y2), color = "orange"))
  })
  output$kpi_summary_box_api_usage <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    x <- lapply(split_dataset, function(x) {
      switch(date_range,
             daily = { safe_tail(x, 2)$events },
             weekly = { safe_tail(x, 14)$events },
             monthly = { safe_tail(x, 60)$events },
             quarterly = { safe_tail(x, 90)$events })
    }) %>% do.call(cbind, .) %>%
      transform(total = cirrus + geo + language + open + prefix) %>%
      { .$total }
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "API usage", value = compress(median(x), 0), color = "orange"))
    }
    y1 <- median(half(x, "top"))
    y2 <- median(half(x, "bottom"))
    z <- 100 * (y2 - y1) / y1 # % change from t-1 to t
    if (abs(z) > 0) {
      return(valueBox(subtitle = sprintf("API usage (%.1f%%)", z),
                      value = compress(y2, 0), color = cond_color(z>0), icon = cond_icon(z>0)))
    }
    return(valueBox(subtitle = "API usage (no change)", value = compress(y2, 0), color = "orange"))
  })
  output$kpi_summary_api_usage_proportions <- renderPlot({
    switch (input$kpi_summary_date_range_selector,
      daily = { n <- 1 },
      weekly = { n <- 7 },
      monthly = { n <- 30 },
      quarterly = { n <- 90 }
    )
    api_latest <- cbind("Full-text via API" = safe_tail(split_dataset$cirrus, n)$events,
                        "Geo Search" = safe_tail(split_dataset$geo, n)$events,
                        "OpenSearch" = safe_tail(split_dataset$open, n)$events,
                        "Language" = safe_tail(split_dataset$language, n)$events,
                        "Prefix" = safe_tail(split_dataset$prefix, n)$events) %>%
      apply(2, median) %>% round
    api_latest <- data.frame(API = names(api_latest),
                             Events = api_latest,
                             Prop = api_latest/sum(api_latest))
    api_latest <- api_latest[api_latest$Prop > 0.01, ]
    # api_latest$text_pos <- cumsum(api_latest$Prop) + (c(0, cumsum(api_latest$Prop)[-nrow(api_latest)]) - cumsum(api_latest$Prop))/2
    api_latest$Label <- sprintf("%s (%.0f%%)", api_latest$API, 100*api_latest$Prop)
    i <- which(api_latest$Prop > 0.5) # Majority API usage type gets additional text (for clarity)
    if ( length(i) == 1 )
      api_latest$Label[i] <- sprintf("%s (%.0f%% of total API usage)", api_latest$API[i], 100*api_latest$Prop[i])
    rm(i)
    gg_prop_bar(api_latest, cols = list(item = "API", prop = "Prop", label = "Label"))
  })
  output$kpi_load_time_series <- renderDygraph({
    num_of_days_in_common <- min(sapply(list(desktop_load_data$Median, mobile_load_data$Median, android_load_data$Median, ios_load_data$Median), length))
    load_times <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      lapply(safe_tail, num_of_days_in_common) %>%
      lapply(function(data_tail) return(data_tail$Median)) %>%
      as.data.frame %>%
      { colnames(.) <- c("Desktop", "Mobile Web", "Android", "iOS"); . } %>%
      {
        Median = apply(., 1, median)
        # Median_change = percent_change(Median)
        cbind(Median = Median[-1], .[-1, ])# , "Median % change" = Median_change[-1])
      } %>%
      xts(order.by = mobile_load_data$timestamp[-1]) # need to make dynamic
    return(dygraph(load_times,
            main = "Load times over time",
            xlab = "Date",
            ylab = "Load time (ms)") %>%
      dySeries("Median", axis = 'y2', strokeWidth = 4, label = "Cross-platform Median") %>%
      dyAxis("y2", label = "Day-to-day % change in median load time",
             independentTicks = TRUE, drawGrid = FALSE) %>%
      dyLegend(width = 500, show = "always") %>%
      dyOptions(strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1],
                drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                includeZero = TRUE) %>%
      dyCSS(css = "./assets/css/custom.css"))
  })
  output$kpi_zero_results_series <- renderDygraph({
    zrr <- 100 * failure_dygraph_set$`Zero Result Queries` / failure_dygraph_set$`Search Queries`
    zrr_change <- 100 * (zrr[2:length(zrr)] - zrr[1:(length(zrr)-1)])/zrr[1:(length(zrr)-1)]
    zrr <- xts(zrr, failure_dygraph_set$date)
    colnames(zrr) <- "rate"
    zrr_change <- xts(zrr_change, failure_dygraph_set$date[-1])
    colnames(zrr_change) <- "change"
    zrr <- cbind(zrr[-1, ], zrr_change)
    return(dygraph(zrr,
            main = "Zero results rate over time",
            xlab = "Date",
            ylab = "% of search queries that yield zero results") %>%
      dySeries("change", axis = 'y2', label = "day-to-day % change", strokeWidth = 1) %>%
      dyLimit(limit = 12.50, label = "Goal: 12.50% zero results rate",
              color = brewer.pal(3, "Set2")[3]) %>%
      dyAxis("y2", label = "Day-to-day % change",
             valueRange = c(-1, 1) * max(max(abs(as.numeric(zrr$change))), 10),
             axisLineColor = brewer.pal(3, "Set2")[2],
             axisLabelColor = brewer.pal(3, "Set2")[2],
             independentTicks = TRUE, drawGrid = FALSE) %>%
      dyAxis("y", drawGrid = FALSE,
             axisLineColor = brewer.pal(3, "Set2")[1],
             axisLabelColor = brewer.pal(3, "Set2")[1]) %>%
      dyLimit(limit = 0, color = brewer.pal(3, "Set2")[2], strokePattern = "dashed") %>%
      dyLegend(width = 400, show = "always") %>%
      dyOptions(strokeWidth = 3, colors = brewer.pal(3, "Set2"),
                drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                includeZero = TRUE) %>%
      dyCSS(css = "./assets/css/custom.css"))
  })
  output$kpi_api_usage_series <- renderDygraph({
    api_usage <- cbind(timestamp = split_dataset$cirrus$timestamp, as.data.frame(lapply(split_dataset, function(x) x$events)))
    # api_usage <- api_usage[order(api_usage$timestamp, decreasing = FALSE), ]
    if ( input$kpi_api_usage_series_include_open ) {
      api_usage <- transform(api_usage, all = cirrus + geo + language + open + prefix)
    } else {
      api_usage <- transform(api_usage, all = cirrus + geo + language + prefix)
    }
    if ( input$kpi_api_usage_series_data == "raw" ) {
      api_usage <- xts(api_usage[, -1], api_usage[, 1])
      if (!input$kpi_api_usage_series_include_open) {
        colnames(api_usage)[6] <- "all except open"
      }
      return(dygraph(api_usage, main = "Calls over time", xlab = "Date",
              ylab = ifelse(input$kpi_api_usage_series_log_scale, "Calls (log10 scale)", "Calls")) %>%
        dySeries("cirrus", label = "full-text via API") %>%
        dyLegend(width = 400, show = "always") %>%
        dyOptions(strokeWidth = 3, colors = brewer.pal(6, "Set2")[6:1],
                  drawPoints = TRUE, pointSize = 3, labelsKMB = TRUE,
                  includeZero = input$kpi_api_usage_series_log_scale,
                  logscale = input$kpi_api_usage_series_log_scale
        ) %>%
        dyCSS(css = "./assets/css/custom.css"))
    }
    api_usage_change <- transform(api_usage,
                                  cirrus = percent_change(cirrus),
                                  geo = percent_change(geo),
                                  language = percent_change(language),
                                  open = percent_change(open),
                                  prefix = percent_change(prefix),
                                  all = percent_change(all)) %>%
                                  { .[-1, ] }
    api_usage_change <- xts(api_usage_change[, -1], api_usage_change[, 1])
    if (!input$kpi_api_usage_series_include_open) colnames(api_usage_change)[6] <- "all except open"
    return(dygraph(api_usage_change,
            main = "Day-to-day % change over time",
            xlab = "Date", ylab = "% change") %>%
      dyLegend(width = 400, show = "always") %>%
      dyOptions(strokeWidth = 3, colors = brewer.pal(6, "Set2"),
                drawPoints = TRUE, pointSize = 3, labelsKMB = TRUE,
                includeZero = TRUE) %>%
      dyCSS(css = "./assets/css/custom.css"))
  })

})
