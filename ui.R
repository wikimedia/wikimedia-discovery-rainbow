library(shiny)
library(shinydashboard)
library(dygraphs)

files <- list.files("./ui", pattern = "\\.R$", full.names = TRUE)
trap <- lapply(files, source)
dashboardPage(header, sidebar, body, skin = "black")