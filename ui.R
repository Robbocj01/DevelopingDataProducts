#
# Developing Data Products - Shiny Application
# Author:  C Robertson
# Date: December 2019

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Calculating Equity Index Distribution"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h4("Input Standard Deviation and Return Forecast"),
            numericInput("numeric", label = "How many points should be plotted",
                         value = 1000, min = 1000, max = 5000, step = 500),
            numericInput("ForcastedReturn", label = "Forecasted Return % per annum",
                    value = 1, min = 0, max = 5, step = 1),
            numericInput("StdDeviation", label = "Standard Deviation % per annum",
                    value = 5, min = 0, max = 5, step = 1),
            checkboxInput("den_curve","Add Density Curve", value = TRUE),
            numericInput("N_monteC_sims", label = "Number of Monte Carlo Simulations",
                         value = 20, min = 5, max = 50, step = 5),
            submitButton("Submit")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot"),
            plotOutput("montecarloPlot")
        )
    )
))
