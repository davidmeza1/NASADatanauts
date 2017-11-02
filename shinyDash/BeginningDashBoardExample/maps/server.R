## COD map server code
JSC <- "Johnson Space Center"
JSCcoords <- geocode("Johnson Space Center")
JSCRealProperty <- readRDS("data/JSCRealProperty.rds")
JSCBuildings <- filter(JSCRealProperty, !is.na(latitude))
## Dummy Data to represent power usage
over <- JSCBuildings[1:66, ]
avearage <- JSCBuildings[67:132, ]
low <- JSCBuildings[133:197, ]
##-------------------------------

JSCmap <- leaflet() %>% 
     addTiles() %>% 
     setView(JSCcoords[1], JSCcoords[2], zoom = 15) %>%  
     addCircleMarkers(data = JSCBuildings, lng = ~ longitude, lat = ~ latitude, radius = (JSCBuildings$BookValue)/1000000, layerId = NULL, 
                      group = "JSC Buildings", stroke = TRUE, color = "blue", weight = 5, opacity = 0.5, 
                      fill = TRUE, fillColor = "blue", fillOpacity = 0.2, dashArray = NULL, 
                      popup = paste(JSCBuildings$PropertyName, JSCBuildings$PriorYrOperating),
                      options = pathOptions(), clusterOptions = NULL, clusterId = NULL)%>%
     addCircleMarkers(data = over, lng = ~ longitude, lat = ~ latitude, group = "High Power", color = "red") %>% 
     addCircleMarkers(data = avearage, lng = ~ longitude, lat = ~ latitude, group = "Avg. Power", color = "yellow") %>%
     addCircleMarkers(data = low, lng = ~ longitude, lat = ~ latitude, group = "Low Power", color = "green") %>% 
     hideGroup("High Power") %>% 
     hideGroup("Avg. Power") %>% 
     hideGroup("Low Power") %>% 
     addLayersControl(baseGroups = "JSC Buildings", overlayGroups = c("High Power", "Avg. Power", "Low Power"),
                      options = layersControlOptions(collapsed = FALSE))

output$CODmap <- renderLeaflet(JSCmap)

observeEvent(input$CODmap_marker_click, {
     p <- input$CODMap_marker_click
     
     # if(!is.null(p$id)){
     #      if(is.null(input$location)) updateSelectInput(session, "location", selected=p$id)
     #      if(!is.null(input$location) && input$location!=p$id) updateSelectInput(session, "location", selected=p$id)
     # }
})

output$building_info <- renderDataTable(over)
