#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  theme = bs_theme(version = 4, 
                   bootswatch = "minty", 
                   bg = "GhostWhite", 
                   fg = "Teal"),
  
  # Application title
  #titlePanel("Musique"),
  navbarPage(textOutput('allthatjazz'),
             tags$head(tags$style("#allthatjazz{color : black;
                                                    font-size: 16px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    letter-spacing: 2px;
                                                    text-align: center;
                                                    }"
             )
             ),
             
             
             #1e onglet : 
             tabPanel(icon=icon("home"), 'Home',
                      fluidRow(
                        column(width=2), 
                        column(width = 8,
                               br(),
                               textOutput('HomeTitle1'),
                               tags$head(tags$style("#HomeTitle1{color : black;
                                                    font-size: 13px;
                                                    font-family: Arial,serif;
                                                    font-style: bold;
                                                    letter-spacing: 3px;
                                                    text-align: center;
                                                    }"
                               )
                               ),
                               textOutput('HomeTitle2'),
                               tags$head(tags$style("#HomeTitle2{color: 1d3624;
                                                    font-size: 44px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    text-align: center;
                                                    }"
                               )
                               ), 
                               br(),
                               br(), 
                               textOutput("HomePara"), 
                               tags$head(tags$style("#HomePara{color: black;
                                                    font-size: 18px;
                                                    font-family: Arial,serif;
                                                    font-style: normal;
                                                    text-align: justified;
                                                    }"
                               )
                               
                               #titlePanel("Bibliography"),
                               ),
                               br(),
                               a(href="https://www.midiaresearch.com/blog/music-subscriber-market-shares-q2-2021", 
                                 target="_blank",
                                 "Music suscriber market shares Q2 2021 - Midia Research Article"),
                               br(),
                               a(href="https://www.youtube.com/watch?v=O_2oDXw9Rps&ab_channel=FullStackCreative", 
                                 target="_blank",
                                 "How the Spotify Algorithm actually works - Youtube video")
                               
                               
                        
                               
                               
                               
                        ), 
                        column(width = 2)
                        
                      )),
             # 2e onglet : dataset description (features explanation)
             tabPanel("Data description", 
                      fluidRow(
                        column(width=3, 
                               wellPanel(
                                 titlePanel("Bibliography"), 
                                 a(href=" https://developer.spotify.com/documentation/web-api/reference/#/operations/get-several-audio-features",
                                   target="_blank",
                                   "Spotify for Developers website"),
                                 br(),
                                 a(href="https://www.kaggle.com/datasets/vicsuperman/prediction-of-music-genre?select=music_genre.csv", 
                                   target="_blank",
                                   "Music Dataset on Kaggle")
                                 
                               )
                        ),
                        column(width = 8,
                               textOutput('DataTitle1'),
                               tags$head(tags$style("#DataTitle1{color : 1d3624;
                                                    font-size: 28px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    }"
                               )
                               ),
                               br(),
                               textOutput('DataPara1'),
                               tags$head(tags$style("#DataPara1{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }"
                               )
                               ),
                               br(),
                               textOutput('DataTitle2'),
                               tags$head(tags$style("#DataTitle2{color : 1d3624;
                                                    font-size: 28px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    }"
                               )
                               ), 
                               br(),
                               textOutput('DataPara2'),
                               tags$head(tags$style("#DataPara2{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }")),
                               tags$ul(
                                 tags$li("Rows with NAs were removed",
                                         # tags$style("{color: black;
                                         #            font-size: 18px;
                                         #            font-family: Arial,sans-serif;
                                         #            font-style: normal;
                                         #            }"
                                         #   
                                         # )
                                 ),
                                 tags$li("Mode, key, danceability, energy, popularity and valence were converted as factor"),
                                 tags$li("Other features were considered as numeric"), 
                                 
                                 
                               ),
                               textOutput('DataPara2_2'),
                               tags$head(tags$style("#DataPara2_2{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }"
                               )
                               ), 
                               br(),
                               textOutput('DataTitle3'),
                               tags$head(tags$style("#DataTitle3{color : 1d3624;
                                                    font-size: 28px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    }"
                               )
                               ),
                               
                               dataTableOutput("features_info"), 
                               verbatimTextOutput("dd_summary")
                        ), 
                        column(width = 1)
                      )
             ),
             
             # 3e onglet : visualisation graphique des données
             navbarMenu("Visualization",
                        
                        tabPanel("Histogram", 
                                 
                                 fluidRow(
                                   # premier colonne
                                   column(width = 3, 
                                          # wellPanel pour griser
                                          wellPanel(
                                            titlePanel("Histogram editing"),
                                            sliderInput("bins",
                                                        "Number of bins:",
                                                        min = 1,
                                                        max = 50,
                                                        value = 30),
                                            
                                            # input pour la couleur
                                            colourInput(inputId = "color_hist", label = "Color:", value = "2E56AB"), 
                                            
                                            # titre du graphique
                                            textInput(inputId = "titre_hist", label = "Main title:", value = "Histogram"),
                                            
                                            # selection de la colonne
                                            radioButtons(inputId = "var_hist", label = "Feature: ", choices = colnames(musique)[c(4:9, 11:12, 14:15, 17)])
                                          )
                                   ), 
                                   # deuxieme colonne
                                   column(width = 9, 
                                          #tabsetPanel(
                                          tabPanel("Histogram", 
                                                   # plotOutput -> amChartsOutput
                                                   amChartsOutput("distPlot"),
                                                   # classes (div centrée)
                                                   div(textOutput("n_bins"), align = "center")
                                          )
                                          #)
                                   )
                                 )),
                        
                        tabPanel("Boxplot", 
                                 
                                 fluidRow(
                                   # premier colonne
                                   column(width = 3, 
                                          # wellPanel pour griser
                                          wellPanel(
                                            titlePanel("Boxplot editing"),
                                            
                                            # input pour la couleur
                                            colourInput(inputId = "color_box", label = "Color:", value = "2E56AB"),
                                            
                                            # titre du graphique
                                            textInput(inputId = "titre_box", label = "Main title:", value = "Boxplot"),
                                            
                                            # selection de la colonne
                                            radioButtons(inputId = "var_box", label = "Feature: ", choices = colnames(musique)[c(4:9, 11:12, 14:15, 17)])
                                          )
                                   ), 
                                   # deuxieme colonne
                                   column(width = 9, 
                                          #tabsetPanel(
                                          tabPanel("Boxplot", 
                                                   # plotOutput -> amChartsOutput
                                                   amChartsOutput("boxplot")
                                          )
                                          #)
                                   )
                                 )),
                        
                        tabPanel("Scatterplot",
                                 fluidRow(
                                   
                                   # premier colonne
                                   column(width = 3, 
                                          # wellPanel pour griser
                                          wellPanel(
                                            titlePanel("Scatterplot editing"),
                                            
                                            # titre du graphique
                                            textInput(inputId = "titre_scat", label = "Main title:", value = "Scatterplot"),
                                            
                                            # Sample size
                                            sliderInput("sampleSize", "Sample size:", min = 100, max = nrow(musique), value = 1000),
                                            
                                            # selection des variables x
                                            radioButtons(inputId = "var_scat_x", label = "X variable: ", choices = colnames(musique)[c(8, 5, 12)]),
                                            
                                            # selection des variables y
                                            radioButtons(inputId = "var_scat_y", label = "Y variable: ", choices = colnames(musique)[c(5, 8, 12)]),
                                            
                                            actionButton("goButton2", "Update view", class = "btn-success", icon("refresh")),
                                            
                                            br(), 
                                            
                                            br(),
                                            
                                            # position of the legend
                                            radioButtons(inputId = "legend_pos", label = "Legend's position: ", choices = c("bottomleft",
                                                                                                                            "topleft",
                                                                                                                            "bottomright",
                                                                                                                            "topright")),
                                            # size of the legend
                                            sliderInput("legend_size", "Legend's size:", min = 0.6, max = 1.5, value = 0.8),
                                          )
                                   ), 
                                   # deuxieme colonne
                                   column(width = 9, 
                                          # tabsetPanel(
                                          tabPanel("Scatterplot", 
                                                   # plotOutput -> amChartsOutput
                                                   plotOutput("scatterplot")
                                          )
                                          # )
                                   )
                                   
                                 )),
                        
                        tabPanel("Barchart",
                                 fluidRow(
                                   
                                   # premier colonne
                                   column(width = 3, 
                                          # wellPanel pour griser
                                          wellPanel(
                                            titlePanel("Barchart editing"),
                                            
                                            # titre du graphique
                                            textInput(inputId = "titre_bar", label = "Main title:", value = "Barchart"),
                                            
                                            # selection des variables
                                            radioButtons(inputId = "var_bar", label = "Barchart colored by: ", choices = colnames(musique)[c(10,13)]),
                                            
                                            # input pour la couleur
                                            radioButtons(inputId = "col_bar", label = "Colour:", choices = c("magma","inferno","plasma","viridis","cividis"))
                                          )
                                   ), 
                                   # deuxieme colonne
                                   column(width = 9, 
                                          #tabsetPanel(
                                          tabPanel("Barchart", 
                                                   plotOutput("barchart")
                                          )
                                          #)
                                   )
                                   
                                 ))
             ),
             
             # 4e onglet : Song Recommendations 
             tabPanel("FAMD & Song Recommendations",
                      fluidRow(
                        column(width = 3, 
                               wellPanel(
                                 titlePanel("FAMD settings"), 
                                 print("First graph"),
                                 textInput(inputId = "FAMD1_title", label = "Graph title", value = "Map of the individuals (FAMD)"), 
                                 radioButtons(inputId = "colorFAMD1", label = "Color by", choices = c("music_genre", "key", "mode")),
                                 print("2nd graph"),
                                 textInput(inputId = "FAMD2_title", label = "Graph title", value = "Features contribution"), 
                                 print("3rd graph"),
                                 textInput(inputId = "FAMD3_title", label = "Graph title", value = "Correlation circle"), 
                                 actionButton("goButton3", "Update view", class = "btn-success", icon("refresh"))
                                 
                                 
                               )
                               
                        ), 
                        column(width = 9, 
                               navbarPage("FAMD", 
                                          tabPanel("Graphs", 
                                                   plotOutput(outputId = "FAMD1"),
                                                   br(),
                                                   fluidRow(
                                                     column(width = 6, 
                                                            plotOutput(outputId = "FAMD2") 
                                                            
                                                     ),
                                                     column(width = 6, 
                                                            plotOutput(outputId = "FAMD3")
                                                     ))
                                                   
                                                   
                                          ), 
                                          tabPanel("Eigenvalues", 
                                                   textOutput("eigenvalues"),
                                                   br(),
                                                   tags$head(tags$style("#eigenvalues{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }")
                                                   ),
                                                   verbatimTextOutput(outputId = "eig")
                                                   
                                                   
                                                   
                                          ), 
                                          tabPanel("Features", 
                                                   textOutput("featuresFAMD"),
                                                   br(),
                                                   tags$head(tags$style("#featuresFAMD{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }")
                                                   ),
                                                   verbatimTextOutput(outputId = "var")
                                                   
                                          ),
                                          
                                          tabPanel("Recommendations",
                                                   textOutput("recomdt"),
                                                   
                                                   tags$head(tags$style("#recomdt{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }")
                                                   ),
                                                   br()
                                                   # selectInput(inputId = "song_reco", label = "The song to generate recommendations from...", choices = names(subset_famd[,"track_name"]) )
                                                   
                                                   
                                                   ),
                                          tabPanel("Details", 
                                                   textOutput("FAMD_details"), 
                                                   tags$head(tags$style("#FAMD_details{color : black;
                                                    font-size: 16px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }")
                                                   )
                                          )
                               )
                        )
                        
                        
                      )
                      
                      
             ),
             
             # 5e onglet : prediction with linear regression model
             tabPanel("Linear regression & Prediction model",
                      
                      fluidRow(
                        # premier colonne
                        column(width = 3,
                               
                               # wellPanel pour griser
                               wellPanel(
                                 titlePanel("Model editing"),
                                 selectInput(
                                   inputId = "vars_quanti",
                                   label = "Select model quanti variables",
                                   choices = colnames(musique)[c(5:9, 11:12, 14:15, 17)],
                                   selected = "energy",
                                   multiple = TRUE,
                                   selectize = TRUE,
                                   width = NULL,
                                   size = NULL
                                 ),
                                 selectInput(
                                   inputId = "vars_quali",
                                   label = "Select model quali variables",
                                   choices = colnames(musique)[c(10, 13, 18)],
                                   selected = NULL,
                                   multiple = TRUE,
                                   selectize = TRUE,
                                   width = NULL,
                                   size = NULL
                                 ),
                                 
                                 sliderInput(
                                   "TrainTest",
                                   label = h3("Train/Test Split %"),
                                   min =1,
                                   max = 99,
                                   value = 70
                                 ),
                                 
                                 #submitButton("Update View", icon("refresh"))
                                 actionButton("goButton", "Update view", class = "btn-success", icon("refresh"))
                               )
                        ),
                        # deuxieme colonne
                        column(width = 9,
                               
                               navbarPage("Model",
                                          
                                          tabPanel("Summary",
                                                   textOutput("summary"),
                                                   br(),
                                                   verbatimTextOutput("summary_model")
                                          ),
                                          
                                          tabPanel("Graph",
                                                   textOutput("graph_pred"),
                                                   br(),
                                                   textOutput("rmse"),
                                                   br(),
                                                   plotlyOutput("graph")
                                          ),
                                          
                                          tabPanel("DataTable",
                                                   textOutput("datatable"),
                                                   br(),
                                                   textOutput("datatble2"),
                                                   br(),
                                                   tags$li("Green : abs(popularity) < 10"),
                                                   tags$li("Orange : abs(popularity) < 20"),
                                                   tags$li("Red : abs(popularity) > 20"),
                                                   br(),
                                                   DT::dataTableOutput("DataTable")
                                          ),
                                          
                                          tabPanel("Graph residual",
                                                   textOutput("graph_res"),
                                                   br(),
                                                   plotlyOutput("graph_residual")
                                          ),
                                          
                                          tabPanel("Your prediction",
                                                   
                                                   textOutput("exp_pred"),
                                                   br(),
                                                   
                                                   # selectInput(
                                                   #   inputId = "model_utilise",
                                                   #   label = "Choose your model",
                                                   #   choices = c("Your variables", "Best model variables"),
                                                   #   selected = NULL,
                                                   #   multiple = FALSE,
                                                   #   selectize = TRUE,
                                                   #   width = NULL,
                                                   #   size = NULL
                                                   # ),
                                                   
                                                   fluidRow(
                                                     # numericInput("Ac",
                                                     #              label="Acousticness",
                                                     #              value = NA,
                                                     #              min = 0,
                                                     #              max = 1,
                                                     #              step = NA),
                                                     #input.Ac = NA
                                                     
                                                     # conditionalPanel(
                                                     #   "input.model_utilise =='Your variables'",
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('acousticness') >= 0",
                                                         sliderInput(
                                                           "Ac",
                                                           label = ("Acousticness"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('energy') >= 0",
                                                         sliderInput(
                                                           "En",
                                                           label = ("Energy"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('instrumentalness') >= 0",
                                                         sliderInput(
                                                           "Ins",
                                                           label = ("Instrumentalness"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('danceability') >= 0",
                                                         sliderInput(
                                                           "Dan",
                                                           label = ("Danceability"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('loudness') >= 0",
                                                         sliderInput(
                                                           "Lou",
                                                           label = ("Loudness"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('liveness') >= 0",
                                                         sliderInput(
                                                           "Live",
                                                           label = ("Liveness"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('speechiness') >= 0",
                                                         sliderInput(
                                                           "Spee",
                                                           label = ("Speechiness"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('valence') >= 0",
                                                         sliderInput(
                                                           "Val",
                                                           label = ("Valence"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('valence') >= 0",
                                                         sliderInput(
                                                           "Tempo",
                                                           label = ("Tempo"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quanti.indexOf('duration_ms') >= 0",
                                                         sliderInput(
                                                           "Dur",
                                                           label = ("Duration_ms"),
                                                           min = 0,
                                                           max = 1,
                                                           value = 0.5
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quali.indexOf('music_genre') >= 0",
                                                         selectInput(
                                                           inputId = "Genre",
                                                           label = "Music genre",
                                                           choices = levels(musique$music_genre)[-1],
                                                           selected = NULL,
                                                           multiple = FALSE,
                                                           selectize = TRUE,
                                                           width = NULL,
                                                           size = NULL
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quali.indexOf('key') >= 0",
                                                         selectInput(
                                                           inputId = "Key",
                                                           label = "Key",
                                                           choices = levels(musique$key),
                                                           selected = "A",
                                                           multiple = FALSE,
                                                           selectize = TRUE,
                                                           width = NULL,
                                                           size = NULL
                                                         )
                                                       ),
                                                       
                                                       conditionalPanel(
                                                         "input.vars_quali.indexOf('mode') >= 0",
                                                         selectInput(
                                                           inputId = "mode",
                                                           label = "Mode",
                                                           choices = levels(musique$mode),
                                                           selected = "Major",
                                                           multiple = FALSE,
                                                           selectize = TRUE,
                                                           width = NULL,
                                                           size = NULL
                                                         )
                                                       ),
                                                       br(),
                                                       textOutput("prediction")
                                                       
                                                     # ),
                                                     
                                                     # conditionalPanel(
                                                     #   "input.model_utilise =='Best model variables'",
                                                     #   
                                                     #   sliderInput(
                                                     #     "Nb_vars",
                                                     #     label = ("Number step in stepAIC"),
                                                     #     min = 1,
                                                     #     max = 30,
                                                     #     value = 1
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Ac2",
                                                     #     label = ("Acousticness"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "En2",
                                                     #     label = ("Energy"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Ins2",
                                                     #     label = ("Instrumentalness"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Dan2",
                                                     #     label = ("Danceability"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Lou2",
                                                     #     label = ("Loudness"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Live2",
                                                     #     label = ("Liveness"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Spee2",
                                                     #     label = ("Speechiness"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Val2",
                                                     #     label = ("Valence"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Tempo2",
                                                     #     label = ("Tempo"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   sliderInput(
                                                     #     "Dur2",
                                                     #     label = ("Duration_ms"),
                                                     #     min = 0,
                                                     #     max = 1,
                                                     #     value = 0.5
                                                     #   ),
                                                     #   
                                                     #   selectInput(
                                                     #     inputId = "Genre2",
                                                     #     label = "Music genre",
                                                     #     choices = levels(musique$music_genre)[-1],
                                                     #     selected = NULL,
                                                     #     multiple = FALSE,
                                                     #     selectize = TRUE,
                                                     #     width = NULL,
                                                     #     size = NULL
                                                     #   ),
                                                     #   
                                                     #   selectInput(
                                                     #     inputId = "Key2",
                                                     #     label = "Key",
                                                     #     choices = levels(musique$key),
                                                     #     selected = "A",
                                                     #     multiple = FALSE,
                                                     #     selectize = TRUE,
                                                     #     width = NULL,
                                                     #     size = NULL
                                                     #   ),
                                                     #   
                                                     #   selectInput(
                                                     #     inputId = "mode2",
                                                     #     label = "Mode",
                                                     #     choices = levels(musique$mode),
                                                     #     selected = "Major",
                                                     #     multiple = FALSE,
                                                     #     selectize = TRUE,
                                                     #     width = NULL,
                                                     #     size = NULL
                                                     #   ),
                                                     #   br(),
                                                     #   #verbatimTextOutput("test"),
                                                     #   textOutput("predi")
                                                     #   
                                                     #   
                                                     # )
                                                     
                                                     
                                                     
                                                   ),
                                                   #submitButton("Update View", icon("refresh")),
                                                   
                                                   
                                                   
                                                   
                                                   #DT::dataTableOutput("data_pred")
                                                   #DT::dataTableOutput("test")
                                                   
                                          )
                                          
                                          
                                          
                                          
                                          
                               )
                               
                        )
                        
                        
                      )
                      
                      
                      
             )
             
             
             
             
  )
  
  
  
)
)