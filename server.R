suppressPackageStartupMessages({
  library(shiny)
  library(shinydashboard)
  library(dygraphs)
  library(sparkline)
})

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
    progress$set(message = "Downloading mobile web data", value = 0.2)
    read_web()
    progress$set(message = "Downloading API usage data", value = 0.3)
    read_api()
    progress$set(message = "Downloading zero results data", value = 0.4)
    read_failures()
    progress$set(message = "Downloading engagement data", value = 0.5)
    read_augmented_clickthrough()
    progress$set(message = "Downloading language-project engagement data", value = 0.6)
    read_augmented_clickthrough_langproj()
    progress$set(message = "Downloading survival data", value = 0.7)
    read_lethal_dose()
    progress$set(message = "Downloading PaulScore data", value = 0.8)
    read_paul_score()
    progress$set(message = "Downloading sister search data", value = 0.9)
    read_sister_search()
    progress$set(message = "Finished downloading datasets", value = 1)
    existing_date <<- Sys.Date()
    progress$close()
  }

  # KPIs
  source("modules/key_performance_metrics/summary/date_range.R", local = TRUE)
  source("modules/key_performance_metrics/summary/boxes.R", local = TRUE)
  source("modules/key_performance_metrics/summary/sparklines.R", local = TRUE)
  source("modules/key_performance_metrics/monthly_metrics.R", local = TRUE)
  source("modules/key_performance_metrics/load_times.R", local = TRUE)
  source("modules/key_performance_metrics/zero_results.R", local = TRUE)
  source("modules/key_performance_metrics/api_usage.R", local = TRUE)
  source("modules/key_performance_metrics/augmented_clickthroughs.R", local = TRUE)
  # Desktop
  source("modules/desktop/events.R", local = TRUE)
  source("modules/desktop/load_times.R", local = TRUE)
  source("modules/desktop/paulscore.R", local = TRUE)
  # Mobile Web
  source("modules/mobile_web/events.R", local = TRUE)
  source("modules/mobile_web/load_times.R", local = TRUE)
  # Mobile Apps
  source("modules/mobile_app/events.R", local = TRUE)
  source("modules/mobile_app/load_times.R", local = TRUE)
  source("modules/mobile_app/click_position.R", local = TRUE)
  source("modules/mobile_app/invoke_source.R", local = TRUE)
  # API
  source("modules/api.R", local = TRUE)
  # ZRR
  source("modules/zero_results.R", local = TRUE)
  # Sister Search
  source("modules/sister_search/traffic.R", local = TRUE)
  # Survival
  source("modules/page_visit_times.R", local = TRUE)
  # Language/Project Breakdown
  source("modules/language-project_breakdown.R", local = TRUE)

  # Check datasets for missing data and notify user which datasets are missing data (if any)
  output$message_menu <- renderMenu({
    notifications <- list(
      polloi::check_yesterday(desktop_dygraph_set, "Desktop events"),
      polloi::check_past_week(desktop_load_data, "Desktop load times"),
      polloi::check_yesterday(mobile_dygraph_set, "Mobile Web events"),
      polloi::check_past_week(mobile_load_data, "Mobile Web load times"),
      polloi::check_yesterday(android_dygraph_set, "Android events"),
      polloi::check_past_week(android_load_data, "Android load times"),
      polloi::check_yesterday(position_prop, "clicked result positions"),
      polloi::check_past_week(position_prop, "clicked result positions"),
      polloi::check_yesterday(source_prop, "source of search on Android"),
      polloi::check_past_week(source_prop, "source of search on Android"),
      polloi::check_yesterday(ios_dygraph_set, "iOS events"),
      polloi::check_past_week(ios_load_data, "iOS load times"),
      polloi::check_yesterday(dplyr::bind_rows(split_dataset, .id = "api"), "API usage data"),
      polloi::check_past_week(dplyr::bind_rows(split_dataset, .id = "api"), "API usage data"),
      polloi::check_yesterday(failure_data_with_automata, "zero results data"),
      polloi::check_past_week(failure_data_with_automata, "zero results data"),
      polloi::check_yesterday(suggestion_with_automata, "suggestions data"),
      polloi::check_past_week(suggestion_with_automata, "suggestions data"),
      polloi::check_yesterday(augmented_clickthroughs, "engagement % data"),
      polloi::check_past_week(augmented_clickthroughs, "engagement % data"),
      polloi::check_yesterday(paulscore_fulltext, "full-text PaulScores"),
      polloi::check_past_week(paulscore_fulltext, "full-text PaulScores"),
      polloi::check_yesterday(sister_search_traffic, "sister search traffic"),
      polloi::check_past_week(sister_search_traffic, "sister search traffic"),
      polloi::check_yesterday(user_page_visit_dataset, "page survival times"),
      polloi::check_past_week(user_page_visit_dataset, "page survival times"),
      polloi::check_yesterday(serp_page_visit_dataset, "serp survival times"),
      polloi::check_past_week(serp_page_visit_dataset, "serp survival times"))
    notifications <- notifications[!vapply(notifications, is.null, FALSE)]
    return(dropdownMenu(type = "notifications", .list = notifications))
  })

}
