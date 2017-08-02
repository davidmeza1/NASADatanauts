library(plotly)
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

nhYr_p <- plot_ly(data = filter(NHyearlyTemp, between(Year, 1951, 2015)), x = ~MeanTemp,
                  type = "histogram", histnorm = "probability", nbinsx = 25) %>% 
    layout(xaxis = list(range = c(-1, 1.3))) 

nh_p <- plot_ly(alpha = 0.6, histnorm = "probability", nbinsx = 25) %>%
    add_histogram(data = filter(NHyearlyTemp, between(Year, 1951, 2015)), x = ~MeanTemp, alpha = .2, fill = "black") %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 1951, 1980)), x = ~MeanTemp ) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 1983, 1993)), x = ~MeanTemp ) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 1994, 2004)), x = ~MeanTemp ) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 2005, 2015)), x = ~MeanTemp ) %>% 
    layout(barmode = "overlay", xaxis = list(range = c(-1, 1.3)))


nh_p2 <- plot_ly(alpha = 0.6, frame = ~Group, histnorm = "probability", nbinsx = 25, color = ~Group) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 1951, 1980)), x = ~MeanTemp ) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 1983, 1993)), x = ~MeanTemp ) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 1994, 2004)), x = ~MeanTemp ) %>% 
    add_histogram(data = filter(NHsummerTemp, between(Year, 2005, 2015)), x = ~MeanTemp ) %>% 
    layout(barmode = "overlay", xaxis = list(range = c(-1, 1.3))) %>% 
    animation_opts(redraw = TRUE)

nh_p2
################################
accumulate_by <- function(dat, var) {
    var <- lazyeval::f_eval(var, dat)
    lvls <- plotly:::getLevels(var)
    dats <- lapply(seq_along(lvls), function(x) {
        cbind(dat[var %in% lvls[seq(1, x)], ], frame = lvls[[x]])
    })
    dplyr::bind_rows(dats)
}

df <- NHsummerTemp %>% 
    filter(between(Year, 1951, 2015), Year != 1981, Year != 1982) %>% 
    accumulate_by(~MeanTemp)

nh_p3 <- df %>% 
    plot_ly(alpha = 0.6, frame = ~Group, histnorm = "probability", nbinsx = 25, color = ~Group) %>% 
    add_histogram(x = ~MeanTemp ) %>% 
    add_histogram(x = ~MeanTemp ) %>% 
    add_histogram(x = ~MeanTemp ) %>% 
    add_histogram(x = ~MeanTemp ) %>% 
    layout(barmode = "overlay", xaxis = list(range = c(-1, 1.3))) %>% 
    animation_opts(frame = 300, transition = 0, redraw = TRUE)

