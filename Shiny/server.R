#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(dplyr)

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
  
  output$distPlot <- renderAmCharts({

    # generate bins based on input$bins from ui.R
    x    <- musique[, input$var]
    bins <- trunc(seq(min(x), max(x) + 0.01, length.out = input$bins + 1)*100)/100 # troncature

    # use amHist

    amHist(x = x, control_hist = list(breaks = bins), 
           col = input$color, border = "FFFFFF", main = input$titre, ylab = "Frequency",
           export = TRUE, zoom = TRUE)
  })
  
  # Split train test
  
   musique_train <- reactive(subset({musique %>% dplyr::sample_frac(input$TrainTest/100)}))
   musique_test <- reactive(subset({dplyr::anti_join(musique, musique_train())}))
   
  
  # Linear model

  model <- reactive({
    vars_quanti <- as.matrix(musique_train()[, input$vars_quanti])
    vars_quali <- as.matrix(musique_train()[, input$vars_quali])
    if (!is.null(input$vars_quali)){
      if (!is.null(input$vars_quanti)){
        lm(popularity~vars_quanti + vars_quali + vars_quanti:vars_quali, data = musique_train())
      }else{
        lm(popularity~ vars_quali, data = musique_train())
      }
    }else{
      lm(popularity~vars_quanti, data = musique_train())
    }
  })
  
  # Linear Regression output
  output$summary_model <- renderPrint({
    summary(model())
  })
  
  # Datatable
  output$DataTable <- DT::renderDataTable({
    
    DT::datatable(musique_test() %>% mutate(predicted = round(predict(model())), residuals = round(residuals(model()))) %>% select(popularity, predicted, residuals), 
                  rownames = FALSE, colnames = c('actual popularity', 'predicted popularity', 'residuals'), 
                  extensions = c('Buttons', 'Responsive'), 
                  options = list(columnDefs = list(list(className = 'dt-center', targets = "_all")), dom = 'Blfrt', 
                                 buttons = c('copy', 'csv', 'excel', 'print'), searching = FALSE, 
                                 lengthMenu = c(20, 100, 1000, nrow(musique)), 
                                 #scrollY = 300, 
                                 scrollCollapse = TRUE
                                 )) %>% formatStyle(
                                   'residuals',
                                   backgroundColor = styleInterval(c(-20, -10, 10, 20), c("red","orange", 'green', 'orange', "red"))
                                   #color = styleInterval(c(1,2), c('black', 'white', "white"))
                                 )
    
  })
  
  # Plotly Scatterplot: predicted vs actual popularity
  output$graph <- renderPlotly({
    
    plot_ly(data = musique_test(), y = ~predict(model(), newdata = musique_test()), x = ~popularity,
            type = "scatter", mode = "markers",
            marker = list(size = 5,
                          color = '#FFFFFF',
                          line = list(color = '#EA6345', 
                                      width = 2))) %>% 

      layout(title = '',
             yaxis = list(zeroline = FALSE, title = "predicted popularity"),
             xaxis = list(zeroline = FALSE, title = "actual popularity"))
      
    
  })
  
  # Plotly Histogram of residuals
  output$graph_residual <- renderPlotly({
    
    
    plot_ly(musique_test(), x = ~round(residuals(model()),2), type = "histogram", marker = list(color = "#EA6345",
                                                                                          line = list(color = "#FFFFFF", width = 1))) %>%   layout(title = '',
                                                                                                                                                   yaxis = list(zeroline = FALSE, title = "frequency"),
                                                                                                                                                   xaxis = list(zeroline = FALSE, title = "residual",  titlefont = list(
                                                                                                                                                     family = "Lucida Console, Courier New, monospace", size = 12, color = "#FFFFFF"), 
                                                                                                                                                     tickfont = list(
                                                                                                                                                       family = "Lucida Console, Courier New, monospace", size = 10, color = "#FFFFFF"), color =  "white")) 

    
    
  })
  
  
  
  
  
})
