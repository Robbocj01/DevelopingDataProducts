#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
            numericInput("ForcastedReturn", label = "Forecasted Return",
                    value = 10, min = 0, max = 50, step = 1),
            numericInput("StdDeviation", label = "Standard Deviation",
                    value = 10, min = 0, max = 50, step = 1),
            checkboxInput("den_curve","Add Density Curve", value = TRUE),
            submitButton("Submit")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
))
