#Retrieves data for the desktop stuff we care about, drops it in the public-datasets directory.
#Should be run on stat1002, /not/ on the datavis machine.
source("config.R")

#Grab desktop data
desktop_data <- as.data.table(olivr::mysql_read(paste0(readLines("desktop_events.sql"), collapse=" "),"log"))
desktop_data$timestamp <- as.Date(olivr::from_mediawiki(desktop_data$timestamp))

#Produce event aggregates
desktop_results <- desktop_data[,j = list(events = .N), by = c("timestamp","action")]
write_tsv(desktop_results, file.path(base_path, "desktop_event_counts.tsv"))

#Load times
result_data <- desktop_data[desktop_data$action == "Result pages opened",]
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
write_tsv(load_times, file.path(base_path, "desktop_load_times.tsv"))
