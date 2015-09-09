library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)

#Header elements for the visualisation
header <- dashboardHeader(title = "Search & Discovery", disable = FALSE)

#Sidebar elements for the search visualisations.
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "rainbow.js")
  ),
  sidebarMenu(
    menuItem(text = "KPIs",
             menuSubItem(text = "Summary", tabName = "kpis_summary"),
             menuSubItem(text = "Load times", tabName = "kpi_load_time"),
             menuSubItem(text = "Zero results", tabName = "kpi_zero_results"),
             menuSubItem(text = "API usage", tabName = "kpi_api_usage")),
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
             menuSubItem(text = "Full-text via API", tabName = "fulltext_search"),
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
    selectInput(inputId = "smoothing_global", label = "Smoothing (Global Setting)", selectize = TRUE, selected = "day",
                choices = c("No Smoothing" = "day", "Moving Average" = "moving_avg",
                            "Weekly Median" = "week", "Monthly Median" = "month"))
  )
)

# Standardised input selector for smoothing
smooth_select <- function(input_id, label = "Smoothing") {
  return(selectInput(inputId = input_id, label = label, selectize = TRUE,
                     selected = "global", choices = c("Use Global Setting" = "global",
                     "No Smoothing" = "day", "Moving Average" = "moving_avg",
                     "Weekly Median" = "week", "Monthly Median" = "month")))
}

#Body elements for the search visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "kpis_summary",
            selectInput("kpi_summary_date_range_selector", label = "Data range", multiple = FALSE, selected = "weekly",
                        choices = list("Yesterday" = "daily", "Last 7 days" = "weekly",
                                       "Last 30 days" = "monthly", "Last 90 days" = "quarterly")),
            htmlOutput("kpi_summary_date_range"),
            fluidRow(valueBoxOutput("kpi_summary_box_load_time", width = 3),
                     valueBoxOutput("kpi_summary_box_zero_results", width = 3),
                     valueBoxOutput("kpi_summary_box_api_usage", width = 3),
                     valueBox(subtitle = "User-satisfaction", value = "WIP", color = "black", width = 3)),
            plotOutput("kpi_summary_api_usage_proportions", height = "30px"),
            includeMarkdown("./assets/content/kpis_summary.md")
            ),
    tabItem(tabName = "kpi_load_time",
            smooth_select("smoothing_kpi_load_time"),
            dygraphOutput("kpi_load_time_series"),
            includeMarkdown("./assets/content/kpi_load_time.md")),
    tabItem(tabName = "kpi_zero_results",
            smooth_select("smoothing_kpi_zero_results"),
            dygraphOutput("kpi_zero_results_series"),
            includeMarkdown("./assets/content/kpi_zero_results.md")),
    tabItem(tabName = "kpi_api_usage",
            fluidRow(column(radioButtons("kpi_api_usage_series_data",
                                         label = "Type of data to display",
                                         choices = list("Calls" = "raw",
                                                        "Day-to-day % change" = "change"),
                                         inline = TRUE),
                            width = 4),
                     column(checkboxInput("kpi_api_usage_series_log_scale",
                                          label = "Log10 Scale",
                                          value = FALSE),
                            width = 2),
                     column(checkboxInput("kpi_api_usage_series_include_open",
                                          label = "Include OpenSearch in total",
                                          value = TRUE),
                            width = 3),
                     column(smooth_select("smoothing_kpi_api_usage"), width = 3)),
            dygraphOutput("kpi_api_usage_series"),
            includeMarkdown("./assets/content/kpi_api_usage.md")),
    tabItem(tabName = "desktop_events",
            fluidRow(
              valueBoxOutput("desktop_event_searches"),
              valueBoxOutput("desktop_event_resultsets"),
              valueBoxOutput("desktop_event_clickthroughs")
            ),
            smooth_select("smoothing_desktop_event"),
            dygraphOutput("desktop_event_plot"),
            includeMarkdown("./assets/content/desktop_events.md")),
    tabItem(tabName = "desktop_load",
            smooth_select("smoothing_desktop_load"),
            dygraphOutput("desktop_load_plot"),
            includeMarkdown("./assets/content/desktop_load.md")),
    tabItem(tabName = "mobile_events",
            fluidRow(
              valueBoxOutput("mobile_event_searches"),
              valueBoxOutput("mobile_event_resultsets"),
              valueBoxOutput("mobile_event_clickthroughs")
            ),
            smooth_select("smoothing_mobile_event"),
            dygraphOutput("mobile_event_plot"),
            includeMarkdown("./assets/content/mobile_events.md")
    ),
    tabItem(tabName = "mobile_load",
            smooth_select("smoothing_mobile_load"),
            dygraphOutput("mobile_load_plot"),
            includeMarkdown("./assets/content/mobile_load.md")
    ),
    tabItem(tabName = "app_events",
            fluidRow(
              valueBoxOutput("app_event_searches"),
              valueBoxOutput("app_event_resultsets"),
              valueBoxOutput("app_event_clickthroughs")
            ),
            smooth_select("smoothing_app_event"),
            dygraphOutput("android_event_plot"),
            dygraphOutput("ios_event_plot"),
            includeMarkdown("./assets/content/app_events.md")
    ),
    tabItem(tabName = "app_load",
            smooth_select("smoothing_app_load"),
            dygraphOutput("android_load_plot"),
            dygraphOutput("ios_load_plot"),
            includeMarkdown("./assets/content/app_load.md")
    ),
    tabItem(tabName = "fulltext_search",
            smooth_select("smoothing_fulltext_search"),
            dygraphOutput("cirrus_aggregate"),
            includeMarkdown("./assets/content/fulltext_basic.md")
    ),
    tabItem(tabName = "open_search",
            smooth_select("smoothing_open_search"),
            dygraphOutput("open_aggregate"),
            includeMarkdown("./assets/content/open_basic.md")
    ),
    tabItem(tabName = "geo_search",
            smooth_select("smoothing_geo_search"),
            dygraphOutput("geo_aggregate"),
            includeMarkdown("./assets/content/geo_basic.md")
    ),
    tabItem(tabName = "prefix_search",
            smooth_select("smoothing_prefix_search"),
            dygraphOutput("prefix_aggregate"),
            includeMarkdown("./assets/content/prefix_basic.md")
    ),
    tabItem(tabName = "language_search",
            smooth_select("smoothing_language_search"),
            dygraphOutput("language_aggregate"),
            includeMarkdown("./assets/content/language_basic.md")
    ),
    tabItem(tabName = "failure_rate",
            smooth_select("smoothing_failure_rate"),
            dygraphOutput("failure_rate_plot"),
            dygraphOutput("failure_rate_change_plot"),
            includeMarkdown("./assets/content/failure_rate.md")
    ),
    tabItem(tabName = "failure_breakdown",
            smooth_select("smoothing_failure_breakdown"),
            dygraphOutput("failure_breakdown_plot"),
            includeMarkdown("./assets/content/failure_breakdown.md")
    ),
    tabItem(tabName = "failure_suggestions",
            smooth_select("smoothing_failure_suggestions"),
            dygraphOutput("suggestion_dygraph_plot"),
            includeMarkdown("./assets/content/failure_suggests.md")
    )
  )
)

dashboardPage(header, sidebar, body, skin = "black")
