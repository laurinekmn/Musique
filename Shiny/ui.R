### FUNZIONA


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
                                            
                                            # selection des variables
                                            radioButtons(inputId = "var_scat", label = "Feature: ", choices = c("Energy vs Acousticness",
                                                                                                                "Loudness vs Acousticness",
                                                                                                                "Loudness vs Energy"))
                                          )
                                   ), 
                                   # deuxieme colonne
                                   column(width = 9, 
                                          # tabsetPanel(
                                          tabPanel("Scatterplot", 
                                                   # plotOutput -> amChartsOutput
                                                   amChartsOutput("scatterplot")
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
                                            textInput(inputId = "titre", label = "Main title:", value = "Barchart"),
                                            
                                            # selection des variables
                                            radioButtons(inputId = "var", label = "Feature: ", choices = c("Genre vs Mode",
                                                                                                           "Genre vs Key"))
                                          )
                                   ), 
                                   # deuxieme colonne
                                   column(width = 9, 
                                          #tabsetPanel(
                                          tabPanel("Barchart", 
                                                   # plotOutput -> amChartsOutput
                                                   amChartsOutput("barchart")
                                          )
                                          #)
                                   )
                                   
                                 ))
             ),
             
             # 4e onglet : ACP / Classification
             tabPanel("PCA & clustering",
                      fluidRow(
                        
                        
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


