#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)
library(lubridate)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
    
    # Application title
    titlePanel("Precious Metal Prices"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            selectInput(inputId = "metal", "Choose a precious metal:", 
                        choices = c('Gold' = 'XAU','Silver' = 'XAG', 'Palladium' = 'XPD', 'Platinum' = 'XPT')),
            selectInput(inputId = "currency", "Choose a currency:", 
                        choices = c('USD', 'EUR', 'GBP', 'CAD', 'AUD', 'CHF', 'JPY', 'CNY', 'BTC')),
            selectInput(inputId = "date", "Choose a date:", 
                        choices = c('1w' = '1w', '2w' = '2w', '1m' = '1m', '6m' = '6m', 
                                    '1y' = '1y', 'max' = 'max', 'YTD' = 'YTD')),
            selectInput(inputId = "type", "Choose a type of plot:", 
                        choices = c('Chart' = 'Chart', 'Line' = 'Line')),
            selectInput(inputId = "theme", "Choose a theme:", 
                        choices = c('Dark' = 'Dark', 'Light' = 'Light'))
            
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            
            # Introduction
            h2('Goal'),
            p("We are interested in the price of precious metals and their performance.
              For this purpose, a small app has been realized with R."),
            h2('Instructions'),
            p("Choose a precious metal, a currency and a time range and wait for the plot to appear."),
            
            
            
            # Plot
            plotOutput("distPlot"),
            
            # Performance
            h2('Performance'),
            textOutput('open')
        )
    )
))


# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
    
    
    # Reactive data
    getData <- reactive({ 
        
        # Get the data according to the date
        dt_to <- Sys.Date()
        dt_from <- Sys.Date()
        
        if (input$date == "1w") dt_from <- dt_to - as.difftime(1, unit = "weeks")
        else if (input$date == "2w") dt_from <- dt_to - as.difftime(2, unit = "weeks")
        else if (input$date == "1m") dt_from <- dt_to %m-% months(1)
        else if (input$date == "6m") dt_from <- dt_to %m-% months(6)
        else if (input$date == "1y") dt_from <- dt_to %m-% months(12)
        else if (input$date == "max") dt_from <- dt_to %m-% months(60)
        else if (input$date == "YTD") dt_from <- dt_to - yday(dt_to - 1)
        
        data <- get(getMetals(input$metal, from = dt_from, to = dt_to, base.currency = input$currency)) 
    })
    

    # Plot    
    output$distPlot <- renderPlot({
        
        data <- getData()
        
        if (input$type == "Chart") {
            if (input$theme == "Light")     chartSeries(data, theme = chartTheme("white", up.col = 'blue'))
            else if (input$theme == "Dark") chartSeries(data, theme = chartTheme("black", up.col = 'gold'))
        }
        else if (input$type == "Line") {
            if (input$theme == "Light")     lineChart(data, theme = chartTheme("white", up.col = 'blue'), line.type = 'h')
            else if (input$theme == "Dark") lineChart(data, theme = chartTheme("black", up.col = 'gold'), line.type = 'h')
        } 
    })
    
    
    # Performance
    output$open <- renderText({
        data <- getData()
        
        d1 <- data[1,1]
        d2 <- tail(data, 1)[1,1]
        perf <- (as.numeric(d2) - as.numeric(d1)) / as.numeric(d1)
        perf <- round(perf * 100, digits = 2)
        
        paste0("Initial value: ", d1, ", Final Value: ", d2, ". Performance: ", perf)
    })

})

# Run the application 
shinyApp(ui = ui, server = server)

