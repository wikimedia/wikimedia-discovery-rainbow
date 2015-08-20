library(lubridate)
source("common.R")

# Central function
main <- function(date = NULL){

  # Date handling
  if(is.null(date)){
    date <- Sys.Date() - 1
  }
  subquery <- paste0(" WHERE year = ", lubridate::year(date),
                     " AND month = ", lubridate::month(date),
                     " AND day = ", lubridate::day(date), " ")

  # Write query and dump to file
  query <- paste0("ADD JAR /srv/deployment/analytics/refinery/artifacts/refinery-hive.jar;
                   CREATE TEMPORARY FUNCTION search_classify AS
                  'org.wikimedia.analytics.refinery.hive.SearchClassifierUDF';
                   USE wmf;
                   SELECT year, month, day, search_classify(uri_path, uri_query) AS event_type,
                   COUNT(*) AS search_events
                   FROM webrequest
                  ", subquery,
                  "AND webrequest_source IN('text','mobile') AND http_status = '200'
                   GROUP BY year, month, day, search_classify(uri_path, uri_query);")
  query_dump <- tempfile()
  cat(query, file = query_dump)

  # Query
  results_dump <- tempfile()
  system(paste0("export HADOOP_HEAPSIZE=1024 && hive -f ", query_dump, " > ", results_dump))
  results <- read.delim(results_dump, sep = "\t", quote = "", as.is = TRUE, header = TRUE)
  file.remove(query_dump, results_dump)

  # Filter and reformat
  results <- results[complete.cases(results),]
  results <- results[results$event_type %in% c("language","cirrus","prefix","geo","open"),]
  output <- data.frame(timestamp = as.Date(paste(results$year, results$month, results$day, sep = "-")),
                       event_type = results$event_type,
                       events = results$search_events,
                       stringsAsFactors = FALSE)

  # Write out
  conditional_write(output, file.path(base_path, "search_api_aggregates.tsv"))
}

#Run and kill
main()
q(save = "no")
