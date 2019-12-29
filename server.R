#Load the R packages
suppressWarnings(library(shiny))
suppressWarnings(library(dplyr))
suppressWarnings(library(stringr))
suppressWarnings(library(tidyr))

#Load bigram, trigram and quadgram data from gitHub.
bigramsBlogsOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/bigramsBlogsOk.rds?raw=true")))
bigramsNewsOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/bigramsNewsOk.rds?raw=true")))
bigramsTwitterOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/bigramsTwitterOk.rds?raw=true")))

trigramsBlogsOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/trigramsBlogsOk.rds?raw=true")))
trigramsNewsOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/trigramsNewsOk.rds?raw=true")))
trigramsTwitterOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/trigramsTwitterOk.rds?raw=true")))

quadgramsBlogsOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/quadgramsBlogsOk.rds?raw=true")))
quadgramsNewsOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/quadgramsNewsOk.rds?raw=true")))
quadgramsTwitterOk <- readRDS(gzcon(url("https://github.com/kongchakbun/Data-Science-Capstone---Final-Project/blob/master/quadgramsTwitterOk.rds?raw=true")))
        
shinyServer(function(input, output) {
        #Function for tidy the input text
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
                #turn the input as lower case letter
                lines <- tolower(textLines)
        }        
        
        #Function for finding the second word
        findSecondWord <- function(inputText, textLength, bigramsData){
                wordInput <- inputText[textLength]
                word1 <- bigramsData %>% 
                        #select observations with the same word
                        filter(wordInput == bigram1) %>%
                        #select the observation with the highest frequency 
                        filter(n == max(n)) %>%
                        .[["bigram2"]]
                if (length(word1)==0 | is.null(word1)== TRUE ) (word1 = "")
                word1
        }        
        
        #Function for finding the third word
        findThirdWord <- function(inputText, textLength, bigramsData, trigramsData) {
                wordInput1 <- inputText[textLength-1]
                wordInput2 <- inputText[textLength]
                
                word1 <- trigramsData %>% 
                        #select observation with the same first two words
                        filter(wordInput1 == trigram1, wordInput2== trigram2) %>%
                        #select the observation with the highest frequency 
                        filter(n == max(n)) %>%
                        .[["trigram3"]]
                if (length(word1)==0 | is.null(word1)==TRUE) { 
                        word1 <- findSecondWord(inputText, textLength, bigramsData)
                }
                word1
        }
        
        #Function for finding the fourth word
        findFourthWord <- function(inputText, textLength, bigramsData, trigramsData, quadgramsData) {
                wordInput1 <- inputText[textLength-2]
                wordInput2 <- inputText[textLength-1]
                wordInput3 <- inputText[textLength]
                word1 <- quadgramsData %>% 
                        #select observation with the same first two words
                        filter(wordInput1 == quadgram1, wordInput2== quadgram2, wordInput3 == quadgram3) %>%
                        #select the observation with the highest frequency 
                        filter(n == max(n)) %>%
                        .[["quadgram4"]]
                if (length(word1)==0 | is.null(word1)==TRUE) { 
                        word1 <- findThirdWord(inputText, textLength, bigramsData, trigramsData)
                }
                word1
        }
        
        
        
        
        findword <- function(x, y){ 
                #Select the data sets for prediction
                if(y == "dataNews") {
                        bigramsData <- bigramsNewsOk
                        trigramsData <- trigramsNewsOk
                        quadgramsData <- quadgramsNewsOk
                        }
                if (y == "dataBlogs") {
                        bigramsData <- bigramsBlogsOk
                        trigramsData <- trigramsBlogsOk
                        quadgramsData <- quadgramsBlogsOk
                        }
                if (y == "dataTwitter") {
                        bigramsData <- bigramsTwitterOk
                        trigramsData <- trigramsTwitterOk
                        quadgramsData <- quadgramsTwitterOk
                        }
                
                #Separat the input text word by word
                splitText <- strsplit(tidyLines(x), " ")[[1]]
                textLength <- length(splitText)
                
                if (textLength == 0) {word1 <- ""}
                
                if (textLength == 1) { 
                        word1 <- findSecondWord(splitText, textLength, bigramsData)
                } 
                if (textLength == 2) { 
                        word1 <- findThirdWord(splitText, textLength, bigramsData, trigramsData)
                }
                if (textLength > 2) {
                        word1 <- findFourthWord(splitText, textLength, bigramsData, trigramsData, quadgramsData)
                }
                
                word1
        }
        
        
        
        output$nextWord <- renderPrint({
                findword(input$inputWord, input$dataSet)
                
                
        })
        
        
})           






