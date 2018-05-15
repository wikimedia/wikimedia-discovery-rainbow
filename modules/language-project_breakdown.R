output$language_selector_container <- renderUI({
  if (input$langproj_metrics %in% c("User engagement", "Threshold-passing %", "Clickthrough rate")){
    temp_language <- available_languages_ctr
  } else if (input$langproj_metrics %in% c("clickthroughs", "Result pages opened", "search sessions")){
    temp_language <- available_languages_desktop
  } else if (input$langproj_metrics %in% c("F = 0.1", "F = 0.5", "F = 0.9")){
    temp_language <- available_languages_paulscore
  } else{
    temp_language <- available_languages
  }

  if (input$language_order == "alphabet") {
    languages_to_display <- as.list(sort(temp_language$language))
    names(languages_to_display) <- temp_language$label[order(temp_language$language)]
  } else {
    languages_to_display <- temp_language$language
    names(languages_to_display) <- temp_language$label
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
  return(selectInput(
    "language_selector", "Language",
    multiple = TRUE, selectize = FALSE, size = 19,
    choices = languages_to_display, selected = selected_language
  ))
})

output$project_selector_container <- renderUI({
  if (input$langproj_metrics %in% c("User engagement", "Threshold-passing %", "Clickthrough rate")){
    temp_project <- available_projects_ctr
  } else if (input$langproj_metrics %in% c("clickthroughs", "Result pages opened", "search sessions")){
    temp_project <- available_projects_desktop
  } else if (input$langproj_metrics %in% c("F = 0.1", "F = 0.5", "F = 0.9")){
    temp_project <- available_projects_paulscore
  } else{
    temp_project <- available_projects
  }

  if (input$project_order == "alphabet") {
    projects_to_display <- as.list(sort(temp_project$project))
    names(projects_to_display) <- temp_project$label[order(temp_project$project)]
  } else {
    projects_to_display <- temp_project$project
    names(projects_to_display) <- temp_project$label
  }

  if (!is.null(input$project_selector)) {
    selected_project <- input$project_selector
  } else {
    selected_project <- projects_to_display[[1]]
  }
  return(selectInput("project_selector", "Project", multiple = TRUE,selectize = FALSE, size = 19,
                     choices = projects_to_display, selected = selected_project))
})

output$langproj_breakdown_plot <- renderDygraph({
  req(input$langproj_metrics, input$language_selector, input$project_selector)
  # Select data
  if (input$langproj_metrics %in% c("User engagement", "Threshold-passing %", "Clickthrough rate")){
    temp <- augmented_clickthroughs_langproj
  } else if (input$langproj_metrics %in% c("clickthroughs", "Result pages opened", "search sessions")){
    temp <- desktop_langproj_dygraph_set
  } else if (input$langproj_metrics %in% c("F = 0.1", "F = 0.5", "F = 0.9")){
    temp <- paulscore_fulltext_langproj
    if (input$paulscore_relative_langproj) {
      temp$`F = 0.1` <- temp$`F = 0.1` / (1/(1-0.1))
      temp$`F = 0.5` <- temp$`F = 0.5` / (1/(1-0.5))
      temp$`F = 0.9` <- temp$`F = 0.9` / (1/(1-0.9))
    }
  } else{
    temp <- input$failure_langproj_automata %>%
      polloi::data_select(langproj_with_automata, langproj_no_automata)
  }
  # Plot
  dyOut <- temp %>%
    aggregate_wikis(input$language_selector, input$project_selector, input$langproj_metrics) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_langproj_breakdown)) %>%
    polloi::make_dygraph(
      xlab = "Date",
      ylab = ifelse(grepl("^F = ", input$langproj_metrics), paste0("PaulScore, ", input$langproj_metrics), polloi::capitalize_first_letter(input$langproj_metrics)),
      title = ifelse(grepl("^F = ", input$langproj_metrics), paste0("PaulScore for fulltext searches, ", input$langproj_metrics), paste0(polloi::capitalize_first_letter(input$langproj_metrics), ", by language and project"))
    ) %>%
    dyLegend(show = "always", width = 400, labelsDiv = "langproj_breakdown_legend") %>%
    dyAxis("x", axisLabelFormatter = polloi::custom_axis_formatter) %>%
    dyRangeSelector(fillColor = "") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-03-29"), "M (Eventlogging Maintenance)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-05-10"), "B (iOS bug fix)", labelLoc = "bottom")
  if (input$paulscore_relative_langproj) {
    dyOut <- dyAxis(dyOut, "y", axisLabelFormatter = "function(x) { return Math.round(100*x, 2) + '%'; }", valueFormatter = "function(x) { return Math.round(100*x, 2) + '%'; }")
  }
  if (input$langproj_metrics %in% c("User engagement", "Threshold-passing %", "Clickthrough rate", "Zero result rate")){
    dyOut <- dyAxis(dyOut, "y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x * 1000)/1000 + '%'; }")
  }
  return(dyOut)
})
