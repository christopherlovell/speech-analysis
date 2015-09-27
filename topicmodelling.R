library(jsonlite)
library(plyr)
library(tm)
library(topicmodels)
library(LDAvis)

dat <- jsonlite::fromJSON("speech_data 27th Jul 12:53.json", flatten = T)

dat <- plyr::rbind.fill(dat$pages$results)


corpus <- tm::Corpus(tm::VectorSource(dat$text))

corpus.clean <- tm_map(corpus, content_transformer(tolower), lazy = T)
corpus.clean <- tm_map(corpus.clean, content_transformer(removePunctuation), lazy = T)
corpus.clean <- tm_map(corpus.clean, content_transformer(removeNumbers), lazy = T)
corpus.clean <- tm_map(corpus.clean, content_transformer(removeWords), stopwords('english'), lazy = T)
corpus.clean <- tm_map(corpus.clean, content_transformer(stripWhitespace), lazy = T)

dtm <- tm::DocumentTermMatrix(corpus.clean)

# filter out low scoring tf-idf terms
tfidf.scores <- colSums(as.matrix(tm::weightTfIdf(dtm)))
dtm <- dtm[,tfidf.scores > quantile(tfidf.scores, 0.2)]

td.mat <- as.matrix(dtm)

topic.no <- 15

lda <- topicmodels::LDA(dtm, k = topic.no, method = "Gibbs")

phi <- posterior(lda)$terms
theta <- posterior(lda)$topics
doc.length <- rowSums(td.mat)
term.frequency <- colSums(td.mat)
vocab <- tm::Terms(dtm)


# jensenShannon <- function(x, y) {
#   m <- 0.5*(x + y)
#   0.5*sum(x*log(x/m)) + 0.5*sum(y*log(y/m))
# }
# dist.mat <- proxy::dist(x = phi, method = jensenShannon)
# dist.mat


LDAvis.json <- LDAvis::createJSON(phi = phi,
                                  theta = theta,
                                  doc.length = doc.length,
                                  vocab = vocab,
                                  term.frequency = term.frequency)

LDAvis::serVis(LDAvis.json)

#rm(phi,theta,doc.length,term.frequency,vocab,not,lda,LDAvis.json,td.mat)
#write.table(LDAvis.json[[1]],file = "topics.json")

