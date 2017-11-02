maps.box <- fluidPage(
     
     leafletOutput("CODmap", width = "100%", height = 600),
     DT::dataTableOutput("building_info")
     
)