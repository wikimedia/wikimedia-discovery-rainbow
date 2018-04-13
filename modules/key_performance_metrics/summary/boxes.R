output$kpi_summary_box_augmented_clickthroughs <- renderValueBox({
  date_range <- input$kpi_summary_date_range_selector
  if (date_range == "all") return(div("User engagement"))
  x <- polloi::subset_by_date_range(augmented_clickthroughs, from = start_date(date_range), to = Sys.Date() - 1)
  if (date_range == "quarterly") {
    return(valueBox(subtitle = "User engagement", color = "orange",
                    value = sprintf("%.1f%%", median(x$`User engagement`))))
  }
  y1 <- median(polloi::half(x$`User engagement`))
  y2 <- median(polloi::half(x$`User engagement`, FALSE))
  z <- 100 * (y2 - y1)/y1
  if (!is.na(z)) {
    if (abs(z) > 0) {
      return(valueBox(
        subtitle = sprintf("User engagement (%.1f%%)", z),
        value = sprintf("%.1f%%", y2),
        icon = polloi::cond_icon(z > 0), color = polloi::cond_color(z > 0, "green")
      ))
    }
    return(valueBox(subtitle = "User engagement (no change)",
                    value = sprintf("%.1f%%", y2), color = "orange"))
  }
  return(polloi::na_box("User engagement (data problem)"))
})

output$kpi_summary_box_load_time <- renderValueBox({
  date_range <- input$kpi_summary_date_range_selector
  if (date_range == "all") return(div("Load time"))
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
