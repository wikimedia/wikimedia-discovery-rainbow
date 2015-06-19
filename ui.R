library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)

#Header elements for the visualisation
header <- dashboardHeader(title = "Search & Discovery", disable = FALSE)

#Sidebar elements for the search visualisations.
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Desktop",
             menuSubItem(text = "Events", tabName = "desktop_events"),
             menuSubItem(text = "Load times", tabName = "desktop_load")),
    menuItem(text = "Mobile Web",
             menuSubItem(text = "Events", tabName = "mobile_events"),
             menuSubItem(text = "Load times", tabName = "mobile_load")),
    menuItem(text = "Mobile Apps",
             menuSubItem(text = "Events", tabName = "app_events"),
             menuSubItem(text = "Load times", tabName = "app_load")
    ),
    menuItem(text = "API",
             menuSubItem(text = "Cirrus Search", tabName = "cirrus_search"),
             menuSubItem(text = "Open Search", tabName = "open_search"),
             menuSubItem(text = "Geo Search", tabName = "geo_search"),
             menuSubItem(text = "Prefix Search", tabName = "prefix_search"),
             menuSubItem(text = "Language Search", tabName = "language_search")
    ),
    menuItem(text = "Zero Results",
             menuSubItem(text = "Zero Rate", tabName = "failure_rate")
    )
    
  )
)

#Body elements for the search visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "desktop_events",
            fluidRow(
              valueBoxOutput("desktop_event_searches"),
              valueBoxOutput("desktop_event_resultsets"),
              valueBoxOutput("desktop_event_clickthroughs")
            ),
            dygraphOutput("desktop_event_plot"),
            includeMarkdown("./assets/content/desktop_events.md")),
    tabItem(tabName = "desktop_load",
            dygraphOutput("desktop_load_plot"),
            includeMarkdown("./assets/content/desktop_load.md")),
    tabItem(tabName = "mobile_events",
            fluidRow(
              valueBoxOutput("mobile_event_searches"),
              valueBoxOutput("mobile_event_resultsets"),
              valueBoxOutput("mobile_event_clickthroughs")
            ),
            dygraphOutput("mobile_event_plot"),
            includeMarkdown("./assets/content/mobile_events.md")
    ),
    tabItem(tabName = "mobile_load",
            dygraphOutput("mobile_load_plot"),
            includeMarkdown("./assets/content/mobile_load.md")
    ),
    tabItem(tabName = "app_events",
            fluidRow(
              valueBoxOutput("app_event_searches"),
              valueBoxOutput("app_event_resultsets"),
              valueBoxOutput("app_event_clickthroughs")
            ),
            dygraphOutput("app_event_plot"),
            includeMarkdown("./assets/content/app_events.md")
    ),
    tabItem(tabName = "app_load",
            dygraphOutput("app_load_plot"),
            includeMarkdown("./assets/content/app_load.md")
    ),
    tabItem(tabName = "failure_rate",
            dygraphOutput("failure_rate_plot"),
            includeMarkdown("./assets/content/failure_rate.md")
    ),
    tabItem(tabName = "cirrus_search",
            dygraphOutput("cirrus_aggregate"),
            includeMarkdown("./assets/content/cirrus_basic.md")
    ),
    tabItem(tabName = "open_search",
            dygraphOutput("open_aggregate"),
            includeMarkdown("./assets/content/open_basic.md")
    ),
    tabItem(tabName = "geo_search",
            dygraphOutput("geo_aggregate"),
            includeMarkdown("./assets/content/geo_basic.md")
    ),
    tabItem(tabName = "prefix_search",
            dygraphOutput("prefix_aggregate"),
            includeMarkdown("./assets/content/prefix_basic.md")
    ),
    tabItem(tabName = "language_search",
            dygraphOutput("language_aggregate"),
            includeMarkdown("./assets/content/language_basic.md")
    )
  )
)

dashboardPage(header, sidebar, body, skin = "black")