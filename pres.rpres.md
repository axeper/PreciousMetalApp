Data Product Capstone
========================================================
author: Axel Perruchoud
date: 10.09.2016
autosize: true
transition: concave

Precious Metals Prices, a small App made with Shiny


Goal
========================================================
transition: fade

The client is interested in some small widget that would allow hom to follow the prices of precious metals.
The requirements are:

- The app must be reactive
- The app must be fast
- The app must be hosted online

With these requirements, a snall app was created using Shiny and the quantmod library.

The app can be tried here:
https://datascienceproject.shinyapps.io/PreciousMetalPrices/

The code can be seen here:
https://github.com/axeper/PreciousMetalApp



Quantmod - Getting and Displaying the Data
========================================================
transition: rotate

Quantmod allows to get the data for stocks and precious metals. We can put it into a reactive function so that Shiny can be used efficiently. Here are the key lines of codes:


```r
library(quantmod)

getData <- reactive({ 
    # Download daily metals (here gold) prices from oanda.
    data <- get(getMetals(Metals = "XAU", 
            from = "2013-01-01", to = Sys.Date(),
            base.currency="USD"))
})

# Display the data in a financial chart
chartSeries(x = getData())
```


Example - Case study
========================================================
transition: zoom
What happened to Gold since the beggining of the year?

![caseStudy](screen.png)

With a performance of 25.9% (January - September 2016), this year has been a good year for Gold.




Conclusion and Discussion
========================================================

This concludes the presentation of the app. The main challenges were:

* Understanding the quantmod package
* Making a user-friendly interface 
* Implementing everything as efficiently as possible in Shiny

More features could be implemented:

* Adding a moving average to the plot (SMA, EMA, etc...)
* More plot types (candle, bar, etc ...)
* Plotting volumes
