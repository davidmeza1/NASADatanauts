sidebar <- dashboardSidebar(sidebarMenu(
     menuItem("Introduction", tabName = "intro", icon = icon("info"), badgeLabel = "new", badgeColor = "green"),
     menuItem("Boxes Examples", tabName = "dbboxes", icon = icon("gears")),
     menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
     menuItem("Maps", tabName = "maps", icon = icon("map")),
     menuItem("Topic Modeling", tabName = "lda", icon = icon("language")),
     menuItem("Acknowledegements", tabName = "ack", icon = icon("group"))
     )
)
