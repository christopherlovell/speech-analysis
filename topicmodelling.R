
library(jsonlite)
library(plyr)
library(tm)
library(topicmodels)
library(LDAvis)

dat <- jsonlite::fromJSON("speech_data 27th Jul 12:53.json", flatten = T)

dat <- plyr::rbind.fill(dat$pages$results)


corpus <- tm::Corpus(tm::VectorSource(dat$text))

corpus.clean <- tm::tm_map(corpus, content_transformer(tolower), lazy = T)
corpus.clean <- tm::tm_map(corpus.clean, content_transformer(removePunctuation), lazy = T)
corpus.clean <- tm::tm_map(corpus.clean, content_transformer(removeNumbers), lazy = T)
corpus.clean <- tm::tm_map(corpus.clean, content_transformer(removeWords), stopwords('english'))
corpus.clean <- tm::tm_map(corpus.clean, content_transformer(stripWhitespace), lazy = T)
corpus.clean <- tm::tm_map(corpus.clean, content_transformer(removeWords), stopwords('english'))
corpus.clean <- tm::tm_map(corpus.clean, stemDocument)

dtm <- tm::DocumentTermMatrix(corpus.clean)

# filter out low scoring tf-idf terms
tfidf.scores <- colSums(as.matrix(tm::weightTfIdf(dtm)))
dtm <- dtm[,tfidf.scores > quantile(tfidf.scores, 0.3)]

# convert to matrix to allow row and column sums to be calculated
td.mat <- as.matrix(dtm)

topic.no <- 28

lda <- topicmodels::LDA(dtm, k = topic.no, method = "Gibbs")

phi <- posterior(lda)$terms
theta <- posterior(lda)$topics
doc.length <- rowSums(td.mat)
term.frequency <- colSums(td.mat)
vocab <- tm::Terms(dtm)


LDAvis.json <- LDAvis::createJSON(phi = phi,
                                  theta = theta,
                                  doc.length = doc.length,
                                  vocab = vocab,
                                  term.frequency = term.frequency)

LDAvis::serVis(LDAvis.json)

save.image("image.RData")

#rm(phi,theta,doc.length,term.frequency,vocab,not,lda,LDAvis.json,td.mat)
#write.table(LDAvis.json[[1]],file = "topics.json")

