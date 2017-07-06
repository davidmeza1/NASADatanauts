#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shiny)
library("httr")
library("XML")
library("stringr")
library("ggplot2")
library("png")
library("grid")
library("dplyr")
library("ggrepel")
library(jpeg)
library(stringr)
library(gridExtra)



dbHeader <- dashboardHeader(title = "Remo", titleWidth = 200, disable = FALSE)

# dbHeader$children[[2]]$children <-  tags$a(href='https://www.nasa.gov/',
#                                            tags$img(src="logo-nasa-1959.jpg",height=42, align = "center"))

# dbHeader$children[[3]]$children <-  tags$a(href='mailto:cody.w.bryant@nasa.gov?subject=Remo API Application Feedback',
#                                            tags$img(src="mail.png", height=28, style="float:right; margin: 11px 11px;"))


dashboardPage(skin = "blue",
  dbHeader,
  
  dashboardSidebar(width = 200,
    sidebarMenu(
    # Customer background image for primary window
    tags$head(tags$style(type="text/css", ".content-wrapper, .right-side, .main-footer {
    background-image: url(bg.jpg); background-color: #d3d3d3; background-size: cover;
    background-repeat: no-repeat;
    }")),
    
    tags$head(tags$style(type="text/css", HTML('#smoke .box.box-solid.box-primary {background-color:rgba(34,45,50,0.8) !important;}
                                                  #smoke .selectize-control.multi .selectize-input > div {background-color: #00a65a ;}
                                                  #smoke .selectize-control.multi .selectize-input > div.active {background-color: #008d4c !important ;}
                                                  #smoke .selectize-control.multi .selectize-input > div {color: #ffffff !important;}
                                                  #smoke .selectize-control.multi .selectize-input {border-color: #00a65a !important;}
                                                  #smoke .selectize-control.multi .selectize-input {background-color: rgba(34,45,50,0.8) !important;}
                                                  #smoke .selectize-input.focus {box-shadow:  inset 0 1px 1px rgba(244,244,244,0) !important;}
                                                  '))),
    
    menuItem("Home", tabName = "wrn", icon = icon("home")),
    menuItem("About", tabName = "abt", icon = icon("user"))
    
                   )),
  dashboardBody(
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: Tahoma, Geneva, sans-serif;
        font-weight: bold;
        font-size: 32px;
      }
    '))),
    fluidRow(
    tabItem(
      tabName = "wrn",
      tags$div(id="smoke",
               box(title = "Emotion API", status = "primary", solidHeader = TRUE, collapsible = T, collapsed = F, width=12,
                   textInput("url_input", label = HTML('<font color = "white"><h4>Input URL (jpg or png):</h4></font>'), value = HTML('http://www.speakers.ca/wp-content/uploads/2013/06/Chris_Hadfield-2013-760x427.jpg')),
                   actionButton("submit_url", "Submit")
                )
      )
    
    )),
    
    uiOutput("ui")
 

)
)