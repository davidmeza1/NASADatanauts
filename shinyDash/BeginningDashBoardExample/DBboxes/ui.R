## Dashboard Boxes eamples
dbboxes.box <-  fluidPage(
     headerPanel("Dashboard Boxes"),
     sidebarPanel(
          sidebarSearchForm(textId = "searchText", buttonId = "searchButton", label = "Search..."),
          sliderInput(inputId = "siderbarSlider", label = "Slider:", min = 0, max = 100, value = 50),
          textInput(inputId = "sidebarText", label = "Text Input:"),
          dateInput(inputId = "sidebarDate", label = "Date:")
          
     ),
     mainPanel(
          tabsetPanel(type = "tabs",
                      tabPanel("Boxes", 
                               fluidRow(
                                    box(plotOutput("plot1")),
                                    
                                    box("Box content here", br(), "More box content",
                                        sliderInput("slider1", "Slider input:", 1, 100, 50),
                                        textInput("text", "Text input:")
                                    )
                               ),
                               fluidRow(
                                    column(width = 6,
                                           box(title = "Histogram", status = "primary", plotOutput("plot2", height = 250)),
                                           
                                           box(title = "Inputs", status = "warning",
                                               "Box content here", br(), "More box content",
                                               sliderInput("slider2", "Slider input:", 1, 100, 50),
                                               textInput("text", "Text input:")
                                           )
                                    ),
                                    column(width = 6,
                                           box(title = "Histogram", status = "primary", solidHeader = TRUE,
                                               collapsible = TRUE,
                                               plotOutput("plot3", height = 250)
                                           ),
                                           
                                           box(title = "Inputs", status = "warning", solidHeader = TRUE,
                                               "Box content here", br(), "More box content",
                                               sliderInput("slider3", "Slider input:", 1, 100, 50),
                                               textInput("text", "Text input:")
                                           )
                                    )
                               )
                      ),
                      tabPanel("tabBox",
                               fluidRow( 
                                    #If you want a box to have tabs for displaying different sets of content, you can use a tabBox
                                    tabBox(
                                         title = "First tabBox",
                                         # The id lets us use input$tabset1 on the server to find the current tab
                                         id = "tabset1", height = "250px",
                                         tabPanel("Tab1", "First tab content"),
                                         tabPanel("Tab2", "Tab content 2")
                                    ),
                                    tabBox(
                                         side = "right", height = "250px",
                                         selected = "Tab3",
                                         tabPanel("Tab1", "Tab content 1"),
                                         tabPanel("Tab2", "Tab content 2"),
                                         tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
                                    )
                               ),
                               fluidRow(
                                    tabBox(
                                         # Title can include an icon
                                         title = tagList(shiny::icon("gear"), "tabBox status"),
                                         tabPanel("Tab1",
                                                  "Currently selected tab from first box:",
                                                  verbatimTextOutput("tabset1Selected")
                                         ),
                                         tabPanel("Tab2", "Tab content 2")
                                    )
                               )
                               ),
                      tabPanel("infoBox",
                               # There is a special kind of box that is used for displaying simple numeric
                               # or text values, with an icon. Here are some examples:
                               fluidRow(
                                    # A static infoBox
                                    infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
                                    # Dynamic infoBoxes
                                    infoBoxOutput("progressBox"),
                                    infoBoxOutput("approvalBox")
                               ),
                               
                               # infoBoxes with fill=TRUE
                               fluidRow(
                                    infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                                    infoBoxOutput("progressBox2"),
                                    infoBoxOutput("approvalBox2")
                               ),
                               
                               fluidRow(
                                    # Clicking this will increment the progress amount
                                    box(width = 4, actionButton("count", "Increment progress"))
                               )
                               ),
                      tabPanel("valueBox",
                               # valueBoxes are similar to infoBoxes, but have a somewhat different appearance.
                               fluidRow(
                                    # A static valueBox
                                    valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
                                    
                                    # Dynamic valueBoxes
                                    valueBoxOutput("progressBox3"),
                                    
                                    valueBoxOutput("approvalBox3")
                               ),
                               fluidRow(
                                    # Clicking this will increment the progress amount
                                    box(width = 4, actionButton("count2", "Increment progress"))
                               ))
                      
          )
     )
     
     
)