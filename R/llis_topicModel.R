library(topicmodels)
library(tidyverse)
library(tidytext)
library(readr)
library(lubridate)
library(LDAvis)
library(corrplot)

llis_df <- read_csv("~/OneDrive/GitHub/NASADatanauts/data/llis.csv",
                            col_types = cols(LessonDate = col_date(format = "%m/%d/%y")))
#windows
llis_df <- read_csv("data/llis.csv",
                    col_types = cols(LessonDate = col_date(format = "%m/%d/%y")))

by_lesson <- llis_df %>% 
    transmute(lessonID = LessonId, title = Title, lesson = Lesson)

# split into words
by_lesson_word <- by_lesson %>% 
    unnest_tokens(word, lesson)

# find document-word counts and remove stop words
word_counts <- by_lesson_word %>% 
    anti_join(stop_words) %>% 
    count(title, word, sort = TRUE) %>% 
    ungroup()

word_counts <- word_counts %>% arrange(word) %>% slice(-1:-1187)

#########################################
# Do this after my_stop_words is created (see below) 
word_counts <- word_counts %>% 
    anti_join(my_stop_words) %>% 
    count(title, word, sort = TRUE) %>% 
    ungroup()

###################################### 


lesson_dtm <- word_counts %>% 
    cast_dtm(title, word, n)

lesson_dtm

system.time(lesson_lda <- LDA(lesson_dtm, k = 27, control = list(seed = 0622)))
# user  system elapsed 
# 74.078   0.408  75.550
lesson_lda

# we can examine per-topic-per-word probabilities (beta)
# For each combination, the model computes the probability of that term being 
# generated from that topic.

lesson_topics <- tidy(lesson_lda, matrix = "beta")
lesson_topics

#We could use dplyr’s top_n() to find the top 5 terms within each topic.

top_terms <- lesson_topics %>% 
    group_by(topic) %>% 
    top_n(5, beta) %>% 
    ungroup() %>% 
    arrange(topic, -beta)

top_terms

top_terms %>%
    mutate(term = reorder(term, beta)) %>%
    ggplot(aes(term, beta, fill = factor(topic))) +
    geom_col(show.legend = FALSE) +
    facet_wrap(~ topic, scales = "free") +
    coord_flip()

#### Before we go further lets explore the terms
#### Create my_stop_words

# Thus, we may want to know which topics are associated with each document. 
# We can find this by examining the per-document-per-topic probabilities, “gamma”.


lesson_gamma <- tidy(lesson_lda, matrix = "gamma")
lesson_gamma


# Each of these values is an estimated proportion of words from that document that
# are generated from that topic. For example, the model estimates that that each
# the first lesson has only a .0000612% probability of coming from topic 1 


# top 5 documents in each topic
top_document_topic <- lesson_gamma %>% 
    group_by(topic) %>% 
    top_n(5, gamma) %>% 
    ungroup() %>% 
    arrange(topic, -gamma)

top_document_topic

# Gets the top topic for each document
top_topic_document <- lesson_gamma %>% 
    group_by(document) %>% 
    top_n(1, gamma) %>% 
    ungroup() %>% 
    arrange(document, -topic)
top_topic_document
   
##############################
lesson_gamma %>% 
    mutate(title = reorder(document, gamma * topic)) %>% 
    ggplot(aes(factor(topic), gamma)) + 
    geom_boxplot() + 
    facet_wrap(~ title)
###############################


# Creates a dataframe of the per-document-per-topic probabilities, “gamma”, of
# each topic for each document
gamma_df <- tidy(posterior(lesson_lda)$topics)

# One step of the LDA algorithm is assigning each word in each document to a topic.
# The more words in a document are assigned to that topic, generally, the more 
# weight (gamma) will go on that document-topic classification.
# 
# We may want to take the original document-word pairs and find which words in 
# each document were assigned to which topic. This is the job of the augment() 
# function, which also originated in the broom package as a way of tidying model 
# output. While tidy() retrieves the statistical components of the model, 
# augment() uses a model to add information to each observation in the original data.

lesson_assignments <- augment(lesson_lda, data = lesson_dtm)
lesson_assignments

top_terms_assignments <- lesson_assignments %>% 
    group_by(document) %>% 
    top_n(1, count) %>% 
    ungroup() %>% 
    arrange(.topic, -count)
top_terms_assignments

top_terms_assignments2 <- lesson_assignments %>% 
    group_by(term) %>% 
    top_n(1, count) %>% 
    ungroup() %>% 
    arrange(.topic, -count)

## To Do 
## compare terms bewtwee the topics containing project as a top term
beta_spread_all <- lesson_topics %>% 
    #mutate(topic = paste0("topic", topic)) %>% 
    spread(topic, beta) %>% 
    filter(`2` > .001 | `7` > .001) %>% 
    mutate(log_ratio = log2(`7`/`2`))

beta_spread_cor <- cor(beta_spread_all[2:28])
corrplot::corrplot(beta_spread_cor)


beta_spread2_7 <- lesson_topics %>% 
    filter(topic == 2 | topic == 7) %>% 
    mutate(topic = paste0("topic", topic)) %>% 
    spread(topic, beta) %>% 
    filter(topic2 > .001 | topic7 > .001) %>% 
    mutate(log_ratio = log2(topic7/topic2))

beta_spread2_7

#beta_spread2_7 %>% select(term, topic2, topic7, log_ratio)

beta_spread2_7 %>%
    group_by(direction = log_ratio > 0,
             absratio = abs(log_ratio)) %>%
    top_n(10, absratio) %>%
    mutate(term = reorder(term, log_ratio)) %>%
    ggplot(aes(term, log_ratio)) +
    geom_col() +
    labs(y = "Log2 ratio of beta in topic 7 / topic 2") +
    coord_flip()
