#Dependent libs
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(toOrdinal)

# library(grid) # for unit

#Utility functions for handling particularly common tasks
download_set <- function(location){
  location <- paste0("http://datasets.wikimedia.org/aggregate-datasets/search/", location,
                     "?ts=", gsub(x = Sys.time(), pattern = "(-| )", replacement = ""))
  con <- url(location)
  return(readr::read_delim(con, delim = "\t"))
}

#Create a dygraph using our standard format.
make_dygraph <- function(data, x, y, title, is_single = FALSE, legend_name = NULL, use_si = TRUE){
  # cat("Making dygraph:", title, "\n"); # Debugging
  if(is_single){
    data <- xts(data[,3], data[[1]])
    if(is.null(legend_name)){
      names(data) <- "events"
    } else {
      names(data) <- legend_name
    }
  } else {
    data <- xts(data[,-1], order.by = data[[1]])
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

# Computes a median absolute deviation
mad <- function(x) {
  median(abs(x - median(x)))
}

compress <- function(x, round.by = 2) {
  # by StackOverflow user 'BondedDust' : http://stackoverflow.com/a/28160474
  div <- findInterval(as.numeric(gsub("\\,", "", x)),
                      c(1, 1e3, 1e6, 1e9, 1e12) )
  paste(round( as.numeric(gsub("\\,","",x))/10^(3*(div-1)), round.by),
        c("","K","M","B","T")[div], sep = "" )
}

# Conditional icon for widget
cond_icon <- function(condition, true_direction = "up") {
  # Returns arrow-up icon on true (if true_direction is 'up'), e.g. load time % change > 0
  if ( true_direction == "up" ) icon(ifelse(condition, "arrow-up", "arrow-down"))
  else icon(ifelse(condition, "arrow-down", "arrow-up"))
}

# Conditional color for widget
cond_color <- function(condition, true_color = "green") {
  # Returns 'green' on true, 'red' on false, e.g. api usage % change > 0
  #                                               load time % change < 0
  ifelse(condition, true_color, ifelse(true_color == "green", "red", "green"))
}

# Uses ggplot2 to create a pie chart in bar form. (Will look up actual name later.)
gg_prop_bar <- function(data, cols) {
  # `cols` = list(`item`, `prop`, `label`)
  data$text_position <- cumsum(data[[cols$prop]]) + (c(0, cumsum(data[[cols$prop]])[-nrow(data)]) - cumsum(data[[cols$prop]]))/2
  ggplot(data, aes_string(x = 1, fill = cols$item)) +
    geom_bar(aes_string(y = cols$prop), stat="identity") +
    scale_fill_discrete(name = item, guide = FALSE, expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_continuous(expand = c(0,0)) +
    labs(x = NULL, y = NULL) +
    coord_flip() +
    theme_bw() +
    theme(axis.ticks = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          plot.margin = grid::unit(c(0, 0, -0.5, -0.5), "lines"),
          panel.margin = grid::unit(0, "lines")) +
    geom_text(aes_string(label = cols$label,
                  y = "text_position",
                  x = 1))
}
