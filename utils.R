library(magrittr)

## Read in desktop data and generate means for the value boxes, along with a time-series appropriate form for
## dygraphs.
read_desktop <- function() {
  desktop_dygraph_set <<- polloi::read_dataset("discovery/search/desktop_event_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    tidyr::spread(action, events, fill = 0)
  desktop_dygraph_means <<- round(colMeans(desktop_dygraph_set[, 2:5]))
  desktop_load_data <<- polloi::read_dataset("discovery/search/desktop_load_times.tsv", col_types = "Dddd") %>%
    dplyr::filter(!is.na(Median))
}

read_web <- function() {
  mobile_dygraph_set <<- polloi::read_dataset("discovery/search/mobile_event_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    tidyr::spread(action, events, fill = 0)
  mobile_dygraph_means <<- round(colMeans(mobile_dygraph_set[, 2:4]))
  mobile_load_data <<- polloi::read_dataset("discovery/search/mobile_load_times.tsv", col_types = "Dddd") %>%
    dplyr::filter(!is.na(Median))
}

read_apps <- function() {
  data <- polloi::read_dataset("discovery/search/app_event_counts.tsv", col_types = "Dcci") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    dplyr::distinct(date, platform, action, .keep_all = TRUE)
  ios <- data %>%
    dplyr::filter(platform == "iOS") %>%
    dplyr::select(-platform) %>%
    tidyr::spread(action, events, fill = 0)
  android <- data %>%
    dplyr::filter(platform == "Android") %>%
    dplyr::select(-platform) %>%
    tidyr::spread(action, events, fill = 0)

  ios_dygraph_set <<- ios
  ios_dygraph_means <<- round(colMeans(ios[, 2:4]))

  android_dygraph_set <<- android
  android_dygraph_means <<- round(colMeans(android[, 2:4]))

  app_load_data <- polloi::read_dataset("discovery/search/app_load_times.tsv", col_types = "Dcddd") %>%
    dplyr::filter(!is.na(Median)) %>%
    dplyr::distinct(date, platform, .keep_all = TRUE)
  ios_load_data <<- app_load_data[app_load_data$platform == "iOS", names(app_load_data) != "platform"]
  android_load_data <<- app_load_data[app_load_data$platform == "Android", names(app_load_data) != "platform"]

  position_interim <- polloi::read_dataset("discovery/search/click_position_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(click_position), !is.na(events)) %>%
    dplyr::distinct(date, click_position, .keep_all = TRUE) %>%
    dplyr::group_by(date) %>%
    dplyr::mutate(prop = round(events/sum(events)*100, 2)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-events) %>%
    tidyr::spread(click_position, prop, fill = 0)
  position_interim <- position_interim[, c("date", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10-19", "20-100", "100+")]
  names(position_interim) <- c("date", "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th-19th", "20th-100th", "101st+")
  position_prop <<- position_interim
  source_prop <<- polloi::read_dataset("discovery/search/invoke_source_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(invoke_source), !is.na(events)) %>%
    dplyr::distinct(date, invoke_source, .keep_all = TRUE) %>%
    dplyr::group_by(date) %>%
    dplyr::mutate(prop = round(events/sum(events)*100, 2)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-events) %>%
    tidyr::spread(invoke_source, prop, fill = 0)
}

read_api <- function(){
  split_dataset <<- polloi::read_dataset("discovery/search/search_api_usage.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(api), !is.na(calls)) %>%
    dplyr::distinct(date, api, .keep_all = TRUE) %>%
    dplyr::arrange(api, date) %>%
    { split(., f = .$api) } %>%
    lapply(dplyr::select_, .dots = list(quote(-api)))
}

read_failures <- function(date) {
  ## Zero results rate
  ### With automata
  failure_data_with_automata <<- polloi::read_dataset("discovery/search/cirrus_query_aggregates_with_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::mutate(rate = 100 * rate)
  ### Without automata
  failure_data_no_automata <<- polloi::read_dataset("discovery/search/cirrus_query_aggregates_no_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::mutate(rate = 100 * rate)
  ## Day-to-day change
  ### With automata
  interim_new <- failure_data_with_automata$rate[2:nrow(failure_data_with_automata)]
  interim_old <- failure_data_with_automata$rate[1:(nrow(failure_data_with_automata)-1)]
  failure_roc_with_automata <<- data.frame(
    date = failure_data_with_automata$date[2:nrow(failure_data_with_automata)],
    daily_change = 100 * (interim_new - interim_old)/interim_old,
    stringsAsFactors = FALSE
  )
  ### Without automata
  interim_new <- failure_data_no_automata$rate[2:nrow(failure_data_no_automata)]
  interim_old <- failure_data_no_automata$rate[1:(nrow(failure_data_no_automata)-1)]
  failure_roc_no_automata <<- data.frame(
    date = failure_data_no_automata$date[2:nrow(failure_data_no_automata)],
    daily_change = 100 * (interim_new - interim_old)/interim_old,
    stringsAsFactors = FALSE
  )
  ## ZRR by type
  ### With automata
  failure_breakdown_with_automata <<- polloi::read_dataset("discovery/search/cirrus_query_breakdowns_with_automata.tsv", col_types = "Dcd") %>%
    dplyr::filter(!is.na(query_type), !is.na(rate)) %>%
    dplyr::mutate(
      rate = 100 * rate,
      query_type = as.character(factor(
        query_type,
        levels = c("Full-Text Search", "Prefix Search", "full_text", "prefix", "comp_suggest", "more_like", "regex", "GeoData_spatial_search"),
        labels = c("Full-Text Search", "Prefix Search", "Full-Text", "Prefix", "Completion Suggester", "More Like", "Regex", "Geospatial")
      )),
      query_type = dplyr::if_else(query_type == "Full-Text", "Full-Text Search", query_type)
    ) %>%
    dplyr::distinct(date, query_type, .keep_all = TRUE) %>%
    tidyr::spread(query_type, rate, fill = as.double(NA))
  ### Without automata
  failure_breakdown_no_automata <<- polloi::read_dataset("discovery/search/cirrus_query_breakdowns_no_automata.tsv", col_types = "Dcd") %>%
    dplyr::filter(!is.na(query_type), !is.na(rate)) %>%
    dplyr::mutate(
      rate = 100 * rate,
      query_type = as.character(factor(
        query_type,
        levels = c("Full-Text Search", "Prefix Search", "full_text", "prefix", "comp_suggest", "more_like", "regex", "GeoData_spatial_search"),
        labels = c("Full-Text Search", "Prefix Search", "Full-Text", "Prefix", "Completion Suggester", "More Like", "Regex", "Geospatial")
      )),
      query_type = dplyr::if_else(query_type == "Full-Text", "Full-Text Search", query_type)
    ) %>%
    dplyr::distinct(date, query_type, .keep_all = TRUE) %>%
    tidyr::spread(query_type, rate, fill = as.double(NA))
  ## ZRR with suggestions
  ### With automata
  suggestion_with_automata <<- polloi::read_dataset("discovery/search/cirrus_suggestion_breakdown_with_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::transmute(date = date, `Full-Text with Suggestions` = 100 * rate) %>%
    dplyr::full_join(dplyr::select(failure_breakdown_with_automata, c(date, `Full-Text Search`)), by = "date") %>%
    dplyr::arrange(date)
  ### Without automata
  suggestion_no_automata <<- polloi::read_dataset("discovery/search/cirrus_suggestion_breakdown_no_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::transmute(date = date, `Full-Text with Suggestions` = 100 * rate) %>%
    dplyr::full_join(dplyr::select(failure_breakdown_no_automata, c(date, `Full-Text Search`)), by = "date") %>%
    dplyr::arrange(date)
  ## Broken down by language-project pair
  ### With automata
  langproj_with_automata <<- polloi::read_dataset("discovery/search/cirrus_langproj_breakdown_with_automata.tsv", na = "~", col_types = "Dccii") %>%
    dplyr::filter(!is.na(zero_results), !is.na(total)) %>%
    dplyr::mutate(language = sub("NA", "(None)", language))
  ### Without automata
  langproj_no_automata <<- polloi::read_dataset("discovery/search/cirrus_langproj_breakdown_no_automata.tsv", na = "~", col_types = "Dccii") %>%
    dplyr::filter(!is.na(zero_results), !is.na(total)) %>%
    dplyr::mutate(language = sub("NA", "(None)", language))
  ### Summaries for sorting
  available_languages <<- langproj_with_automata %>%
    dplyr::group_by(language) %>%
    dplyr::summarize(volume = sum(as.numeric(total))) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume/sum(volume),
                  label = sprintf("%s (%.3f%%)", language, 100*prop))
  available_projects <<- langproj_with_automata %>%
    dplyr::group_by(project) %>%
    dplyr::summarize(volume = sum(as.numeric(total))) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume/sum(volume),
                  label = sprintf("%s (%.3f%%)", project, 100*prop))
  projects_db <<- readr::read_csv(system.file("extdata/projects.csv", package = "polloi"), col_types = "cclc")[, c('project', 'multilingual')]
}

read_augmented_clickthrough <- function() {
  threshold_data <- polloi::read_dataset("discovery/search/search_threshold_pass_rate.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(threshold_pass)) %>%
    dplyr::mutate(threshold_pass = 100 * threshold_pass)
  augmented_clickthroughs <<- list(
    desktop = dplyr::select(desktop_dygraph_set, c(date, clickthroughs, `Result pages opened`)),
    mobile = dplyr::select(mobile_dygraph_set, c(date, clickthroughs, `Result pages opened`)),
    ios = dplyr::select(ios_dygraph_set, c(date, clickthroughs, `Result pages opened`)),
    android = dplyr::select(android_dygraph_set, c(date, clickthroughs, `Result pages opened`))
  ) %>%
    dplyr::bind_rows(.id = "platform") %>%
    dplyr::group_by(date) %>%
    dplyr::summarize(clickthroughs = sum(clickthroughs), serps = sum(`Result pages opened`)) %>%
    dplyr::right_join(threshold_data, by = "date") %>%
    dplyr::transmute(
      date = date,
      `Threshold-passing %` = threshold_pass,
      `Clickthrough rate` = 100 * clickthroughs/serps,
      `User engagement` = (threshold_pass + `Clickthrough rate`)/2
    )
}

read_lethal_dose <- function() {
  user_page_visit_dataset <<- polloi::read_dataset("discovery/search/sample_page_visit_ld.tsv", col_types = "Dddddddd") %>%
    dplyr::filter(!is.na(LD10)) %>%
    set_colnames(c("date", "10%", "25%", "50%", "75%", "90%", "95%", "99%"))
}

read_paul_score <- function() {
  paulscore <- polloi::read_dataset("discovery/search/paulscore_approximations.tsv", col_types = "Dcddddddddd") %>%
    dplyr::filter(!is.na(event_source)) %>%
    dplyr::select(c(date, event_source, `F = 0.1` = pow_1, `F = 0.5` = pow_5, `F = 0.9` = pow_9))
  paulscore_autocomplete <<- dplyr::filter(paulscore, event_source == "autocomplete") %>% dplyr::select(-event_source)
  paulscore_fulltext <<- dplyr::filter(paulscore, event_source == "fulltext") %>% dplyr::select(-event_source)
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

# This is used in subsetting data for KPIs.
start_date <- function(date_range) {
  return(Sys.Date() - (switch(date_range, daily = 2, weekly = 14, monthly = 60, quarterly = 90) + 1))
}
