library(shiny)
library(shinydashboard)
library(dygraphs)

#Header elements for the visualisation
header <- dashboardHeader(title = "Search Metrics", dropdownMenuOutput("message_menu"), disable = FALSE)

#Sidebar elements for the search visualisations.
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "rainbow.js")
  ),
  sidebarMenu(
    menuItem(text = "KPIs",
             div(selectInput("kpi_summary_date_range_selector",
                             label = "KPI data range", multiple = FALSE, selected = "monthly",
                             choices = list("Yesterday" = "daily", "Last 7 days" = "weekly",
                                            "Last 30 days" = "monthly", "Last 90 days" = "quarterly")),
                 style = "margin-bottom:-10px;"),
             menuSubItem(text = "Summary", tabName = "kpis_summary"),
             menuSubItem(text = "Monthly Metrics", tabName = "monthly_metrics"),
             menuSubItem(text = "Load times", tabName = "kpi_load_time"),
             menuSubItem(text = "Zero results", tabName = "kpi_zero_results"),
             menuSubItem(text = "API usage", tabName = "kpi_api_usage"),
             menuSubItem(text = "Augmented Clickthrough", tabName = "kpi_augmented_clickthroughs"),
             icon = icon("star", lib = "glyphicon")),
    menuItem(text = "Desktop",
             menuSubItem(text = "Events", tabName = "desktop_events"),
             menuSubItem(text = "Load times", tabName = "desktop_load")),
    menuItem(text = "Mobile Web",
             menuSubItem(text = "Events", tabName = "mobile_events"),
             menuSubItem(text = "Load times", tabName = "mobile_load")),
    menuItem(text = "Mobile Apps",
             menuSubItem(text = "Events", tabName = "app_events"),
             menuSubItem(text = "Load times", tabName = "app_load")),
    menuItem(text = "API",
             menuSubItem(text = "Full-text via API", tabName = "fulltext_search"),
             menuSubItem(text = "Open Search", tabName = "open_search"),
             menuSubItem(text = "Geo Search", tabName = "geo_search"),
             menuSubItem(text = "Prefix Search", tabName = "prefix_search"),
             menuSubItem(text = "Language Search", tabName = "language_search")),
    menuItem(text = "Zero Results",
             menuSubItem(text = "Summary", tabName = "failure_rate"),
             menuSubItem(text = "Search Type Breakdown", tabName = "failure_breakdown"),
             menuSubItem(text = "Search Suggestions", tabName = "failure_suggestions"),
             menuSubItem(text = "Language/Project Breakdown", tabName = "failure_langproj")),
    menuItem(text = "Page Visit Times", tabName = "survival"),
    menuItem(text = "Global Settings",
             selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                         choices = c("No Smoothing" = "day", "Weekly Median" = "week",
                                     "Monthly Median" = "month", "Splines" = "gam")),
             selectInput(inputId = "timeframe_global", label = "Time Frame", selectize = TRUE, selected = "",
                         choices = c("All available data" = "all", "Last 7 days" = "week", "Last 30 days" = "month",
                                     "Last 90 days" = "quarter", "Custom" = "custom")),
             conditionalPanel("input.timeframe_global == 'custom'",
                              dateRangeInput("daterange_global", label = "Custom Date Range",
                                             start = Sys.Date()-11, end = Sys.Date()-1, min = "2015-04-14")),
             icon = icon("cog", lib = "glyphicon"))
  ),
  div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;")
)

