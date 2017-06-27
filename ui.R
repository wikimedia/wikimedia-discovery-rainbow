library(shiny)
library(shinydashboard)
library(dygraphs)
library(lubridate)

with_wikimedia_mathjax <- function() {
  # Modified version of withMathJax() Keeping this
  # here for now. If another dashboard needs to
  # render LaTeX, we'll have to put this in polloi.
  return(tagList(
    tags$script(src = "https://tools-static.wmflabs.org/cdnjs/ajax/libs/mathjax/2.6.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML", type = "text/javascript"),
    tags$script(HTML("if (window.MathJax) MathJax.Hub.Queue([\"Typeset\", MathJax.Hub]);")),
    tags$script(HTML("MathJax.Hub.Config({ tex2jax: {inlineMath: [['$','$']]} });"), type = "text/x-mathjax-config")
  ))
}

function(request) {
  dashboardPage(

    dashboardHeader(title = "Search Metrics", dropdownMenuOutput("message_menu"), disable = FALSE),

    dashboardSidebar(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
        tags$script(src = "custom.js"),
        with_wikimedia_mathjax()
      ),
      sidebarMenu(id = "tabs",
                  menuItem(text = "KPIs",
                           div(selectInput("kpi_summary_date_range_selector",
                                           label = "KPI data range", multiple = FALSE, selected = "monthly",
                                           choices = list("Yesterday" = "daily", "Last 7 days" = "weekly",
                                                          "Last 30 days" = "monthly", "Last 90 days" = "quarterly",
                                                          "All available data" = "all")),
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
                           menuSubItem(text = "Load times", tabName = "desktop_load"),
                           menuSubItem(text = "PaulScore", tabName = "paulscore_approx")),
                  menuItem(text = "Mobile Web",
                           menuSubItem(text = "Events", tabName = "mobile_events"),
                           menuSubItem(text = "Load times", tabName = "mobile_load")),
                  menuItem(text = "Mobile Apps",
                           menuSubItem(text = "Events", tabName = "app_events"),
                           menuSubItem(text = "Load times", tabName = "app_load"),
                           menuSubItem(text = "Click Position", tabName = "app_click_position"),
                           menuSubItem(text = "Invoke Source", tabName = "app_invoke_source")
                  ),
                  menuItem(text = "API",
                           menuSubItem(text = "Full-text via API", tabName = "fulltext_search"),
                           menuSubItem(text = "Open Search", tabName = "open_search"),
                           menuSubItem(text = "Geo Search", tabName = "geo_search"),
                           menuSubItem(text = "Prefix Search", tabName = "prefix_search"),
                           menuSubItem(text = "Language Search", tabName = "language_search")),
                  menuItem(text = "Zero Results",
                           menuSubItem(text = "Summary", tabName = "failure_rate"),
                           menuSubItem(text = "Search Type Breakdown", tabName = "failure_breakdown"),
                           menuSubItem(text = "Search Suggestions", tabName = "failure_suggestions")),
                  menuItem(text = "Sister Search",
                           menuSubItem(text = "Traffic", tabName = "sister_search_traffic")),
                  menuItem(text = "Page Visit Times", tabName = "survival"),
                  menuItem(text = "Language/Project Breakdown", tabName = "langproj_breakdown"),
                  menuItem(text = "Global Settings",
                           selectInput(inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
                                       choices = c("No Smoothing" = "day", "Weekly Median" = "week",
                                                   "Monthly Median" = "month", "Splines" = "gam")),
                           icon = icon("cog", lib = "glyphicon"))
      ),
      div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;"),
      div(bookmarkButton(), style = "text-align: center;")
    ),

    dashboardBody(
      tabItems(
        tabItem(tabName = "kpis_summary",
                htmlOutput("kpi_summary_date_range"),
                fluidRow(valueBoxOutput("kpi_summary_box_load_time", width = 3),
                         valueBoxOutput("kpi_summary_box_zero_results", width = 3),
                         valueBoxOutput("kpi_summary_box_api_usage", width = 3),
                         valueBoxOutput("kpi_summary_box_augmented_clickthroughs", width = 3)),
                fluidRow(
                  tags$style(HTML(".box {
                                  background-color:	transparent;
                                  border-style: none;
                                  box-shadow: 0 0 0 #ccc;
                                  }")),
                  box(sparkline:::sparklineOutput("sparkline_load_time"), width = 3),
                  box(sparkline:::sparklineOutput("sparkline_zero_results"), width = 3),
                  box(sparkline:::sparklineOutput("sparkline_api_usage"), width = 3),
                  box(sparkline:::sparklineOutput("sparkline_augmented_clickthroughs"), width = 3)
                  ),
                includeMarkdown("./tab_documentation/kpis_summary.md")),
        tabItem(tabName = "monthly_metrics",
                fluidRow(
                  column(fluidRow(
                    column(selectInput("monthy_metrics_month", "Month",
                                       choices = month.name, selectize = FALSE,
                                       selected = month.name[lubridate::month((Sys.Date() - 1) %m-% period(month = 1))]),
                           width = 6),
                    column(selectInput("monthy_metrics_year", "Year",
                                       choices = lubridate::year(seq(
                                         lubridate::floor_date(as.Date("2016-01-01"), "year"),
                                         (Sys.Date() - 1) %m-% period(month = 1),
                                         "year"
                                       )), selectize = FALSE,
                                       selected = lubridate::year((Sys.Date() - 1) %m-% period(month = 1))),
                           width = 6)
                  ),
                  checkboxInput("monthly_metrics_prev_month",
                                "Show previous month", TRUE),
                  checkboxInput("monthly_metrics_prev_year",
                                "Show previous year", TRUE),
                  width = 4),
                  column(DT::dataTableOutput("monthly_metrics_tbl"), width = 8)
                ),
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
                polloi::smooth_select("smoothing_desktop_event"),
                dygraphOutput("desktop_event_plot"),
                includeMarkdown("./tab_documentation/desktop_events.md")),
        tabItem(tabName = "desktop_load",
                polloi::smooth_select("smoothing_desktop_load"),
                dygraphOutput("desktop_load_plot"),
                includeMarkdown("./tab_documentation/desktop_load.md")),
        tabItem(tabName = "paulscore_approx",
                fluidRow(
                  column(polloi::smooth_select("smoothing_paulscore_approx"), width = 6),
                  column(checkboxInput("paulscore_relative", "Use relative PaulScores", FALSE),
                         helpText("Divides PaulScore by the maximum possible score for each F"), width = 6)
                ),
                dygraphOutput("paulscore_approx_plot_fulltext"),
                div(id = "paulscore_approx_legend", style = "text-align: center;"),
                dygraphOutput("paulscore_approx_plot_autocomplete"),
                includeHTML("./tab_documentation/paulscore_approx.html")),
        tabItem(tabName = "mobile_events",
                fluidRow(
                  valueBoxOutput("mobile_event_searches"),
                  valueBoxOutput("mobile_event_resultsets"),
                  valueBoxOutput("mobile_event_clickthroughs")),
                polloi::smooth_select("smoothing_mobile_event"),
                dygraphOutput("mobile_event_plot"),
                includeMarkdown("./tab_documentation/mobile_events.md")
        ),
        tabItem(tabName = "mobile_load",
                polloi::smooth_select("smoothing_mobile_load"),
                dygraphOutput("mobile_load_plot"),
                includeMarkdown("./tab_documentation/mobile_load.md")
        ),
        tabItem(tabName = "app_events",
                fluidRow(
                  valueBoxOutput("app_event_searches"),
                  valueBoxOutput("app_event_resultsets"),
                  valueBoxOutput("app_event_clickthroughs")),
                polloi::smooth_select("smoothing_app_event"),
                dygraphOutput("android_event_plot"),
                dygraphOutput("ios_event_plot"),
                includeMarkdown("./tab_documentation/app_events.md")
        ),
        tabItem(tabName = "app_load",
                polloi::smooth_select("smoothing_app_load"),
                dygraphOutput("android_load_plot"),
                dygraphOutput("ios_load_plot"),
                includeMarkdown("./tab_documentation/app_load.md")
        ),
        tabItem(tabName = "app_click_position",
                polloi::smooth_select("smoothing_app_click_position"),
                div(id = "app_click_position_legend", class = "large"),
                dygraphOutput("click_position_plot"),
                includeMarkdown("./tab_documentation/click_position.md")
        ),
        tabItem(tabName = "app_invoke_source",
                polloi::smooth_select("smoothing_app_invoke_source"),
                div(id = "app_invoke_source_legend"),
                dygraphOutput("invoke_source_plot"),
                includeMarkdown("./tab_documentation/invoke_source.md")
        ),
        tabItem(tabName = "fulltext_search",
                polloi::smooth_select("smoothing_fulltext_search"),
                dygraphOutput("cirrus_aggregate"),
                includeMarkdown("./tab_documentation/fulltext_basic.md")
        ),
        tabItem(tabName = "open_search",
                polloi::smooth_select("smoothing_open_search"),
                dygraphOutput("open_aggregate"),
                includeMarkdown("./tab_documentation/open_basic.md")
        ),
        tabItem(tabName = "geo_search",
                polloi::smooth_select("smoothing_geo_search"),
                dygraphOutput("geo_aggregate"),
                includeMarkdown("./tab_documentation/geo_basic.md")
        ),
        tabItem(tabName = "prefix_search",
                polloi::smooth_select("smoothing_prefix_search"),
                dygraphOutput("prefix_aggregate"),
                includeMarkdown("./tab_documentation/prefix_basic.md")
        ),
        tabItem(tabName = "language_search",
                polloi::smooth_select("smoothing_language_search"),
                dygraphOutput("language_aggregate"),
                includeMarkdown("./tab_documentation/language_basic.md")
        ),
        tabItem(tabName = "failure_rate",
                polloi::smooth_select("smoothing_failure_rate"),
                polloi::automata_select(input_id = "failure_rate_automata"),
                dygraphOutput("failure_rate_plot"),
                dygraphOutput("failure_rate_change_plot"),
                includeMarkdown("./tab_documentation/failure_rate.md")
        ),
        tabItem(tabName = "failure_breakdown",
                fluidRow(
                  column(
                    shiny::checkboxGroupInput("failure_breakdown_include", "Include", choices = list(
                      "Regex searches' ZRR" = "regex",
                      "Searches by automata (e.g. web crawlers)" = "automata"
                    ), selected = "automata", inline = TRUE),
                    width = 8
                  ),
                  column(polloi::smooth_select("smoothing_failure_breakdown"), width = 4)
                ),
                dygraphOutput("failure_breakdown_plot"),
                div(id = "failure_breakdown_plot_legend"),
                includeMarkdown("./tab_documentation/failure_breakdown.md")
        ),
        tabItem(tabName = "failure_suggestions",
                polloi::smooth_select("smoothing_failure_suggestions"),
                polloi::automata_select(input_id = "failure_suggestions_automata"),
                dygraphOutput("suggestion_dygraph_plot"),
                includeMarkdown("./tab_documentation/failure_suggests.md")
        ),
        tabItem(tabName = "sister_search_traffic",
                fluidRow(
                  column(polloi::smooth_select("smoothing_sister_search_traffic_plot"), width = 3),
                  column(shiny::radioButtons("sister_search_traffic_split", "Split pageviews by", choices = list("Project" = "project", "Search results pages vs Articles*" = "destination", "English vs other languages†" = "language", "Desktop vs Mobile Web" = "access_method"), inline = TRUE), width = 9)
                ),
                dygraphOutput("sister_search_traffic_plot"),
                div(id = "sister_search_traffic_plot_legend"),
                includeMarkdown("./tab_documentation/sister_search_traffic.md")),
        tabItem(tabName = "survival",
                polloi::smooth_select("smoothing_lethal_dose_plot"),
                div(id = "lethal_dose_plot_legend"),
                dygraphOutput("lethal_dose_plot"),
                includeMarkdown("./tab_documentation/survival.md")
        ),
        tabItem(tabName = "langproj_breakdown",
                fluidRow(column(polloi::smooth_select("smoothing_langproj_breakdown"), width = 4),
                         column(selectInput("langproj_metrics", "Metrics",
                                            choices = list(
                                              `Augmented Clickthrough` = c(`User engagement` = "User engagement", `Threshold-passing %` = "Threshold-passing %", `Clickthrough rate` = "Clickthrough rate"),
                                              `Desktop Events` = c(`Clickthroughs` = "clickthroughs", `Result pages opened` = "Result pages opened", `Search sessions` = "search sessions"),
                                              `Paulscore` = c(`F = 0.1` = "F = 0.1", `F = 0.5` = "F = 0.5", `F = 0.9` = "F = 0.9"),
                                              `Zero Results` = c(`Zero result rate` = "Zero result rate")
                                            ),
                                            selected = "User engagement", selectize = FALSE), width = 4),
                         column(conditionalPanel("input.langproj_metrics == 'Zero result rate'", polloi::automata_select(input_id = "failure_langproj_automata")), width = 4),
                         column(conditionalPanel("input.langproj_metrics == 'F = 0.1' || input.langproj_metrics == 'F = 0.5' || input.langproj_metrics == 'F = 0.9'",
                                                 checkboxInput("paulscore_relative_langproj", "Use Relative PaulScores", FALSE),
                                                 helpText("Divides PaulScore by the maximum possible score for each F")), width = 4)),
                fluidRow(column(selectInput("project_order", "Sort projects by",
                                            list("Alphabetical order" = "alphabet", "Volume of requests" = "volume"),
                                            selected = "volume"),
                                uiOutput("project_selector_container"), width = 2),
                         column(selectInput("language_order", "Sort languages by",
                                            list("Alphabetical order" = "alphabet", "Volume of requests" = "volume"),
                                            selected = "volume"),
                                uiOutput("language_selector_container"), width = 2),
                         column(dygraphOutput("langproj_breakdown_plot"),
                                div(id = "langproj_breakdown_legend", style = "margin-top:30px;"), width = 8)),
                includeMarkdown("./tab_documentation/langproj_breakdown.md")
        )
      )
    ),

    skin = "black", title = "Search Metrics Dashboard | Search Platform | Technology | Wikimedia Foundation")
}
