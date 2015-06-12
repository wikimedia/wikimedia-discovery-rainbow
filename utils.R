#Utility functions for handling particularly common tasks
download_set <- function(location){
  con <- url(location)
  return(readr::read_delim(con, delim = "\t"))
}

#Create a dygraph using our standard format.
make_dygraph <- function(data, x, y, title){
  renderDygraph({
    dyCSS(
      dyOptions(
        dyLegend(
          dygraph(xts(data[,-1],
                      data[,1]),
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