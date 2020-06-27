# UI script

# load library
library(shiny)

# define UI
shinyUI(fluidPage(
  # display title
  h1("What affects Commuting Distance?"),
  
  # display sidebar for variable selection
  wellPanel(style = "position: relative",fluidRow(
    HTML(
      "&emsp;Select variables to examine effects of one's work on the commuting distance."
    ),
    br(),
    # display dropdown menu for work characteristic
    column(width = 3,
           selectInput(
             "character",
             "Characteristic:",
             c("Industry",
               "Occupation",
               "Annual Income",
               "Method of Travel",
               "Property Owned : Property Rented",
               "Living with Family : Living Alone")
           )),
    # checkbox for region selection when first 4 characteristics selected
    uiOutput('condPanel')
  )),
  
  # display plot and tooltip
  wellPanel(style = "position: relative",
    fluidRow(
      column(width=8,
        h3(textOutput("plotTitle")),
        plotOutput(
          "commutePlot",
          hover = hoverOpts("plot_hover", delay = 100, delayType = "debounce")
        ),
        uiOutput("hover_info")
      ),
      column(width=4,
             htmlOutput("narration")
      )
    )
  ),
  # add reference for data source
  wellPanel(style = "position: relative",
    HTML("Data retrieved from:",
         "<br/>",
         "Australian Bureau of Statistics. (2016). 
         Commuting Distance by Personal Characteristics. 
         Australian Bureau of Statistics.",
         "<br/>",
         "Greater Dandenong. (2016). Suburbs: Detailed information 
         by suburb and segment of the communities. Greater Dandenong.")
  )
))
