#
# This is the user-interface definition of a Shiny web application for allowing
# users input some words. The program will predict next word which was learn from
# the SwiftKey data set. 

library(shiny)

shinyUI(fluidPage(
        
        # Application title
        titlePanel("Data Science Capstone - Final Project (Next Word Prediction)"),
        
        # sidebar panel for selecting data set to learn and input words. 
        sidebarLayout(
                sidebarPanel(
                        selectInput("dataSet", "Select Data We Learn From:",
                                    c("News" = "dataNews",
                                      "Blogs" = "dataBlogs",
                                      "Twitter" = "dataTwitter")),
                        textInput("inputWord", "Enter a word for predicting the next word",value = "")
                ),
                
                # Show a the next word prediction
                mainPanel(
                        h3("Prediction of the next word"),
                        
                        fluidRow(column(10, verbatimTextOutput("nextWord", placeholder = TRUE)))
                        
                )
        )
))
