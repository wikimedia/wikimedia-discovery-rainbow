#Retrieves data for the mobile web stuff we care about, drops it in the aggregate-datasets directory.
#Should be run on stat1002, /not/ on the datavis machine.
source("common.R")

main <- function(date = NULL, table = "MobileWikiAppSearch_10641988"){
  
  #Retrieve data using the query builder in ./common.R
  data <- query_func(fields = "
                    SELECT timestamp,
                    CASE event_action WHEN 'click' THEN 'clickthroughs'
                    WHEN 'start' THEN 'search sessions'
                    WHEN 'results' THEN 'Result pages opened' END AS action,
                    event_timeToDisplayResults AS load_time",
                     date = date,
                     table = table,
                     conditionals = "event_action IN ('click','start','results')")
  data$timestamp <- as.Date(olivr::from_mediawiki(data$timestamp))
  
  #Generate aggregates and save
  app_results <- data[,j = list(events = .N), by = c("timestamp","action")]
  conditional_write(app_results, file.path(base_path, "app_event_counts.tsv"))
  
  #Produce load time data
  load_times <- data[data$action == "Result pages opened",{
    output <- numeric(3)
    quantiles <- quantile(load_time,probs=seq(0,1,0.01))
    
    output[1] <- round(median(load_time))
    output[2] <- quantiles[95]
    output[3] <- quantiles[99]
    
    output <- data.frame(t(output))
    names(output) <- c("Median","95th percentile","99th Percentile")
    output
  }, by = "timestamp"]
  conditional_write(load_times, file.path(base_path, "app_load_times.tsv"))
  
}

#Run and kill
main()
q(save = "no")