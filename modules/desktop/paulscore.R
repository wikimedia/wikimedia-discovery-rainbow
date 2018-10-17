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
    dyLegend(labelsDiv = "paulscore_approx_legend", show = "always") %>%
    dyEvent(as.Date("2017-04-25"), "S (rates)", labelLoc = "bottom")
  if (input$paulscore_relative) {
    dyOut <- dyAxis(dyOut, "y", axisLabelFormatter = "function(x) { return Math.round(100 * x, 3) + '%'; }", valueFormatter = "function(x) { return Math.round(100 * x, 3) + '%'; }")
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
    polloi::make_dygraph(xlab = "Date", ylab = "PaulScore", title = "PaulScore for autocomplete searches from the header, by day", use_si = FALSE, group = "paulscore_approx") %>%
    dyRangeSelector %>%
    dyLegend(labelsDiv = "paulscore_approx_legend", show = "always") %>%
    dyEvent(as.Date("2017-04-25"), "S (rates)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2018-07-05"), "B (bug fixed)", labelLoc = "bottom")
  if (input$paulscore_relative) {
    dyOut <- dyAxis(dyOut, "y", axisLabelFormatter = "function(x) { return Math.round(100 * x, 3) + '%'; }", valueFormatter = "function(x) { return Math.round(100 * x, 3) + '%'; }")
  }
  return(dyOut)
})
