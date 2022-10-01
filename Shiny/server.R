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
  # Histogram
  output$distPlot <- renderAmCharts({
    
    # generate bins based on input$bins from ui.R
    x    <- musique[, input$var_hist]
    bins <- trunc(seq(min(x), max(x) + 0.01, length.out = input$bins + 1)*100)/100 # troncature
    
    # use amHist
    
    amHist(x = x, control_hist = list(breaks = bins), 
           col = input$color_hist, border = "FFFFFF", main = input$titre_hist, 
           ylab = "Frequency", xlab = paste(input$var_hist),
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
    
    set.seed(1234)
    musique_sample <- musique[sample(1:nrow(musique),input$sampleSize),]
    
    plot(musique_sample[, input$var_scat_x], musique_sample[, input$var_scat_y], 
         col = musique_sample$music_genre,
         xlab = paste(input$var_scat_x), ylab=paste(input$var_scat_y),
         pch=19, main = input$titre_scat)
    legend(input$legend_pos,levels(musique_sample$music_genre),
           col = musique_sample$music_genre, pch=19, cex=input$legend_size,bty="n")
    
  })
  
  # Barchart
  output$barchart <- renderPlot({
    
    tab <- table(musique$music_genre, musique[,input$var_bar])
    
    as.data.frame(tab) %>% # must be a dataframe
      group_by(Var2) %>% 
      ggplot(aes(x = Var1, y = Freq, fill = Var2)) + 
      geom_bar(position = "dodge", stat = "identity") + 
      scale_fill_viridis_d(option = input$col_bar, end = 0.8) +
      theme_bw() + 
      labs(x = "Music genre",y = "Prevalence") +
      ggtitle(input$titre_bar)
    
  })
  
})
