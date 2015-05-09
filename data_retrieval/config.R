#Config variables and setup
options(scipen = 500,
        q = "no")
base_path <- "/a/public-datasets/search/"
archive_path <- "/a/public-datasets/search/archive"

#Dependencies
library(WMUtils)
library(data.table)
library(loggr)

if(!dir.exists(base_path)){
  dir.create(path = base_path)
}

#Wrapper functions
write_table <- function(x, file){
  write.table(x, file, sep = "\t", row.names = FALSE, append = TRUE)
}