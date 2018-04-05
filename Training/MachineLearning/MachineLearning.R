library(caret)
library(readr)
library(mlbench)
library(partykit)
library(gmodels)
set.seed(0622)

# Collect The Data
credit <- read_csv("~/Documents/OneDrive/GitHub/NASADatanauts/presentations/MachineLearning/code/chapter 5/credit.csv")
#If the first argument to createDataPartition() is categorical caret will perform stratified random sampling on the variable levels.

# Explore and Prepare the Data
prop.table(table(credit$default))
samp <- createDataPartition(credit$default, p = 0.75, list = FALSE)
training <- credit[samp,]
testing <- credit[-samp,]

prop.table(table(training$default))
prop.table(table(testing$default))

# Training The Data

credit_model_C50 <- train(default ~ . , data = training, method = "C5.0")
credit_model_C50
summary(credit_model_C50)
# visualizes the accuracy of the models
plot(credit_model_C50)
credit_model_C50$finalModel

credit_pred_C50 <- predict(credit_model_C50, testing)
credit_pred_C50B <- predict(credit_model_C50, testing, type = "prob")

CrossTable(testing$default, credit_pred_C50,
             prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
             dnn = c('actual default', 'predicted default'))
################################################################


credit_model_rpart <- train(default ~ . , data = training, method = "rpart")
credit_model_rpart$finalModel
summary(credit_model_rpart)


# visualizes the accuracy of the models
plot(as.party(credit_model_rpart$finalModel))
credit_pred_rpart <- predict(credit_model_rpart, testing)

CrossTable(testing$default, credit_pred_rpart,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))
##############################################################
credit_model_rf <- train(default ~ . , data = training, method = "rf")
credit_model_rf$finalModel
summary(credit_model_rf)
credit_pred_rf <- predict(credit_model_rf, testing)

CrossTable(testing$default, credit_pred_rf,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))


#############################################################
# Comapre the Models
model_list <- list(C50 = credit_model_C50, rpart = credit_model_rpart, rf = credit_model_rf)
res <- resamples(model_list)
summary(res)
compare_models(credit_model_C50, credit_model_rpart)
compare_models(credit_model_C50, credit_model_rf)

###################Predict##########################################
# Explore and Prepare the Data
prop.table(table(credit$default))
samp_times3 <- createDataPartition(credit$default, p = 0.75, list = FALSE, times = 3)
training3 <- credit[samp_times3,]


prop.table(table(training3$default))
prop.table(table(testing$default))

# Training The Data

credit_model_C50_3 <- train(default ~ . , data = training3, method = "C5.0")
credit_model_C50_3
summary(credit_model_C50_3)
# visualizes the accuracy of the models
plot(credit_model_C50_3)
credit_model_C50_3$finalModel

credit_pred_C50 <- predict(credit_model_C50, testing)
credit_pred_C50B <- predict(credit_model_C50, testing, type = "prob")
credit_pred_C50_3 <- predict(credit_model_C50_3, testing)

CrossTable(testing$default, credit_pred_C50,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))


CrossTable(testing$default, credit_pred_C50_3,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual default', 'predicted default'))


fitControl <- trainControl(## 10-fold CV
    method = "cv",
    number = 10)

fitControl2 <- trainControl(## 10-fold CV
    method = "repeatedcv",
    number = 10,
    ## repeated ten times
    repeats = 10)
