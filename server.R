## Version 0.2.0
source("utils.R")

existing_date <- Sys.Date() - 1

shinyServer(function(input, output) {

  if (Sys.Date() != existing_date) {
    read_desktop()
    read_apps()
    read_web()
    read_api()
    read_failures(existing_date)
    read_augmented_clickthrough()
    read_lethal_dose()
    existing_date <<- Sys.Date()
  }

  ## Desktop value boxes
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

  ## The dynamic graphs of events on desktop
  output$desktop_event_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(desktop_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_desktop_event)),
                         xlab = "Date", ylab = "Events", title = "Desktop search events, by day")
  })

  output$desktop_load_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(desktop_load_data,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_desktop_load)),
                         xlab = "Date", ylab = "Load time (ms)", title = "Desktop load times, by day",
                         use_si = FALSE)
  })

  ## Mobile value boxes
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

  ## Mobile plots
  output$mobile_event_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(mobile_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_mobile_event)),
                         xlab = "Date", ylab = "Events", title = "Mobile search events, by day")
  })

  output$mobile_load_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(mobile_load_data,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_mobile_load)),
                         xlab = "Date", ylab = "Load time (ms)", "Mobile result load times, by day",
                         use_si = FALSE)
  })

  ## App value boxes
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

  ## App plots
  output$android_event_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(android_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_app_event)),
                         xlab = "Date", ylab = "Events", "Android mobile app search events, by day")
  })

  output$android_load_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(android_load_data,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_app_load)),
                         xlab = "Date", ylab = "Load time (ms)", "Android result load times, by day",
                         use_si = FALSE)
  })

  output$ios_event_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(ios_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_app_event)),
                         xlab = "Date", ylab = "Events", "iOS mobile app search events, by day")
  })

  output$ios_load_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(ios_load_data,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_app_load)),
                         xlab = "Date", ylab = "Load time (ms)", "iOS result load times, by day",
                         use_si = FALSE)
  })

  ## API plots
  output$cirrus_aggregate <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(split_dataset$cirrus[,c(1,3)],
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_fulltext_search)),
                         xlab = "Date", ylab = "Searches", "Full-text via API usage by day",
                         legend_name = "Searches")
  })

  output$open_aggregate <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(split_dataset$open[,c(1,3)],
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_open_search)),
                         xlab = "Date", ylab = "Searches", "OpenSearch API usage by day",
                         legend_name = "Searches")
  })

  output$geo_aggregate <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(split_dataset$geo[,c(1,3)],
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_geo_search)),
                         xlab = "Date", ylab = "Searches", "Geo Search API usage by day",
                         legend_name = "Searches")
  })

  output$language_aggregate <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(split_dataset$language[,c(1,3)],
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_language_search)),
                         xlab = "Date", ylab = "Searches", "Language Search API usage by day",
                         legend_name = "Searches")
  })

  output$prefix_aggregate <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(split_dataset$prefix[,c(1,3)],
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_prefix_search)),
                         xlab = "Date", ylab = "Searches", "Prefix Search API usage by day",
                         legend_name = "Searches")
  })

  # Failure plots
  output$failure_rate_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(failure_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_failure_rate)),
                         xlab = "Date", ylab = "Queries", "Search Queries with Zero Results, by day")
  })

  output$failure_rate_change_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(failure_roc_dygraph_set[,c(1,3)],
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_failure_rate)),
                         xlab = "Date", ylab = "Change (%)", "Zero Results rate change, by day",
                         legend_name = "Change")
  })

  output$failure_breakdown_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(failure_breakdown_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_failure_breakdown)),
                         xlab = "Date", ylab = "Zero Results Rate (%)", "Zero result rate by search type")
  })

  output$suggestion_dygraph_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(suggestion_dygraph_set,
                                         smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                              input$smoothing_failure_suggestions)),
                         xlab = "Date", ylab = "Zero Results Rate (%)", "Zero Result Rates with Search Suggestions")
  })

  output$lethal_dose_plot <- renderDygraph({
    polloi::make_dygraph(data = polloi::smoother(user_page_visit_dataset,
                                                 smooth_level = polloi::smooth_switch(input$smoothing_global,
                                                                                      input$smoothing_lethal_dose_plot)),
                         xlab = "", ylab = "Time (s)",
                         title = "Time at which we have lost N% of the users") %>%
      dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = CustomAxisFormatter,
             axisLabelWidth = 100, pixelsPerLabel = 80) %>%
      dyLegend(labelsDiv = "lethal_dose_plot_legend")
  })

  ## KPI Summary Boxes
  output$kpi_summary_date_range <- renderUI({
    date_range <- input$kpi_summary_date_range_selector
    switch(date_range,
           daily = {
             temp <- polloi::safe_tail(desktop_load_data, 2)$date %>% {
               paste0(as.character(., "%A, %b "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(., "%e")), toOrdinal)))
             }
           },
           weekly = {
             date_range_index <- c(1, 7, 8, 14)
             temp <- polloi::safe_tail(desktop_load_data, date_range_index[4])$date %>% {
               paste0(as.character(.[date_range_index], "%b "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(.[date_range_index], "%e")), toOrdinal)))
             } %>% {
               c(paste(.[1:2], collapse = "-"), paste(.[3:4], collapse = "-"))
             }
           },
           monthly = {
             date_range_index <- c(1, 31, 31, 60)
             temp <- polloi::safe_tail(desktop_load_data, date_range_index[4])$date %>% {
               paste0(as.character(.[date_range_index], "%b "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(.[date_range_index], "%e")), toOrdinal)))
             } %>% {
               c(paste(.[1:2], collapse = "-"), paste(.[3:4], collapse = "-"))
             }
           },
           quarterly = {
             date_range_index <- c(1, 90)
             temp <- polloi::safe_tail(desktop_load_data, date_range_index[2])$date %>% {
               paste0(as.character(.[date_range_index], "%B "),
                      sub("([a-z]{2})", "<sup>\\1</sup>",
                          sapply(as.numeric(as.character(.[date_range_index], "%e")), toOrdinal)))
             } %>% paste0(collapse = "-")
             return(HTML("<h3 class='kpi_date'>KPI summary for ", temp, ":</h3>"))
           })
    return(HTML("<h3 class='kpi_date'>KPI summary for ", temp[2], ", and % change from ", temp[1], ":</h3>"))
  })
  output$kpi_summary_box_load_time <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    x <- lapply(list(desktop_load_data, mobile_load_data,
                     android_load_data, ios_load_data),
                polloi::safe_tail, n = date_range_switch(date_range)) %>%
      lapply(function(data_tail) return(data_tail$Median))
    if ( date_range == "quarterly" ) {
      y <- median(apply(do.call(cbind, x), 1, median))
      return(valueBox(subtitle = "Load time", value = sprintf("%.0fms", y), color = "orange"))
    }
    x %<>% do.call(cbind, .) %>% apply(MARGIN = 1, FUN = median)
    y1 <- median(polloi::half(x)); y2 <- median(polloi::half(x, FALSE)); z <- 100 * (y2 - y1) / y1
    if (abs(z) > 0) {
      return(valueBox(subtitle = sprintf("Load time (%.1f%%)", z),
                      value = sprintf("%.0fms", y2),
                      color = polloi::cond_color(z > 0, "red"), icon = polloi::cond_icon(z > 0)))
    }
    return(valueBox(subtitle = "Load time (no change)", value = sprintf("%.0fms", y2), color = "orange"))
  })
  output$kpi_summary_box_zero_results <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    x <- polloi::safe_tail(failure_dygraph_set, date_range_switch(date_range))
    x <- transform(x, Rate = `Zero Result Queries` / `Search Queries`)$Rate
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "Zero results rate", color = "orange",
                      value = sprintf("%.1f%%", median(100 * x))))
    }
    y1 <- median(polloi::half(x)); y2 <- median(polloi::half(x, FALSE)); z <- 100 * (y2 - y1)/y1
    if (abs(z) > 0) {
      return(valueBox(
        subtitle = sprintf("Zero results rate (%.1f%%)", z),
        value = sprintf("%.1f%%", 100 * y2),
        icon = cond_icon(z > 0), color = polloi::cond_color(z > 0, "red")
      ))
    }
    return(valueBox(subtitle = "Zero results rate (no change)",
                    value = sprintf("%.1f%%", 100 * y2), color = "orange"))
  })
  output$kpi_summary_box_api_usage <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    x <- lapply(split_dataset, function(x) {
      polloi::safe_tail(x, date_range_switch(date_range))$events
    }) %>% do.call(cbind, .) %>%
      transform(total = cirrus + geo + language + open + prefix) %>%
      { .$total }
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "API usage", value = polloi::compress(median(x), 0), color = "orange"))
    }
    y1 <- median(polloi::half(x, TRUE))
    y2 <- median(polloi::half(x, FALSE))
    z <- 100 * (y2 - y1) / y1 # % change from t-1 to t
    if (abs(z) > 0) {
      return(valueBox(subtitle = sprintf("API usage (%.1f%%)", z),
                      value = polloi::compress(y2, 0), color = polloi::cond_color(z > 0), icon = polloi::cond_icon(z > 0)))
    }
    return(valueBox(subtitle = "API usage (no change)", value = polloi::compress(y2, 0), color = "orange"))
  })
  output$kpi_summary_box_augmented_clickthroughs <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    #========= We can delete this block after we get 90 days of data =========
    if ( (date_range == "monthly" && (Sys.Date()-1)-60 < as.Date("2015-09-02")) || date_range == "quarterly" && (Sys.Date()-1)-90 < as.Date("2015-09-02") ) {
      return(valueBox(subtitle = "User engagement", color = "black", value = "NA"))
    }
    #=========================================================================
    x <- polloi::safe_tail(augmented_clickthroughs, date_range_switch(date_range))
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "User engagement", color = "orange",
                      value = sprintf("%.1f%%", median(x$user_engagement))))
    }
    y1 <- median(polloi::half(x$user_engagement))
    y2 <- median(polloi::half(x$user_engagement, FALSE))
    z <- 100 * (y2 - y1)/y1
    if (abs(z) > 0) {
      return(valueBox(
        subtitle = sprintf("User engagement (%.1f%%)", z),
        value = sprintf("%.1f%%", y2),
        icon = cond_icon(z > 0), color = polloi::cond_color(z > 0, "green")
      ))
    }
    return(valueBox(subtitle = "User engagement (no change)",
                    value = sprintf("%.1f%%", y2), color = "orange"))
  })
  output$kpi_summary_api_usage_proportions <- renderPlot({
    n <- date_range_switch(input$kpi_summary_date_range_selector, 1, 7, 30, 90)
    api_latest <- cbind("Full-text via API" = polloi::safe_tail(split_dataset$cirrus, n)$events,
                        "Geo Search" = polloi::safe_tail(split_dataset$geo, n)$events,
                        "OpenSearch" = polloi::safe_tail(split_dataset$open, n)$events,
                        "Language" = polloi::safe_tail(split_dataset$language, n)$events,
                        "Prefix" = polloi::safe_tail(split_dataset$prefix, n)$events) %>%
      apply(2, median) %>% round
    api_latest <- data.frame(API = names(api_latest),
                             Events = api_latest,
                             Prop = api_latest/sum(api_latest))
    api_latest <- api_latest[api_latest$Prop > 0.01, ]
    api_latest$Label <- sprintf("%s (%.0f%%)", api_latest$API, 100*api_latest$Prop)
    i <- which(api_latest$Prop > 0.5) # Majority API usage type gets additional text (for clarity)
    if ( length(i) == 1 )
      api_latest$Label[i] <- sprintf("%s (%.0f%% of total API usage)", api_latest$API[i], 100*api_latest$Prop[i])
    rm(i)
    gg_prop_bar(api_latest, cols = list(item = "API", prop = "Prop", label = "Label"))
  })

  ## KPI Modules
  output$kpi_load_time_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_load_time
    num_of_days_in_common <- min(sapply(list(desktop_load_data$Median, mobile_load_data$Median, android_load_data$Median, ios_load_data$Median), length))
    load_times <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      lapply(polloi::safe_tail, num_of_days_in_common) %>%
      lapply(function(data_tail) return(data_tail$Median)) %>%
      as.data.frame %>%
      { colnames(.) <- c("Desktop", "Mobile Web", "Android", "iOS"); . } %>%
      {
        Median = apply(., 1, median)
        cbind(Median = Median, .)
      } %>%
      cbind(date = polloi::safe_tail(desktop_load_data, num_of_days_in_common)$date, .) %>%
      polloi::smoother(smooth_level = ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE) %>%
      { xts::xts(.[, -1], order.by = .[, 1]) }
    return(dygraph(load_times,
                   main = "Load times over time",
                   xlab = "Date",
                   ylab = "Load time (ms)") %>%
             dySeries("Median", axis = 'y2', strokeWidth = 4, label = "Cross-platform Median") %>%
             dyAxis("y2", label = "Day-to-day % change in median load time",
                    independentTicks = TRUE, drawGrid = FALSE) %>%
             dyLegend(width = 500, show = "always") %>%
             dyOptions(strokeWidth = 2, colors = RColorBrewer::brewer.pal(5, "Set2")[5:1],
                       drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                       includeZero = TRUE) %>%
             dyCSS(css = system.file("custom.css", package = "polloi")))
  })
  output$kpi_zero_results_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_zero_results
    zrr <- 100 * failure_dygraph_set$`Zero Result Queries` / failure_dygraph_set$`Search Queries`
    zrr_change <- 100 * (zrr[2:length(zrr)] - zrr[1:(length(zrr)-1)])/zrr[1:(length(zrr)-1)]
    zrr <- data.frame(date = failure_dygraph_set$date[-1], rate = zrr[-1], change = zrr_change)
    zrr %<>% polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE)
    zrr <- xts::xts(zrr[, -1], zrr[, 1])
    return(dygraph(zrr,
                   main = "Zero results rate over time",
                   xlab = "Date",
                   ylab = "% of search queries that yield zero results") %>%
             dySeries("change", axis = 'y2', label = "day-to-day % change", strokeWidth = 1) %>%
             dyLimit(limit = 12.50, label = "Goal: 12.50% zero results rate",
                     color = RColorBrewer::brewer.pal(3, "Set2")[3]) %>%
             dyAxis("y2", label = "Day-to-day % change",
                    valueRange = c(-1, 1) * max(max(abs(as.numeric(zrr$change))), 10),
                    axisLineColor = RColorBrewer::brewer.pal(3, "Set2")[2],
                    axisLabelColor = RColorBrewer::brewer.pal(3, "Set2")[2],
                    independentTicks = TRUE, drawGrid = FALSE) %>%
             dyAxis("y", drawGrid = FALSE,
                    axisLineColor = RColorBrewer::brewer.pal(3, "Set2")[1],
                    axisLabelColor = RColorBrewer::brewer.pal(3, "Set2")[1]) %>%
             dyLimit(limit = 0, color = RColorBrewer::brewer.pal(3, "Set2")[2], strokePattern = "dashed") %>%
             dyLegend(width = 400, show = "always") %>%
             dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(3, "Set2"),
                       drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                       includeZero = TRUE) %>%
             dyCSS(css = system.file("custom.css", package = "polloi")))
  })
  output$kpi_api_usage_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_api_usage
    api_usage <- cbind(date = split_dataset$cirrus$date, as.data.frame(lapply(split_dataset, function(x) x$events)))
    if ( input$kpi_api_usage_series_include_open ) {
      api_usage <- transform(api_usage, all = cirrus + geo + language + open + prefix)
    } else {
      api_usage <- transform(api_usage, all = cirrus + geo + language + prefix)
    }
    if ( input$kpi_api_usage_series_data == "raw" ) {
      api_usage %<>% polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE)
      api_usage <- xts::xts(api_usage[, -1], api_usage[, 1])
      if (!input$kpi_api_usage_series_include_open) {
        colnames(api_usage)[6] <- "all except open"
      }
      return(dygraph(api_usage, main = "Calls over time", xlab = "Date",
                     ylab = ifelse(input$kpi_api_usage_series_log_scale, "Calls (log10 scale)", "Calls")) %>%
               dySeries("cirrus", label = "full-text via API") %>%
               dyLegend(width = 400, show = "always") %>%
               dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(6, "Set2")[6:1],
                         drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                         includeZero = input$kpi_api_usage_series_log_scale,
                         logscale = input$kpi_api_usage_series_log_scale
               ) %>%
               dyCSS(css = system.file("custom.css", package = "polloi")))
    }
    api_usage_change <- transform(api_usage,
                                  cirrus = polloi::percent_change(cirrus),
                                  geo = polloi::percent_change(geo),
                                  language = polloi::percent_change(language),
                                  open = polloi::percent_change(open),
                                  prefix = polloi::percent_change(prefix),
                                  all = polloi::percent_change(all)) %>%
                                  { .[-1, ] }
    api_usage_change %<>% polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE)
    api_usage_change <- xts::xts(api_usage_change[, -1], api_usage_change[, 1])
    if (!input$kpi_api_usage_series_include_open) colnames(api_usage_change)[6] <- "all except open"
    return(dygraph(api_usage_change,
                   main = "Day-to-day % change over time",
                   xlab = "Date", ylab = "% change") %>%
             dyLegend(width = 400, show = "always") %>%
             dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(6, "Set2"),
                       drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                       includeZero = TRUE) %>%
             dyCSS(css = system.file("custom.css", package = "polloi")))
  })
  output$kpi_augmented_clickthroughs_series <- renderDygraph({
    smoothed_data <- polloi::smoother(augmented_clickthroughs,
      smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_augmented_clickthroughs))
    polloi::make_dygraph(data = smoothed_data, xlab = "Date", ylab = "Rates", "User engagement (augmented clickthroughs) by day") %>%
      dySeries(name = colnames(smoothed_data)[2], strokeWidth = 1.5, strokePattern = "dashed") %>%
      dySeries(name = colnames(smoothed_data)[3], strokeWidth = 1.5, strokePattern = "dashed") %>%
      dyLegend(labelsDiv = "kpi_augmented_clickthroughs_series_legend")
  })

})
