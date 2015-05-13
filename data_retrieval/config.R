#Config variables and setup
options(scipen = 500,
        q = "no")
base_path <- "/a/public-datasets/search/"
archive_path <- "/a/public-datasets/search/archive"

#Dependencies
library(olivr)
library(data.table)

if(!dir.exists(base_path)){
  dir.create(path = base_path)
}