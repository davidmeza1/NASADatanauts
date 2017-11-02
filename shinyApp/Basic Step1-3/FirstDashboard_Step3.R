# Step 3
# Next, we can add content to the sidebar. For this example we’ll add menu items that behave like tabs. 
# These function similarly to Shiny’s tabPanels: when you click on one menu item, it shows a different set 
# of content in the main body.

# There are two parts that need to be done. First, you need to add menuItems to the sidebar, 
# with appropriate tabNames.

# In the body, add tabItems with corresponding values for tabName:

## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
     dashboardHeader(title = "Basic dashboard"),
     dashboardSidebar(sidebarMenu(
          menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
          menuItem("Widgets", tabName = "widgets", icon = icon("th"))
     )
    ),
    dashboardBody(
         tabItems(
              # First tab content
              tabItem(tabName = "dashboard",
                      fluidRow(
                           box(plotOutput("plot1", height = 250)),
                           
                           box(
                                title = "Controls",
                                sliderInput("slider", "Number of observations:", 1, 100, 50)
                           )
                      )
              ),
              
              # Second tab content
              tabItem(tabName = "widgets",
                      h2("Widgets tab content")
              )
         )
    )
)

server <- function(input, output) {
     set.seed(122)
     histdata <- rnorm(500)
     
     output$plot1 <- renderPlot({
          data <- histdata[seq_len(input$slider)]
          hist(data)
     })
}

shinyApp(ui, server)