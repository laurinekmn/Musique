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

musique <- read.csv("../musique.csv", sep=";")

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    #titlePanel("Musique"),
  navbarPage("Musique maestro !",

        # Premier onglet : visualisation graphique des données
        tabPanel("Visualisation",

                 fluidRow(
                   # premier colonne
                   column(width = 3,
                          # wellPanel pour griser
                          wellPanel(
                            sliderInput("bins",
                                        "Number of bins:",
                                        min = 1,
                                        max = 50,
                                        value = 30),

                            # input pour la couleur
                            colourInput(inputId = "color", label = "Couleur :", value = "purple"),

                            # titre du graphique
                            textInput(inputId = "titre", label = "Titre :", value = "Histogramme"),

                            # selection de la colonne
                            radioButtons(inputId = "var", label = "Variable : ", choices = colnames(musique)[c(4:9, 11:12, 14:15, 17)])
                          )
                   ),
                   # deuxieme colonne
                   column(width = 9,
                          #tabsetPanel(
                            tabPanel("Histogramme",
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

        # Show a plot of the generated distribution
        # mainPanel(
        #     plotOutput("distPlot")
        # )
     )
))
