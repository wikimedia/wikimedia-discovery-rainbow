## Version 0.3.0
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

  # This is used to subset for getting the bounds for polloi::subset_by_date_range():
  time_frame_range <- function(tf_selector) {
    tf_setting <- input[[tf_selector]]
    if ( tf_setting == 'global' ) {
      if ( input$timeframe_global == 'custom' ) {
        return(input$daterange_global)
      } else {
        tf_setting <- input$timeframe_global
      }
    }
    return(switch(tf_setting,
                  all = c(as.Date("2015-04-14"), Sys.Date()-1),
                  week = c(Sys.Date()-8, Sys.Date()-1),
                  month = c(Sys.Date()-31, Sys.Date()-1),
                  quarter = c(Sys.Date()-91, Sys.Date()-1),
                  custom = input[[paste(tf_selector, "daterange", sep = "_")]]))
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
    desktop_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_desktop_event)) %>%
      polloi::subset_by_date_range(time_frame_range("desktop_event_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Desktop search events, by day")
  })

  output$desktop_load_plot <- renderDygraph({
    desktop_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_desktop_load)) %>%
      polloi::subset_by_date_range(time_frame_range("desktop_load_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Desktop load times, by day", use_si = FALSE)
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
    mobile_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_mobile_event)) %>%
      polloi::subset_by_date_range(time_frame_range("mobile_event_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Mobile search events, by day")
  })

  output$mobile_load_plot <- renderDygraph({
    mobile_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_mobile_load)) %>%
      polloi::subset_by_date_range(time_frame_range("mobile_load_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Mobile search events, by day", use_si = FALSE)
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
    android_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
      polloi::subset_by_date_range(time_frame_range("app_event_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Android mobile app search events, by day")
  })

  output$android_load_plot <- renderDygraph({
    android_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_load)) %>%
      polloi::subset_by_date_range(time_frame_range("app_load_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Android result load times, by day", use_si = FALSE)
  })

  output$ios_event_plot <- renderDygraph({
    ios_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
      polloi::subset_by_date_range(time_frame_range("app_event_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "iOS mobile app search events, by day")
  })

  output$ios_load_plot <- renderDygraph({
    ios_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_load)) %>%
      polloi::subset_by_date_range(time_frame_range("app_load_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "iOS result load times, by day", use_si = FALSE)
  })

  ## API plots
  output$cirrus_aggregate <- renderDygraph({
    split_dataset$cirrus[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_fulltext_search)) %>%
      polloi::subset_by_date_range(time_frame_range("fulltext_search_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Full-text via API usage by day", legend_name = "Searches")
  })

  output$open_aggregate <- renderDygraph({
    split_dataset$open[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_open_search)) %>%
      polloi::subset_by_date_range(time_frame_range("open_search_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "OpenSearch API usage by day", legend_name = "Searches")
  })

  output$geo_aggregate <- renderDygraph({
    split_dataset$geo[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geo_search)) %>%
      polloi::subset_by_date_range(time_frame_range("geo_search_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Geo Search API usage by day", legend_name = "Searches")
  })

  output$language_aggregate <- renderDygraph({
    split_dataset$language[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_language_search)) %>%
      polloi::subset_by_date_range(time_frame_range("language_search_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Language Search API usage by day", legend_name = "Searches")
  })

  output$prefix_aggregate <- renderDygraph({
    split_dataset$prefix[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prefix_search)) %>%
      polloi::subset_by_date_range(time_frame_range("prefix_search_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Prefix Search API usage by day", legend_name = "Searches")
  })

  # Failure plots
  output$failure_rate_plot <- renderDygraph({
    failure_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_rate)) %>%
      polloi::subset_by_date_range(time_frame_range("failure_rate_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Queries", title = "Search Queries with Zero Results, by day")
  })

  output$failure_rate_change_plot <- renderDygraph({
    failure_roc_dygraph_set[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_rate)) %>%
      polloi::subset_by_date_range(time_frame_range("failure_rate_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Change (%)", title = "Zero Results rate change, by day", legend_name = "Change")
  })

  output$failure_breakdown_plot <- renderDygraph({
    failure_breakdown_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_breakdown)) %>%
      polloi::subset_by_date_range(time_frame_range("failure_breakdown_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Zero Results Rate (%)", title = "Zero result rate by search type")
  })

  output$suggestion_dygraph_plot <- renderDygraph({
    suggestion_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_suggestions)) %>%
      polloi::subset_by_date_range(time_frame_range("failure_suggestions_timeframe")) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Zero Results Rate (%)", title = "Zero Result Rates with Search Suggestions")
  })

  output$lethal_dose_plot <- renderDygraph({
    user_page_visit_dataset %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_lethal_dose_plot)) %>%
      polloi::subset_by_date_range(time_frame_range("lethal_dose_timeframe")) %>%
      polloi::make_dygraph(xlab = "", ylab = "Time (s)", title = "Time at which we have lost N% of the users") %>%
      dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = CustomAxisFormatter,
             axisLabelWidth = 100, pixelsPerLabel = 80) %>%
      dyLegend(labelsDiv = "lethal_dose_plot_legend")
  })

  ## KPI Summary Boxes
  output$kpi_summary_date_range <- renderUI({
    date_range <- input$kpi_summary_date_range_selector
    switch(date_range,
           daily = {
             dates <- Sys.Date() - c(1, 2)
             temp <- dates %>%
               as.character("%e") %>%
               as.numeric %>%
               sapply(toOrdinal) %>%
               sub("([a-z]{2})", "<sup>\\1</sup>", .) %>%
               paste0(as.character(dates, "%A, %b "), .)
           },
           weekly = {
             dates <- Sys.Date() - c(1, 8, 9, 15)
             temp <- dates %>%
               as.character("%e") %>%
               as.numeric %>%
               sapply(toOrdinal) %>%
               sub("([a-z]{2})", "<sup>\\1</sup>", .) %>%
               paste0(as.character(dates, "%b "), .) %>%
               {
                 c(paste(.[1:2], collapse = "-"), paste(.[3:4], collapse = "-"))
               }
           },
           monthly = {
             dates <- Sys.Date() - c(1, 31, 32, 61)
             temp <- dates %>%
               as.character("%e") %>%
               as.numeric %>%
               sapply(toOrdinal) %>%
               sub("([a-z]{2})", "<sup>\\1</sup>", .) %>%
               paste0(as.character(dates, "%b "), .) %>%
               {
                 c(paste(.[1:2], collapse = "-"), paste(.[3:4], collapse = "-"))
               }
           },
           quarterly = {
             dates <- Sys.Date() - c(1, 91)
             return(dates %>%
                      as.character("%e") %>%
                      as.numeric %>%
                      sapply(toOrdinal) %>%
                      sub("([a-z]{2})", "<sup>\\1</sup>", .) %>%
                      paste0(as.character(dates, "%B "), .) %>%
                      paste0(collapse = "-") %>%
                      HTML("<h3 class='kpi_date'>KPI summary for ", ., ":</h3>"))
           })
    return(HTML("<h3 class='kpi_date'>KPI summary for ", temp[2], ", and % change from ", temp[1], ":</h3>"))
  })

  output$kpi_summary_box_load_time <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    x <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      lapply(polloi::subset_by_date_range, from = start_date(date_range), to = Sys.Date() - 1) %>%
      lapply(function(data_tail) return(data_tail$Median))
    if ( date_range == "quarterly" ) {
      y <- median(apply(do.call(cbind_fill, x), 1, median, na.rm = TRUE))
      return(valueBox(subtitle = "Load time", value = sprintf("%.0fms", y), color = "orange"))
    }
    missing_values <- any(is.na(do.call(cbind_fill, x)))
    x %<>% do.call(cbind_fill, .) %>% apply(MARGIN = 1, FUN = median, na.rm = TRUE)
    y1 <- median(polloi::half(x)); y2 <- median(polloi::half(x, FALSE)); z <- 100 * (y2 - y1) / y1
    if (abs(z) > 0) {
      return(valueBox(subtitle = sprintf("Load time (%s%.1f%%)", ifelse(missing_values, "~", ""), z),
                      value = sprintf("%s%.0fms", ifelse(missing_values, "~", ""), y2),
                      color = polloi::cond_color(z > 0, "red"), icon = polloi::cond_icon(z > 0)))
    }
    return(valueBox(subtitle = "Load time (no change)", value = sprintf("%.0fms", y2), color = "orange"))
  })
  output$kpi_summary_box_zero_results <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    x <- polloi::subset_by_date_range(failure_dygraph_set, from = start_date(date_range), to = Sys.Date() - 1)
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
    x <- split_dataset %>%
      lapply(polloi::subset_by_date_range, from = start_date(date_range), to = Sys.Date() - 1) %>%
      lapply(function(x) return(x$events)) %>%
      do.call(cbind, .) %>%
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
    x <- polloi::subset_by_date_range(augmented_clickthroughs, from = start_date(date_range), to = Sys.Date() - 1)
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
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector,
                                      daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    api_latest <- cbind("Full-text via API" = polloi::subset_by_date_range(split_dataset$cirrus, from = start_date, to = Sys.Date() - 1)$events,
                        "Geo Search" = polloi::subset_by_date_range(split_dataset$geo, from = start_date, to = Sys.Date() - 1)$events,
                        "OpenSearch" = polloi::subset_by_date_range(split_dataset$open, from = start_date, to = Sys.Date() - 1)$events,
                        "Language" = polloi::subset_by_date_range(split_dataset$language, from = start_date, to = Sys.Date() - 1)$events,
                        "Prefix" = polloi::subset_by_date_range(split_dataset$prefix, from = start_date, to = Sys.Date() - 1)$events) %>%
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
    date_range <- input$kpi_summary_date_range_selector
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector,
                                      daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    load_times <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      lapply(polloi::subset_by_date_range, from = start_date, to = Sys.Date() - 1) %>%
      lapply(function(data_tail) return(data_tail[, c('date', 'Median')])) %>%
      { names(.) <- c("Desktop", "Mobile Web", "Android", "iOS"); . } %>%
      dplyr::bind_rows(.id = "Platform") %>%
      unique %>%
      tidyr::spread('Platform', 'Median')
    missing_values <- any(is.na(load_times))
    load_times %<>%
      {
        Median = apply(.[, -1], 1, median, na.rm = TRUE)
        cbind(., Median = Median)
      } %>%
      polloi::smoother(smooth_level = ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE) %>%
      { xts::xts(.[, -1], order.by = .[, 1]) }
    return(dygraph(load_times, xlab = "Date", ylab = "Load time (ms)",
                   main = ifelse(missing_values, "Approximate load times over time", "Load times over time")) %>%
             dySeries("Median", axis = 'y', strokeWidth = 4, label = "Cross-platform Median") %>%
             dyLegend(width = 500, show = "always", labelsDiv = "kpi_load_time_series_legend") %>%
             dyOptions(strokeWidth = 2, colors = RColorBrewer::brewer.pal(5, "Set2")[5:1],
                       drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                       includeZero = TRUE) %>%
             dyCSS(css = system.file("custom.css", package = "polloi")))
  })
  output$kpi_zero_results_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_zero_results
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    zrr <- failure_dygraph_set %>%
      polloi::subset_by_date_range(from = start_date, to = Sys.Date()) %>%
      transform(`Rate` = 100 * `Zero Result Queries` / `Search Queries`)
    zrr_change <- 100 * (zrr$Rate[2:nrow(zrr)] - zrr$Rate[1:(nrow(zrr)-1)])/zrr$Rate[1:(nrow(zrr)-1)]
    zrr <- cbind(zrr[, c('date', 'Rate')], Change = c(NA, zrr_change)) %>%
      polloi::smoother(ifelse(smooth_level == "global", input$smoothing_global, smooth_level), rename = FALSE)
    zrr <- xts::xts(zrr[, -1], zrr[, 1])
    return(dygraph(zrr, main = "Zero results rate over time", xlab = "Date",
                   ylab = "% of search queries that yield zero results") %>%
             dySeries("Change", axis = 'y2', label = "Day-to-day % change", strokeWidth = 1) %>%
             dyLimit(limit = 12.50, label = "Goal: 12.50% zero results rate",
                     color = RColorBrewer::brewer.pal(3, "Set2")[3]) %>%
             dyAxis("y2", label = "Day-to-day % change",
                    valueRange = c(-1, 1) * max(max(abs(as.numeric(zrr$Change)), na.rm = TRUE), 10),
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
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    api_usage <- split_dataset %>%
      lapply(polloi::subset_by_date_range, from = start_date, to = Sys.Date() - 1) %>%
      dplyr::bind_rows() %>%
      tidyr::spread("event_type", "events") %>%
      as.data.frame
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
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    smoothed_data <- augmented_clickthroughs %>%
      polloi::subset_by_date_range(from = start_date, to = Sys.Date() - 1) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_augmented_clickthroughs))
    polloi::make_dygraph(data = smoothed_data, xlab = "Date", ylab = "Rates", "User engagement (augmented clickthroughs) by day") %>%
      dySeries(name = colnames(smoothed_data)[2], strokeWidth = 1.5, strokePattern = "dashed") %>%
      dySeries(name = colnames(smoothed_data)[3], strokeWidth = 1.5, strokePattern = "dashed") %>%
      dyLegend(labelsDiv = "kpi_augmented_clickthroughs_series_legend")
  })

})
