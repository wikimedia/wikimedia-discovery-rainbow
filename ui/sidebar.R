#Sidebar elements for the search visualisations.
#Should be exclusively used source()d from ../ui.R
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Desktop",
             menuSubItem(text = "Events", tabName = "desktop_events"),
             menuSubItem(text = "Load times", tabName = "desktop_load")),
    menuItem(text = "Mobile Web",
             menuSubItem(text = "Events", tabName = "mobile_events"),
             menuSubItem(text = "Load times", tabName = "mobile_load")),
    menuItem(text = "Mobile Apps",
             menuSubItem(text = "Load times", tabName = "app_load")
             )
  )
)