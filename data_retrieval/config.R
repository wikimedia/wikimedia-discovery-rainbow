#Config variables and setup
options(scipen = 500,
        q = "no")
base_path <- "/a/aggregate-datasets/search/"

#Dependencies
library(olivr)
suppressPackageStartupMessages(library(data.table))

if(!file.exists(base_path)){
  dir.create(path = base_path)
}