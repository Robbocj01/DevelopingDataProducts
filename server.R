#
# Developing Data Products - Shiny Application
# Author:  C Robertson
# Date: December 2019


library(shiny)
library(tidyverse)
library(tidyquant)
library(timetk)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$distPlot <- renderPlot({
        input_mean <- input$ForcastedReturn / 120
        input_STDev <- input$StdDeviation / 120
        input_no_points <- input$numeric
        
        # Then we use the rnorm() function to sample from a distribution with mean equal to 
        # Mean and standard deviation equal. That is the crucial random sampling that underpins this exercise.
        simulated_monthly_returns <- rnorm(input_no_points,input_mean,input_STDev)

        # draw the histogram with the specified number of bins
        hist(simulated_monthly_returns, breaks = 40, col = 'darkgray', border = 'white', main = "Histogram of Equity Index Returns",
             xlab = "Returns", prob = TRUE)
        if (input$den_curve){
            lines(density(simulated_monthly_returns), col = "blue", lwd=4)
        }

    })
    
    output$montecarloPlot <- renderPlot({        
    
        input_mean <- input$ForcastedReturn / 120
        input_STDev <- input$StdDeviation / 120
        input_sims <- input$N_monteC_sims
        
        # Runs the returns simulationa and creates an index of returns
        simulation_accum_1 <- function(init_value, N, mean, stdev) {
            tibble(c(init_value, 1 + rnorm(N, mean, stdev))) %>% 
                `colnames<-`("returns") %>%
                mutate(growth = 
                           accumulate(returns, 
                                      function(x, y) x * y)) %>% 
                select(growth)
        }
        
        # Creates the dataframe ot capture the simulated returns
        open_values <- 
            rep(100, input_sims) %>%
            set_names(paste("sim", 1:input_sims, sep = ""))
        
        # Naps the monte carlo simulation
        monte_carlo_sim <- 
            map_dfc(open_values, 
                    simulation_accum_1, 
                    N = 120, 
                    mean = input_mean, 
                    stdev = input_STDev)
        
        
        monte_carlo_sim <- 
            monte_carlo_sim %>% 
            mutate(month = seq(1:nrow(.))) %>% 
            select(month, everything()) %>% 
            `colnames<-`(c("month", names(open_values))) %>% 
            mutate_all(funs(round(., 2)))
        
        
        # Plots the results using ggplot
        monte_carlo_sim %>% 
            gather(sim, growth, -month) %>% 
            group_by(sim) %>% 
            ggplot(aes(x = month, y = growth, color = sim)) + 
            geom_line() +
            ggtitle("Monte Carlo Simulation of Returns")+
            theme(legend.position="none")+
            xlab("Month") + ylab("Growth of $100")+
            theme(plot.title = element_text(hjust = 0.5))
    })
    

})
