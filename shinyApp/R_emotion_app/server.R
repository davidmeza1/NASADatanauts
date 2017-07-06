#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.


library(shiny)
library(shinydashboard)
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

# Consider getting your own key. You can use mine for testing but please
# don't programtically max out my microsoft API calls
# https://www.microsoft.com/cognitive-services/en-us/face-api
# https://www.microsoft.com/cognitive-services/en-us/emotion-api
emo_api_key <<- '7db2433dd74a466b81eeda33f06f05f3'
face_api_key <<- 'e4f20735078844f0a9a76a5d39445ab8'


# Remo fetch img to memory
remo_f2mem <- function(img_url) {
  
  if (str_extract(tolower(img_url), "\\.[a-z]*\\z")==".jpg") {
    download.file(img_url, destfile = "img.jpg", mode = 'wb')
    img <- readJPEG(paste(getwd(), '\\img.jpg', sep=""))
    return(img)
  } else if  (str_extract(tolower(img_url), "\\.[a-z]*\\z")==".png") {
    download.file(img_url, destfile = "img.png", mode = 'wb')
    img <- readPNG(paste(getwd(), '\\img.png', sep=""))
    return(img)
  } else {
    warning("URL doesn't end in supported format (.jpg or .png) thus wasn't recognized as an image")  
  }
}


# Remo Fetch Emotion Function
remo_femo <- function(url, emo_api_key) {
  
  # Access key is available via: https://www.microsoft.com/cognitive-services/en-us/emotion-api
  # Define Microsoft API URL to request data
  emo_api = 'https://api.projectoxford.ai/emotion/v1.0/recognize'
  
  # Define image
  mybody = list(url = url)
  
  # Request data from Microsoft
  # (if Status=200, request is okay)
  face_emo_js = POST(
    url = emo_api,
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = emo_api_key)),
    body = mybody,
    encode = 'json'
  )
  
  if (face_emo_js$status_code != 200) {
    warning("Bad status code (",face_emo_js$status_code,") returned from Microsoft API. Check your URL.")
    warning("Error Code: ", httr::content(face_emo_js)$error$code)
    warning("Error Msg: ", httr::content(face_emo_js)$error$message)
  }
  
  all_emos = NULL
  for (i in 1:length(httr::content(face_emo_js))) {
    # Request results from face analysis
    result_df_s = httr::content(face_emo_js)[[i]]
    
    # Define results in data frame
    result_df <- as.data.frame(as.matrix(result_df_s$scores))
    
    # Make some transformation
    # o$V1 <- lapply(strsplit(as.character(o$V1 ), "e"), "[", 1)
    result_df$V1 <- as.numeric(result_df$V1)
    colnames(result_df)[1] <- "Level"
    
    # Define names
    result_df$Emotion<- rownames(result_df)
    
    result_df$faceid <- i
    all_emos <- rbind(all_emos, result_df)
    
  }
  
  return(all_emos)
}


# Remo Fetch Face Data
remo_fface <- function(url, face_api_key) {
  # Define Microsoft API URL to request data
  face_api = "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=true&returnFaceAttributes=age"
  
  # Define access key (access key is available via: https://www.microsoft.com/cognitive-services/en-us/face-api)
  
  
  # Define image
  mybody = list(url = url)
  
  # Request data from Microsoft
  # (if Status=200, request is okay)
  face_js = POST(
    url = face_api, 
    content_type('application/json'), add_headers(.headers = c('Ocp-Apim-Subscription-Key' = face_api_key)),
    body = mybody,
    encode = 'json'
  )
  
  all_faces <- NULL
  all_boxes <- data.frame(c(NA, NA, NA, NA))
  row.names(all_boxes) <- c("top", "left", "width", "height")
  
  for (i in seq(1:length(httr::content(face_js)))) {
    
    
    # Request results from face analysis
    hadR = httr::content(face_js)[[i]]
    
    # Define results in data frame
    face_data_df <- as.data.frame(as.matrix(hadR$faceLandmarks))
    
    box_data <- as.data.frame(as.matrix(hadR$faceRectangle))
    all_boxes[,i] <- as.numeric(unlist(box_data))
    colnames(all_boxes)[i] <- i
    
    #face_box <- add_rownames(face_box, "loc")
    
    # Make some transfface_data_dfmation to data frame
    face_data_df$V2 <- lapply(strsplit(as.character(face_data_df$V1), "\\="), "[", 2)
    face_data_df$V2 <- lapply(strsplit(as.character(face_data_df$V2), "\\,"), "[", 1)
    colnames(face_data_df)[2] <- "X"
    face_data_df$X<-as.numeric(face_data_df$X)
    
    face_data_df$V3 <- lapply(strsplit(as.character(face_data_df$V1), "\\y = "), "[", 2)
    face_data_df$V3 <- lapply(strsplit(as.character(face_data_df$V3), "\\)"), "[", 1)
    colnames(face_data_df)[3] <- "Y"
    face_data_df$Y<-as.numeric(face_data_df$Y)
    
    face_data_df$V1<-NULL
    face_data_df <- add_rownames(face_data_df, "location")
    face_data_df$faceid <- i
    
    all_faces <- rbind(all_faces, face_data_df)
    
  }
  
  return(list(all_faces, all_boxes))
}


