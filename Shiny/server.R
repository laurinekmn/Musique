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
  
  #split <- reactive({sample(nrow(musique), round(nrow(musique)*input$TrainTest/100), replace = FALSE)})
  # musique_train <- reactive({musique %>% dplyr::sample_frac(input$TrainTest/100)})
  # musique_test <- reactive({dplyr::anti_join(musique, musique_train)})
  
  
  # Linear model
  # model <- reactive({
  #    #vars <- as.matrix(musique[, input$Var_quanti])
  #   # vars_quali <- as.matrix(musique[, input$Var_quali])
  #   # lm(popularity~vars:vars_quali, data = musique)
  #   vars <- as.matrix(musique[, input$vars_model])
  #   lm(popularity~vars, data = musique)
  # })
  model <- reactive({
    # vars <- as.matrix(musique[, input$vars_model])
    # lm(popularity~vars, data = musique)
    vars_quanti <- as.matrix(musique[, input$vars_quanti])
    vars_quali <- as.matrix(musique[, input$vars_quali])
    if (!is.null(input$vars_quali)){
      if (!is.null(input$vars_quanti)){
        lm(popularity~vars_quanti + vars_quali + vars_quanti:vars_quali, data = musique)
      }else{
        lm(popularity~ vars_quali, data = musique)
      }
    }else{
      lm(popularity~vars_quanti, data = musique)
    }
  })
  
  # Linear Regression output
  output$summary_model <- renderPrint({
    summary(model())
  })
  
  # Datatable
  output$DataTable <- DT::renderDataTable({
    
    DT::datatable(musique %>% mutate(predicted = round(predict(model())), residuals = round(residuals(model()))) %>% select(popularity, predicted, residuals), 
                  rownames = FALSE, colnames = c('actual popularity', 'predicted popularity', 'residuals'), 
                  #extensions = c('Buttons', 'Responsive'), 
                  options = list(columnDefs = list(list(className = 'dt-center', targets = "_all")), dom = 'Blfrt', 
                                 buttons = c('copy', 'csv', 'excel', 'print'), searching = FALSE, 
                                 lengthMenu = c(20, 100, 1000, nrow(musique)), 
                                 #scrollY = 300, 
                                 scrollCollapse = TRUE
                                 )) 
    
  })
  
  # Plotly Scatterplot: predicted vs actual popularity
  output$graph <- renderPlotly({
    
    plot_ly(data = musique, y = ~predict(model()), x = ~popularity,
            type = "scatter", mode = "markers",
            marker = list(size = 5,
                          color = '#FFFFFF',
                          line = list(color = '#EA6345', 
                                      width = 2))) %>% 
      # layout(title = '',
      #        yaxis = list(zeroline = FALSE, title = "predicted popularity", titlefont = list(
      #          family = "Lucida Console, Courier New, monospace", size = 12, color = "#FFFFFF"), tickfont = list(
      #            family = "Lucida Console, Courier New, monospace", size = 10, color = "#FFFFFF"), color =  "white", size = 2),
      #        xaxis = list(zeroline = FALSE, title = "actual popularity", titlefont = list(
      #          family = "Lucida Console, Courier New, monospace", size = 12, color = "#FFFFFF"), tickfont = list(
      #            family = "Lucida Console, Courier New, monospace", size = 10, color = "#FFFFFF"), color =  "white", size = 7)) %>%
      # layout(plot_bgcolor='#678EB9', paper_bgcolor='#678EB9')
      layout(title = '',
             yaxis = list(zeroline = FALSE, title = "predicted popularity"),
             xaxis = list(zeroline = FALSE, title = "actual popularity"))
      
    
  })
  
  # Plotly Histogram of residuals
  output$graph_residual <- renderPlotly({
    
    
    plot_ly(musique, x = ~round(residuals(model()),2), type = "histogram", marker = list(color = "#EA6345",
                                                                                          line = list(color = "#FFFFFF", width = 1))) %>%   layout(title = '',
                                                                                                                                                   yaxis = list(zeroline = FALSE, title = "frequency"),
                                                                                                                                                   xaxis = list(zeroline = FALSE, title = "residual",  titlefont = list(
                                                                                                                                                     family = "Lucida Console, Courier New, monospace", size = 12, color = "#FFFFFF"), 
                                                                                                                                                     tickfont = list(
                                                                                                                                                       family = "Lucida Console, Courier New, monospace", size = 10, color = "#FFFFFF"), color =  "white")) #%>%
      #layout(plot_bgcolor='#678EB9', paper_bgcolor='#678EB9')
    
    
  })
  
  
  
  
  
})
