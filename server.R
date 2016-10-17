library(shiny)
library(shinydashboard)
library(dygraphs)

source("utils.R")

existing_date <- Sys.Date() - 1

function(input, output, session) {

  if (Sys.Date() != existing_date) {
    # Create a Progress object
    progress <- shiny::Progress$new()
    progress$set(message = "Downloading desktop data", value = 0)
    read_desktop()
    progress$set(message = "Downloading apps data", value = 0.1)
    read_apps()
    progress$set(message = "Downloading mobile web data", value = 0.3)
    read_web()
    progress$set(message = "Downloading API usage data", value = 0.4)
    read_api()
    progress$set(message = "Downloading zero results data", value = 0.5)
    read_failures(existing_date)
    progress$set(message = "Downloading engagement data", value = 0.7)
    read_augmented_clickthrough()
    progress$set(message = "Downloading survival data", value = 0.8)
    read_lethal_dose()
    progress$set(message = "Downloading PaulScore data", value = 0.9)
    read_paul_score()
    progress$set(message = "Finished downloading datasets", value = 1)
    existing_date <<- Sys.Date()
    progress$close()
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
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Desktop search events, by day") %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2016-07-12"), "A (schema switch)", labelLoc = "bottom")
  })

  output$desktop_load_plot <- renderDygraph({
    desktop_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_desktop_load)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Desktop load times, by day", use_si = FALSE) %>%
      dyRangeSelector %>%
      dyEvent(as.Date("2016-07-12"), "A (schema switch)", labelLoc = "bottom")
  })

  output$paulscore_approx_plot_fulltext <- renderDygraph({
    temp <- paulscore_fulltext
    if (input$paulscore_relative) {
      temp$`F = 0.1` <- temp$`F = 0.1` / (1/(1-0.1))
      temp$`F = 0.5` <- temp$`F = 0.5` / (1/(1-0.5))
      temp$`F = 0.9` <- temp$`F = 0.9` / (1/(1-0.9))
    }
    dyOut <- temp %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_paulscore_approx)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "PaulScore", title = "PaulScore for fulltext searches, by day", use_si = FALSE, group = "paulscore_approx") %>%
      dyRangeSelector %>%
      dyLegend(labelsDiv = "paulscore_approx_legend", show = "always")
    if (input$paulscore_relative) {
      dyOut <- dyAxis(dyOut, "y", axisLabelFormatter = "function(x) { return Math.round(100*x, 2) + '%'; }", valueFormatter = "function(x) { return Math.round(100*x, 2) + '%'; }")
    }
    return(dyOut)
  })

  output$paulscore_approx_plot_autocomplete <- renderDygraph({
    temp <- paulscore_autocomplete
    if (input$paulscore_relative) {
      temp$`F = 0.1` <- temp$`F = 0.1` / (1/(1-0.1))
      temp$`F = 0.5` <- temp$`F = 0.5` / (1/(1-0.5))
      temp$`F = 0.9` <- temp$`F = 0.9` / (1/(1-0.9))
    }
    dyOut <- temp %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_paulscore_approx)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "PaulScore", title = "PaulScore for autocomplete searches, by day", use_si = FALSE, group = "paulscore_approx") %>%
      dyRangeSelector %>%
      dyLegend(labelsDiv = "paulscore_approx_legend", show = "always")
    if (input$paulscore_relative) {
      dyOut <- dyAxis(dyOut, "y", axisLabelFormatter = "function(x) { return Math.round(100*x, 2) + '%'; }", valueFormatter = "function(x) { return Math.round(100*x, 2) + '%'; }")
    }
    return(dyOut)
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
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Mobile search events, by day") %>%
      dyRangeSelector
  })

  output$mobile_load_plot <- renderDygraph({
    mobile_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_mobile_load)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Mobile search events, by day", use_si = FALSE) %>%
      dyRangeSelector
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
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "Android mobile app search events, by day") %>%
      dyRangeSelector
  })

  output$android_load_plot <- renderDygraph({
    android_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_load)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "Android result load times, by day", use_si = FALSE) %>%
      dyRangeSelector
  })

  output$ios_event_plot <- renderDygraph({
    ios_dygraph_set %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_event)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Events", title = "iOS mobile app search events, by day") %>%
      dyRangeSelector
  })

  output$ios_load_plot <- renderDygraph({
    ios_load_data %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_load)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Load time (ms)", title = "iOS result load times, by day", use_si = FALSE) %>%
      dyRangeSelector
  })

  output$click_position_plot <- renderDygraph({
    position_prop %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_click_position)) %>%
      polloi::make_dygraph(xlab = "", ylab = "Proportion of Clicks (%)", title = "Proportion of Clicks on Nth Result") %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return x + '%'; }") %>%
      dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
             axisLabelWidth = 100, pixelsPerLabel = 80) %>%
      dyLegend(labelsDiv = "app_click_position_legend") %>%
      dyRangeSelector(fillColor = "", strokeColor = "")
  })

  output$invoke_source_plot <- renderDygraph({
    source_prop %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_app_invoke_source)) %>%
      polloi::make_dygraph(xlab = "", ylab = "Proportion of Search Sessions (%)", title = "Proportion of Search Sessions, by Invoke Source") %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return x + '%'; }") %>%
      dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
             axisLabelWidth = 100, pixelsPerLabel = 80) %>%
      dyLegend(labelsDiv = "app_invoke_source_legend") %>%
      dyRangeSelector(fillColor = "", strokeColor = "")
  })

  ## API plots
  output$cirrus_aggregate <- renderDygraph({
    split_dataset$cirrus[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_fulltext_search)) %>%

      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Full-text via API usage by day", legend_name = "Searches") %>%
      dyRangeSelector
  })

  output$open_aggregate <- renderDygraph({
    split_dataset$open[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_open_search)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "OpenSearch API usage by day", legend_name = "Searches") %>%
      dyRangeSelector
  })

  output$geo_aggregate <- renderDygraph({
    split_dataset$geo[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geo_search)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Geo Search API usage by day", legend_name = "Searches") %>%
      dyRangeSelector
  })

  output$language_aggregate <- renderDygraph({
    split_dataset$language[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_language_search)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Language Search API usage by day", legend_name = "Searches") %>%
      dyRangeSelector
  })

  output$prefix_aggregate <- renderDygraph({
    split_dataset$prefix[, c(1, 3)] %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prefix_search)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Prefix Search API usage by day", legend_name = "Searches") %>%
      dyRangeSelector
  })

  # Failure plots
  output$failure_rate_plot <- renderDygraph({
    polloi::data_select(input$failure_rate_automata, failure_data_with_automata, failure_data_no_automata) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_rate)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Zero Results Rate (%)", title = "Zero Results Rate, by day",
                           legend_name = "ZRR") %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return x + '%'; }") %>%
      dyRangeSelector(fillColor = "") %>%
      dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom")
  })

  output$failure_rate_change_plot <- renderDygraph({
    polloi::data_select(input$failure_rate_automata, failure_roc_with_automata, failure_roc_no_automata) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_rate)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Change", title = "Zero Results rate change, by day", legend_name = "Change") %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
      dyRangeSelector(fillColor = "", strokeColor = "") %>%
      dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom")
  })

  output$failure_breakdown_plot <- renderDygraph({
    xts_data <- input$failure_breakdown_automata %>%
      polloi::data_select(failure_breakdown_with_automata, failure_breakdown_no_automata) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_breakdown)) %>%

      { xts(.[, -1], order.by = .$date) }
    xts_data %>% dygraph(xlab = "Date", ylab = "Zero Results Rate",
                         main = "Zero result rate by search type") %>%
      dyLegend(width = 600, show = "always", labelsDiv = "failure_breakdown_plot_legend") %>%
      dyOptions(strokeWidth = 2, drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE, includeZero = TRUE) %>%
      dyCSS(css = system.file("custom.css", package = "polloi")) %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return x + '%'; }") %>%
      # We use grep(colnames(xts_data), value = TRUE) because smoothing appends "(... median)" to colnames.
      # Customize the full_text and prefix series colors so they match "Full-Text Search" and "Prefix Search":
      dySeries(grep("Full-Text Search", colnames(xts_data), value = TRUE, fixed = TRUE),
               color = "#377EB8", strokeWidth = 3) %>%
      dySeries(grep("Full-Text", colnames(xts_data), value = TRUE)[1], color = "#377EB8") %>%
      dySeries(grep("Prefix Search", colnames(xts_data), value = TRUE, fixed = TRUE),
               color = "#E41A1C", strokeWidth = 3) %>%
      dySeries(grep("Prefix", colnames(xts_data), value = TRUE)[1], color = "#E41A1C") %>%
      # Specify the colors for other query types here:
      dySeries(grep("Completion Suggester", colnames(xts_data), value = TRUE), color = "#4DAF4A") %>%
      dySeries(grep("More Like", colnames(xts_data), value = TRUE), color = "#984EA3") %>%
      dySeries(grep("Geospatial", colnames(xts_data), value = TRUE), color = "#A65628") %>%
      dySeries(grep("Regex", colnames(xts_data), value = TRUE), color = "#FF7f00") %>%
      dyRangeSelector(fillColor = "") %>%
      # Remember to update the tab documentation with details about the annotations!
      dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom")
  })

  output$suggestion_dygraph_plot <- renderDygraph({
    polloi::data_select(input$failure_suggestions_automata, suggestion_with_automata, suggestion_no_automata) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_suggestions)) %>%
      polloi::make_dygraph(xlab = "Date", ylab = "Zero Results Rate", title = "Zero Result Rates with Search Suggestions") %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return x + '%'; }") %>%
      dyRangeSelector(fillColor = "") %>%
      dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
      dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom")
  })

  output$language_selector_container <- renderUI({
    if (input$language_order == "alphabet") {
      languages_to_display <- as.list(sort(available_languages$language))
      names(languages_to_display) <- available_languages$label[order(available_languages$language)]
    } else {
      languages_to_display <- available_languages$language
      names(languages_to_display) <- available_languages$label
    }

    # e.g. if user sorts projects alphabetically and the selected project is "10th Anniversary of Wikipeda"
    #      then automatically select the language "(None)" to avoid giving user an error. This also works if
    #      the user selects a project that is not multilingual, so this automatically chooses the "(None)"
    #      option for the user.
    if (any(input$project_selector %in% projects_db$project[!projects_db$multilingual])) {
      if (any(input$project_selector %in% projects_db$project[projects_db$multilingual])) {
        if (!is.null(input$language_selector)) {
          selected_language <- union("(None)", input$language_selector)
        } else {
          selected_language <- c("(None)", languages_to_display[[1]])
        }
      } else {
        selected_language <- "(None)"
      }
    } else {
      if (!is.null(input$language_selector)) {
        selected_language <- input$language_selector
      } else {
        selected_language <- languages_to_display[[1]]
      }
    }
    return(selectInput("language_selector", "Language", multiple = TRUE,selectize = FALSE, size = 19,
                       choices = languages_to_display, selected = selected_language))
  })

  output$project_selector_container <- renderUI({
    if (input$project_order == "alphabet") {
      projects_to_display <- as.list(sort(available_projects$project))
      names(projects_to_display) <- available_projects$label[order(available_projects$project)]
    } else {
      projects_to_display <- available_projects$project
      names(projects_to_display) <- available_projects$label
    }
    return(selectInput("project_selector", "Project", multiple = TRUE,selectize = FALSE, size = 19,
                       choices = projects_to_display, selected = projects_to_display[[1]]))
  })

  output$failure_langproj_plot <- renderDygraph({
    polloi::data_select(input$failure_langproj_automata, langproj_with_automata, langproj_no_automata) %>%
      aggregate_wikis(input$language_selector, input$project_selector) %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_langproj)) %>%
      polloi::make_dygraph(xlab = "", ylab = "Zero Results Rate", title = "Zero result rate by language and project") %>%
      dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return x + '%'; }") %>%
      dyLegend(show = "always", width = 400, labelsDiv = "failure_langproj_legend") %>%
      dyAxis("x", axisLabelFormatter = polloi::custom_axis_formatter) %>%
      dyRangeSelector(fillColor = "")
  })

  # Survival
  output$lethal_dose_plot <- renderDygraph({
    user_page_visit_dataset %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_lethal_dose_plot)) %>%
      polloi::make_dygraph(xlab = "", ylab = "Time (s)", title = "Time at which we have lost N% of the users") %>%
      dyAxis("x", ticker = "Dygraph.dateTicker", axisLabelFormatter = polloi::custom_axis_formatter,
             axisLabelWidth = 100, pixelsPerLabel = 80) %>%
      dyLegend(labelsDiv = "lethal_dose_plot_legend") %>%
      dyRangeSelector(fillColor = "", strokeColor = "")
  })

  ## KPI Summary Boxes
  output$kpi_summary_date_range <- renderUI({
    date_range <- input$kpi_summary_date_range_selector
    switch(date_range,
           all = {
             return(NULL)
           },
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
                 c(paste(.[2:1], collapse = "-"), paste(.[4:3], collapse = "-"))
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
                 c(paste(.[2:1], collapse = "-"), paste(.[4:3], collapse = "-"))
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
                      HTML("<h3 class='kpi_date'>KPI summary for", ., "</h3>"))
           })
    return(HTML("<h3 class='kpi_date'>KPI summary for", temp[1], ", and % change from", temp[2], "</h3>"))
  })

  output$kpi_summary_box_load_time <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    if (date_range == "all") {
      return(valueBox(subtitle = "Load time", value = "N/A", color = "black"))
    }
    x <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      lapply(polloi::subset_by_date_range, from = start_date(date_range), to = Sys.Date() - 1) %>%
      lapply(function(data_tail) return(data_tail$Median))
    if ( date_range == "quarterly" ) {
      y <- median(apply(do.call(polloi::cbind_fill, x), 1, median, na.rm = TRUE))
      return(valueBox(subtitle = "Load time", value = sprintf("%.0fms", y), color = "orange"))
    }
    missing_values <- any(is.na(do.call(polloi::cbind_fill, x)))
    x %<>% do.call(polloi::cbind_fill, .) %>% apply(MARGIN = 1, FUN = median, na.rm = TRUE)
    y1 <- median(polloi::half(x)); y2 <- median(polloi::half(x, FALSE)); z <- 100 * (y2 - y1) / y1
    if (!is.na(z)) {
      if (abs(z) > 0) {
        return(valueBox(subtitle = sprintf("Load time (%s%.1f%%)", ifelse(missing_values, "~", ""), z),
                        value = sprintf("%s%.0fms", ifelse(missing_values, "~", ""), y2),
                        color = polloi::cond_color(z > 0, "red"), icon = polloi::cond_icon(z > 0)))
      }
      return(valueBox(subtitle = "Load time (no change)", value = sprintf("%.0fms", y2), color = "orange"))
    }
    return(polloi::na_box("Load time (data problem)"))
  })
  output$kpi_summary_box_zero_results <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    if (date_range == "all") {
      return(valueBox(subtitle = "Zero results rate", value = "N/A", color = "black"))
    }
    x <- polloi::subset_by_date_range(failure_data_with_automata, from = start_date(date_range), to = Sys.Date() - 1)
    x <- transform(x, Rate = rate)$Rate
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "Zero results rate", color = "orange",
                      value = sprintf("%.1f%%", median(x))))
    }
    y1 <- median(polloi::half(x)); y2 <- median(polloi::half(x, FALSE)); z <- (y2 - y1)/y1
    if (!is.na(z)) {
      if (abs(z) > 0) {
        return(valueBox(
          subtitle = sprintf("Zero results rate (%.1f%%)", z),
          value = sprintf("%.1f%%", y2),
          icon = cond_icon(z > 0), color = polloi::cond_color(z > 0, "red")
        ))
      }
      return(valueBox(subtitle = "Zero results rate (no change)",
                      value = sprintf("%.1f%%", y2), color = "orange"))
    }
    return(polloi::na_box("Zero results rate (data problem)"))
  })
  output$kpi_summary_box_api_usage <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    if (date_range == "all") {
      return(valueBox(subtitle = "API usage", value = "N/A", color = "black"))
    }
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
    if (!is.na(z)) {
      if (abs(z) > 0) {
        return(valueBox(subtitle = sprintf("API usage (%.1f%%)", z),
                        value = polloi::compress(y2, 0), color = polloi::cond_color(z > 0), icon = polloi::cond_icon(z > 0)))
      }
      return(valueBox(subtitle = "API usage (no change)", value = polloi::compress(y2, 0), color = "orange"))
    }
    return(polloi::na_box("API usage (data problem)"))
  })
  output$kpi_summary_box_augmented_clickthroughs <- renderValueBox({
    date_range <- input$kpi_summary_date_range_selector
    if (date_range == "all") {
      return(valueBox(subtitle = "User engagement", value = "N/A", color = "black"))
    }
    x <- polloi::subset_by_date_range(augmented_clickthroughs, from = start_date(date_range), to = Sys.Date() - 1)
    if (date_range == "quarterly") {
      return(valueBox(subtitle = "User engagement", color = "orange",
                      value = sprintf("%.1f%%", median(x$user_engagement))))
    }
    y1 <- median(polloi::half(x$user_engagement))
    y2 <- median(polloi::half(x$user_engagement, FALSE))
    z <- 100 * (y2 - y1)/y1
    if (!is.na(z)) {
      if (abs(z) > 0) {
        return(valueBox(
          subtitle = sprintf("User engagement (%.1f%%)", z),
          value = sprintf("%.1f%%", y2),
          icon = cond_icon(z > 0), color = polloi::cond_color(z > 0, "green")
        ))
      }
      return(valueBox(subtitle = "User engagement (no change)",
                      value = sprintf("%.1f%%", y2), color = "orange"))
    }
    return(polloi::na_box("User engagement (data problem)"))
  })

  ## KPI Modules
  output$kpi_load_time_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_load_time
    date_range <- input$kpi_summary_date_range_selector
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector,
                                      all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    load_times <- list(desktop_load_data, mobile_load_data, android_load_data, ios_load_data) %>%
      {
        if (is.na(start_date)) {
          lapply(., function(dataset) {
            return(dataset[!duplicated(dataset$date, dataset$event_type, fromLast = TRUE), ])
          })
        } else {
          lapply(., polloi::subset_by_date_range, from = start_date, to = Sys.Date() - 1)
        }
      } %>%
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
             dyCSS(css = system.file("custom.css", package = "polloi")) %>%
             dyRangeSelector)
  })
  output$kpi_zero_results_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_zero_results
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    zrr <- failure_data_with_automata %>%
      {
        if (is.na(start_date)) {
          .
        } else {
          polloi::subset_by_date_range(., from = start_date, to = Sys.Date())
        }
      } %>%
      transform(`Rate` = rate)
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
                    independentTicks = TRUE, drawGrid = FALSE,
                    axisLabelFormatter = "function(x) { return x + '%'; }",
                    valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
             dyAxis("y", drawGrid = FALSE,
                    axisLineColor = RColorBrewer::brewer.pal(3, "Set2")[1],
                    axisLabelColor = RColorBrewer::brewer.pal(3, "Set2")[1],
                    axisLabelFormatter = "function(x) { return x + '%'; }",
                    valueFormatter = "function(x) { return x + '%'; }") %>%
             dyLimit(limit = 0, color = RColorBrewer::brewer.pal(3, "Set2")[2], strokePattern = "dashed") %>%
             dyLegend(width = 400, show = "always") %>%
             dyOptions(strokeWidth = 3, colors = RColorBrewer::brewer.pal(3, "Set2"),
                       drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE,
                       includeZero = TRUE) %>%
             dyCSS(css = system.file("custom.css", package = "polloi")) %>%
             dyRangeSelector(fillColor = "") %>%
             dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
             dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom"))
  })
  output$kpi_api_usage_series <- renderDygraph({
    smooth_level <- input$smoothing_kpi_api_usage
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    api_usage <- split_dataset %>%
      {
        if (is.na(start_date)) {
          lapply(., function(dataset) {
            return(dataset[!duplicated(dataset$date, dataset$event_type, fromLast = TRUE), ])
          })
        } else {
          lapply(., polloi::subset_by_date_range, from = start_date, to = Sys.Date() - 1)
        }
      } %>%
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
               dyCSS(css = system.file("custom.css", package = "polloi")) %>%
               dyRangeSelector)
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
             dyCSS(css = system.file("custom.css", package = "polloi")) %>%
             dyRangeSelector)
  })
  output$kpi_augmented_clickthroughs_series <- renderDygraph({
    start_date <- Sys.Date() - switch(input$kpi_summary_date_range_selector, all = NA, daily = 1, weekly = 8, monthly = 31, quarterly = 91)
    smoothed_data <- augmented_clickthroughs %>%
      {
        if (is.na(start_date)) {
          .
        } else {
          polloi::subset_by_date_range(., from = start_date, to = Sys.Date())
        }
      } %>%
      polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_augmented_clickthroughs))
    polloi::make_dygraph(data = smoothed_data, xlab = "Date", ylab = "Rates", "User engagement (augmented clickthroughs) by day") %>%
      dySeries(name = colnames(smoothed_data)[2], strokeWidth = 1.5, strokePattern = "dashed") %>%
      dySeries(name = colnames(smoothed_data)[3], strokeWidth = 1.5, strokePattern = "dashed") %>%
      dyLegend(labelsDiv = "kpi_augmented_clickthroughs_series_legend") %>%
      dyRangeSelector(fillColor = "", strokeColor = "") %>%
      dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom")
  })

  ## Monthly metrics
  output$monthly_metrics_tbl <- renderTable({
    temp <- data.frame(
      KPI = c("Load time", "Zero results rate", "API Usage", "User engagement"),
      Units = c("ms", "%", "", "%")
    )

    prev_month <- as.Date(paste(input$monthy_metrics_year, which(month.name == input$monthy_metrics_month), "1", sep = "-"))
    prev_prev_month <- prev_month - months(1)
    prev_year <- prev_month - months(12)

    smoothed_load_times <- list(Desktop = desktop_load_data,
                                Mobile = mobile_load_data,
                                Android = android_load_data,
                                iOS = ios_load_data) %>%
      lapply(function(platform_load_data) {
        platform_load_data[, c("date", "Median")]
      }) %>%
      dplyr::bind_rows(.id = "platform") %>%
      dplyr::group_by(date) %>%
      dplyr::summarize(Median = median(Median)) %>%
      polloi::smoother("month", rename = FALSE)
    smoothed_zrr <- polloi::smoother(failure_data_with_automata, "month", rename = FALSE)
    smoothed_api <- split_dataset %>%
      lapply(function(platform_load_data) {
        platform_load_data[, c("date", "events")]
      }) %>%
      dplyr::bind_rows(.id = "api") %>%
      dplyr::group_by(date) %>%
      dplyr::summarize(total = sum(events)) %>%
      polloi::smoother("month", rename = FALSE)
    smoothed_engagement <- augmented_clickthroughs[, c("date", "user_engagement")] %>%
      polloi::smoother("month", rename = FALSE)

    temp$Current <- c(
      smoothed_load_times$Median[smoothed_load_times$date == prev_month],
      smoothed_zrr$rate[smoothed_zrr$date == prev_month],
      smoothed_api$total[smoothed_api$date == prev_month],
      smoothed_engagement$user_engagement[smoothed_engagement$date == prev_month]
    )
    temp$Previous_month <- c(
      smoothed_load_times$Median[smoothed_load_times$date == prev_prev_month],
      smoothed_zrr$rate[smoothed_zrr$date == prev_prev_month],
      smoothed_api$total[smoothed_api$date == prev_prev_month],
      smoothed_engagement$user_engagement[smoothed_engagement$date == prev_prev_month]
    )
    temp$Previous_year <- c(
      ifelse(sum(smoothed_load_times$date == prev_year) == 0, NA, smoothed_load_times$Median[smoothed_load_times$date == prev_year]),
      ifelse(sum(smoothed_zrr$date == prev_year) == 0, NA, smoothed_zrr$rate[smoothed_zrr$date == prev_year]),
      ifelse(sum(smoothed_api$date == prev_year) == 0, NA, smoothed_api$total[smoothed_api$date == prev_year]),
      ifelse(sum(smoothed_engagement$date == prev_year) == 0, NA, smoothed_engagement$user_engagement[smoothed_engagement$date == prev_year])
    )

    # Compute month-over-month changes:
    temp$MoM <- c(
      100 * (temp$Current - temp$Previous_month)/temp$Previous_month
    )
    # Compute year-over-year changes:
    temp$YoY <- c(
      100 * (temp$Current - temp$Previous_year)/temp$Previous_year
    )
    # Affix units:
    temp$Current <- paste0(temp$Current, temp$Units)
    temp$Previous_month <- paste0(temp$Previous_month, temp$Units)
    temp$Previous_year <- paste0(temp$Previous_year, temp$Units)
    temp$MoM <- sprintf("%s%.2f%%", ifelse(temp$MoM > 0, "+", ""), temp$MoM)
    temp$YoY <- sprintf("%s%.2f%%", ifelse(temp$YoY > 0, "+", ""), temp$YoY)
    # API Usage units (K/M/B/T):
    temp[3, c("Current", "Previous_month", "Previous_year")] <- polloi::compress(as.numeric(temp[3, c("Current", "Previous_month", "Previous_year")]))
    # Rename columns to use month & year:
    names(temp) <- c("KPI", "Units", as.character(prev_month, "%B %Y"), as.character(prev_prev_month, "%B %Y"), as.character(prev_year, "%B %Y"), "MoM", "YoY")
    # Sanitize:
    temp[temp == "NA%" | temp == "NANA%" | temp == "NANA"] <- "--"
    rownames(temp) <- temp$KPI
    cols_to_keep <- c(5, 4, 3, 6, 7)
    if (!input$monthly_metrics_prev_month) {
      cols_to_keep <- base::setdiff(cols_to_keep, 4)
    }
    if (!input$monthly_metrics_prev_year) {
      cols_to_keep <- base::setdiff(cols_to_keep, 5)
    }
    temp[, cols_to_keep]
  }, rownames = TRUE, striped = TRUE)

  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(desktop_dygraph_set, "Desktop events"),
      polloi::check_past_week(desktop_load_data, "Desktop load times"),
      polloi::check_yesterday(mobile_dygraph_set, "Mobile Web events"),
      polloi::check_past_week(mobile_load_data, "Mobile Web load times"),
      polloi::check_yesterday(android_dygraph_set, "Android events"),
      polloi::check_past_week(android_load_data, "Android load times"),
      polloi::check_yesterday(ios_dygraph_set, "iOS events"),
      polloi::check_past_week(ios_load_data, "iOS load times"),
      polloi::check_yesterday(dplyr::bind_rows(split_dataset), "API usage data"),
      polloi::check_past_week(dplyr::bind_rows(split_dataset), "API usage data"),
      polloi::check_yesterday(failure_data_with_automata, "zero results data"),
      polloi::check_past_week(failure_data_with_automata, "zero results data"),
      polloi::check_yesterday(suggestion_with_automata, "suggestions data"),
      polloi::check_past_week(suggestion_with_automata, "suggestions data"),
      polloi::check_yesterday(augmented_clickthroughs, "engagement % data"),
      polloi::check_past_week(augmented_clickthroughs, "engagement % data"),
      polloi::check_yesterday(user_page_visit_dataset, "survival times"),
      polloi::check_past_week(user_page_visit_dataset, "survival times"))
    notifications <- notifications[!sapply(notifications, is.null)]
    return(dropdownMenu(type = "notifications", .list = notifications))
  })

}
