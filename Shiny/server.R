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
library(DT)

# 
# # Importation des donnees
# musique <- read.csv("../musique.csv", sep=";")
# musique$music_genre <- as.factor(musique$music_genre)
# #musique$obtained_date <- as.Date(musique$obtained_date, "%d-%m") # Faut d'abord changer Apr en 04
# musique$mode <- as.factor(musique$mode)
# musique$key <- as.factor(musique$key)
# musique$instrumentalness <- as.numeric(musique$instrumentalness)
# musique$acousticness <- as.numeric(musique$acousticness)
# musique$tempo <- as.numeric(musique$tempo)
# 
# # On prend les lignes sans NA
# musique <- musique[stats::complete.cases(musique),]

# Meilleur modèle
# best_model_prediction <- lm(popularity~., data = musique)
#   # RcmdrMisc::stepwise(lm(popularity~.  + acousticness:music_genre +
#   #                          danceability:music_genre + duration_ms:music_genre +
#   #                          energy:music_genre + instrumentalness:music_genre +
#   #                          liveness:music_genre + loudness:music_genre +
#   #                          speechiness:music_genre + tempo:music_genre +
#   #                          valence:music_genre  + acousticness:mode +
#   #                          danceability:mode + duration_ms:mode + energy:mode +
#   #                          instrumentalness:mode + liveness:mode + loudness:mode +
#   #                          speechiness:mode + tempo:mode + valence:mode +
#   #                          acousticness:key + danceability:key + duration_ms:key +
#   #                          energy:key + instrumentalness:key + liveness:key +
#   #                          loudness:key + speechiness:key + tempo:key + valence:key,
#   #                        data = musique),direction = "forward/backward", criterion = "AIC",
#   #                     trace = FALSE, step = 1)
# lm(popularity~., data = musique)


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
  
  best_model_prediction <- lm(popularity ~ acousticness + danceability + duration_ms + energy + instrumentalness + liveness + loudness + speechiness + tempo + valence + acousticness:music_genre + danceability:music_genre + duration_ms:music_genre + energy:music_genre + instrumentalness:music_genre + liveness:music_genre + loudness:music_genre + speechiness:music_genre + tempo:music_genre + valence:music_genre, data = musique)
    
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
  train <-reactive({subset({musique_train()[, c("popularity", input$vars_quali, input$vars_quanti)]})})

  
  # Linear model
  
  model <- eventReactive(input$goButton,{
    
    lm(popularity~.^2, data = train())
    
  })
  
  # Linear Regression output
  output$summary_model <- renderPrint({
    input$goButton
    summary(model())
  })
  
  # RMSE
  output$rmse <- renderPrint({
    input$goButton
    paste("RMSE =",MLmetrics::RMSE(predict(model()), musique_test()$popularity)) # ajouter au shiny
  })
  
  # Datatable
  output$DataTable <- DT::renderDataTable({
    input$goButton
    
    DT::datatable(musique_test() %>% mutate(predicted = round(predict(model(), newdata = musique_test())), residuals = (popularity - predicted)) %>% select(popularity, predicted, residuals), 
                  rownames = FALSE, colnames = c('actual popularity', 'predicted popularity', 'residuals'), 
                  extensions = c('Buttons', 'Responsive'), 
                  options = list(columnDefs = list(list(className = 'dt-center', targets = "_all")), dom = 'Blfrtp', 
                                 buttons = c('copy', 'csv', 'excel', 'print'), searching = FALSE, 
                                 lengthMenu = c(20, 100, 1000, nrow(musique)), 
                                 #scrollY = 300, 
                                 scrollCollapse = TRUE
                  )) %>% DT::formatStyle(
                    'residuals',
                    backgroundColor = styleInterval(c(-20, -10, 10, 20), c("red","orange", 'green', 'orange', "red"))
                    
                  )
    
  })
  
  # Plotly Scatterplot: predicted vs actual popularity
  output$graph <- renderPlotly({
    input$goButton
    
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
    input$goButton
    
    
    plot_ly(musique_test(), x = ~round(residuals(model()),2), type = "histogram", marker = list(color = "#EA6345",
                                                                                                line = list(color = "#FFFFFF", width = 1))) %>%   layout(title = '',
                                                                                                                                                         yaxis = list(zeroline = FALSE, title = "frequency"),
                                                                                                                                                         xaxis = list(zeroline = FALSE, title = "residual",  titlefont = list(
                                                                                                                                                           family = "Lucida Console, Courier New, monospace", size = 12, color = "#FFFFFF"), 
                                                                                                                                                           tickfont = list(
                                                                                                                                                             family = "Lucida Console, Courier New, monospace", size = 10, color = "#FFFFFF"), color =  "white")) 
    
    
    
    
  })
  
  
  observeEvent(input$model_utilise, {
    shinyjs::refresh()
  })
  
  # Données de prédiction entrées par l'utilisateur
  data_pred <- reactive({data.frame(acousticness = input$Ac, danceability = input$Dan,
                                    duration_ms = input$Dur, energy = input$En,
                                    instrumentalness = input$Ins, key = input$Key,
                                    liveness = input$Live, loudness = input$Lou,
                                    mode = input$mode, speechiness = input$Spee,
                                    tempo = input$Tempo, valence = input$Val,
                                    music_genre = input$Genre)})
  
  
  
  #model_prediction <- reactive({RcmdrMisc::stepwise(model(), direction = "forward/backward", criterion = "AIC", trace = FALSE)})
  
  output$prediction <- renderPrint({paste("Prediction :",predict(model(), newdata = data_pred()))})
  
  
  # # Meilleur model
  # 
  # 
  # # Données de prédiction entrées par l'utilisateur
  data_prediction <- reactive({data.frame(acousticness = input$Ac2, danceability = input$Dan2,
                                          duration_ms = input$Dur2, energy = input$En2,
                                          instrumentalness = input$Ins2, key = input$Key2,
                                          liveness = input$Live2, loudness = input$Lou2,
                                          mode = input$mode2, speechiness = input$Spee2,
                                          tempo = input$Tempo2, valence = input$Val2,
                                          music_genre = input$Genre2)})
  
  #output$test <- renderPrint({data_prediction()})
  output$predi <- renderPrint({paste("Prediction :",predict(best_model_prediction, data_prediction()))})

  
  
})
