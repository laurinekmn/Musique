#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# musique <- read.csv("./Musique/musique.csv", sep=";")
# musique$music_genre <- as.factor(musique$music_genre)
# #musique$obtained_date <- as.Date(musique$obtained_date, "%d-%m") # Faut d'abord changer Apr en 04
# musique$mode <- as.factor(musique$mode)
# musique$key <- as.factor(musique$key)
# musique$instrumentalness <- as.numeric(musique$instrumentalness)
# musique$acousticness <- as.numeric(musique$acousticness)
# musique$tempo <- as.numeric(musique$tempo)
# 
# # On prend les lignes sans NA
# musique <- musique[complete.cases(musique),]

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  musique <- read.csv("../musique.csv", sep=";")
  musique$music_genre <- as.factor(musique$music_genre)
  #musique$obtained_date <- as.Date(musique$obtained_date, "%d-%m") # Faut d'abord changer Apr en 04
  musique$mode <- as.factor(musique$mode)
  musique$key <- as.factor(musique$key)
  musique$instrumentalness <- as.numeric(musique$instrumentalness)
  musique$acousticness <- as.numeric(musique$acousticness)
  musique$tempo <- as.numeric(musique$tempo)
  
  # On prend les lignes sans NA
  musique <- musique[complete.cases(musique),]
  

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- musique[, 9]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })

})
