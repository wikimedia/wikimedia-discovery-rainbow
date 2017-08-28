output$cirrus_aggregate <- renderDygraph({
  split_dataset$cirrus %>%
    tidyr::spread(key = referer_class, value = calls) %>%
    dplyr::mutate(All = ifelse(is.na(All), rowSums(.[, -c(1, 2)], na.rm = TRUE), All)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_fulltext_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Full-text via API usage by day", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "U (new UDF)", labelLoc = "bottom")
})

output$open_aggregate <- renderDygraph({
  split_dataset$open %>%
    tidyr::spread(key = referer_class, value = calls) %>%
    dplyr::mutate(All = ifelse(is.na(All), rowSums(.[, -c(1, 2)], na.rm = TRUE), All)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_open_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "OpenSearch API usage by day", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "U (new UDF)", labelLoc = "bottom")
})

output$geo_aggregate <- renderDygraph({
  split_dataset$geo %>%
    tidyr::spread(key = referer_class, value = calls) %>%
    dplyr::mutate(All = ifelse(is.na(All), rowSums(.[, -c(1, 2)], na.rm = TRUE), All)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_geo_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Geo Search API usage by day", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "U (new UDF)", labelLoc = "bottom")
})

output$language_aggregate <- renderDygraph({
  split_dataset$language %>%
    tidyr::spread(key = referer_class, value = calls) %>%
    dplyr::mutate(All = ifelse(is.na(All), rowSums(.[, -c(1, 2)], na.rm = TRUE), All)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_language_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Language Search API usage by day", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "U (new UDF)", labelLoc = "bottom")
})

output$prefix_aggregate <- renderDygraph({
  split_dataset$prefix %>%
    tidyr::spread(key = referer_class, value = calls) %>%
    dplyr::mutate(All = ifelse(is.na(All), rowSums(.[, -c(1, 2)], na.rm = TRUE), All)) %>%
    polloi::smoother(smooth_level = polloi::smooth_switch(input$smoothing_global, input$smoothing_prefix_search)) %>%
    polloi::make_dygraph(xlab = "Date", ylab = "Searches", title = "Prefix Search API usage by day", legend_name = "Searches") %>%
    dyRangeSelector %>%
    dyEvent(as.Date("2017-01-01"), "R (reportupdater)", labelLoc = "bottom") %>%
    dyEvent(as.Date("2017-08-14"), "U (new UDF)", labelLoc = "bottom")
})
