library(lubridate)
source("config.R")

#A function for creating a hive query aimed at the data from yesterday.
hive_script_query_date <- function(before, after = ";"){
  
  run_date <- Sys.Date() - 1
  
  subquery <- paste0(" WHERE year = ", lubridate::year(run_date),
                     " AND month = ", lubridate::month(run_date),
                     " AND day = ", lubridate::day(run_date), " ")
  
  result <- paste0(before, subquery, after)
  return(result)
}

#A function for running a hive query and returning the results
hive_run <- function(query){
  
  query_dump <- tempfile()
  cat(query, file = query_dump)
  results_dump <- tempfile()
  system(paste0("export HADOOP_HEAPSIZE=1024 && hive -f ", query_dump, " > ", results_dump))
  
  data <- read.delim(results_dump, sep = "\t", quote = "", as.is = TRUE, header = TRUE)
  return(data)
}

query <- hive_script_query_date(before = "add jar /home/ironholds/refinery-hive-0.0.12-SNAPSHOT.jar;
                                          create temporary function search_classify AS
                                          'org.wikimedia.analytics.refinery.hive.SearchClassifierUDF';
                                          SELECT year, month, day, search_classify(uri_path, uri_query) AS event_type,
                                          COUNT(*) AS search_events
                                          FROM wmf.webrequest",
                                after = "AND webrequest_source IN('text','mobile') AND http_status = '200'
                                         GROUP BY year, month, day, search_classify(uri_path, uri_query);")

results <- hive_run(query)
results <- results[complete.cases(results),]
results <- results[results$event_type %in% c("language","cirrus","prefix","geo","open"),]
output <- data.frame(timestamp = as.Date(paste(results$year, results$month, results$day, sep = "-")),
                     event_type = results$event_type,
                     events = results$search_events,
                     stringsAsFactors = FALSE)

file_location <- file.path(base_path, "search_api_aggregates.tsv")
if(file.exists(file_location)){
  write.table(x = output, file = file_location, append = TRUE, quote = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE)
} else {
  write.table(x = output, file = file_location, append = FALSE, quote = TRUE, sep = "\t", row.names = FALSE, col.names = TRUE)
}