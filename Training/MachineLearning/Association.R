library(arules)
library(arulesViz)
library(readr)

# Collect the Data
groceries_df <- read_csv("~/Documents/OneDrive/GitHub/NASADatanauts/presentations/MachineLearning/code/chapter 8/groceries.csv", 
                      col_names = FALSE)
groceries <- read.transactions("~/Documents/OneDrive/GitHub/NASADatanauts/presentations/MachineLearning/code/chapter 8/groceries.csv", sep = ",")

#Explore the Data
summary(groceries)

inspect(groceries[1:5])
itemFrequency(groceries[, 1:3])

itemFrequencyPlot(groceries, support = 0.1)

itemFrequencyPlot(groceries, topN = 20)

# Training the Data
groceryrules <- apriori(groceries, parameter = list(support = 0.006, confidence = 0.25, minlen = 2))
summary(groceryrules)


inspect(groceryrules[1:3])

inspect(sort(groceryrules, by = "lift")[1:5])

berryrules <- subset(groceryrules, items %in% "berries")

inspect(berryrules)
