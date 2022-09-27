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

musique <- read.csv("../musique.csv", sep=";")

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
                                   selected = NULL,
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
                                                   )
                                          
                               
                               )

                        ),
                        

                      )


             )


  )
))


