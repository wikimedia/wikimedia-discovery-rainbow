library(magrittr)

## Read in desktop data and generate means for the value boxes, along with a time-series appropriate form for
## dygraphs.
read_desktop <- function() {
  desktop_dygraph_set <<- polloi::read_dataset("discovery/metrics/search/desktop_event_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    tidyr::spread(action, events, fill = 0)
  desktop_dygraph_means <<- round(apply(polloi::safe_tail(desktop_dygraph_set[, 2:5], 90), 2, median))
  desktop_load_data <<- polloi::read_dataset("discovery/metrics/search/desktop_load_times.tsv", col_types = "Dddd") %>%
    dplyr::filter(!is.na(Median))
  # Broken down by language-project pair
  desktop_langproj_dygraph_set <<- polloi::read_dataset("discovery/metrics/search/desktop_event_counts_langproj_breakdown.tsv", col_types = "Dccci") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    dplyr::mutate(language = ifelse(is.na(language), "(None)", language)) %>%
    tidyr::spread(action, events, fill = 0)
  ## Summaries for sorting (search sessions)
  available_languages_desktop <<- desktop_langproj_dygraph_set %>%
    dplyr::group_by(language) %>%
    dplyr::summarize(volume = sum(as.numeric(`search sessions`), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", language, 100 * prop))
  available_projects_desktop <<- desktop_langproj_dygraph_set %>%
    dplyr::group_by(project) %>%
    dplyr::summarize(volume = sum(as.numeric(`search sessions`), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", project, 100 * prop))
}

read_web <- function() {
  mobile_dygraph_set <<- polloi::read_dataset("discovery/metrics/search/mobile_event_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    tidyr::spread(action, events, fill = 0) %>%
    dplyr::rename(`search start` = `search sessions`)
  mobile_dygraph_means <<- round(apply(mobile_dygraph_set[(nrow(mobile_dygraph_set) - 89):nrow(mobile_dygraph_set), 2:4], 2, median))
  mobile_session <<- polloi::read_dataset("discovery/metrics/search/mobile_session_counts.tsv", col_types = "Diiiiiii") %>%
    dplyr::select(date, user_sessions, high_volume, medium_volume, low_volume) %>%
    dplyr::rename(
      `Total user sessions` = user_sessions,
      `High volume` = high_volume,
      `Medium volume` = medium_volume,
      `Low volume` = low_volume
    )
  mobile_session_mean <<- round(apply(mobile_session[(nrow(mobile_session) - 89):nrow(mobile_session), -1], 2, median))
  mobile_load_data <<- polloi::read_dataset("discovery/metrics/search/mobile_load_times.tsv", col_types = "Dddd") %>%
    dplyr::filter(!is.na(Median))
}

read_apps <- function() {
  data <- polloi::read_dataset("discovery/metrics/search/app_event_counts.tsv", col_types = "Dcci") %>%
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
  ios_dygraph_means <<- round(apply(ios[, 2:4], 2, median))

  android_dygraph_set <<- android
  android_dygraph_means <<- round(apply(android[, 2:4], 2, median))

  app_load_data <- polloi::read_dataset("discovery/metrics/search/app_load_times.tsv", col_types = "Dcddd") %>%
    dplyr::filter(!is.na(Median)) %>%
    dplyr::distinct(date, platform, .keep_all = TRUE)
  ios_load_data <<- app_load_data[app_load_data$platform == "iOS", names(app_load_data) != "platform"]
  android_load_data <<- app_load_data[app_load_data$platform == "Android", names(app_load_data) != "platform"]

  position_interim <- polloi::read_dataset("discovery/metrics/search/click_position_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(click_position), !is.na(events)) %>%
    dplyr::distinct(date, click_position, .keep_all = TRUE) %>%
    dplyr::group_by(date) %>%
    dplyr::mutate(prop = round(events / sum(events, na.rm = TRUE) * 100, 2)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-events) %>%
    tidyr::spread(click_position, prop, fill = 0)
  position_interim <- position_interim[, c("date", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10-19", "20-100", "100+")]
  names(position_interim) <- c("date", "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th-19th", "20th-100th", "101st+")
  position_prop <<- position_interim
  source_prop <<- polloi::read_dataset("discovery/metrics/search/invoke_source_counts.tsv", col_types = "Dci") %>%
    dplyr::filter(!is.na(invoke_source), !is.na(events)) %>%
    dplyr::distinct(date, invoke_source, .keep_all = TRUE) %>%
    dplyr::group_by(date) %>%
    dplyr::mutate(prop = round(events / sum(events, na.rm = TRUE) * 100, 2)) %>%
    dplyr::ungroup() %>%
    dplyr::select(-events) %>%
    tidyr::spread(invoke_source, prop, fill = 0)
}

read_api <- function(){
  split_dataset <<- polloi::read_dataset("discovery/metrics/search/search_api_usage.tsv", col_types = "Dcci") %>%
    dplyr::filter(!is.na(api), !is.na(referer_class), !is.na(calls)) %>%
    dplyr::distinct(date, api, referer_class, .keep_all = TRUE) %>%
    dplyr::arrange(api, date) %>%
    dplyr::mutate(
      referer_class = forcats::fct_recode(
        referer_class,
        `None (direct)` = "none",
        `Search engine` = "external (search engine)",
        `External (but not search engine)` = "external",
        Internal = "internal",
        Unknown = "unknown"
      ),
      api = forcats::fct_recode(
        api,
        `full-text via API` = "cirrus",
        `morelike via API` = "cirrus (more like)"
      )
    ) %>%
    tidyr::spread(referer_class, calls) %>%
    dplyr::mutate(All = ifelse(is.na(All), rowSums(.[, -c(1, 2)], na.rm = TRUE), All)) %>%
    tidyr::gather(referrer, calls, -c(date, api)) %>%
    { split(., f = .$api) } %>%
    lapply(dplyr::select_, .dots = list(quote(-api)))
}

read_failures <- function() {
  ## Zero results rate
  ### With automata
  failure_data_with_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_query_aggregates_with_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::mutate(rate = 100 * rate)
  ### Without automata
  failure_data_no_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_query_aggregates_no_automata.tsv", col_types = "Dd") %>%
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
  failure_breakdown_with_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_query_breakdowns_with_automata.tsv", col_types = "Dcd") %>%
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
  failure_breakdown_no_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_query_breakdowns_no_automata.tsv", col_types = "Dcd") %>%
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
  suggestion_with_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_suggestion_breakdown_with_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::transmute(date = date, `Full-Text with Suggestions` = 100 * rate) %>%
    dplyr::full_join(dplyr::select(failure_breakdown_with_automata, c(date, `Full-Text Search`)), by = "date") %>%
    dplyr::arrange(date)
  ### Without automata
  suggestion_no_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_suggestion_breakdown_no_automata.tsv", col_types = "Dd") %>%
    dplyr::filter(!is.na(rate)) %>%
    dplyr::transmute(date = date, `Full-Text with Suggestions` = 100 * rate) %>%
    dplyr::full_join(dplyr::select(failure_breakdown_no_automata, c(date, `Full-Text Search`)), by = "date") %>%
    dplyr::arrange(date)
  ## Broken down by language-project pair
  ### With automata
  langproj_with_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_langproj_breakdown_with_automata.tsv", na = "~", col_types = "Dccii") %>%
    dplyr::filter(!is.na(zero_results), !is.na(total)) %>%
    dplyr::mutate(language = ifelse(is.na(language) | language == "NA", "(None)", language))
  ### Without automata
  langproj_no_automata <<- polloi::read_dataset("discovery/metrics/search/cirrus_langproj_breakdown_no_automata.tsv", na = "~", col_types = "Dccii") %>%
    dplyr::filter(!is.na(zero_results), !is.na(total)) %>%
    dplyr::mutate(language = ifelse(is.na(language) | language == "NA", "(None)", language))
  ### Summaries for sorting
  available_languages <<- langproj_with_automata %>%
    dplyr::group_by(language) %>%
    dplyr::summarize(volume = sum(as.numeric(total), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", language, 100 * prop))
  available_projects <<- langproj_with_automata %>%
    dplyr::group_by(project) %>%
    dplyr::summarize(volume = sum(as.numeric(total), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", project, 100 * prop))
  projects_db <<- readr::read_csv(system.file("extdata/projects.csv", package = "polloi"), col_types = "cclc")[, c("project", "multilingual")]
}

read_augmented_clickthrough <- function() {
  threshold_data <- polloi::read_dataset("discovery/metrics/search/search_threshold_pass_rate.tsv", col_types = "Dd") %>%
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
    dplyr::summarize(clickthroughs = sum(clickthroughs, na.rm = TRUE), serps = sum(`Result pages opened`, na.rm = TRUE)) %>%
    dplyr::right_join(threshold_data, by = "date") %>%
    dplyr::transmute(
      date = date,
      `Threshold-passing %` = threshold_pass,
      `Clickthrough rate` = 100 * clickthroughs / serps,
      `User engagement` = (threshold_pass + `Clickthrough rate`) / 2
    )
}

read_augmented_clickthrough_langproj <- function() {
  # Read data
  threshold_data <- polloi::read_dataset("discovery/metrics/search/search_threshold_pass_rate_langproj_breakdown.tsv", col_types = "Dccdi") %>%
    dplyr::filter(!is.na(threshold_pass)) %>%
    dplyr::mutate(threshold_pass = 100 * threshold_pass, language = ifelse(is.na(language), "(None)", language))
  mobile_langproj <- polloi::read_dataset("discovery/metrics/search/mobile_event_counts_langproj_breakdown.tsv", col_types = "Dccci") %>%
    dplyr::mutate(language = ifelse(is.na(language), "(None)", language)) %>%
    dplyr::filter(!is.na(action), !is.na(events), !is.na(project)) %>%
    tidyr::spread(action, events, fill = 0)
  app_langproj <- polloi::read_dataset("discovery/metrics/search/app_event_counts_langproj_breakdown.tsv", col_types = "Dccci") %>%
    dplyr::mutate(language = ifelse(is.na(language), "(None)", language)) %>%
    dplyr::mutate(project = "Wikipedia") %>%
    dplyr::filter(!is.na(action), !is.na(events)) %>%
    dplyr::distinct(date, platform, language, project, action, .keep_all = TRUE)
  ios_langproj <- app_langproj %>%
    dplyr::filter(platform == "iOS") %>%
    dplyr::select(-platform) %>%
    tidyr::spread(action, events, fill = 0)
  android_langproj <- app_langproj %>%
    dplyr::filter(platform == "Android") %>%
    dplyr::select(-platform) %>%
    tidyr::spread(action, events, fill = 0)
  # Augmented clickthroughs
  augmented_clickthroughs_langproj <<- list(
    desktop = dplyr::select(desktop_langproj_dygraph_set, c(date, language, project, clickthroughs, `Result pages opened`)),
    mobile = dplyr::select(mobile_langproj, c(date, language, project, clickthroughs, `Result pages opened`)),
    ios = dplyr::select(ios_langproj, c(date, language, project, clickthroughs, `Result pages opened`)),
    android = dplyr::select(android_langproj, c(date, language, project, clickthroughs, `Result pages opened`))
  ) %>%
    dplyr::bind_rows(.id = "platform") %>%
    dplyr::group_by(date, language, project) %>%
    dplyr::summarize(clickthroughs = sum(clickthroughs, na.rm = TRUE), serps = sum(`Result pages opened`, na.rm = TRUE)) %>%
    dplyr::right_join(threshold_data, by = c("date", "language", "project")) %>%
    dplyr::ungroup() %>%
    dplyr::transmute(
      date = date,
      language = language,
      project = project,
      `Result pages opened` = serps,
      search_sessions_threshold = search_sessions,
      `Threshold-passing %` = round(threshold_pass, 2),
      `Clickthrough rate` = round(100 * clickthroughs / serps, 2),
      `User engagement` = round((threshold_pass + `Clickthrough rate`) / 2, 2)
    )
  # Summaries for sorting (SERP)
  available_languages_ctr <<- augmented_clickthroughs_langproj %>%
    dplyr::group_by(language) %>%
    dplyr::summarize(volume = sum(as.numeric(`Result pages opened`), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", language, 100 * prop))
  available_projects_ctr <<- augmented_clickthroughs_langproj %>%
    dplyr::group_by(project) %>%
    dplyr::summarize(volume = sum(as.numeric(`Result pages opened`), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", project, 100 * prop))
}

read_lethal_dose <- function() {
  user_page_visit_dataset <<- polloi::read_dataset("discovery/metrics/search/sample_page_visit_ld.tsv", col_types = "Dddddddd") %>%
    dplyr::filter(!is.na(LD10)) %>%
    set_colnames(c("date", "10%", "25%", "50%", "75%", "90%", "95%", "99%"))
  serp_page_visit_dataset <<- polloi::read_dataset("discovery/metrics/search/srp_survtime.tsv", col_types = "Dcddddddd") %>%
    dplyr::filter(!is.na(LD10)) %>%
    set_colnames(c("date", "language", "10%", "25%", "50%", "75%", "90%", "95%", "99%"))
}

read_paul_score <- function() {
  paulscore <- polloi::read_dataset("discovery/metrics/search/paulscore_approximations.tsv", col_types = "Dcddddddddd") %>%
    dplyr::filter(!is.na(event_source)) %>%
    dplyr::select(c(date, event_source, `F = 0.1` = pow_1, `F = 0.5` = pow_5, `F = 0.9` = pow_9))
  paulscore_autocomplete <<- paulscore %>%
    dplyr::filter(event_source == "autocomplete") %>%
    dplyr::select(-event_source)
  paulscore_fulltext <<- paulscore %>%
    dplyr::filter(event_source == "fulltext") %>%
    dplyr::select(-event_source)
  # Broken down by language-project pair
  paulscore_fulltext_langproj <<- polloi::read_dataset("discovery/metrics/search/paulscore_approximations_fulltext_langproj_breakdown.tsv", col_types = "Dcciddddddddd") %>%
    dplyr::mutate(language = ifelse(is.na(language), "(None)", language)) %>%
    dplyr::filter(!is.na(project)) %>%
    dplyr::select(c(date, language, project, `search sessions` = search_sessions, `F = 0.1` = pow_1, `F = 0.5` = pow_5, `F = 0.9` = pow_9))
  ## Summaries for sorting (search sessions)
  available_languages_paulscore <<- paulscore_fulltext_langproj %>%
    dplyr::group_by(language) %>%
    dplyr::summarize(volume = sum(as.numeric(`search sessions`), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", language, 100 * prop))
  available_projects_paulscore <<- paulscore_fulltext_langproj %>%
    dplyr::group_by(project) %>%
    dplyr::summarize(volume = sum(as.numeric(`search sessions`), na.rm = TRUE)) %>%
    dplyr::filter(volume > 0) %>%
    dplyr::arrange(desc(volume)) %>%
    dplyr::mutate(prop = volume / sum(volume, na.rm = TRUE),
                  label = sprintf("%s (%.3f%%)", project, 100 * prop))
}

read_sister_search <- function() {
  sister_search_traffic <<- polloi::read_dataset("discovery/metrics/search/sister_search_traffic.tsv", col_types = "Dcccli") %>%
    dplyr::mutate(
      project = polloi::capitalize_first_letter(project),
      access_method = polloi::capitalize_first_letter(access_method)
    )
  sister_search_prevalence <<- polloi::read_dataset("discovery/metrics/search/sister_search_prevalence.tsv", col_types = "Dcii") %>%
    dplyr::group_by(wiki_id) %>%
    dplyr::mutate(include = all((has_sister_results + no_sister_results) > 20)) %>%
    dplyr::ungroup() %>%
    dplyr::filter(include) %>%
    dplyr::mutate(prevalence = round(100 * has_sister_results / (has_sister_results + no_sister_results), 2)) %>%
    dplyr::left_join(
      polloi::get_langproj()[, c("wikiid", "language")],
      by = c("wiki_id" = "wikiid")
    ) %>%
    dplyr::select(c(date, language, prevalence))
  sister_search_averages <<- sister_search_prevalence %>%
    dplyr::group_by(language) %>%
    dplyr::summarize(avg = mean(prevalence, na.rm = TRUE)) %>%
    dplyr::arrange(language)
}

aggregate_wikis <- function(data, languages, projects, input_metric) {
  languages <- sub(" \\([0-9]{1,2}\\.[0-9]{1,3}%\\)", "", languages)
  projects <- sub(" \\([0-9]{1,2}\\.[0-9]{1,3}%\\)", "", projects)
  if (length(languages) == 1 && languages[1] == "(None)") {
    temp <- data %>%
      dplyr::filter_(~ project %in% projects) %>%
      dplyr::rename(wiki = project) %>%
      dplyr::group_by(date, wiki)
    if (input_metric %in% c("User engagement", "Threshold-passing %", "Clickthrough rate")) {
      temp %<>%
        dplyr::summarize(
          `Threshold-passing %` = round(sum(`Threshold-passing %` * search_sessions_threshold, na.rm = TRUE) / sum(search_sessions_threshold, na.rm = TRUE), 2),
          `Clickthrough rate` = round(sum(`Clickthrough rate` * `Result pages opened`, na.rm = TRUE) / sum(`Result pages opened`, na.rm = TRUE), 2),
          `User engagement` = round((`Threshold-passing %` + `Clickthrough rate`) / 2, 2)
        )
    } else if (input_metric %in% c("clickthroughs", "Result pages opened", "search sessions")) {
      temp %<>%
        dplyr::summarize(
          clickthroughs = round(sum(as.numeric(clickthroughs), na.rm = TRUE), 2),
          `Result pages opened` = round(sum(as.numeric(`Result pages opened`), na.rm = TRUE), 2),
          `search sessions` = round(sum(as.numeric(`search sessions`), na.rm = TRUE), 2)
        )
    } else if (input_metric %in% c("F = 0.1", "F = 0.5", "F = 0.9")) {
      temp %<>%
        dplyr::summarize(
          `F = 0.1` = round(sum(`F = 0.1` * `search sessions`, na.rm = TRUE) / sum(`search sessions`, na.rm = TRUE), 2),
          `F = 0.5` = round(sum(`F = 0.5` * `search sessions`, na.rm = TRUE) / sum(`search sessions`, na.rm = TRUE), 2),
          `F = 0.9` = round(sum(`F = 0.9` * `search sessions`, na.rm = TRUE) / sum(`search sessions`, na.rm = TRUE), 2)
        )
    } else {
      temp %<>%
        dplyr::summarize(
          zero_results = sum(as.numeric(zero_results), na.rm = TRUE),
          total = sum(as.numeric(total), na.rm = TRUE)
        )
    }
    temp %<>% dplyr::ungroup()
  } else {
    temp <- data %>%
      dplyr::filter_(~language %in% languages & project %in% projects) %>%
      tidyr::unite(wiki, language, project, sep = " ") %>%
      dplyr::mutate(wiki = sub("(None) ", "", wiki, fixed = TRUE))
  }
  if (input_metric == "Zero result rate") {
    temp %<>%
      dplyr::mutate(zrr = round(100 * as.numeric(zero_results) / as.numeric(total), 2)) %>%
      dplyr::select(-c(total, zero_results)) %>%
      tidyr::spread(wiki, zrr)
  } else {
    temp %<>%
      dplyr::select_(.dots = c("date", "wiki", "val" = paste0("`", input_metric, "`"))) %>%
      tidyr::spread(., wiki, val, fill = 0)
  }
  return(temp)
}

# This is used in subsetting data for KPIs.
start_date <- function(date_range) {
  return(Sys.Date() - (switch(date_range, daily = 2, weekly = 14, monthly = 60, quarterly = 90) + 1))
}
