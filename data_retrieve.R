#Retrieves data for the stuff we care about, drops it in the public-datasets directory.
#Should be run on stat1002, /not/ on the datavis machine.

#Config variables and setup
options(scipen = 500,
        q = "no")
base_path <- "/a/public-datasets/search/"
archive_path <- "/a/public-datasets/search/archive"

#Dependencies
library(WMUtils)

if(!dir.exists(base_path)){
  dir.create(path = base_path)
}

if(!dir.exists(archive_path)){
  dir.create(path = archive_path)
}


#Wrapper functions
write_table <- function(x, file){
  write.table(x, file, sep = "\t", row.names = FALSE, append = TRUE)
}

#Grab desktop data
desktop_data <- WMUtils::mysql_query("SELECT timestamp, event_action AS action, event_clickIndex AS click_index,
                                      event_numberOfResults AS result_count, event_resultSetType as result_type,
                                      event_timeOffsetSinceStart AS time_offset, event_timeToDisplayResults AS
                                      load_time FROM Search_11670541", "log")
desktop_data$timestamp <- as.Date(mw_strptime(desktop_data$timestamp))

desktop_results <- desktop_data[,j = {
  output <- data.table(events = .N)
}, by = c("timestamp","action")]

write_table(desktop_results, file.path(base_path, "desktop_eventlogging_aggregates.tsv"))