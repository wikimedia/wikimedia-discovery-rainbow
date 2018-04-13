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

    dashboardHeader(title = "Search Platform", dropdownMenuOutput("message_menu"), disable = FALSE),

    dashboardSidebar(
      tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
        tags$script(src = "custom.js"),
        tags$script(src = "js4checkbox.js"),
        with_wikimedia_mathjax()
      ),
      sidebarMenu(
        id = "tabs",
        menuItem(
          text = "Metrics",
          div(selectInput(
            "kpi_summary_date_range_selector",
            label = "Date Range", multiple = FALSE, selected = "monthly",
            choices = list(
              "Yesterday" = "daily", "Last 7 days" = "weekly",
              "Last 30 days" = "monthly", "Last 90 days" = "quarterly",
              "All available data" = "all"
            )
          ),
          style = "margin-bottom:-10px;"
          ),
          menuSubItem(text = "Summary", tabName = "summary"),
          menuSubItem(text = "Monthly Metrics", tabName = "monthly_metrics"),
          menuSubItem(text = "User Engagement", tabName = "kpi_augmented_clickthroughs"),
          menuSubItem(text = "Load times", tabName = "kpi_load_time"),
          icon = icon("star", lib = "glyphicon")
        ),
        menuItem(
          text = "Desktop",
          menuSubItem(text = "Events", tabName = "desktop_events"),
          menuSubItem(text = "Load times", tabName = "desktop_load"),
          menuSubItem(text = "PaulScore", tabName = "paulscore_approx")
        ),
        menuItem(
          text = "Mobile Web",
          menuSubItem(text = "Events", tabName = "mobile_events"),
          menuSubItem(text = "Load times", tabName = "mobile_load")
        ),
        menuItem(
          text = "Mobile Apps",
          menuSubItem(text = "Events", tabName = "app_events"),
          menuSubItem(text = "Load times", tabName = "app_load"),
          menuSubItem(text = "Click Position", tabName = "app_click_position"),
          menuSubItem(text = "Invoke Source", tabName = "app_invoke_source")
        ),
        menuItem(
          text = "API Usage",
          menuSubItem(text = "Summary", tabName = "api_usage"),
          menuSubItem(text = "Full-text via API", tabName = "fulltext_search"),
          menuSubItem(text = "Morelike Search", tabName = "morelike_search"),
          menuSubItem(text = "Open Search", tabName = "open_search"),
          menuSubItem(text = "Geo Search", tabName = "geo_search"),
          menuSubItem(text = "Prefix Search", tabName = "prefix_search"),
          menuSubItem(text = "Language Search", tabName = "language_search"),
          menuSubItem(text = "Referrer Breakdown", tabName = "referer_breakdown")
        ),
        menuItem(
          text = "Zero Results",
          menuSubItem(text = "Summary", tabName = "failure_rate"),
          menuSubItem(text = "Search Type Breakdown", tabName = "failure_breakdown"),
          menuSubItem(text = "Search Suggestions", tabName = "failure_suggestions")
        ),
        menuItem(
          text = "Sister Search",
          menuSubItem(text = "Traffic", tabName = "sister_search_traffic"),
          menuSubItem(text = "Prevalence", tabName = "sister_search_prevalence")
        ),
        menuItem(
          text = "Page Visit Times",
          menuSubItem(text = "Search result pages", tabName = "spr_surv"),
          menuSubItem(text = "Visited search results", tabName = "survival")
        ),
        menuItem(text = "Language/Project Breakdown", tabName = "langproj_breakdown"),
        menuItem(
          text = "Global Settings",
          selectInput(
            inputId = "smoothing_global", label = "Smoothing", selectize = TRUE, selected = "day",
            choices = c(
              "No Smoothing" = "day", "Weekly Median" = "week",
              "Monthly Median" = "month", "Splines" = "gam"
            )
          ),
          icon = icon("cog", lib = "glyphicon")
        )
      ),
      div(icon("info-sign", lib = "glyphicon"), HTML("<strong>Tip</strong>: you can drag on the graphs with your mouse to zoom in on a particular date range."), style = "padding: 10px; color: white;"),
      div(bookmarkButton(), style = "text-align: center;")
    ),

    dashboardBody(
      tabItems(
        tabItem(
          tabName = "summary",
          htmlOutput("kpi_summary_date_range"),
          fluidRow(
            valueBoxOutput("kpi_summary_box_augmented_clickthroughs", width = 6),
            valueBoxOutput("kpi_summary_box_load_time", width = 6)
          ),
          fluidRow(
            tags$style(HTML(".box { background-color:	transparent; border-style: none; box-shadow: 0 0 0 #ccc; }")),
            box(sparkline:::sparklineOutput("sparkline_augmented_clickthroughs"), width = 6),
            box(sparkline:::sparklineOutput("sparkline_load_time"), width = 6)
          ),
          includeMarkdown("./tab_documentation/summary.md")
        ),

        tabItem(
          tabName = "monthly_metrics",
          fluidRow(
            column(fluidRow(
              column(
                selectInput(
                  "monthy_metrics_month", "Month",
                  choices = month.name,
                  selected = month.name[lubridate::month((Sys.Date() - 1) %m-% period(month = 1))],
                  selectize = FALSE
                ),
                width = 6
              ),
              column(
                selectInput(
                  "monthy_metrics_year", "Year",
                  choices = lubridate::year(seq(lubridate::floor_date(as.Date("2016-01-01"), "year"), (Sys.Date() - 1) %m-% period(month = 1), "year")),
                  selected = lubridate::year((Sys.Date() - 1) %m-% period(month = 1)),
                  selectize = FALSE
                ),
                width = 6
              )
            ),
            checkboxInput("monthly_metrics_prev_month", "Show previous month", TRUE),
            checkboxInput("monthly_metrics_prev_year", "Show previous year", TRUE),
            width = 4),
            column(DT::dataTableOutput("monthly_metrics_tbl"), width = 8)
          ),
          includeMarkdown("./tab_documentation/monthly_metrics.md")
        ),

        tabItem(
          tabName = "kpi_load_time",
          fluidRow(
            column(polloi::smooth_select("smoothing_kpi_load_time"), width = 4),
            column(div(id = "kpi_load_time_series_legend"), width = 8)
          ),
          dygraphOutput("kpi_load_time_series"),
          includeMarkdown("./tab_documentation/kpi_load_time.md")
        ),

        tabItem(
          tabName = "kpi_augmented_clickthroughs",
          fluidRow(
            column(polloi::smooth_select("smoothing_augmented_clickthroughs"), width = 4),
            column(div(id = "kpi_augmented_clickthroughs_series_legend"), width = 8)),
          dygraphOutput("kpi_augmented_clickthroughs_series"),
          includeMarkdown("./tab_documentation/kpi_augmented_clickthroughs.md")
        ),

        tabItem(
          tabName = "desktop_events",
          fluidRow(
            valueBoxOutput("desktop_event_searches"),
            valueBoxOutput("desktop_event_resultsets"),
            valueBoxOutput("desktop_event_clickthroughs")),
          polloi::smooth_select("smoothing_desktop_event"),
          dygraphOutput("desktop_event_plot"),
          includeMarkdown("./tab_documentation/desktop_events.md")
        ),

        tabItem(
          tabName = "desktop_load",
          polloi::smooth_select("smoothing_desktop_load"),
          dygraphOutput("desktop_load_plot"),
          includeMarkdown("./tab_documentation/desktop_load.md")
        ),

        tabItem(
          tabName = "paulscore_approx",
          fluidRow(
            column(polloi::smooth_select("smoothing_paulscore_approx"), width = 6),
            column(checkboxInput("paulscore_relative", "Use relative PaulScores", FALSE),
                   helpText("Divides PaulScore by the maximum possible score for each F"), width = 6)
          ),
          dygraphOutput("paulscore_approx_plot_fulltext"),
          div(id = "paulscore_approx_legend", style = "text-align: center;"),
          dygraphOutput("paulscore_approx_plot_autocomplete"),
          includeHTML("./tab_documentation/paulscore_approx.html")
        ),

        tabItem(
          tabName = "mobile_events",
          fluidRow(
            valueBoxOutput("mobile_event_user_session", width = 3),
            valueBoxOutput("mobile_event_searches", width = 3),
            valueBoxOutput("mobile_event_resultsets", width = 3),
            valueBoxOutput("mobile_event_clickthroughs", width = 3)
          ),
          polloi::smooth_select("smoothing_mobile_event"),
          dygraphOutput("mobile_event_plot"),
          dygraphOutput("mobile_session_plot"),
          includeMarkdown("./tab_documentation/mobile_events.md")
        ),

        tabItem(
          tabName = "mobile_load",
          polloi::smooth_select("smoothing_mobile_load"),
          dygraphOutput("mobile_load_plot"),
          includeMarkdown("./tab_documentation/mobile_load.md")
        ),

        tabItem(
          tabName = "app_events",
          fluidRow(
            valueBoxOutput("app_event_searches"),
            valueBoxOutput("app_event_resultsets"),
            valueBoxOutput("app_event_clickthroughs")
          ),
          polloi::smooth_select("smoothing_app_event"),
          dygraphOutput("android_event_plot"),
          dygraphOutput("ios_event_plot"),
          includeMarkdown("./tab_documentation/app_events.md")
        ),

        tabItem(
          tabName = "app_load",
          polloi::smooth_select("smoothing_app_load"),
          dygraphOutput("android_load_plot"),
          dygraphOutput("ios_load_plot"),
          includeMarkdown("./tab_documentation/app_load.md")
        ),

        tabItem(
          tabName = "app_click_position",
          polloi::smooth_select("smoothing_app_click_position"),
          div(id = "app_click_position_legend", class = "large"),
          dygraphOutput("click_position_plot"),
          includeMarkdown("./tab_documentation/click_position.md")
        ),

        tabItem(
          tabName = "app_invoke_source",
          polloi::smooth_select("smoothing_app_invoke_source"),
          div(id = "app_invoke_source_legend"),
          dygraphOutput("invoke_source_plot"),
          includeMarkdown("./tab_documentation/invoke_source.md")
        ),

        tabItem(
          tabName = "api_usage",
          fluidRow(
            column(
              radioButtons(
                "api_usage_series_data",
                label = "Type of data to display", inline = TRUE,
                choices = list("Calls" = "raw", "Day-to-day % change" = "change")
              ),
              width = 4),
            column(
              conditionalPanel(
                "input.api_usage_series_data == 'raw'",
                checkboxInput("api_usage_series_log_scale", label = "Log10 Scale", value = FALSE)
              ),
              width = 2),
            column(
              conditionalPanel(
                "input.api_usage_series_data == 'raw'",
                checkboxInput("api_usage_series_prop", label = "Use Proportion", value = FALSE)
              ),
              width = 2),
            column(polloi::smooth_select("smoothing_api_usage"), width = 4)
          ),
          div(id = "api_usage_series_legend", style = "text-align: right;"),
          dygraphOutput("api_usage"),
          includeMarkdown("./tab_documentation/api_usage.md")
        ),

        tabItem(
          tabName = "fulltext_search",
          fluidRow(
            column(checkboxInput("fulltext_search_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("fulltext_search_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_fulltext_search"), width = 8)
          ),
          div(id = "cirrus_aggregate_legend", style = "text-align: right;"),
          dygraphOutput("cirrus_aggregate"),
          includeMarkdown("./tab_documentation/fulltext_basic.md")
        ),

        tabItem(
          tabName = "morelike_search",
          fluidRow(
            column(checkboxInput("morelike_search_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("morelike_search_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_morelike_search"), width = 8)
          ),
          div(id = "morelike_aggregate_legend", style = "text-align: right;"),
          dygraphOutput("morelike_aggregate"),
          includeMarkdown("./tab_documentation/morelike_basic.md")
        ),

        tabItem(
          tabName = "open_search",
          fluidRow(
            column(checkboxInput("open_search_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("open_search_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_open_search"), width = 8)
          ),
          div(id = "open_aggregate_legend", style = "text-align: right;"),
          dygraphOutput("open_aggregate"),
          includeMarkdown("./tab_documentation/open_basic.md")
        ),

        tabItem(
          tabName = "geo_search",
          fluidRow(
            column(checkboxInput("geo_search_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("geo_search_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_geo_search"), width = 8)
          ),
          div(id = "geo_aggregate_legend", style = "text-align: right;"),
          dygraphOutput("geo_aggregate"),
          includeMarkdown("./tab_documentation/geo_basic.md")
        ),

        tabItem(
          tabName = "prefix_search",
          fluidRow(
            column(checkboxInput("prefix_search_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("prefix_search_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_prefix_search"), width = 8)),
          div(id = "prefix_aggregate_legend", style = "text-align: right;"),
          dygraphOutput("prefix_aggregate"),
          includeMarkdown("./tab_documentation/prefix_basic.md")
        ),

        tabItem(
          tabName = "language_search",
          fluidRow(
            column(checkboxInput("language_search_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("language_search_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_language_search"), width = 8)
          ),
          div(id = "language_aggregate_legend", style = "text-align: right;"),
          dygraphOutput("language_aggregate"),
          includeMarkdown("./tab_documentation/language_basic.md")
        ),

        tabItem(
          tabName = "referer_breakdown",
          fluidRow(
            column(checkboxInput("referer_breakdown_log_scale", label = "Log10 Scale", value = FALSE), width = 2),
            column(checkboxInput("referer_breakdown_prop", label = "Use Proportion", value = FALSE), width = 2),
            column(polloi::smooth_select("smoothing_referer_breakdown"), width = 8)
          ),
          div(id = "referer_breakdown_plot_legend", style = "text-align: right;"),
          dygraphOutput("referer_breakdown_plot"),
          includeMarkdown("./tab_documentation/referer_breakdown.md")
        ),

        tabItem(
          tabName = "failure_rate",
          polloi::smooth_select("smoothing_failure_rate"),
          polloi::automata_select(input_id = "failure_rate_automata"),
          dygraphOutput("failure_rate_plot"),
          dygraphOutput("failure_rate_change_plot"),
          includeMarkdown("./tab_documentation/failure_rate.md")
        ),

        tabItem(
          tabName = "failure_breakdown",
          fluidRow(
            column(
              shiny::checkboxGroupInput(
                "failure_breakdown_include", "Include",
                choices = list(
                  "Regex searches' ZRR" = "regex",
                  "Searches by automata (e.g. web crawlers)" = "automata"
                ),
                selected = "automata", inline = TRUE
              ),
              width = 8
            ),
            column(polloi::smooth_select("smoothing_failure_breakdown"), width = 4)
          ),
          dygraphOutput("failure_breakdown_plot"),
          div(id = "failure_breakdown_plot_legend"),
          includeMarkdown("./tab_documentation/failure_breakdown.md")
        ),

        tabItem(
          tabName = "failure_suggestions",
          polloi::smooth_select("smoothing_failure_suggestions"),
          polloi::automata_select(input_id = "failure_suggestions_automata"),
          dygraphOutput("suggestion_dygraph_plot"),
          includeMarkdown("./tab_documentation/failure_suggests.md")
        ),

        tabItem(
          tabName = "sister_search_traffic",
          fluidRow(
            column(polloi::smooth_select("smoothing_sister_search_traffic_plot"), width = 3),
            column(
              shiny::checkboxGroupInput(
                "sister_search_traffic_split", "Split pageviews by",
                choices = list(
                  "Project" = "project",
                  "More Results vs Articles*" = "destination",
                  "English vs other languages†" = "language",
                  "Desktop vs Mobile Web" = "access_method"
                ),
                selected = "none", inline = TRUE
              ),
              helpText("Select up to 2"),
              width = 9
            )
          ),
          dygraphOutput("sister_search_traffic_plot"),
          div(id = "sister_search_traffic_plot_legend"),
          includeMarkdown("./tab_documentation/sister_search_traffic.md")
        ),

        tabItem(
          tabName = "sister_search_prevalence",
          fluidRow(
            column(
              selectInput(
                "sister_search_prevalence_lang_order",
                "Sort languages by", selected = "high2low",
                choices = list("Alphabetical order" = "alphabet", "Prevalence (high to low)" = "high2low", "Prevalence (low to high)" = "low2high"),
              ),
              width = 3
            ),
            column(polloi::smooth_select("smoothing_sister_search_prevalence_plot"), width = 9)
          ),
          fluidRow(
            column(
              uiOutput("sister_search_prevalence_lang_container"),
              helpText("The % beside each language name is the average prevalence."),
              width = 3
            ),
            column(
              dygraphOutput("sister_search_prevalence_plot"),
              div(id = "sister_search_prevalence_plot_legend", style = "text-align: right;"),
              width = 9
            )
          ),
          includeMarkdown("./tab_documentation/sister_search_prevalence.md")
        ),

        tabItem(
          tabName = "survival",
          fluidRow(
            column(
              polloi::smooth_select("smoothing_lethal_dose_plot"),
              width = 3
            ),
            column(
              numericInput("rolling_lethal_dose_plot", "Rolling Average*", 14, min = 1, max = 30),
              helpText("* Each point will become an average of this many days."),
              width = 3
            ),
            column(
              checkboxGroupInput(
                "filter_lethal_dose_plot", "Time until",
                choices = c(
                  "10% of users left SRP" = "10%",
                  "25% of users left SRP" = "25%",
                  "50% of users left SRP" = "50%",
                  "75% of users left SRP" = "75%",
                  "90% of users left SRP" = "90%",
                  "95% of users left SRP" = "95%",
                  "99% of users left SRP" = "99%"
                ),
                selected = c("25%", "50%", "75%"), inline = TRUE
              ),
              width = 6
            )
          ),
          div(id = "lethal_dose_plot_legend", style = "text-align: right;"),
          dygraphOutput("lethal_dose_plot"),
          includeMarkdown("./tab_documentation/survival.md")
        ),

        tabItem(
          tabName = "spr_surv",
          fluidRow(
            column(
              fluidRow(
                column(polloi::smooth_select("smoothing_srp_ld_plot"), width = 7),
                column(numericInput("rolling_srp_ld_plot", "Rolling Average*", 1, min = 1, max = 30), width = 5)
              ),
              helpText("* Each point will become an average of this many days."),
              width = 3
            ),
            column(
              checkboxGroupInput(
                "language_srp_ld_plot", "Language",
                choices = c("English", "French and Catalan", "Other languages"),
                selected = c("Other languages"), inline = TRUE
              ),
              width = 4
            ),
            column(
              checkboxGroupInput(
                "filter_srp_ld_plot", "Time until",
                choices = c(
                  "10% of users left SRP" = "10%",
                  "25% of users left SRP" = "25%",
                  "50% of users left SRP" = "50%",
                  "75% of users left SRP" = "75%",
                  "90% of users left SRP" = "90%",
                  "95% of users left SRP" = "95%"
                ),
                selected = c("50%", "75%", "90%"), inline = TRUE),
              width = 5
            )
          ),
          div(id = "srp_ld_plot_legend", style = "text-align: right;"),
          dygraphOutput("srp_ld_plot"),
          includeMarkdown("./tab_documentation/srp_surv.md")
        ),

        tabItem(
          tabName = "langproj_breakdown",
          fluidRow(
            column(polloi::smooth_select("smoothing_langproj_breakdown"), width = 4),
            column(selectInput(
              "langproj_metrics", "Metrics",
              choices = list(
                `Augmented Clickthrough` = c(`User engagement` = "User engagement", `Threshold-passing %` = "Threshold-passing %", `Clickthrough rate` = "Clickthrough rate"),
                `Desktop Events` = c(`Clickthroughs` = "clickthroughs", `Result pages opened` = "Result pages opened", `Search sessions` = "search sessions"),
                `Paulscore` = c(`F = 0.1` = "F = 0.1", `F = 0.5` = "F = 0.5", `F = 0.9` = "F = 0.9"),
                `Zero Results` = c(`Zero result rate` = "Zero result rate")
              ),
              selected = "User engagement", selectize = FALSE), width = 4),
            column(conditionalPanel("input.langproj_metrics == 'Zero result rate'", polloi::automata_select(input_id = "failure_langproj_automata")), width = 4),
            column(conditionalPanel(
              "input.langproj_metrics == 'F = 0.1' || input.langproj_metrics == 'F = 0.5' || input.langproj_metrics == 'F = 0.9'",
              checkboxInput("paulscore_relative_langproj", "Use Relative PaulScores", FALSE),
              helpText("Divides PaulScore by the maximum possible score for each F")),
              width = 4
            )
          ),
          fluidRow(
            column(
              selectInput(
                "project_order", "Sort projects by",
                list("Alphabetical order" = "alphabet", "Volume of requests" = "volume"),
                selected = "volume"),
              uiOutput("project_selector_container"),
              width = 2
            ),
            column(
              selectInput(
                "language_order", "Sort languages by",
                list("Alphabetical order" = "alphabet", "Volume of requests" = "volume"),
                selected = "volume"),
              uiOutput("language_selector_container"),
              width = 2
            ),
            column(
              dygraphOutput("langproj_breakdown_plot"),
              div(id = "langproj_breakdown_legend", style = "margin-top:30px;"),
              width = 8
            )
          ),
          includeMarkdown("./tab_documentation/langproj_breakdown.md")
        )
      )
    ),

    skin = "black", title = "Search Platform Metrics | Technology | Wikimedia Foundation")
}
