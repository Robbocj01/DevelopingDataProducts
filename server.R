#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$distPlot <- renderPlot({
        input_mean <- input$ForcastedReturn
        input_STDev <- input$StdDeviation
        input_no_points <- input$numeric
        hist_data <- rnorm(input_no_points,input_mean,input_STDev)
        # draw the histogram with the specified number of bins
        hist(hist_data, breaks = 40, col = 'darkgray', border = 'white', main = "Histogram of Equity Index Returns",
             xlab = "Returns", prob = TRUE)
        if (input$den_curve){
            lines(density(hist_data), col = "blue", lwd=4)
        }

    })

})
