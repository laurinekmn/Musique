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
  output$DataTitle1 <- renderText({paste("General structure of the dataset")})
  output$DataPara1 <- renderText({paste("The raw dataset has", dim0[1], "rows and ",dim0[2]," columns. Each row corresponds to a song identified by an unique id and described by features. The features are described in the table below.")})
  output$DataTitle2 <- renderText({paste("Data pre-processing")})
  output$DataPara2 <- renderText({paste("Before the start of the analysis, the dataset has been preprocessed.")})
  output$DataPara2_2 <- renderText({paste("The resulting dataset has", dim1[1], "rows and", dim1[2], "columns.")})
  output$DataTitle3 <- renderText({paste("Features description")})
  
  
  output$features_info <- renderDataTable({tabfeat})
  
  
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
  
  # colFAMD1 <- match(input$colorFAMD1, colnames(subset[,-c(1:3,16)]))
  
  output$FAMD1 <- renderPlot({
    input$updatevisu
    plot.FAMD(res.FAMD,invisible=c('quali','quali.sup','ind.sup'),
              select = 'all' ,
              habillage=7,
              title= input$FAMD1_title,
              cex=0.85,cex.main=0.85,cex.axis=0.85)
    
    
  })
  
  output$FAMD2 <- renderPlot(
    {# Features graph 
      input$updatevisu
      plot.FAMD(res.FAMD,axes=c(1,2),choix='var',cex=1.15,cex.main=1.15,cex.axis=1.15,title=input$FAMD2_title)
    })
  
  output$FAMD3 <- renderPlot({
    # Correlation circle
    input$updatevisu
    plot.FAMD(res.FAMD, choix='quanti',title=input$FAMD3_title)
  })
  
  # eigen values 
  output$eig <- renderPrint(res.FAMD$eig)
  
  # features info 
  output$var <- renderPrint(res.FAMD$var)
  # 
  # # info 
  # 
  # txt <- read.table("Data/testdoc.txt")

})
