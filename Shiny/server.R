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
  
  output$HomePara = renderText({paste(read_file("Data/home.txt"))})
  
  
  # Data description text outputs
  output$DataTitle1 <- renderText({paste("General structure of the dataset")})
  output$DataPara1 <- renderText({paste("The raw dataset has", dim0[1], "rows and ",dim0[2]," columns. Each row corresponds to a song identified by an unique id and described by features. The features are described in the table below.")})
  output$DataTitle2 <- renderText({paste("Data pre-processing")})
  output$DataPara2 <- renderText({paste("Before the start of the analysis, the dataset has been preprocessed.")})
  output$DataPara2_2 <- renderText({paste("The resulting dataset has", dim1[1], "rows and", dim1[2], "columns.")})
  output$DataTitle3 <- renderText({paste("Features description")})
  output$dd_summary <- renderPrint({summary(musique)})
  
  output$features_info <- renderDataTable({tabfeat})
  
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
  musique_sample <- eventReactive(input$goButton2,{musique[sample(1:nrow(musique),input$sampleSize),]})
  var_scat_x <- eventReactive(input$goButton2, {input$var_scat_x})
  var_scat_y <- eventReactive(input$goButton2, {input$var_scat_y})
  
  output$scatterplot <- renderPlot({
    #input$goButton2
    #set.seed(1234)
    musique_sample <- musique_sample()
    #musique_sample <- eventReactive(input$goButton2,{musique[sample(1:nrow(musique),input$sampleSize),]})
    plot(musique_sample[, var_scat_x()], musique_sample[, var_scat_y()], 
         col = musique_sample$music_genre,
         xlab = paste(var_scat_x()), ylab=paste(var_scat_y()),
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
      ggtitle(input$titre_bar)+ labs(fill = Vars2)
    
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
  
  color <- eventReactive(input$goButton3, {input$colorFAMD1})
  titre <- eventReactive(input$goButton3, {input$FAMD1_title})
  output$FAMD1 <- renderPlot({
    input$goButton3
    #input$updatevisu
    plot.FAMD(res.FAMD,invisible=c('quali','quali.sup','ind.sup'),
              select = 'all' ,
              habillage=color(),
              title= titre(),
              cex=0.85,cex.main=0.85,cex.axis=0.85)
    
    
  })
  output$eigenvalues = renderText({paste("Eigenvalues of the FAMD. See Details tab to learn more about the FAMD tuning.")})
  output$featuresFAMD = renderText({paste("Coordinates, contribution and cos² for each feature and dimension. See Details tab to learn more about the FAMD tuning.")})
  output$recomdt = renderText({paste("In this tab, choose a song from the list and get recommended a few others that you might like as well. See Details tab to learn more about the FAMD tuning.")})
 
  output$FAMD_details = renderText({paste(read_file("Data/FAMD_details.txt"))})
  
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
    output$rmse <- renderText({
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
    
    titre2 <- eventReactive(input$goButton3, {input$FAMD2_title})
    output$FAMD2 <- renderPlot(
      {# Features graph 
        #input$updatevisu
        plot.FAMD(res.FAMD,axes=c(1,2),choix='var',cex=1.15,cex.main=1.15,cex.axis=1.15,title=titre2())
      })
    
    titre3 <- eventReactive(input$goButton3, {input$FAMD3_title})
    output$FAMD3 <- renderPlot({
      # Correlation circle
      input$updatevisu
      plot.FAMD(res.FAMD, choix='quanti',title=titre3())
    })
    
    # eigen values 
    output$eig <- renderPrint(res.FAMD$eig)
    
    # features info 
    output$var <- renderPrint(res.FAMD$var)
    # 
    # # info 
    # 
    # txt <- read.table("Data/testdoc.txt")
    
    
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
    
    
    #best_model_prediction <- lm(popularity ~ acousticness + danceability + duration_ms + energy + instrumentalness + liveness + loudness + speechiness + tempo + valence + acousticness:music_genre + danceability:music_genre + duration_ms:music_genre + energy:music_genre + instrumentalness:music_genre + liveness:music_genre + loudness:music_genre + speechiness:music_genre + tempo:music_genre + valence:music_genre, data = musique)
    #model_prediction <- reactive({RcmdrMisc::stepwise(model(), direction = "forward/backward", criterion = "AIC", trace = FALSE)})
    
    output$prediction <- renderText({paste("Prediction :",predict(model(), newdata = data_pred()))})
    
    
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
    output$predi <- renderText({paste("Prediction :",predict(best_model_prediction, data_prediction()))})
    
    # Explication des onglets
    
    output$exp_pred <- renderText({"You have an idea for a new song ? Let's try to predict the popularity of your future song !
      You can choose to predict it thanks to the variables you have selected or the variables of the best model (à définir)"})
    
    output$datatable <- renderText({"Compare the actual value of popularity to the one predicted and the différence between the two of them.
      "})
    output$datatble2 <- renderText({"Color code : "})
    
    output$graph_res <- renderText({"Repartition of the difference between prediction and actual value of popularity"})
    
    output$summary <- renderText({"Summary of the model selected on the panel on the right. Do not forget to update the view to have the information. "})
  
    output$graph_pred <- renderText({"Representation of the actual and predicted value of popularity with the selected model."})
    
  })
  
#})