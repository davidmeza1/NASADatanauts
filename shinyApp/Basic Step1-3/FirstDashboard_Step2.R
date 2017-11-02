# Step 2
# Obviously, this dashboard isn’t very useful. We’ll need to add components that actually do something. 
# In the body we can add boxes that have content.

## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
     dashboardHeader(title = "Basic dashboard"),
     dashboardSidebar(),
     dashboardBody(
          # Boxes need to be put in a row (or column)
          fluidRow(
               box(plotOutput("plot1", height = 250)),
               
               box(
                    title = "Controls",
                    sliderInput("slider", "Number of observations:", 1, 100, 50)
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