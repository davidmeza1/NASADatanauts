library(gapminder)
library(ggplot2)
library(animation)
theme_set(theme_bw())

p <- ggplot(gapminder, aes(gdpPercap, lifeExp, color = continent, frame = year)) +
    geom_point(aes(size = pop)) +
    geom_text(aes(label = country),vjust = 0, nudge_y = 0.5, check_overlap = TRUE) +
    theme(legend.position = "none") +
    scale_x_log10() +
    scale_size(range = c(0,30)) +
    labs(x = "GDP Per Capita", y = "Life Expectancy")
    
 
p

devtools::install_github("dgrtwo/gganimate")
library(gganimate)

gganimate(p)
# save as gif
gganimate(p, filename = "images/gapminder.gif")
# Save as mp4
gganimate_save(gganimate(p), filename = "images/gapminder.mp4", saver = "mp4")


head(gapminder)
range(gapminder$gdpPercap)



aq <- airquality
aq$date <- as.Date(paste(1973, aq$Month, aq$Day, sep = "-"))

p2 <- ggplot(aq, aes(date, Temp, frame = Month, cumulative = TRUE)) +
    geom_line()
gganimate(p2, title_frame = FALSE)
