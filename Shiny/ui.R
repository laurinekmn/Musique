#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(colourpicker)
library(rAmCharts)
library(bslib)
library(plotly)

musique <- read.csv("../musique.csv", sep=";")
musique$music_genre <- as.factor(musique$music_genre)
musique$key <- as.factor(musique$key)
musique$mode <- as.factor(musique$mode)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  theme = bs_theme(version = 4, 
                   bootswatch = "minty", 
                   bg = "GhostWhite", 
                   fg = "Teal"),
  
  # Application title
  #titlePanel("Musique"),
  navbarPage("All that jazz",
             
             
             #1e onglet : 
             tabPanel("Home",
                      fluidRow(
                        
                        
                      )
               
             ),
             # 2e onglet : dataset description (features explanation)
             tabPanel("Data description", 
                      fluidRow(
                        
                        
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
             
             # 4e onglet : ACP / Classification
             tabPanel("PCA & clustering",
                      fluidRow(
                        
                        
                      )
               
               
             ),
             
             # 5e onglet : prediction with linear regression model
             tabPanel("Linear regression prediction model",

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
                                   min = 0,
                                   max = 100,
                                   value = 70
                                 ),
                                 
                                 submitButton("Update View", icon("refresh"))
                               )
                        ),
                        # deuxieme colonne
                        column(width = 9,
   
                               navbarPage("Model",
                                          
                                          tabPanel("Summary",
                                                   verbatimTextOutput("summary_model")
                                          ),
                                          
                                          tabPanel("Graph",
                                                   plotlyOutput("graph")
                                          ),
                                          
                                          tabPanel("DataTable",
                                                   DT::dataTableOutput("DataTable")
                                                   ),
                                          
                                          tabPanel("Graph residual",
                                                   plotlyOutput("graph_residual")
                                                   ),
                                          
                                          tabPanel("Your prediction",
                                                   fluidRow(
                                                     # numericInput("Ac",
                                                     #              label="Acousticness",
                                                     #              value = NA,
                                                     #              min = 0,
                                                     #              max = 1,
                                                     #              step = NA),
                                                     
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
                                                       "input.vars_quanti.indexOf('speechness') >= 0",
                                                       sliderInput(
                                                         "Spee",
                                                         label = ("Speechness"),
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
                                                       "input.vars_quanti.indexOf('valence') >= 0",
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
                                                         selected = NULL,
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
                                                         selected = NULL,
                                                         multiple = FALSE,
                                                         selectize = TRUE,
                                                         width = NULL,
                                                         size = NULL
                                                       )
                                                     )
                                                     
                                                     
                                                   ),
                                                   submitButton("Update View", icon("refresh")),
                                                   verbatimTextOutput("prediction"),
                                                   verbatimTextOutput("test")
                                                   
                                                   ),
                                          
                                          
                                                  
                                          
                               
                               )

                        ),
                        

                      )


             )


  )
))


