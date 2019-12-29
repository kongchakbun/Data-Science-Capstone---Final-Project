## The following codes were for the purpose of tokenization.
## As this process involved large volume of memony, we run the code
## in Google Cloud Platform.  Because of the high sparsity in the ngram
## process, we have to run the code line by in in the cloud machine.


# Load the R packages
library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)

# Read the text files from SwiftKey
con <- file("en_US.twitter.txt", "r")
lineTwitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("en_US.blogs.txt", "r")
lineBlogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file("en_US.news.txt", "r")
lineNews <- suppressWarnings(readLines(con, encoding = "UTF-8", skipNul = TRUE))
close(con)


# Function for tidy the textlines
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
  #conver all the text in lower case.
  lines <- tolower(textLines)
}

# Tidy the text.
lineNews <- tidyLines(lineNews)
lineBlogs <- tidyLines(lineBlogs)
lineTwitter <- tidyLines(lineTwitter)

gc()

# Change the textlines into data frame format.
lineNews <- as.data.frame(lineNews)
lineBlogs <- as.data.frame(lineBlogs)
lineTwitter <- as.data.frame(lineTwitter)

gc()

# Create the bigram for the News data set.
bigramsNews <- lineNews %>%
  unnest_tokens(bigram, lineNews  , token = "ngrams", to_lower = FALSE, n = 2) %>%
  separate(bigram, c("bigram1", "bigram2"), sep = " ") %>%
  count(bigram1, bigram2, sort = TRUE)

gc()

# Create the trigram for the News data set.
trigramsNews <- lineNews %>%
  unnest_tokens(trigram, lineNews, token = "ngrams", to_lower = FALSE, n = 3) 
gc()
trigramsNews <- separate(trigramsNews, trigram, c("trigram1", "trigram2", "trigram3"), sep = " ")
gc()
trigramsNews <-  count(trigramsNews, trigram1, trigram2, trigram3, sort = TRUE)

# Create the bigram for the Blogs data set.
bigramsBlogs <- lineBlogs %>%
  unnest_tokens(bigram, lineBlogs, token = "ngrams", to_lower = FALSE, n = 2) %>%
  separate(bigram, c("bigram1", "bigram2"), sep = " ") %>%
  count(bigram1, bigram2, sort = TRUE)

# Create the trigram for the Blogs data set.
trigramsBlogs <- lineBlogs %>%
  unnest_tokens(trigram, lineBlogs, token = "ngrams", to_lower = FALSE, n = 3)
gc()
trigramsBlogs <- separate(trigramsBlogs, trigram, c("trigram1", "trigram2", "trigram3"), sep = " ")
gc()
trigramsBlogs <- count(trigramsBlogs, trigram1, trigram2, trigram3, sort = TRUE)

# Create the bigram for the Twitter data set.
bigramsTwitter <- lineTwitter %>%
  unnest_tokens(bigram, lineTwitter, token = "ngrams", to_lower = FALSE, n = 2) %>%
  separate(bigram, c("bigram1", "bigram2"), sep = " ") %>%
  count(bigram1, bigram2, sort = TRUE)

# Create the trigram for the Twitter data set.
trigramsTwitter <- lineTwitter %>%
  unnest_tokens(trigram, lineTwitter, token = "ngrams", to_lower = FALSE, n = 3) %>%
  separate(trigram, c("trigram1", "trigram2", "trigram3"), sep = " ") %>%
  count(trigram1, trigram2, trigram3, sort = TRUE)

# Truncate the News bigram
bigramsNewsOk <- filter(bigramsNews, n>1)
# Save the News bigram in rds format
saveRDS(bigramsNewsOk, file = "bigramsNewsOk.rds")

# Truncate the Blogs bigram
bigramsBlogsOk <- filter(bigramsBlogs, n>1)
# Save the Blogs bigram in rds format
saveRDS(bigramsBlogsOk, file = "bigramsBlogsOk.rds")

# Truncate the Twitter bigram
bigramsTwitterOk <- filter(bigramsTwitter, n>1)
# Save the Twitter bigram in rds format
saveRDS(bigramsTwitterOk, file = "bigramsTwitterOk.rds")

# Truncate the News trigram 
trigramsNewsOk <- filter(trigramsNews, n>1)
# Save the News trigram in rds format
saveRDS(trigramsNewsOk, file = "trigramsNewsOk.rds")

# Truncate the Blogs trigram
trigramsBlogsOk <- filter(trigramsBlogs, n>1)
# Save the Blogs trigram in rds format
saveRDS(trigramsBlogsOk, file = "trigramsBlogsOk.rds")

# Truncate the Twitter trigram
trigramsTwitterOk <- filter(trigramsTwitter, n>1)
# Savel the Twitter trigram in rds fromat
saveRDS(trigramsTwitterOk, file = "trigramsTwitterOk.rds")


# Create the quadgram for the Twitter data set
quadgramsTwitter <- lineTwitter %>%
        unnest_tokens(quadgram, lineTwitter, token = "ngrams", to_lower = FALSE, n = 4)
gc()
quadgramsTwitter <- separate(quadgramsTwitter, quadgram, c("quadgram1", "quadgram2", "quadgram3", "quadgram4"), sep = " ")
gc()
quadgramsTwitter <- count(quadgramsTwitter, quadgram1, quadgram2, quadgram3, quadgram4, sort = TRUE)
gc()
quadgramsTwitterOk <- filter(quadgramsTwitter, n>1) 
saveRDS(quadgramsTwitter, file = "quadgramsTwitter.rds")


# Create the quadgram for the News data set
quadgramsNews <- lineNews %>%
        unnest_tokens(quadgram, lineNews, token = "ngrams", to_lower = FALSE, n = 4)
gc()
quadgramsNews <- separate(quadgramsNews, quadgram, c("quadgram1", "quadgram2", "quadgram3", "quadgram4"), sep = " ")
gc()
quadgramsNews <- count(quadgramsNews, quadgram1, quadgram2, quadgram3, quadgram4, sort = TRUE)
quadgramsNewsOk <- filter(quadgramsNews, n>1)
saveRDS(quadgramsNewsOk, file = "quadgramsNewsOk.rds")

# Create the quadgram for the Blogs data set
quadgramsBlogs <- lineBlogs %>%
        unnest_tokens(quadgram, lineBlogs, token = "ngrams", to_lower = FALSE, n = 4)
gc()
quadgramsBlogs <- separate(quadgramsBlogs, quadgram, c("quadgram1", "quadgram2", "quadgram3", "quadgram4"), sep = " ")
gc()
quadgramsBlogs <- count(quadgramsBlogs, quadgram1, quadgram2, quadgram3, quadgram4, sort = TRUE)
quadgramsBlogsOk <- filter(quadgramsBlogs, n>1)
saveRDS(quadgramsBlogsOk, file = "quadgramsBlogsOk.rds")
