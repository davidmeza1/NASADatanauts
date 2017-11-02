## app.R ## Dashboard Examples
## This is the starting point for the application
## Run locally if in interactive session (for testing)
if(interactive()) {
     source("global.R")
     source("ui.R")
     source("server.R") ## function(input, out)
     shinyApp(ui, server)
}