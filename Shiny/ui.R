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
             
             # 3e onglet : visualisation graphique des données
             tabPanel("Visualization", 
                      
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
                                 colourInput(inputId = "color", label = "Color:", value = "C1CC3A"), #277042
                                 
                                 # titre du graphique
                                 textInput(inputId = "titre", label = "Main title:", value = "Histogram"),
                                 
                                 # selection de la colonne
                                 radioButtons(inputId = "var", label = "Feature: ", choices = colnames(musique)[c(4:9, 11:12, 14:15, 17)])
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
                               )#,
                               #   tabPanel("Boxplot", amChartsOutput("boxplot"))
                               # )
                        )
                      )
             ),
             
             # 4e onglet : Song Recommendations 
             tabPanel("FAMD & Song Recommendations",
                      fluidRow(
                        column(width = 3, 
                               wellPanel(
                                 titlePanel("FAMD settings"), 
                                 # colorer par music genre, key ou mode 
                                 
                               )
                               
                        ), 
                        column(width = 9, 
                               navbarPage("FAMD", 
                                          tabPanel("Graphs"
                                                   
                                                   
                                          ), 
                                          tabPanel("Eigenvalues"
                                                   
                                                   
                                          ), 
                                          tabPanel("Features"
                                                   
                                          ),
                                          tabPanel("Infos"
                                                   
                                          )
                               )
                        )
                        
                        
                      )
                      
                      
             ),
             
             # 5e onglet : prediction with linear regression model
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


