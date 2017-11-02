sidebar <- dashboardSidebar(sidebarMenu(
     menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
     menuItem("Widgets", tabName = "widgets", icon = icon("th")),
     sidebarSearchForm(textId = "searchText", buttonId = "searchButton", label = "Search..."),
     sliderInput(inputId = "siderbarSlider", label = "Slider:", min = 0, max = 100, value = 50),
     textInput(inputId = "sidebarText", label = "Text Input:"),
     dateInput(inputId = "sidebarDate", label = "Date:")
     )
)
