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
             
             
             # 1e onglet : home ----------------
             tabPanel(icon=icon("home"), 'Home',
                      fluidRow(
                        column(width=12,
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
                               )
                               
                               
                               
                        )
                        
                      )),
             # 2e onglet : dataset description (features explanation)  ----------------
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
                               textOutput('VisuTitle1'),
                               tags$head(tags$style("#VisuTitle1{color : 1d3624;
                                                    font-size: 30px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    }"
                               )
                               ),
                               br(),
                               textOutput('VisuPara1'),
                               tags$head(tags$style("#VisuPara1{color : black;
                                                    font-size: 18px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }"
                               )
                               ),
                               br(),
                               textOutput('VisuTitle2'),
                               tags$head(tags$style("#VisuTitle2{color : 1d3624;
                                                    font-size: 30px;
                                                    font-family: Georgia,serif;
                                                    font-style: bold;
                                                    }"
                               )
                               ), 
                               br(),
                               textOutput('VisuPara2'),
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
                                 tags$li("Other features were considered as numeric")
                                 
                               ),
                               tags$head(tags$style("#VisuPara2{color : black;
                                                    font-size: 18px;
                                                    font-family: Arial,sans-serif;
                                                    font-style: normal;
                                                    }"
                               )
                               )
                        ), 
                        column(width = 1)
                      )
             ),
             
             # 3e onglet : visualisation graphique des données ----------------
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
             
             
             # 4e onglet : ACP / Classification  ----------------
             tabPanel("PCA & clustering",
                      fluidRow(
                        
                        
                      )
                      
                      
             ),
             
             # 5e onglet : prediction with linear regression model  ----------------
             tabPanel("Linear regression prediction model",
                      
                      fluidRow(
                        
                        
                      )
                      
                      
             )
             # Show a plot of the generated distribution
             # mainPanel(
             #     plotOutput("distPlot")
             # )
  )
))


