## Tab Items
## Introduction-----------------------------------------
source('intro/intro.R', local = TRUE)
intro <- tabItem(tabName = "intro", intro.box)

## Dashboard Boxes Example --------------------------------
source('DBboxes/ui.R', local = TRUE)
dbboxes <- tabItem(tabName = "dbboxes", dbboxes.box)

## Dashboard ----------------------------------------------
source('dashboard/ui.R', local = TRUE)
dashboard <- tabItem(tabName = "dashboard", dashboard.box)

## maps ------------------------------------------------
source('maps/ui.R', local = TRUE)
maps <- tabItem(tabName = "maps", maps.box)

## Topic Modeling -------------------------------------
source("LDAvis/ui.R", local = TRUE)
lda <- tabItem(tabName = "lda", lda.box)

## Acknowledgements ------------------------------------
source('acknowledgements/acknowledgements.R', local = TRUE)
ack <- tabItem(tabName = "ack", ack.box)


body <- dashboardBody(
     tabItems(
          intro,
          dbboxes,
          dashboard,
          maps,
          lda,
          ack
     )
)