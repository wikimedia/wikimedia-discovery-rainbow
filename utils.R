#Dependent libs
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(grid) # for unit

#Utility functions for handling particularly common tasks
download_set <- function(location){
  location <- paste0("http://datasets.wikimedia.org/aggregate-datasets/search/", location,
                     "?ts=", gsub(x = Sys.time(), pattern = "(-| )", replacement = ""))
  con <- url(location)
  return(readr::read_delim(con, delim = "\t"))
}

#Create a dygraph using our standard format.
make_dygraph <- function(data, x, y, title, is_single = FALSE, legend_name = NULL, use_si = TRUE){

  if(is_single){
    data <- xts(data[,3], data[,1])
    if(is.null(legend_name)){
      names(data) <- "events"
    } else {
      names(data) <- legend_name
    }
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
        drawPoints = TRUE, pointSize = 3, labelsKMB = use_si,
        includeZero = TRUE
      )
      ,css = "./assets/css/custom.css")
  })
}
