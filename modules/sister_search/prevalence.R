output$sister_search_prevalence_lang_container <- renderUI({
  languages_to_display <- sister_search_averages$language
  names(languages_to_display) <- sprintf("%s (%.1f%%)", sister_search_averages$language, sister_search_averages$avg)
  if (input$sister_search_prevalence_lang_order != "alphabet") {
    languages_to_display <- languages_to_display[order(
      sister_search_averages$avg,
      decreasing = input$sister_search_prevalence_lang_order == "high2low"
    )]
  }
  if (!is.null(input$language_selector)) {
    selected_language <- input$language_selector
  } else {
    selected_language <- languages_to_display[1]
  }
  return(selectInput(
    "sister_search_prevalence_lang_selector", "Language",
    multiple = TRUE, selectize = FALSE, size = 19,
    choices = languages_to_display, selected = selected_language
  ))
})

output$sister_search_prevalence_plot <- renderDygraph({
  req(input$sister_search_prevalence_lang_selector)
  sister_search_prevalence %>%
    dplyr::filter(language %in% input$sister_search_prevalence_lang_selector) %>%
    tidyr::spread(language, prevalence, fill = 0) %>%
    polloi::reorder_columns() %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_sister_search_prevalence_plot)) %>%
    polloi::make_dygraph("Date", "Prevalence (%)", "Wikipedia searches that showed sister project search results") %>%
    dyLegend(show = "always", width = 400, labelsDiv = "sister_search_prevalence_plot_legend") %>%
    dyAxis("y",
      axisLabelFormatter = "function(x) { return x + '%'; }",
      valueFormatter = "function(x) { return Math.round(x * 100)/100 + '%'; }"
    ) %>%
    dyAxis("x", axisLabelFormatter = polloi::custom_axis_formatter) %>%
    dyRangeSelector(fillColor = "", strokeColor = "")
})
