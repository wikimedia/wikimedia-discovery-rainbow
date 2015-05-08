library(shiny)
library(shinydashboards)

files <- list.files("./ui", pattern = "\\.R$", full.names = TRUE)
trap <- lapply(files, source)

shinyApp(
  ui = dashboardPage(header, sidebar, body()),
  server = function(input, output) { }
)