#Body elements for the search visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "kpis_summary",
            htmlOutput("kpi_summary_date_range"),
            fluidRow(valueBoxOutput("kpi_summary_box_load_time", width = 3),
                     valueBoxOutput("kpi_summary_box_zero_results", width = 3),
                     valueBoxOutput("kpi_summary_box_api_usage", width = 3),
                     valueBoxOutput("kpi_summary_box_augmented_clickthroughs", width = 3)),
            plotOutput("kpi_summary_api_usage_proportions", height = "30px"),
            includeMarkdown("./tab_documentation/kpis_summary.md")),
    tabItem(tabName = "monthly_metrics",
            tableOutput("monthly_metrics_tbl"),
            includeMarkdown("./tab_documentation/monthly_metrics.md")),
    tabItem(tabName = "kpi_load_time",
            fluidRow(
              column(polloi::smooth_select("smoothing_kpi_load_time"), width = 4),
              column(div(id = "kpi_load_time_series_legend"), width = 8)
            ),
            dygraphOutput("kpi_load_time_series"),
            includeMarkdown("./tab_documentation/kpi_load_time.md")),
    tabItem(tabName = "kpi_zero_results",
            polloi::smooth_select("smoothing_kpi_zero_results"),
            dygraphOutput("kpi_zero_results_series"),
            includeMarkdown("./tab_documentation/kpi_zero_results.md")),
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
                     column(polloi::smooth_select("smoothing_kpi_api_usage"), width = 3)),
            dygraphOutput("kpi_api_usage_series"),
            includeMarkdown("./tab_documentation/kpi_api_usage.md")),
    tabItem(tabName = "kpi_augmented_clickthroughs",
            fluidRow(
              column(polloi::smooth_select("smoothing_augmented_clickthroughs"), width = 4),
              column(div(id = "kpi_augmented_clickthroughs_series_legend"), width = 8)),
            dygraphOutput("kpi_augmented_clickthroughs_series"),
            includeMarkdown("./tab_documentation/kpi_augmented_clickthroughs.md")),
    tabItem(tabName = "desktop_events",
            fluidRow(
              valueBoxOutput("desktop_event_searches"),
              valueBoxOutput("desktop_event_resultsets"),
              valueBoxOutput("desktop_event_clickthroughs")),
            fluidRow(
              column(polloi::smooth_select("smoothing_desktop_event"), width = 4),
              column(polloi::timeframe_select("desktop_event_timeframe"), width = 4),
              column(polloi::timeframe_daterange("desktop_event_timeframe"), width = 4)),
            dygraphOutput("desktop_event_plot"),
            includeMarkdown("./tab_documentation/desktop_events.md")),
    tabItem(tabName = "desktop_load",
            fluidRow(
              column(polloi::smooth_select("smoothing_desktop_load"), width = 4),
              column(polloi::timeframe_select("desktop_load_timeframe"), width = 4),
              column(polloi::timeframe_daterange("desktop_load_timeframe"), width = 4)),
            dygraphOutput("desktop_load_plot"),
            includeMarkdown("./tab_documentation/desktop_load.md")),
    tabItem(tabName = "mobile_events",
            fluidRow(
              valueBoxOutput("mobile_event_searches"),
              valueBoxOutput("mobile_event_resultsets"),
              valueBoxOutput("mobile_event_clickthroughs")),
            fluidRow(
              column(polloi::smooth_select("smoothing_mobile_event"), width = 4),
              column(polloi::timeframe_select("mobile_event_timeframe"), width = 4),
              column(polloi::timeframe_daterange("mobile_event_timeframe"), width = 4)),
            dygraphOutput("mobile_event_plot"),
            includeMarkdown("./tab_documentation/mobile_events.md")
    ),
    tabItem(tabName = "mobile_load",
            fluidRow(
              column(polloi::smooth_select("smoothing_mobile_load"), width = 4),
              column(polloi::timeframe_select("mobile_load_timeframe"), width = 4),
              column(polloi::timeframe_daterange("mobile_load_timeframe"), width = 4)),
            dygraphOutput("mobile_load_plot"),
            includeMarkdown("./tab_documentation/mobile_load.md")
    ),
    tabItem(tabName = "app_events",
            fluidRow(
              valueBoxOutput("app_event_searches"),
              valueBoxOutput("app_event_resultsets"),
              valueBoxOutput("app_event_clickthroughs")),
            fluidRow(
              column(polloi::smooth_select("smoothing_app_event"), width = 4),
              column(polloi::timeframe_select("app_event_timeframe"), width = 4),
              column(polloi::timeframe_daterange("app_event_timeframe"), width = 4)),
            dygraphOutput("android_event_plot"),
            dygraphOutput("ios_event_plot"),
            includeMarkdown("./tab_documentation/app_events.md")
    ),
    tabItem(tabName = "app_load",
            fluidRow(
              column(polloi::smooth_select("smoothing_app_load"), width = 4),
              column(polloi::timeframe_select("app_load_timeframe"), width = 4),
              column(polloi::timeframe_daterange("app_load_timeframe"), width = 4)),
            dygraphOutput("android_load_plot"),
            dygraphOutput("ios_load_plot"),
            includeMarkdown("./tab_documentation/app_load.md")
    ),
    tabItem(tabName = "fulltext_search",
            fluidRow(
              column(polloi::smooth_select("smoothing_fulltext_search"), width = 4),
              column(polloi::timeframe_select("fulltext_search_timeframe"), width = 4),
              column(polloi::timeframe_daterange("fulltext_search_timeframe"), width = 4)),
            dygraphOutput("cirrus_aggregate"),
            includeMarkdown("./tab_documentation/fulltext_basic.md")
    ),
    tabItem(tabName = "open_search",
            fluidRow(
              column(polloi::smooth_select("smoothing_open_search"), width = 4),
              column(polloi::timeframe_select("open_search_timeframe"), width = 4),
              column(polloi::timeframe_daterange("open_search_timeframe"), width = 4)),
            dygraphOutput("open_aggregate"),
            includeMarkdown("./tab_documentation/open_basic.md")
    ),
    tabItem(tabName = "geo_search",
            fluidRow(
              column(polloi::smooth_select("smoothing_geo_search"), width = 4),
              column(polloi::timeframe_select("geo_search_timeframe"), width = 4),
              column(polloi::timeframe_daterange("geo_search_timeframe"), width = 4)),
            dygraphOutput("geo_aggregate"),
            includeMarkdown("./tab_documentation/geo_basic.md")
    ),
    tabItem(tabName = "prefix_search",
            fluidRow(
              column(polloi::smooth_select("smoothing_prefix_search"), width = 4),
              column(polloi::timeframe_select("prefix_search_timeframe"), width = 4),
              column(polloi::timeframe_daterange("prefix_search_timeframe"), width = 4)),
            dygraphOutput("prefix_aggregate"),
            includeMarkdown("./tab_documentation/prefix_basic.md")
    ),
    tabItem(tabName = "language_search",
            fluidRow(
              column(polloi::smooth_select("smoothing_language_search"), width = 4),
              column(polloi::timeframe_select("language_search_timeframe"), width = 4),
              column(polloi::timeframe_daterange("language_search_timeframe"), width = 4)),
            dygraphOutput("language_aggregate"),
            includeMarkdown("./tab_documentation/language_basic.md")
    ),
    tabItem(tabName = "failure_rate",
            fluidRow(
              column(polloi::smooth_select("smoothing_failure_rate"), width = 4),
              column(polloi::timeframe_select("failure_rate_timeframe"), width = 4),
              column(polloi::timeframe_daterange("failure_rate_timeframe"), width = 4)),
            polloi::automata_select(input_id = "failure_rate_automata"),
            dygraphOutput("failure_rate_plot"),
            dygraphOutput("failure_rate_change_plot"),
            includeMarkdown("./tab_documentation/failure_rate.md")
    ),
    tabItem(tabName = "failure_breakdown",
            fluidRow(
              column(polloi::smooth_select("smoothing_failure_breakdown"), width = 4),
              column(polloi::timeframe_select("failure_breakdown_timeframe"), width = 4),
              column(polloi::timeframe_daterange("failure_breakdown_timeframe"), width = 4)),
            polloi::automata_select(input_id = "failure_breakdown_automata"),
            dygraphOutput("failure_breakdown_plot"),
            div(id = "failure_breakdown_plot_legend"),
            includeMarkdown("./tab_documentation/failure_breakdown.md")
    ),
    tabItem(tabName = "failure_suggestions",
            fluidRow(
              column(polloi::smooth_select("smoothing_failure_suggestions"), width = 4),
              column(polloi::timeframe_select("failure_suggestions_timeframe"), width = 4),
              column(polloi::timeframe_daterange("failure_suggestions_timeframe"), width = 4)),
            polloi::automata_select(input_id = "failure_suggestions_automata"),
            dygraphOutput("suggestion_dygraph_plot"),
            includeMarkdown("./tab_documentation/failure_suggests.md")
    ),
    tabItem(tabName = "failure_langproj",
            fluidRow(
              column(polloi::smooth_select("smoothing_failure_langproj"), width = 4),
              column(polloi::timeframe_select("failure_langproj_timeframe"), width = 4),
              column(polloi::timeframe_daterange("failure_langproj_timeframe"), width = 4)),
            polloi::automata_select(input_id = "failure_langproj_automata"),
            fluidRow(column(selectInput("project_order", "Sort projects by",
                                        list("Alphabetical order" = "alphabet", "Volume of requests" = "volume"),
                                        selected = "volume"),
                            uiOutput("project_selector_container"), width = 2),
                     column(selectInput("language_order", "Sort languages by",
                                        list("Alphabetical order" = "alphabet", "Volume of requests" = "volume"),
                                        selected = "volume"),
                            uiOutput("language_selector_container"), width = 2),
                     column(dygraphOutput("failure_langproj_plot"),
                            div(id = "failure_langproj_legend", style = "margin-top:30px;"), width = 8)),
            includeMarkdown("./tab_documentation/failure_langproj.md")
    ),
    tabItem(tabName = "survival",
            fluidRow(
              column(polloi::smooth_select("smoothing_lethal_dose_plot"), width = 4),
              column(polloi::timeframe_select("lethal_dose_timeframe"), width = 4),
              column(polloi::timeframe_daterange("lethal_dose_timeframe"), width = 4)),
            div(id = "lethal_dose_plot_legend"),
            dygraphOutput("lethal_dose_plot"),
            includeMarkdown("./tab_documentation/survival.md")
    )
  )
)

dashboardPage(header, sidebar, body, skin = "black",
              title = "Search Metrics Dashboard | Discovery | Engineering | Wikimedia Foundation")
