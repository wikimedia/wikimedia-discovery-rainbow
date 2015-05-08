#Sidebar elements for the search visualisations.
#Should be exclusively used source()d from ../ui.R
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(text = "Desktop",
             menuSubItem("Load times")),
    menuItem(text = "Mobile Web",
             menuSubItem("Load times")),
    menuItem(text = "Mobile Apps",
             menuSubItem("Load times"))
  )
)