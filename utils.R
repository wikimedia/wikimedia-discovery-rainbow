#Dependent libs
library(reshape2)
library(ggplot2)
library(toOrdinal)
library(magrittr)
library(polloi)
library(xts)
library(dplyr)
library(tidyr)

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

  interim <- polloi::read_dataset("search/cirrus_query_aggregates_with_automata.tsv")
  interim$rate <- interim$rate*100
  failure_data_with_automata <<- interim

  interim <- polloi::read_dataset("search/cirrus_query_aggregates_no_automata.tsv")
  interim$rate <- interim$rate*100
  failure_data_no_automata <<- interim

  interim <- {failure_data_with_automata$rate[1:nrow(failure_data_with_automata)-1] /
              failure_data_with_automata$rate[2:nrow(failure_data_with_automata)]}

  failure_roc_with_automata <<- data.frame(date = failure_data_with_automata$date[2:nrow(failure_data_with_automata)],
                                           daily_change = interim,
                                           stringsAsFactors = FALSE)

  interim <- {failure_data_no_automata$rate[1:nrow(failure_data_no_automata)-1] /
      failure_data_no_automata$rate[2:nrow(failure_data_no_automata)]}

  failure_roc_no_automata <<- data.frame(date = failure_data_no_automata$date[2:nrow(failure_data_no_automata)],
                                           daily_change = interim,
                                           stringsAsFactors = FALSE)

  interim_breakdown_with_automata <- polloi::read_dataset("search/cirrus_query_breakdowns_with_automata.tsv")
  interim_breakdown_with_automata$rate <- interim_breakdown_with_automata$rate*100
  failure_breakdown_with_automata <<- reshape2::dcast(interim_breakdown_with_automata,
                                                      formula = date ~ query_type, fun.aggregate = sum)

  interim_breakdown_no_automata <- polloi::read_dataset("search/cirrus_query_breakdowns_no_automata.tsv")
  interim_breakdown_no_automata$rate <- interim_breakdown_no_automata$rate*100
  failure_breakdown_no_automata <<- reshape2::dcast(interim_breakdown_no_automata,
                                                    formula = date ~ query_type, fun.aggregate = sum)

  interim <- polloi::read_dataset("search/cirrus_suggestion_breakdown_with_automata.tsv")
  interim$rate <- interim$rate*100
  interim$query_type <- "Full-Text with Suggestions"
  interim <- rbind(interim[,c("date", "query_type", "rate")],
                   interim_breakdown_with_automata[interim_breakdown_with_automata$date %in% interim$date
                                                   & interim_breakdown_with_automata$query_type == "Full-Text Search",])
  suggestion_with_automata <<- reshape2::dcast(interim, formula = date ~ query_type, fun.aggregate = sum)

  interim <- polloi::read_dataset("search/cirrus_suggestion_breakdown_no_automata.tsv")
  interim$rate <- interim$rate*100
  interim$query_type <- "Full-Text with Suggestions"
  interim <- rbind(interim[,c("date", "query_type", "rate")],
                   interim_breakdown_no_automata[interim_breakdown_no_automata$date %in% interim$date
                                                 & interim_breakdown_no_automata$query_type == "Full-Text Search",])
  suggestion_no_automata <<- reshape2::dcast(interim, formula = date ~ query_type, fun.aggregate = sum)

  interim <<- polloi::read_dataset("search/cirrus_langproj_breakdown_with_automata.tsv",
                                                  na = "~", col_types = "Dccii")
  interim$language %<>% sub("NA", "(None)", .)
  langproj_with_automata <<- interim
  interim <<- polloi::read_dataset("search/cirrus_langproj_breakdown_no_automata.tsv",
                                                na = "~", col_types = "Dccii")
  interim$language %<>% sub("NA", "(None)", .)
  langproj_no_automata <<- interim
  available_languages <<- langproj_with_automata %>%
    group_by(language) %>%
    summarize(volume = sum(as.numeric(total))) %>%
    dplyr::filter(volume > 0) %>%
    arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume/sum(volume),
                  label = sprintf("%s (%.3f%%)", language, 100*prop))
  available_projects <<- langproj_with_automata %>%
    group_by(project) %>%
    summarize(volume = sum(as.numeric(total))) %>%
    dplyr::filter(volume > 0) %>%
    arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume/sum(volume),
                  label = sprintf("%s (%.3f%%)", project, 100*prop))
  projects_db <<- readr::read_csv(system.file("extdata/projects.csv", package = "polloi"))[, c('project', 'multilingual')]
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

aggregate_wikis <- function(data, languages, projects) {
  languages <- sub(" \\([0-9]{1,2}\\.[0-9]{1,3}%\\)", "", languages)
  projects <- sub(" \\([0-9]{1,2}\\.[0-9]{1,3}%\\)", "", projects)
  if (length(languages) == 1 && languages[1] == "(None)") {
    temp <- data %>%
      dplyr::filter_(~project %in% projects) %>%
      dplyr::rename(wiki = project) %>%
      dplyr::group_by(date, wiki) %>%
      dplyr::summarize(zero_results = sum(as.numeric(zero_results)),
                       total = sum(as.numeric(total))) %>%
      dplyr::ungroup()
  } else {
    temp <- data %>%
      dplyr::filter_(~language %in% languages & project %in% projects) %>%
      tidyr::unite(wiki, language, project, sep = " ") %>%
      dplyr::mutate(wiki = sub("(None) ", "", wiki, fixed = TRUE))
  }
  temp %<>%
    dplyr::mutate(zrr = round(100 * as.numeric(zero_results) / as.numeric(total), 2)) %>%
    dplyr::select(-c(total, zero_results)) %>%
    tidyr::spread(wiki, zrr)
  return(temp)
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
