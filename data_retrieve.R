#Retrieves data for the stuff we care about, drops it in the public-datasets directory.
#Should be run on stat1002, /not/ on the datavis machine.

#Config variables and setup
options(scipen = 500,
        q = "no")
base_path <- "/a/public-datasets/search/"
if(!dir.exists(base_path)){
  dir.create(path = base_path)
}

#Wrapper functions
write_table <- function(x, file){
  write.table(x, file, sep = "\t", row.names = FALSE, append = TRUE)
}

format_date <- function(dates){
  
}