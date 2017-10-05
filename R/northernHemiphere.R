library(tidyverse)
library(readr)
# read the data from my folder
NHtemp <- read_csv("~/OneDrive/GitHub/NASADatanauts/data/NHtemp.csv", 
                    na = "empty", comment = "*")
# Pull out the monthly data for each year. Removing 2017 since it has missing data.
# Tidy the data, gather the months and mean temperatures into columns.
# Arrange the data by year, ascending.
# The month means for 1880 - 2016
NHyearlyTemp <- NHtemp %>% 
    select(Year:Dec) %>% 
    filter(Year != 2017) %>% 
    gather(Months, MeanTemp, -Year) %>% 
    arrange(Year)

# The summer month means for 1880 - 2016
NHsummerTemp <- NHtemp %>% 
    select(Year, Jun:Aug) %>% 
    filter(Year != 2017) %>% 
    gather(Months, MeanTemp, -Year) %>% 
    arrange(Year)

# Adding a column for the Year groups. This will be used as the frame parameter
# for the animation, shown below.
library(data.table)
NHsummerTemp <- data.table(NHsummerTemp)
NHsummerTemp[, Group := ifelse(Year %in% c(1951:1980), "1951-1980",
                               ifelse(Year %in% c(1983:1993), "1983-1993",
                               ifelse(Year %in% c(1994:2004), "1994-2004", 
                               ifelse(Year %in% c(2005:2015), "2005-2015", "1880-1950"))))]

## The base period is 1951 - 1980. Let's pull that out to create the base plot.
## Just to show you what the yearly and summer month means loook like
ggplot(data = filter(NHsummerTemp, between(Year, 1951, 1980)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
    xlim(-1, 1) +
    ggtitle("Summer Month Mean For 1951 - 1980")
ggplot(data = filter(NHyearlyTemp, between(Year, 1951, 1980)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
    xlim(-1, 1) + 
    ggtitle("Yearly Month Mean For 1951 - 1980")

#ggplot(data = filter(NHyearlyTemp, between(Year, 1951, 1980)), mapping = aes(x = MeanTemp, y = ..density..))  +
#    geom_histogram(binwidth = 0.04, fill = "light gray", color = "black") +
#    xlim(-1, 1) +
#    geom_density()

## Stand Alone plots for
##For period is 1983 - 1993.
ggplot(data = filter(NHsummerTemp, between(Year, 1983, 1993)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "yellow", color = "black") +
    xlim(-1, 1)

## The period is 1994 - 2004.
ggplot(data = filter(NHsummerTemp, between(Year, 1994, 2004)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "orange", color = "black") +
    xlim(-1, 1)

## The period is 2005 - 2015.
ggplot(data = filter(NHsummerTemp, between(Year, 2005, 2015)), mapping = aes(MeanTemp))  +
    geom_histogram(binwidth = 0.04, fill = "red", color = "black") +
    xlim(-1, 1) 

###########
# I wanted to see the table of means for the years
# I do not use it anywhere else
x <- filter(NHsummerTemp, between(Year, 1951, 1980))
table(x$MeanTemp)
#################

# Sets the theme for ggplot for the entire session
# You can also set the theme at the geom_
theme_set(theme_bw())

# This plots all the histograms on one canvass
# ggplot() creates a canvas. You can add data and aesthetics (aes) here or set them in
# the geometric, i.e., geom_histogram. 
ggplot()  +
    geom_histogram(data = filter(NHsummerTemp, between(Year, 1951, 1980)), mapping = aes(MeanTemp),
                  binwidth = 0.04, fill = "light gray", color = "black", alpha = .2) +
    geom_histogram(data = filter(NHsummerTemp, between(Year, 1983, 1993)), mapping = aes(MeanTemp),
                   binwidth = 0.04, fill = "yellow", color = "black", alpha = .5) + 
    geom_histogram(data = filter(NHsummerTemp, between(Year, 1994, 2004)), mapping = aes(MeanTemp),
                   binwidth = 0.04, fill = "orange", color = "black", alpha = .7) + 
    geom_histogram(data = filter(NHsummerTemp, between(Year, 2005, 2015)), mapping = aes(MeanTemp),
                   binwidth = 0.04, fill = "red", color = "black", alpha = .9) + 
    xlim(-1, 1)


# This package require ImageMagick (http://imagemagick.org/script/index.php) on your system.
# https://github.com/dgrtwo/gganimate
library(gganimate)
# df is used as the data source for the histograms used in the animation
# The first geom_histogram uses a different data source. This is the base plot.
df <- filter(NHsummerTemp, between(Year, 1983, 2015))
p <- ggplot(data = df, mapping = aes(MeanTemp))  +
    geom_histogram(data = filter(NHsummerTemp, between(Year, 1951, 1980)), mapping = aes(MeanTemp),
                   binwidth = 0.04, fill = "light gray", color = "black", alpha = .2) +
    geom_histogram(aes(frame = Group, fill = Group),binwidth = 0.04, color = "black") + 
    xlim(-1, 1)

# "nhtemp.gif" creates the animated gif in your working directory. I added the gif
# to the markdown file to be rendered on the html. Can also be rendered in a presentation.
gganimate(p, interval = 1.5, "nhtemp.gif")






