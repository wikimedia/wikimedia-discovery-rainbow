#Retrieves data for the mobile web stuff we care about, drops it in the public-datasets directory.
#Should be run on stat1002, /not/ on the datavis machine.
source("config.R")

#Grab desktop data
app_data <- as.data.table(olivr::mysql_read(paste0(readLines("app_events.sql"), collapse=" "),"log"))
app_data$timestamp <- as.Date(olivr::from_mediawiki(app_data$timestamp))

#Produce event aggregates
app_results <- app_data[,j = list(events = .N), by = c("timestamp","action")]
write_tsv(app_results, file.path(base_path, "app_event_counts.tsv"))

#Load times
result_data <- app_data[app_data$action == "Result pages opened",]
load_times <- result_data[,{
  output <- numeric(4)
  quantiles <- quantile(load_time,probs=seq(0,1,0.01))
  
  output[1] <- round(mean(load_time))
  output[2] <- round(median(load_time))
  output[3] <- quantiles[95]
  output[4] <- quantiles[99]
  
  output <- data.frame(t(output))
  names(output) <- c("Mean","Median","95th percentile","99th Percentile")
  output
}, by = "timestamp"]
write.table(load_times, file.path(base_path, "mobile_load_times.tsv"), row.names = FALSE, quote = TRUE, sep = "\t")
