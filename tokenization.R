

library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)

con <- file("en_US.twitter.txt", "r")
lineTwitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("en_US.blogs.txt", "r")
lineBlogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("en_US.news.txt", "r")
lineNews <- suppressWarnings(readLines(con, encoding = "UTF-8", skipNul = TRUE))
close(con)

tidyLines <- function(textLines){ 

  #removal of non-English text
  textLines <- iconv(textLines, "latin1", "ASCII", sub="")
  textLines <- gsub("[[:digit:]]", "", textLines)
  textLines <- gsub("http[[:alnum:]]*", "", textLines)
  
  #split at all ".", ",", ":", ";" ...
  Textlines <- unlist(strsplit(textLines, "[.,:;!?(){}<>]+"))
  
  #remove multiple sapce
  textLines <- gsub("\\s+", " ", textLines)
  #remove spaces at the begining and the end of the line
  textLines <- str_trim(textLines)
  
  lines <- tolower(textLines)
}

lineNews <- tidyLines(lineNews)
lineBlogs <- tidyLines(lineBlogs)
lineTwitter <- tidyLines(lineTwitter)

gc()

lineNews <- as.data.frame(lineNews)
lineBlogs <- as.data.frame(lineBlogs)
lineTwitter <- as.data.frame(lineTwitter)

save(lineNews, file = "lineNews.rda")
save(lineBlogs, file = "lineBlogs.rda")
save(lineTwitter, file = "lineTwitter.rda")

gc()

bigramsNews <- lineNews %>%
  unnest_tokens(bigram, lineNews  , token = "ngrams", to_lower = FALSE, n = 2) %>%
  separate(bigram, c("bigram1", "bigram2"), sep = " ") %>%
  count(bigram1, bigram2, sort = TRUE)

gc()
trigramsNews <- lineNews %>%
  unnest_tokens(trigram, lineNews, token = "ngrams", to_lower = FALSE, n = 3) 
gc()
trigramsNews <- separate(trigramsNews, trigram, c("trigram1", "trigram2", "trigram3"), sep = " ")
gc()
trigramsNews <-  count(trigramsNews, trigram1, trigram2, trigram3, sort = TRUE)

bigramsBlogs <- lineBlogs %>%
  unnest_tokens(bigram, lineBlogs, token = "ngrams", to_lower = FALSE, n = 2) %>%
  separate(bigram, c("bigram1", "bigram2"), sep = " ") %>%
  count(bigram1, bigram2, sort = TRUE)

trigramsBlogs <- lineBlogs %>%
  unnest_tokens(trigram, lineBlogs, token = "ngrams", to_lower = FALSE, n = 3)
gc()
trigramsBlogs <- separate(trigramsBlogs, trigram, c("trigram1", "trigram2", "trigram3"), sep = " ")
gc()
trigramsBlogs <- count(trigramsBlogs, trigram1, trigram2, trigram3, sort = TRUE)

bigramsTwitter <- lineTwitter %>%
  unnest_tokens(bigram, lineTwitter, token = "ngrams", to_lower = FALSE, n = 2) %>%
  separate(bigram, c("bigram1", "bigram2"), sep = " ") %>%
  count(bigram1, bigram2, sort = TRUE)

trigramsTwitter <- lineTwitter %>%
  unnest_tokens(trigram, lineTwitter, token = "ngrams", to_lower = FALSE, n = 3) %>%
  separate(trigram, c("trigram1", "trigram2", "trigram3"), sep = " ") %>%
  count(trigram1, trigram2, trigram3, sort = TRUE)

bigramsNewsOk <- filter(bigramsNews, n>1)
saveRDS(bigramsNewsOk, file = "bigramsNewsOk.rds")

bigramsBlogsOk <- filter(bigramsBlogs, n>1)
saveRDS(bigramsBlogsOk, file = "bigramsBlogsOk.rds")

bigramsTwitterOk <- filter(bigramsTwitter, n>1)
saveRDS(bigramsTwitterOk, file = "bigramsTwitterOk.rds")


trigramsNewsOk <- filter(trigramsNews, n>1)
saveRDS(trigramsNewsOk, file = "trigramsNewsOk.rds")


trigramsBlogsOk <- filter(trigramsBlogs, n>1)
saveRDS(trigramsBlogsOk, file = "trigramsBlogsOk.rds")

trigramsTwitterOk <- filter(trigramsTwitter, n>1)
saveRDS(trigramsTwitterOk, file = "trigramsTwitterOk.rds")


