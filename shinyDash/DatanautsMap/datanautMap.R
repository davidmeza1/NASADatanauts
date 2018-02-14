library(googlesheets)
library(dplyr)
library(tidyr)
library(forcats)
library(ggmap)
library(leaflet)
library(glue)
library(stringr)
library(DT)
library(crosstalk)

# Authenticate your google account and save token
ttt <- gs_auth()
saveRDS(ttt, "ttt.rds")

#Create an object to store the url to the googlesheet containing the information
datanautsLocation <- gs_url("https://docs.google.com/spreadsheets/d/1aDqpgXzxOQY6D8uQa8TNA2Xef09wRyaqUbVT7yLc-F4/edit#gid=1242744883")
# Read in the sheet
datanauts <- datanautsLocation %>% gs_read("Form Responses 1")
# Renaming columns to something easier to use
names(datanauts) <- c("Timestamp", "name", "city", "state", "country", "industry", "class", "share")

# Pasting city, state and country into one column
# Then I am removing the NA from rows with datanauts not in US
# Binding colums from datanauts df and the lot, lan from geocode pull using ggmap
# Converting class to factor
datanauts <- datanauts %>%  mutate(location = paste0(city, ", ", state, ", ", country))
datanauts <- datanauts %>%  mutate(location = str_replace(location, "NA, ", ""))
datanauts <- bind_cols(datanauts, data.frame(geocode(datanauts$location, source = "dsk")))
datanauts$class <- factor(datanauts$class)
# Save the rdata file for use later
save(datanauts, file = "datanauts.Rdata")
# Do not run
load("datanauts.Rdata")

# Thsi creates an object holding a leaflet map
datanauts_map <- leaflet() %>%
    setView(-82.831040,35.88904, zoom = 3) %>% 
    addTiles() %>%
    addCircleMarkers(data = datanauts, lng =~ lon, lat = ~ lat, group = "Members", color = "blue") %>% 
    addCircleMarkers(data = filter(datanauts, class == "Founding Class (2015)"), lng = ~ lon, lat = ~ lat, group = "Founding Class", color = "green") %>% 
    addCircleMarkers(data = filter(datanauts, class == "2016"), lng = ~ lon, lat = ~ lat, group = "2016", color = "purple") %>% 
    addCircleMarkers(data = filter(datanauts, class == "Spring 2017"), lng = ~ lon, lat = ~ lat, group = "Spring 2017", color = "red") %>% 
    addCircleMarkers(data = filter(datanauts, class == "Fall 2017"), lng = ~ lon, lat = ~ lat, group = "Fall 2017", color = "cyan") %>% 
    hideGroup("Founding Class") %>% 
    hideGroup("2016") %>% 
    hideGroup("Spring 2017") %>% 
    hideGroup("Fall 2017") %>%
    addLayersControl(baseGroups = "Members", overlayGroups = c("Members", "Founding Class", "2016", "Spring 2017", "Fall 2017"),
                     options = layersControlOptions(collapsed = FALSE))


# Creates datatable of the Datanauts using only 4 columns
datatable(datanauts %>% select(name, location, industry, class))

# Create subset to separate industry
# Did not use this
#industry_levels <- c("Finance", "Academia", "Oil & Gas", "Non-profit", "Government", "Natural/Physical Science and Engineering",
#                     "Computer Science", "Student", "Education", "Bioinformatics", "Scocial Science", "Other")

# Creates subset of the member df for is on the wordcloud
datanaut_sub <- datanauts %>% select(name, location, industry, class)
datanaut_sub <- datanaut_sub %>% separate_rows(industry, sep = ",")
datanaut_sub$industry <- str_trim(datanaut_sub$industry)
datanaut_sub$industry <- factor(datanaut_sub$industry)

industry_count <- fct_count(datanaut_sub$industry, sort = TRUE)

library(wordcloud2)
wordcloud2(industry_count, size = .5, color = "random-light", backgroundColor = "grey")

# Could also have done
# wordcloud2(fct_count(datanaut_sub$industry, sort = TRUE), size = .5, color = "random-light", backgroundColor = "grey")




