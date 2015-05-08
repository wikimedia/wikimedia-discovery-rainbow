#Body elements for the search visualisations.
#Should be exclusively used source()d from ../ui.R
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "desktop_events", dygraphOutput("desktop_event_plot")),
    tabItem(tabName = "desktop_load"),
    tabItem(tabName = "mobile_load"),
    tabItem(tabName = "app_load")
  )
)