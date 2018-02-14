#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
    leafletOutput("R4DSmap", width = "100%", height = 600)
    #DT::dataTableOutput("building_info")
      )
   


# Define server logic required to draw a histogram
server <- function(input, output) {
   library(leaflet)
   library(glue)
   library(dplyr)
    
    r4ds_map <- leaflet() %>%
        addTiles() %>%
        addCircleMarkers(data = r4ds_users, lng = ~ lon, lat = ~ lat, group = "Members", color = "blue",
                         popup = glue('My R Comnfort is {r4ds_users$R_Comfort} ,', ' My Analysis Comfort is {r4ds_users$Analysis_Comfort}')) %>%
        addCircleMarkers(data = filter(r4ds_users, Type == "Mentor"), lng = ~ lon, lat = ~ lat, group = "Mentor", color = "green",
                         popup = glue('My R Comnfort is {r4ds_users$R_Comfort} ,', ' My Analysis Comfort is {r4ds_users$Analysis_Comfort}')) %>% 
        addCircleMarkers(data = filter(r4ds_users, Type == "Learner"), lng = ~ lon, lat = ~ lat, group = "Learner", color = "orange", 
                         popup = glue('My R Comnfort is {r4ds_users$R_Comfort} ,', ' My Analysis Comfort is {r4ds_users$Analysis_Comfort}')) %>% 
        hideGroup("Mentor") %>% 
        hideGroup("Learner") %>% 
        addLayersControl(baseGroups = "Members", overlayGroups = c("Members", "Mentor", "Learner"),
                         options = layersControlOptions(collapsed = FALSE))
    
    output$R4DSmap <- renderLeaflet(r4ds_map)
    
    
   }


# Run the application 
shinyApp(ui = ui, server = server)

