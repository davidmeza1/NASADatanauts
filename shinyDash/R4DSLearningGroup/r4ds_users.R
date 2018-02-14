library(googlesheets)
library(dplyr)
library(ggmap)
library(leaflet)
library(glue)
# Authenticate your google account and save token
ttt <- gs_auth()
saveRDS(ttt, "ttt.rds")
# Get sheet key and read Sheet1
r4ds_deidentified <- gs_url("https://docs.google.com/spreadsheets/d/1L7lU5QqVfUtZXenFsGErPFS4n1jL4fixx9d3lrF94hU/edit#gid=0")
r4ds_users <- r4ds_deidentified %>% gs_read("Sheet1")
# Change names to something easier to use
names(r4ds_users) <- c("Type", "R_Comfort", "Analysis_Comfort", "Location", "Cohort")
# filter out the rows missing a location
r4ds_users <- r4ds_users %>%
  filter(!is.na(Location))
# Add longitude and lattitude to the dataframe, using Data Science Toolkit since
# it has no rate limit
r4ds_users <- bind_cols(r4ds_users, data.frame(geocode(r4ds_users$Location, source = "dsk")))
# filter out rows with not coordinates
r4ds_users <- r4ds_users %>%  filter(!is.na(lon))
save(r4ds_users, file = "r4dsUsers.rdata")

load("r4dsUsers.rdata")

# Create leaflet map and popup to identify users comfort in R and analysis
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

r4ds_map

# To Do
# add layer for learner and mentor groiuped by cohort
