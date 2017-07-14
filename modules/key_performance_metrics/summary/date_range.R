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
             vapply(toOrdinal::toOrdinal, "") %>%
             sub("([a-z]{2})", "<sup>\\1</sup>", .) %>%
             paste0(as.character(dates, "%A, %b "), .)
         },
         weekly = {
           dates <- Sys.Date() - c(1, 8, 9, 15)
           temp <- dates %>%
             as.character("%e") %>%
             as.numeric %>%
             vapply(toOrdinal::toOrdinal, "") %>%
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
             vapply(toOrdinal::toOrdinal, "") %>%
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
                    vapply(toOrdinal::toOrdinal, "") %>%
                    sub("([a-z]{2})", "<sup>\\1</sup>", .) %>%
                    paste0(as.character(dates, "%B "), .) %>%
                    paste0(collapse = "-") %>%
                    HTML("<h3 class='kpi_date'>KPI summary for", ., "</h3>"))
         })
  return(HTML("<h3 class='kpi_date'>KPI summary for", temp[1], ", and % change from", temp[2], "</h3>"))
})
