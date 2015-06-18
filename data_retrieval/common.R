source("config.R")

#Query building function
query_func <- function(fields, table, ts_field, date = NULL, conditionals){
  
  #Ensure we have a date and deconstruct it into a MW-friendly format
  if(is.null(date)){
    date <- Sys.Date()-1
  }
  date <- gsub(x = date, pattern = "-", replacement = "")
  
  #Build the query proper (this will work for EL schemas where the field is always 'timestamp')
  query <- paste(fields, "FROM", table, "WHERE LEFT(timestamp,8) =", date, "AND", conditionals)
  
  results <- data.table::as.data.table(olivr::mysql_read(query, "log"))
  return(results)
}

#Conditional write; if the file exists, add x to the end. If it doesn't, write an entirely new file.
conditional_write <- function(x, file){
  if(file.exists(file)){
    write.table(x, file, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE)
  } else {
    write.table(x, file, append = FALSE, sep = "\t", row.names = FALSE)
  }
}