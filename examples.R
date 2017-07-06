poldat2 <- with(mraja1spl, polarity(dialogue, 
                                    list(sex, fam.aff, died)))
colsplit2df(scores(poldat2))
plot(poldat2)
plot(scores(poldat2))
cumulative(poldat2)

devtools::install_github("cpsievert/LDAvisData")
library(LDAvisData)
data(Jeopardy, package="LDAvisData")
json <- with(Jeopardy,
             createJSON(phi, theta, doc.length, vocab, term.frequency))
serVis(json) # Check out Topic 22 (bodies of water!)


phi <- posterior(fitted)$terms %>% as.matrix
theta <- posterior(fitted)$topics %>% as.matrix
vocab <- colnames(phi)
doc_length <- vector()

phi <- beta_spread_all[ , 2:28] %>% as.matrix
theta <- gamma_df %>% as.matrix
vocab <- beta_spread_all[ , 1]
doc_length <- 