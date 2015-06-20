#Dependent libs
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)

#Utility functions for handling particularly common tasks
download_set <- function(location){
  location <- paste0("http://datasets.wikimedia.org/aggregate-datasets/search/", location)
  con <- url(location)
  return(readr::read_delim(con, delim = "\t"))
}

#Create a dygraph using our standard format.
make_dygraph <- function(data, x, y, title, is_single = FALSE){
  
  if(is_single){
    data <- xts(data[,3], data[,1])
    names(data) <- "events"
  } else {
    data <- xts(data[,-1], data[,1])
  }
  renderDygraph({
    dyCSS(
      dyOptions(
        dyLegend(
          dygraph(data,
                  main = title,
                  xlab = x, ylab = y),
          width = 400, show = "always"
        ), strokeWidth = 3, colors = brewer.pal(3, "Set2"),
        drawPoints = TRUE, pointSize = 3, labelsKMB = TRUE,
        includeZero = TRUE
      )
      ,css = "./assets/css/custom.css")
  })
}