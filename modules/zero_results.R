output$failure_rate_plot <- renderDygraph({
  input$failure_rate_automata %>%
    polloi::data_select(failure_data_with_automata, failure_data_no_automata) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_rate)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Zero Results Rate (%)", title = "Zero Results Rate, by day", legend_name = "ZRR") %>%
    dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
    dyRangeSelector(fillColor = "") %>%
    dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})

output$failure_rate_change_plot <- renderDygraph({
  input$failure_rate_automata %>%
    polloi::data_select(failure_roc_with_automata, failure_roc_no_automata) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_rate)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Change", title = "Zero Results rate change, by day", legend_name = "Change") %>%
    dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
    dyRangeSelector(fillColor = "", strokeColor = "") %>%
    dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})

output$failure_breakdown_plot <- renderDygraph({
  xts_data <- ("automata" %in% input$failure_breakdown_include) %>%
    polloi::data_select(failure_breakdown_with_automata, failure_breakdown_no_automata) %>%
    polloi::data_select("regex" %in% input$failure_breakdown_include, ., dplyr::select(., -Regex)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_breakdown), rename = FALSE) %>%
    { xts::xts(.[, -1], order.by = .$date) }
  xts_data %>%
    dygraph(xlab = "Date", ylab = "Zero Results Rate", main = paste("Zero result rate by search type,", ifelse("automata" %in% input$failure_breakdown_include, "including", "excluding"), "automata")) %>%
    dyLegend(width = 600, show = "always", labelsDiv = "failure_breakdown_plot_legend") %>%
    dyOptions(strokeWidth = 2, drawPoints = FALSE, pointSize = 3, labelsKMB = TRUE, includeZero = TRUE) %>%
    dyCSS(css = system.file("custom.css", package = "polloi")) %>%
    dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
    dySeries("Full-Text Search", color = "#377EB8", strokeWidth = 3) %>%
    dySeries("Prefix Search", color = "#E41A1C", strokeWidth = 3) %>%
    dySeries("Prefix", color = "#E41A1C") %>%
    dySeries("Completion Suggester", color = "#4DAF4A") %>%
    dySeries("More Like", color = "#984EA3") %>%
    dySeries("Geospatial", color = "#A65628") %>%
    {
      if ("regex" %in% input$failure_breakdown_include) {
        dySeries(., "Regex", color = "#FF7f00")
      } else {
        .
      }
    } %>%
    dyRangeSelector(fillColor = "") %>%
    # Remember to update the tab documentation with details about the annotations!
    dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})

output$suggestion_dygraph_plot <- renderDygraph({
  input$failure_suggestions_automata %>%
    polloi::data_select(suggestion_with_automata, suggestion_no_automata) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_failure_suggestions)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Zero Results Rate", title = "Zero Result Rates with Search Suggestions") %>%
    dyAxis("y", axisLabelFormatter = "function(x) { return x + '%'; }", valueFormatter = "function(x) { return Math.round(x, 3) + '%'; }") %>%
    dyRangeSelector(fillColor = "") %>%
    dyEvent(as.Date("2016-02-01"), "A (format switch)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2016-03-16"), "Completion Suggester Deployed", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom")
})
