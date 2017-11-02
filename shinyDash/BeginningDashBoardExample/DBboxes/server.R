## Place all your server here.
## Do not forget to source this file in the root server.r file

# Boxes tab --------------------------------------
set.seed(122)
histdata <- rnorm(500)
histdata2 <- rnorm(500)
histdata3 <- rnorm(500)

output$plot1 <- renderPlot({
     data <- histdata[seq_len(input$slider1)]
     hist(data)
})


output$plot2 <- renderPlot({
     data <- histdata2[seq_len(input$slider2)]
     hist(data)
})


output$plot3 <- renderPlot({
     data <- histdata3[seq_len(input$slider3)]
     hist(data)
})

## Info Box server code ------------------------------------------------
output$progressBox <- renderInfoBox({
     infoBox(
          "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
          color = "purple"
     )
})
output$approvalBox <- renderInfoBox({
     infoBox(
          "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
          color = "yellow"
     )
})

# Same as above, but with fill=TRUE
output$progressBox2 <- renderInfoBox({
     infoBox(
          "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
          color = "purple", fill = TRUE
     )
})
output$approvalBox2 <- renderInfoBox({
     infoBox(
          "Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"),
          color = "yellow", fill = TRUE
     )
})

# Value Box Server code -----------------------------------------------
output$progressBox3 <- renderValueBox({
     valueBox(
          paste0(25 + input$count2, "%"), "Progress", icon = icon("list"),
          color = "purple"
     )
})

output$approvalBox3 <- renderValueBox({
     valueBox(
          "80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"),
          color = "yellow"
     )
})