output$monthly_metrics_tbl <- DT::renderDataTable({
  temp <- data.frame(
    KPI = c("Load time", "Zero results rate", "API Usage", "User engagement"),
    Units = c("ms", "%", "", "%"),
    stringsAsFactors = FALSE
  )

  prev_month <- as.Date(paste(input$monthy_metrics_year, which(month.name == input$monthy_metrics_month), "1", sep = "-"))
  prev_prev_month <- prev_month - months(1)
  prev_year <- prev_month - months(12)

  smoothed_load_times <- list(
    Desktop = desktop_load_data,
    Mobile = mobile_load_data,
    Android = android_load_data,
    iOS = ios_load_data
  ) %>%
    dplyr::bind_rows(.id = "platform") %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(Median = median(Median)) %>%
    polloi::smoother("month", rename = FALSE)
  smoothed_zrr <- polloi::smoother(failure_data_with_automata, "month", rename = FALSE)
  smoothed_api <- split_dataset %>%
    dplyr::bind_rows(.id = "api") %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(total = sum(calls)) %>%
    polloi::smoother("month", rename = FALSE)
  smoothed_engagement <- augmented_clickthroughs %>%
    dplyr::select(c(date, `User engagement`)) %>%
    polloi::smoother("month", rename = FALSE)
  temp$Current <- c(
    smoothed_load_times$Median[smoothed_load_times$date == prev_month],
    smoothed_zrr$rate[smoothed_zrr$date == prev_month],
    smoothed_api$total[smoothed_api$date == prev_month],
    smoothed_engagement$`User engagement`[smoothed_engagement$date == prev_month]
  )
  temp$Previous_month <- c(
    smoothed_load_times$Median[smoothed_load_times$date == prev_prev_month],
    smoothed_zrr$rate[smoothed_zrr$date == prev_prev_month],
    smoothed_api$total[smoothed_api$date == prev_prev_month],
    smoothed_engagement$`User engagement`[smoothed_engagement$date == prev_prev_month]
  )
  temp$Previous_year <- c(
    ifelse(sum(smoothed_load_times$date == prev_year) == 0, NA, smoothed_load_times$Median[smoothed_load_times$date == prev_year]),
    ifelse(sum(smoothed_zrr$date == prev_year) == 0, NA, smoothed_zrr$rate[smoothed_zrr$date == prev_year]),
    ifelse(sum(smoothed_api$date == prev_year) == 0, NA, smoothed_api$total[smoothed_api$date == prev_year]),
    ifelse(sum(smoothed_engagement$date == prev_year) == 0, NA, smoothed_engagement$`User engagement`[smoothed_engagement$date == prev_year])
  )
  temp$Anchors <- c("kpi_load_time", "kpi_zero_results", "kpi_api_usage", "kpi_augmented_clickthroughs")

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
  names(temp) <- c("KPI", "Units", as.character(prev_month, "%B %Y"), as.character(prev_prev_month, "%B %Y"), as.character(prev_year, "%B %Y"), "Anchors", "MoM", "YoY")
  # Sanitize:
  temp[temp == "NA%" | temp == "NANA%" | temp == "NANA"] <- "--"
  temp$KPI <- paste0('<a id="mm_', temp$Anchors, '">', temp$KPI, '</a>')
  # Sparklines:
  monthly_ts <- . %>%
    dplyr::arrange(date) %>%
    dplyr::mutate(date = lubridate::floor_date(date, "month")) %>%
    dplyr::distinct() %>%
    dplyr::select(-date)
  temp$`Monthly Median` <- c(
    paste(monthly_ts(smoothed_load_times)$Median, collapse = ","),
    paste(monthly_ts(smoothed_zrr)$rate, collapse = ","),
    paste(monthly_ts(smoothed_api)$total, collapse = ","),
    paste(monthly_ts(smoothed_engagement)$`User engagement`, collapse = ",")
  )
  cols_to_keep <- c(1, 5, 4, 3, 7, 8, 9)
  if (!input$monthly_metrics_prev_month) {
    cols_to_keep <- base::setdiff(cols_to_keep, 4)
  }
  if (!input$monthly_metrics_prev_year) {
    cols_to_keep <- base::setdiff(cols_to_keep, 5)
  }
  column_def <- list(list(
    targets = length(cols_to_keep) - 1,
    render = DT::JS("function(data, type, full) { return '<span class=\"sparkSeries\">' + data + '</span>'; }")
  ))
  line_string <- "type: 'line', lineColor: 'black', fillColor: '#ccc', highlightLineColor: 'orange', highlightSpotColor: 'orange'"
  callback_fnc <- DT::JS(paste0("function (oSettings, json) {
      $('.sparkSeries:not(:has(canvas))').sparkline('html', { ", line_string, " });
      $('a[id^=mm_kpi_]').click(function(){
      var target = $(this).attr('id').replace('mm_', '');
      $('a[data-value=\"'+target+'\"]').click();});
      $('a[id^=mm_kpi_]').hover(function() {$(this).css('cursor','pointer');});\n}"), collapse = "")
  mm_dt <- DT::datatable(
    temp[c(4, 2, 3, 1), cols_to_keep], rownames = FALSE,
    options = list(
      searching = FALSE, paging = FALSE, info = FALSE, ordering = FALSE,
      columnDefs = column_def, fnDrawCallback = callback_fnc
    ),
    escape = FALSE
  )
  mm_dt$dependencies <- append(mm_dt$dependencies, htmlwidgets:::getDependency("sparkline"))
  return(mm_dt)
})
