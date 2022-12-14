#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyServer(function(input, output) {
  
  # 1e onglet : home -----
  
  output$allthatjazz <- renderText({"All that Jazz"})
  
  # Home text outputs
  output$HomeTitle1 <- renderText({"WELCOME TO"})
  output$HomeTitle2 <- renderText({"All that Jazz"})
  
  output$HomePara = renderText({paste(read_file("Data/home.txt"))})
  output$HomePara2 = renderText({"This app is about understanding what information we can get from a small dataset (on the scale of what is used by Spotify's algorithms for example) with fairly simple methods. The objectives were: "})
  output$HomeSubt = renderText({"References"})
  output$authors = renderText({"Made by Sofia Chemolli, Léane Gernigon and Laurine Komendanczyk."})
  
  # 2e onglet : dataset description (features explanation) -----
  
  # Data description text outputs
  output$DataTitle1 <- renderText({paste("General structure of the dataset")})
  output$DataPara1 <- renderText({paste("The raw dataset has", dim0[1], "rows and ",dim0[2]," columns. Each row corresponds to a song identified by an unique id and described by features. The features are described in the table below.")})
  output$DataTitle2 <- renderText({paste("Data pre-processing")})
  output$DataPara2 <- renderText({paste("Before the start of the analysis, the dataset has been preprocessed.")})
  output$DataPara2_2 <- renderText({paste("The resulting dataset has", dim1[1], "rows and", dim1[2], "columns.")})
  output$DataTitle3 <- renderText({paste("Features description")})
  output$DataTitle4 <- renderText({paste("Summary")})
  output$dd_summary <- renderPrint({summary(musique)})
  
  output$features_info <- renderDataTable({tabfeat})
  
  # 3e onglet : visualisation graphique des données ----------
  # Histogram
  output$distPlot <- renderAmCharts({
    
    # generate bins based on input$bins from ui.R
    x    <- musique[, input$var_hist]
    bins <- trunc(seq(min(x) - 0.01, max(x) + 0.01, length.out = input$bins + 1)*100)/100 # troncature
    
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
              ylab = paste(input$var_box), xlab = "Musical genre",
              export = TRUE, zoom = TRUE)
  })
  
  
  # Scatterplot
  musique_sample <- eventReactive(input$goButton2,{musique[sample(1:nrow(musique),input$sampleSize),]})
  var_scat_x <- eventReactive(input$goButton2, {input$var_scat_x})
  var_scat_y <- eventReactive(input$goButton2, {input$var_scat_y})
  
  
  titre_scatter <- eventReactive(input$goButton2, {input$titre_scat})
  output$scatterplot <- renderPlotly({
    
    musique_sample <- musique_sample()
    ggplot(musique_sample, 
           aes(x = musique_sample[, var_scat_x()], y = musique_sample[, var_scat_y()], 
               col = musique_sample$music_genre)) + 
      geom_point(size = 0.75) +
      theme_bw() + 
      theme(legend.text = element_text(size=10),
            legend.title = element_text(size=15),
            axis.text = element_text(size=10),
            axis.title = element_text(size=10,face="bold"),
            plot.title = element_text(size=20, hjust = 0.5)) +
      labs(x = paste(var_scat_x()), y = paste(var_scat_y()), col="Music genre") +
      ggtitle(titre_scatter())
  })
  
  # cor
  output$cor <- renderText({
    # input$goButton
    paste("cor =",round(cor(musique[, var_scat_x()], musique[, var_scat_y()]),4)) # it works but it's wrong
    # paste("cor =",round(cor(musique[, var_scat_x()], musique[, var_scat_y()]),4)) # it doesn't works but it's right
  })
  
  
  # Barchart
  output$barchart <- renderPlotly({
    
    tab <- table(musique$music_genre, musique[,input$var_bar])
    
    as.data.frame(tab) %>% # must be a dataframe
      group_by(Var2) %>% 
      ggplot(aes(x = Var1, y = Freq, fill = Var2)) + 
      geom_bar(position = "dodge", stat = "identity") + 
      scale_fill_viridis_d(option = input$col_bar, end = 0.8) +
      theme_bw() + 
      theme(legend.text = element_text(size=10),
            legend.title = element_text(size=15),
            axis.text = element_text(size=10),
            axis.title = element_text(size=10,face="bold"),
            plot.title = element_text(size=20, hjust = 0.5)) +
      labs(x = "Music genre",y = "Prevalence", fill=paste(input$var_bar)) +
      ggtitle(input$titre_bar)
    
    
  })
  
  # Explication des onglets
  
  output$exp_hist <- renderText({"Choose the variable you want to represent and take a look at the distribution."})
  output$exp_box <- renderText({"Choose the variable you want to represent and take a look at the distribution according to the musical genre."})
  output$exp_scat <- renderText({"IMPORTANT: Don't forget to click \"Update\" to see the plot with the newest settings. 
    REMEMBER: If you choose the same variable for both axes, you will obtain a straight line and correlation = 1."})
  output$exp_bar <- renderText({"Representation of the musical genre distribution according to key or mode (two categorical variables of the dataset)."})
  
  
  # 4e onglet : FAMD & Song Recommendations ------
  
  res.FAMD <- FAMD(subset[,-c(1:3,16)], 
                   ncp = 4, 
                   graph = FALSE, 
                   sup.var = c("danceability", "energy", "popularity", "valence", "music_genre")
  )
  
  ### FAMD plots
  
  ## 1st plot
  color <- eventReactive(input$goButton3, {input$colorFAMD1})
  titre <- eventReactive(input$goButton3, {input$FAMD1_title})
  
  
  output$FAMD1 <- renderPlot({
    input$goButton3
    plot.FAMD(res.FAMD,invisible=c('quali','quali.sup','ind.sup'),
              select = 'all' ,
              habillage=color(),
              title= titre(),
              cex=0.85, cex.main=1.5, cex.axis=1.2)
    
  })
  
  # download 1st plot
  typedown <- eventReactive(input$goButton3, {input$type_down})
  
  output$get_the_item1 <- renderUI({
    req(input$goButton3)
    downloadButton('downFAMD1', label = 'Download the 1st plot') })
  
  output$downFAMD1 <- downloadHandler(
    
    filename =  function() {
      paste(titre(), typedown(), sep=".")
    },
    
    content = function(file) {
      if(typedown() == "jpeg")
        jpeg(file) 
      else if(typedown() == "png")
        png(file)
      else
        pdf(file) 
      
      y <- plot.FAMD(res.FAMD, invisible=c('quali','quali.sup','ind.sup'),
                     select = 'ind' ,
                     habillage=color(),
                     title= titre(),
                     cex=0.85, cex.main=1.5, cex.axis=1.2)
      print(y)
      
      dev.off()  # turn the device off
      
    } 
  )
  
  ## 2nd plot
  titre2 <- eventReactive(input$goButton3, {input$FAMD2_title})
  
  output$FAMD2 <- renderPlot(
    {# Features graph 
      plot.FAMD(res.FAMD, axes=c(1,2), choix='var',
                cex=1.15, cex.main=1.15, cex.axis=1.15, title=titre2())
    })
  
  # download 2nd plot
  output$get_the_item2 <- renderUI({
    req(input$goButton3)
    downloadButton('downFAMD2', label = 'Download the 2nd plot') })
  
  output$downFAMD2 <- downloadHandler(
    
    filename =  function() {
      paste(titre2(), typedown(), sep=".")
    },
    
    content = function(file) {
      if(typedown() == "jpeg")
        jpeg(file) 
      else if(typedown() == "png")
        png(file)
      else
        pdf(file) 
      
      y <- plot.FAMD(res.FAMD, axes=c(1,2), choix='var',
                     cex=1.15, cex.main=1.15, cex.axis=1.15, title=titre2())
      print(y)
      
      dev.off()  # turn the device off
      
    } 
  )
  
  ## 3rd plot
  titre3 <- eventReactive(input$goButton3, {input$FAMD3_title})
  
  output$FAMD3 <- renderPlot({
    # Correlation circle
    input$updatevisu
    plot.FAMD(res.FAMD, choix='quanti',title=titre3())
  })
  
  # download 3rd plot
  output$get_the_item3 <- renderUI({
    req(input$goButton3)
    downloadButton('downFAMD3', label = 'Download the 3rd plot') })
  
  output$downFAMD3 <- downloadHandler(
    
    filename =  function() {
      paste(titre3(), typedown(), sep=".")
    },
    
    content = function(file) {
      if(typedown() == "jpeg")
        jpeg(file) 
      else if(typedown() == "png")
        png(file)
      else
        pdf(file)
      
      y <- plot.FAMD(res.FAMD, choix='quanti',title=titre3())
      print(y)
      
      dev.off()  # turn the device off
      
    } 
  )
  
  output$graphAFMD = renderText("FAMD graphs with tempo, mode, key, loudness, liveness, instrumentalness, speechiness, acousticness and duration as active variables. The tracks on the first graph can be colored according to the variable. Make your choice on the side panel. IMPORTANT: You need to click \"Update\" to see graphs in the first place or to update them.")
  output$eigenvalues = renderText({paste("Eigenvalues of the FAMD. See Details tab to learn more about the FAMD tuning.")})
  output$featuresFAMD = renderText({paste("Coordinates, contribution and cos² for each feature and dimension. See Details tab to learn more about the FAMD tuning.")})
  output$recomdt = renderText({paste("In this tab, choose a song from the list and get recommended a few others that you might like as well. See Details tab to learn more about the FAMD tuning.")})
  
  ## Recommendation tab
  
  output$artist_genre <- renderUI({
    selectInput(inputId = "artist_reco", 
                label = "Filter by artist", 
                choices = c(subset[which (subset$music_genre %in% input$genre_reco),]$artist_name))
  })
  
  output$choose_song <- renderUI({
    selectInput(inputId = "song_to_reco", 
                label = "Choose the song to iniate a recommendation", 
                choices = c(subset[which (subset$artist_name %in% input$artist_reco),]$track_name))
  })
  
  output$your_song <- renderText({paste("Your choice: ", input$song_to_reco, "by", input$artist_reco)})
  output$song_recos_subtitle <- renderText("Our Music Recommendations")   
  
  
  reco10 <- reactive({
    coord.tmp <- data.frame(cbind(id = as.character(subset$instance_id),
                                  res.FAMD$ind$coord))
    
    coord.tmp <- cbind(coord.tmp,
                       track_name = subset$track_name, 
                       artist_name = subset$artist_name,
                       genre = subset$music_genre)
    
    id <- song_id(track = input$song_to_reco, artist = input$artist_reco)
    
    dist_vec <- c()
    for (k in coord.tmp$id){
      dist_vec <- c(dist_vec, eucl_dist(id, k, coord.tmp))
    }
    
    coord.tmp <- cbind(coord.tmp, dist = dist_vec)
    coord.tmp = arrange(coord.tmp, dist)
    reco10 = coord.tmp[2:(input$nb_recos+1),-(2:5)]
    
    
  })
  
  output$finalrecos <- renderDataTable({
    datatable(reco10(),
              rownames = F,
              extensions = c('Buttons', 'Responsive'), 
              options = list(columnDefs = list(list(className = 'dt-center', targets = "_all")), dom = 'Blfrtp', 
                             buttons = c('copy', 'csv', 'excel', 'print'), searching = FALSE, 
                             scrollCollapse = TRUE
              )
    )
  })
  
  
  ## FAMD Details tab 
  
  output$FAMD_details0 = renderText({paste(read_file("Data/FAMD_details0.txt"))})
  output$FAMD_details1 = renderText({paste(read_file("Data/FAMD_details1.txt"))})
  output$FAMD_details2 = renderText({paste(read_file("Data/FAMD_details2.txt"))})
  output$FAMD_details3 = renderText({paste(read_file("Data/FAMD_details3.txt"))})
  
  
  # 5e onglet : prediction with linear regression model ------
  
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
    paste("RMSE =",round(MLmetrics::RMSE(predict(model()), musique_test()$popularity),2)) # ajouter au shiny
  })
  
  # Datatable
  output$DataTable <- DT::renderDataTable({
    input$goButton
    
    DT::datatable(musique_test() %>% mutate(predicted = round(predict(model(), newdata = musique_test())), residuals = (popularity - predicted)) %>% select(artist_name, track_name, popularity, predicted, residuals), 
                  rownames = FALSE, colnames = c("artist name", "track name",'actual popularity', 'predicted popularity', 'residuals'), 
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
      
      add_lines(y = ~popularity, color = I("black"),
                marker = list(size=1, color="black", line = list(color = 'black', 
                                                                 width = 0))) %>%
      layout(title = '',
             yaxis = list(zeroline = FALSE, title = "predicted popularity"),
             xaxis = list(zeroline = FALSE, title = "actual popularity"),
             showlegend=F)
    
    
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
  
  # eigen values 
  output$eig <- renderPrint(res.FAMD$eig)
  
  # features info 
  output$var <- renderPrint(res.FAMD$var)
  
  # Données de prédiction entrées par l'utilisateur
  data_pred <- reactive({data.frame(acousticness = input$Ac, danceability = input$Dan,
                                    duration_ms = input$Dur, energy = input$En,
                                    instrumentalness = input$Ins, key = input$Key,
                                    liveness = input$Live, loudness = input$Lou,
                                    mode = input$mode, speechiness = input$Spee,
                                    tempo = input$Tempo, valence = input$Val,
                                    music_genre = input$Genre)})
  
  
  output$prediction0 <- renderText({paste(round(predict(model(), newdata = data_pred())),"/ 100")})
  output$prediction <- renderText({paste("The predicted popularity of a song with these characteristics using the model choosen in the left side panel is", round(predict(model(), newdata = data_pred())),"out of 100 (100 being the best grade possible). Update your song's features or the model to see how the popularity evolves! ")})
  
  # Explication des sous-onglets
  
  output$exp_pred <- renderText({"You have an idea for a future song? Let's try to predict its popularity! 
      "})
  output$pop_subtitle <- renderText({"Popularity predicted by the model"})
  output$datatable <- renderText({"Compare the actual value of popularity with the one predicted by the model, and get an insight of the difference between the two.
      "})
  output$graph_pred <- renderText({"Graph representing predicted popularity according to the actual popularity of the song."})
  
  output$datatble2 <- renderText({"Color code"})
  
  output$graph_res <- renderText({"Repartition of the difference between prediction and actual value of popularity"})
  
  output$summary <- renderText({"Summary of the model selected on the left side panel. IMPORTANT: Don't forget to click \"Update\" once you're done tuning the model!"})
  
})