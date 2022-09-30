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
library(shinyPredict)

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
   train <-reactive({subset({musique_train()[, c("popularity", input$vars_quali, input$vars_quanti)]})})
  
  # Linear model
   
   
   #vars_quanti <- reactive({as.matrix(musique[, input$vars_quanti])})
   #vars_quali <- reactive({as.matrix(musique[, input$vars_quali])})

  model <- reactive({
    # vars_quanti <- as.matrix(musique_train()[, input$vars_quanti])
    # vars_quali <- as.matrix(musique_train()[, input$vars_quali])
    # vars_quanti <- input$vars_quanti
    # vars_quali <- input$vars_quali
    # if (!is.null(input$vars_quali)){
    #   if (!is.null(input$vars_quanti)){
        
        lm(popularity~.^2, 
           data = train())
    #   }else{
    #     lm(popularity~ vars_quali, data = musique_train())
    #   }
    # }else{
    #   lm(popularity~vars_quanti, data = musique_train())
    #}
  })
  
  # Linear Regression output
  output$summary_model <- renderPrint({
    summary(model())
  })
  
  # RMSE
  output$rmse <- renderPrint({
    paste("RMSE =",MLmetrics::RMSE(predict(model()), musique_test()$popularity)) # ajouter au shiny
  })
  
  # Datatable
  output$DataTable <- DT::renderDataTable({
    
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
  
  
  observeEvent(input$model_utilise, {
    shinyjs::refresh()
  })
  
  # Données de prédiction entrées par l'utilisateur
  # output$data_pred <- renderDataTable({data.frame(acousticness = input$Ac, danceability = input$Dan,
  #                                      duration_ms = input$Dur, energy = input$En,
  #                                      instrumentalness = input$Ins, key = input$Key,
  #                                      liveness = input$Live, loudness = input$Lou,
  #                                      mode = input$mode, speechness = input$Spee,
  #                                      tempo = input$Tempo, valence = input$Val,
  #                                      music_genre = input$Genre, replace = TRUE)})
  data_pred <- reactive({data.frame(acousticness = input$Ac, danceability = input$Dan,
                                    duration_ms = input$Dur, energy = input$En,
                                    instrumentalness = input$Ins, key = input$Key,
                                    liveness = input$Live, loudness = input$Lou,
                                    mode = input$mode, speechiness = input$Spee,
                                                  tempo = input$Tempo, valence = input$Val,
                                                  music_genre = input$Genre)})
  
  # data_pred <- reactive({
  #   vars_quanti <- as.matrix(acousticness = input$Ac, danceability = input$Dan,
  #                            duration_ms = input$Dur, energy = input$En,
  #                            instrumentalness = input$Ins,
  #                            liveness = input$Live, loudness = input$Lou,
  #                            speechiness = input$Spee,
  #                            tempo = input$Tempo, valence = input$Val)
  #   vars_quali <- as.matrix(mode = input$mode, 
  #                           key = input$Key,
  #                           music_genre = input$Genre)
  # })
  
  
  mod <- reactive({
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
   
  model_prediction <- reactive({RcmdrMisc::stepwise(mod, direction = "forward/backward", criterion = "AIC", trace = FALSE)})
  # 
  # output$prediction <- renderPrint({predict(model_prediction(), data_pred())})
  output$prediction <- renderPrint({predict(mod(), newdata = data_pred())})
  #output$test <- renderPrint({data_pred()})
  #output$test <- renderDataTable({data_pred()})
  
  # Meilleur model
  
  # best_model_prediction <- reactive({RcmdrMisc::stepwise(lm(popularity~. + acousticness:music_genre +
  #                                   danceability:music_genre + duration_ms:music_genre +
  #                                   energy:music_genre + instrumentalness:music_genre +
  #                                   liveness:music_genre + loudness:music_genre +
  #                                   speechiness:music_genre + tempo:music_genre +
  #                                   valence:music_genre  + acousticness:mode +
  #                                   danceability:mode + duration_ms:mode + energy:mode +
  #                                   instrumentalness:mode + liveness:mode + loudness:mode +
  #                                   speechiness:mode + tempo:mode + valence:mode +
  #                                   acousticness:key + danceability:key + duration_ms:key +
  #                                   energy:key + instrumentalness:key + liveness:key +
  #                                   loudness:key + speechiness:key + tempo:key + valence:key,
  #                                 data = musique[c(4:9, 11:12, 14:15, 17, 10, 13, 18)]),
  #                              direction = "forward/backward", criterion = "AIC",
  #                              trace = FALSE, step = 15)
  #   })
  output$test <- renderPrint({train()})
  # output$predi <- renderPrint({predict(best_model_prediction(), data_pred())})
  output$predi <- renderPrint({predict(mod())})
  
  
})
