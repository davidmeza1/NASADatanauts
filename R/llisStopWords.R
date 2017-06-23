# cleaning up some of the topics

topic22_terms <- lesson_topics %>% 
    filter(topic == 22) %>% 
    arrange(topic, -beta) %>% 
    top_n(40, beta)


llis_stop_words <- topic22_terms[1:27, 2] 
llis_stop_words <- llis_stop_words %>% 
    rename(word = term) %>% 
    mutate(lexicon = rep("custom", 27))
my_stop_words <- bind_rows(stop_words, llis_stop_words)

tail(my_stop_words, 27)

