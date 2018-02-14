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

datanautsLocation <- gs_url("https://docs.google.com/spreadsheets/d/1aDqpgXzxOQY6D8uQa8TNA2Xef09wRyaqUbVT7yLc-F4/edit#gid=1242744883")
datanauts <- datanautsLocation %>% gs_read("Form Responses 1")                            
names(datanauts) <- c("Timestamp", "name", "city", "state", "country", "industry", "class", "share")

datanauts <- datanauts %>%  mutate(location = paste0(city, ", ", state, ", ", country))
datanauts <- datanauts %>%  mutate(location = str_replace(location, "NA, ", ""))
datanauts <- bind_cols(datanauts, data.frame(geocode(datanauts$location, source = "dsk")))
datanauts$class <- factor(datanauts$class)

save(datanauts, file = "datanauts.Rdata")
load("datanauts.Rdata")
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


# Creates datatable of the Datanauts
datatable(datanauts %>% select(name, location, industry, class))

# Create subset to separate industry
industry_levels <- c("Finance", "Academia", "Oil & Gas", "Non-profit", "Government", "Natural/Physical Science and Engineering",
                     "Computer Science", "Student", "Education", "Bioinformatics", "Scocial Science", "Other")
datanaut_sub <- datanauts %>% select(name, location, industry, class)
datanaut_sub <- datanaut_sub %>% separate_rows(industry, sep = ",")
datanaut_sub$industry <- str_trim(datanaut_sub$industry)
datanaut_sub$industry <- factor(datanaut_sub$industry)

industry_count <- fct_count(datanaut_sub$industry, sort = TRUE)

pal <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#fb8072')
wordcloud(industry_count$f, industry_count$n, scale=c(3,.5), min.freq = 1, colors = pal)

library(wordcloud2)
wordcloud2(industry_count, size = .5, color = "random-light", backgroundColor = "grey")