remo_pfaces <- function(ggplt, face_box, lw=1.5, bc=RColorBrewer::brewer.pal(length(face_box), "Set1")) {
  
  for (i in 1:length(face_box)) {
    color_vec <- bc
    ggplt <- ggplt + geom_rect(data=NULL, inherit.aes=FALSE, ymax=-unlist(face_box[1,i]), 
                               xmin=unlist(face_box[2,i]), 
                               xmax=(unlist(face_box[2,i])+unlist(face_box[3,i])), 
                               ymin=-(unlist(face_box[1,i])+unlist(face_box[4,i])),
                               fill="white", linetype = 1, alpha=0, size=lw, color=color_vec[i])
    ggplt
  }
  return(ggplt)
}

percent <- function(x, digits = 2, format = "f", ...) {
  paste0(formatC(100 * x, format = format, digits = digits, ...), "%")
}


# SERVER LOGIC
shinyServer(function(input, output) {
  
  vals <- reactiveValues(
    
  )
  
  # Receive URL Input
  observeEvent(input$submit_url, {
    print("execute below...")
    vals$img <- remo_f2mem(input$url_input)
    vals$img_m <- rasterGrob(vals$img, interpolate=FALSE)
    vals$df <- data.frame(x = 1:as.numeric(dim(vals$img)[1]), y = -(1:as.numeric(dim(vals$img)[1])))
    face_api_call <- remo_fface(input$url_input, face_api_key)
    vals$face_df <- face_api_call[[1]]
    vals$face_box <- face_api_call[[2]]
    
    pdata <- remo_femo(input$url_input, emo_api_key)
    pdata$Level <- percent(pdata$Level, digits = 2, format="f")
    rownames(pdata) <- NULL
    vals$pdata <- pdata
    
  })
  
  
  output$plot1 <- renderPlot({

    remo_pfaces(ggplot(vals$df, aes(x, y)) +
      annotation_custom(vals$img_m, xmin=0, xmax=as.numeric(dim(vals$img)[2]), ymin=-as.numeric(dim(vals$img)[1]), ymax=0) +
      coord_cartesian(xlim = c(0, as.numeric(dim(vals$img)[2])), ylim = c(0, -as.numeric(dim(vals$img)[1]))) +
      geom_point(data=vals$face_df, aes(x=X, y=-Y, label=location, color = as.factor(faceid)), alpha=0.2, size = 1) +
      geom_text_repel(data=vals$face_df, aes(label=location, x=X, y=-Y, color = as.factor(faceid)), alpha=0.5, size=2) + 
      coord_fixed(ratio = 1) + 
      theme_bw() +
      xlim(0, as.numeric(dim(vals$img)[2])) +
      ylim(-as.numeric(dim(vals$img)[1]), 0), vals$face_box, lw=1.0) +
      scale_colour_brewer(palette = "Set1", guide=FALSE)
  })
  
  output$table <- renderTable(vals$pdata)
  
  
  
  output$ui <- renderUI({
    
    if (input$submit_url[1]==0) {
      return()
    } else {
    fluidRow(
    tabItem(
      tabName = "plot",
      tags$div(id="smoke",
               box(title = "Facial Landmarks", status = "primary", solidHeader = TRUE, collapsible = T, collapsed = F, width=8,
                   plotOutput("plot1")
               )
      )
    ), tabItem(
        tabName = "emo_tbl",
      
                 box(title = "Emotion", status = "primary", solidHeader = TRUE, collapsible = T, collapsed = F, width=4,
                     tableOutput('table') 
                 )
        
      )      
    )
      }
  })

})

