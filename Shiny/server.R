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

})
