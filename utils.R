#Dependent libs
library(reshape2)
library(ggplot2)
library(toOrdinal)
library(magrittr)
library(polloi)
library(xts)

## Read in desktop data and generate means for the value boxes, along with a time-series appropriate form for
## dygraphs.
read_desktop <- function() {
  data <- polloi::read_dataset("search/desktop_event_counts.tsv")
  names(data)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  interim <- reshape2::dcast(data, formula = date ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  desktop_dygraph_set <<- interim
  desktop_dygraph_means <<- round(colMeans(desktop_dygraph_set[,2:5]))
  interim <- polloi::read_dataset("search/desktop_load_times.tsv")
  names(interim)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  desktop_load_data <<- interim
}

read_web <- function() {
  data <- polloi::read_dataset("search/mobile_event_counts.tsv")
  names(data)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  interim <- reshape2::dcast(data, formula = date ~ action, fun.aggregate = sum)
  interim[is.na(interim)] <- 0
  mobile_dygraph_set <<- interim
  mobile_dygraph_means <<- round(colMeans(mobile_dygraph_set[,2:4]))
  interim <- polloi::read_dataset("search/mobile_load_times.tsv")
  names(interim)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  mobile_load_data <<- interim
}

read_apps <- function() {

  data <- polloi::read_dataset("search/app_event_counts.tsv")
  names(data)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  ios <- reshape2::dcast(data[data$platform == "iOS",], formula = date ~ action, fun.aggregate = sum)
  android <- reshape2::dcast(data[data$platform == "Android",], formula = date ~ action, fun.aggregate = sum)
  ios_dygraph_set <<- ios
  ios_dygraph_means <<- round(colMeans(ios[,2:4]))

  android_dygraph_set <<- android
  android_dygraph_means <<- round(colMeans(android[,2:4]))

  app_load_data <- polloi::read_dataset("search/app_load_times.tsv")
  names(app_load_data)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  ios_load_data <<- app_load_data[app_load_data$platform == "iOS", names(app_load_data) != "platform"]
  android_load_data <<- app_load_data[app_load_data$platform == "Android", names(app_load_data) != "platform"]

}

read_api <- function(){
  data <- polloi::read_dataset("search/search_api_aggregates.tsv")
  names(data)[1] <- 'date' # Will be unnecessary after https://gerrit.wikimedia.org/r/#/c/250856/
  data <- data[order(data$event_type),]
  split_dataset <<- split(data, f = data$event_type)
}

read_failures <- function(date) {

  data <- polloi::read_dataset("search/cirrus_query_aggregates.tsv")
  interim_data <- reshape2::dcast(data, formula = date ~ variable, fun.aggregate = sum)
  failure_dygraph_set <<- interim_data

  interim_vector <- interim_data$`Zero Result Queries`/interim_data$`Search Queries`
  output_vector <- (interim_vector[2:nrow(interim_data)] - interim_vector[1:(nrow(interim_data)-1)]) / interim_vector[1:(nrow(interim_data)-1)]

  failure_roc_dygraph_set <<- data.frame(date = interim_data$date[2:nrow(interim_data)],
                                         variable = "failure ROC",
                                         daily_change = output_vector*100,
                                         stringsAsFactors = FALSE)

  interim_breakdown_data <- polloi::read_dataset("search/cirrus_query_breakdowns.tsv")
  interim_breakdown_data$value <- interim_breakdown_data$value*100
  failure_breakdown_dygraph_set <<- reshape2::dcast(interim_breakdown_data,
                                                    formula = date ~ variable, fun.aggregate = sum)

  suggestion_data <- polloi::read_dataset("search/cirrus_suggestion_breakdown.tsv")
  suggestion_data$variable <- "Full-Text with Suggestions"
  suggestion_data$value <- suggestion_data$value*100
  suggestion_data <- rbind(suggestion_data,
                           interim_breakdown_data[interim_breakdown_data$date %in% suggestion_data$date
                                                  & interim_breakdown_data$variable == "Full-Text Search",])
  suggestion_dygraph_set <<- reshape2::dcast(suggestion_data,
                                             formula = date ~ variable, fun.aggregate = sum)

}

read_augmented_clickthrough <- function() {
  data <- polloi::read_dataset("search/search_threshold_pass_rate.tsv")
  temp <- polloi::safe_tail(desktop_dygraph_set, nrow(data))[, c('clickthroughs', 'Result pages opened')] +
    polloi::safe_tail(mobile_dygraph_set, nrow(data))[, c('clickthroughs', 'Result pages opened')] +
    polloi::safe_tail(ios_dygraph_set, nrow(data))[, c('clickthroughs', 'Result pages opened')] +
    polloi::safe_tail(android_dygraph_set, nrow(data))[, c('clickthroughs', 'Result pages opened')]
  intermediary_dataset <- cbind(data, clickthrough_rate = 100 * temp$clickthroughs/temp$'Result pages opened')
  colnames(intermediary_dataset) <- c("date", "threshold_passing_rate", "clickthrough_rate")
  intermediary_dataset$threshold_passing_rate <- 100 * intermediary_dataset$threshold_passing_rate
  augmented_clickthroughs <<- transform(intermediary_dataset, user_engagement = (threshold_passing_rate + clickthrough_rate)/2)
}

read_lethal_dose <- function() {
  intermediary_dataset <- polloi::read_dataset("search/sample_page_visit_ld.tsv")
  colnames(intermediary_dataset) <- c("date", "10%", "25%", "50%", "75%", "90%", "95%", "99%")
  user_page_visit_dataset <<- intermediary_dataset
}

# Uses ggplot2 to create a pie chart in bar form. (Will look up actual name)
gg_prop_bar <- function(data, cols) {
  # `cols` = list(`item`, `prop`, `label`)
  data$text_position <- cumsum(data[[cols$prop]]) + (c(0, cumsum(data[[cols$prop]])[-nrow(data)]) - cumsum(data[[cols$prop]]))/2
  ggplot(data, aes_string(x = 1, fill = cols$item)) +
    geom_bar(aes_string(y = cols$prop), stat="identity") +
    scale_fill_discrete(guide = FALSE, expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_continuous(expand = c(0,0)) +
    labs(x = NULL, y = NULL) +
    coord_flip() +
    theme_bw() +
    theme(axis.ticks = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          plot.margin = grid::unit(c(0, 0, -0.5, -0.5), "lines"),
          panel.margin = grid::unit(0, "lines")) +
    geom_text(aes_string(label = cols$label,
                  y = "text_position",
                  x = 1))
}

# This is used in subsetting data for KPIs.
start_date <- function(date_range) {
  return(Sys.Date() - (switch(date_range, daily = 2, weekly = 14, monthly = 60, quarterly = 90) + 1))
}
