library(tidyverse)
library(readr)
GLBtemp <- read_csv("~/OneDrive/GitHub/NASADatanauts/data/GLBtemp.csv", 
                    na = "empty", comment = "*")
# Pull out the monthly data for each year. Removing 2017 since it has missing data.
# Tidy the data, gather the months and mean temperatures into columns.
# Arrange the data by year, ascending.
yearlyTemp <- GLBtemp %>% 
    select(Year:Dec) %>% 
    filter(Year != 2017) %>% 
    gather(Months, MeanTemp, -Year) %>% 
    arrange(Year)

## The base period is 1951 - 1980. Let's pull that out to create the base plot.
ggplot(data = filter(yearlyTemp, between(Year, 1951, 1980)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
    xlim(-1, 1)
   
##For period is 1983 - 1993.
ggplot(data = filter(yearlyTemp, between(Year, 1983, 1993)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
    xlim(-1, 1)

## The base period is 1994 - 2004.
ggplot(data = filter(yearlyTemp, between(Year, 1994, 2004)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
    xlim(-1, 1)

## The base period is 2005 - 2015.
ggplot(data = filter(yearlyTemp, between(Year, 2005, 2015)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
    xlim(-1, 1)

###########
x <- filter(yearlyTemp, between(Year, 1951, 1980))
table(x$MeanTemp)
