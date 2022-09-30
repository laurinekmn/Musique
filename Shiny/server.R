#### FUNZIONA

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Importation des donnees
  musique <- read.csv("../musique.csv", sep=";")
  musique$music_genre <- as.factor(musique$music_genre)
  #musique$obtained_date <- as.Date(musique$obtained_date, "%d-%m") # Faut d'abord changer Apr en 04
  musique$mode <- as.factor(musique$mode)
  musique$key <- as.factor(musique$key)
  musique$instrumentalness <- as.numeric(musique$instrumentalness)
  musique$acousticness <- as.numeric(musique$acousticness)
  musique$tempo <- as.numeric(musique$tempo)
  
  # On prend les lignes sans NA
  musique <- musique[stats::complete.cases(musique),]
  
  # Histogram
  output$distPlot <- renderAmCharts({

    # generate bins based on input$bins from ui.R
    x    <- musique[, input$var_hist]
    bins <- trunc(seq(min(x), max(x) + 0.01, length.out = input$bins + 1)*100)/100 # troncature

    # use amHist

    amHist(x = x, control_hist = list(breaks = bins), 
           col = input$color_hist, border = "FFFFFF", main = input$titre_hist, ylab = "Frequency",
           export = TRUE, zoom = TRUE)
  })
  
  # Boxplot
  output$boxplot <- renderAmCharts({
    
    amBoxplot(object = as.formula(paste(input$var_box, "~ music_genre")),
              data = musique,
           col = input$color_box, border = "FFFFFF", main = input$titre_box,
           export = TRUE, zoom = TRUE)
  })
  
  # Scatterplot
  output$scatterplot <- renderPlot({
    
    
    
  })
  
  # Barchart
  output$barchart <- renderPlot({
    
  })

})
