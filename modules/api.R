output$cirrus_aggregate <- renderDygraph({
  split_dataset$cirrus %>%
    tidyr::spread(referrer, calls) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_fulltext_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Full-text search API usage by referrer", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$morelike_aggregate <- renderDygraph({
  split_dataset$`cirrus (more like)` %>%
    tidyr::spread(referrer, calls) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_morelike_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Morelike search API usage by referrer", legend_name = "Searches") %>%
    dyRangeSelector
})

output$open_aggregate <- renderDygraph({
  split_dataset$open %>%
    tidyr::spread(referrer, calls) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_open_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily OpenSearch API usage by referrer", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$geo_aggregate <- renderDygraph({
  split_dataset$geo %>%
    tidyr::spread(referrer, calls) %>%polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geo_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Geo Search API usage by referrer", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$language_aggregate <- renderDygraph({
  split_dataset$language %>%
    tidyr::spread(referrer, calls) %>%polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_language_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Language search API usage by referrer", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})

output$prefix_aggregate <- renderDygraph({
  split_dataset$prefix %>%
    tidyr::spread(referrer, calls) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prefix_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Daily Prefix search API usage by referrer", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-06-29"), "U (new UDF)", labelLoc = "bottom")
})
