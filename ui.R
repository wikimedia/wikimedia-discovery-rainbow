library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)

#Header elements for the visualisation
header <- dashboardHeader(title = "Search & Discovery", disable = FALSE)

#Sidebar elements for the search visualisations.
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "KPIs",
             menuSubItem(text = "Summary", tabName = "kpis_summary", selected = TRUE)),
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
             menuSubItem(text = "Summary", tabName = "failure_rate"),
             menuSubItem(text = "Search Type Breakdown", tabName = "failure_breakdown"),
             menuSubItem(text = "Search Suggestions", tabName = "failure_suggestions")
    ),
    menuItem(text = "Build-A-Plot(TM)",
             tabName = "build_a_plot",
             badgeLabel = "experimental",
             badgeColor = "fuchsia")
  )
)

#Body elements for the search visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "kpis_summary",
            fluidRow(valueBox("--%", "User Satisfaction",
                              color = "green", # make dynamic
                              width = 6,
                              icon = icon("thumbs-up", lib = "glyphicon")),
                     valueBox("--ms", "User-perceived load time",
                              color = "purple", # make dynamic
                              width = 6,
                              icon = icon("time", lib = "glyphicon"))
                     ),
            h2("Zero Results Rate"),
            fluidRow(valueBoxOutput("kpi_summary_zero_results_latest", width = 2),
                     valueBoxOutput("kpi_summary_zero_results_week_avg", width = 3),
                     valueBoxOutput("kpi_summary_zero_results_rate_change", width = 3),
                     valueBoxOutput("kpi_summary_zero_results_rate_week_avg", width = 4)),
            h2("API Usage"),
            fluidRow(valueBoxOutput("kpi_summary_api_usage_all", width = 2),
                     valueBoxOutput("kpi_summary_api_usage_cirrus", width = 2),
                     valueBoxOutput("kpi_summary_api_usage_open", width = 2),
                     valueBoxOutput("kpi_summary_api_usage_geo", width = 2),
                     valueBoxOutput("kpi_summary_api_usage_prefix", width = 2),
                     valueBoxOutput("kpi_summary_api_usage_language", width = 2)),
            plotOutput("kpi_summary_api_usage_proportions", height = "120px"),
            includeMarkdown("./assets/content/kpis_summary.md")
            ),
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
            dygraphOutput("android_event_plot"),
            dygraphOutput("ios_event_plot"),
            includeMarkdown("./assets/content/app_events.md")
    ),
    tabItem(tabName = "app_load",
            dygraphOutput("android_load_plot"),
            dygraphOutput("ios_load_plot"),
            includeMarkdown("./assets/content/app_load.md")
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
    ),
    tabItem(tabName = "failure_rate",
            dygraphOutput("failure_rate_plot"),
            dygraphOutput("failure_rate_change_plot"),
            includeMarkdown("./assets/content/failure_rate.md")
    ),
    tabItem(tabName = "failure_breakdown",
            dygraphOutput("failure_breakdown_plot"),
            includeMarkdown("./assets/content/failure_breakdown.md")
    ),
    tabItem(tabName = "failure_suggestions",
            dygraphOutput("suggestion_dygraph_plot"),
            includeMarkdown("./assets/content/failure_suggests.md")
    ),
    tabItem(tabName = "build_a_plot",
            uiOutput("custom_plot"),
            includeMarkdown("./assets/content/build_a_plot.md")
    )
  )
)

dashboardPage(header, sidebar, body, skin = "black")
