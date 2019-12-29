# Data-Science-Capstone---Final-Project
This repository holds the r codes and data for the final project of the Data Science Capstone course

The project inovloved text mining using data from SwiftKey.  English version of text was downloaded.
After tidying the text documents, we needed to tokenize the documents into bigrams, trigrams and quandgrams.
The tokenization process was a challenge task because of high sparsity of the data.  

Having tried numbers of different R packages and hundreds of hours generating the ngrams, we gave up doing so in the laptop.
We deployed the RStudio Server Pro Standard for GCP in the Google Compute Engine and had the tokenization process.
The text data sets were decomposed into bigrams, trigrams and quadgrams and saved as rds files.  These ngram files were 
stored in GitHub repository for easy access.  

We used Shiny Application for allowing users input some words.  In case the number of word input was one, we matched the
input word with the first word of the bigram data. The program would  output the second word of the bigram with the highest 
frequency.  If users input more than two words, we matched these two word with the first two words of the trigram.  The
program would output the thrid word of the trigram.  In case the number of input word was higher than three, we matched the 
last three words with the first three words of the quadram. The program would return the last word of the quadram.  If the
quandram could not find the three word input, we chose the last two input words and matched this two words with the trigram.
Same logic was applied to lower level of ngram.
