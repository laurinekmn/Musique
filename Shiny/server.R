#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$allthatjazz <- renderText({"All that Jazz"})
  
  # Home text outputs
  output$HomeTitle1 <- renderText({"WELCOME TO"})
  output$HomeTitle2 <- renderText({"All that Jazz"})

  # Data description text outputs
  output$VisuTitle1 <- renderText({paste("General structure of the dataset")})
  output$VisuPara1 <- renderText({paste("This dataset has xx lines and yy columns. Each line corresponds to a song identified by an unique id and described by features. The features are described below.")})
  output$VisuTitle2 <- renderText({paste("Data pre-processing")})
  output$VisuPara2 <- renderText({paste("Before the start of the analysis, the dataset has been preprocessed.")})
  
  # Visualisation 
  output$distPlot <- renderAmCharts({

    # generate bins based on input$bins from ui.R
    x    <- musique[, input$var]
    bins <- trunc(seq(min(x), max(x) + 0.01, length.out = input$bins + 1)*100)/100 # troncature

    # use amHist

    amHist(x = x, control_hist = list(breaks = bins), 
           col = input$color, border = "FFFFFF", main = input$titre, ylab = "Frequency",
           export = TRUE, zoom = TRUE)
  })
  
  
  # FAMD & Recommendations
 
  # Subset: 10% of each music_genre 
  subset <- musique %>% 
    group_by(music_genre) %>%
    sample_frac(size = 0.10, replace = FALSE)
  
  #FAMD on subset
  res.FAMD <- FAMD(subset[,-c(1:3,16)], 
                   ncp = 4, 
                   graph = FALSE, 
                   sup.var = c("danceability", "energy", "popularity", "valence", "music_genre")
  )
  
  # colFAMD1 <- match(colnames(subset[,-c(1:3,16)]), input$colorFAMD1)
  
  output$FAMD1 <- renderPlot({
    plot.FAMD(res.FAMD,invisible=c('quali','quali.sup','ind.sup'),
              select = 'all' ,
              habillage=7,
              title= input$FAMD1_title,
              cex=0.85,cex.main=0.85,cex.axis=0.85)
    
    
  })
  
  output$FAMD2 <- renderPlot(
    {# Features graph 
      plot.FAMD(res.FAMD,axes=c(1,2),choix='var',cex=1.15,cex.main=1.15,cex.axis=1.15,title=input$FAMD2_title)
    })
  
  output$FAMD3 <- renderPlot({
    # Correlation circle 
    plot.FAMD(res.FAMD, choix='quanti',title=input$FAMD3_title)
  })
  
  

})
