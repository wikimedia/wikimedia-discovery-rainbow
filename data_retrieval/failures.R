library(rPython)

aggregate_location <- "/a/aggregate-datasets/search/cirrus_query_aggregates.tsv"
raw_dir <- "/a/aggregate-datasets/search/daily_pages/"

#Identify a cirrus log file
get_file <- function(date){
  date <- gsub(x = date, pattern = "(-|:)", replacement = "")
  files <- list.files("/a/mw-log/archive/", full.names = TRUE)
  return(files[grepl(x = files, pattern = date, fixed = TRUE)])
}

#Extract a file's content
extract_file <- function(file){
  output_file <- tempfile()
  system(paste("gunzip -c", file, ">", output_file))
  return(output_file)
}

save_aggregates <- file()
#Get failure counts and such
main <- function(date = NULL){
  if(is.null(date)){
    date <- Sys.Date() - 1
  }
  filename <- extract_file(get_file(Sys.Date()-1))
  python.assign("filename", filename)
  python.exec("import core; query_count, zero_count, zero_results = core.parse_file(filename)")
  file.remove(filename)
  query_count <- python.get("query_count")
  zero_count <- python.get("zero_count")
  zero_results <- python.get("zero_results")

  aggregate_data <- data.frame(date = date, variable = c("Search Queries","Zero Result Queries"),
                               value = c(query_count, zero_count), stringsAsFactors = FALSE)

  if(file.exists(aggregate_location)){
    write.table(aggregate_data, aggregate_location, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE)
  } else {
    write.table(aggregate_data, aggregate_location, append = FALSE, sep = "\t", row.names = FALSE)
  }

  zero_results <- data.frame(matrix(unlist(zero_results), nrow = length(zero_results), byrow = TRUE),
                             stringsAsFactors = FALSE)
  names(zero_results) <- c("query","attempts")
  zero_results$query <- gsub(x=zero_results$query, pattern = "(\\t|\\n)", replacement = "")
  dir.create(raw_dir, showWarnings = FALSE)
  write.table(zero_results, file = paste0(raw_dir, "zero_resulting_queries",
                                          gsub(x = date, pattern = "-", replacement = ""),".tsv"),
              quote = FALSE, sep = "\t", row.names = FALSE)
  return(invisible())
}

main()
