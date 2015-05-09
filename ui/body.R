#Body elements for the search visualisations.
#Should be exclusively used source()d from ../ui.R
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
    tabItem(tabName = "mobile_load"),
    tabItem(tabName = "app_load")
  )
)