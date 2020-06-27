# Server script

# load libraries
library(shiny)
library(datasets)
library(rgdal)
library(ggplot2)
library(forcats)
library(Cairo)
library(tidyverse)

# load csv datasets
df_ind = read.csv('commuting by industry.csv', header = T)
df_occ = read.csv('commuting by occupation.csv', header = T)
df_inc = read.csv('commuting by income.csv', header = T)
df_tra_gre = read.csv('commuting by travel method in greater melbourne.csv', header = T)
df_liv = read.csv("normalised commuting by living arrangement.csv", header = T)

# rename column names for living arrangement dataframe
colnames(df_liv) = c('Commuting.Distance',
                     'Owned..Rented',
                     'Family..Alone')

# define server
shinyServer(function(input, output) {
  # display checkboxes for regions if only categorical characteristics selected
  output$condPanel = renderUI({
    if ((input$character != "Property Owned : Property Rented") &
        (input$character != "Living with Family : Living Alone")){
          column(
            width = 3,
            checkboxGroupInput(
              inputId = "region",
              label = "Region",
              choices = c(
                "Greater Melbourne" = "mel",
                "Regional Victoria" = "vic"
              ),
              selected = c("mel", "vic"),
              inline = F
            )
          )
        }
  })
  
  # return plot title
  output$plotTitle = renderText({
    # if no characteristic selected, return empty plot title
    if (input$character == "Select") {
      paste("Commuting Distance by")
    } else {
      paste("Commuting Distance by", input$character)
    }
  })
  
  # generate plot
  output$commutePlot = renderPlot({
    # create dataframe based on work characteristic selection
    if (input$character == "Industry") {
      df = df_ind
      df$Character = df$Industry
    } else if (input$character == "Occupation") {
      df = df_occ
      df$Character = df$Occupation
    } else if (input$character == "Annual Income") {
      df = df_inc
      df$Character = df$Income..AUD.
    } else if (input$character == "Method of Travel") {
      df = df_tra_gre
      df$Character = df$Travel.method
    } else if ((input$character == "Property Owned : Property Rented") |
               (input$character == "Living with Family : Living Alone")) {
      df = df_liv
    }
    
    # reorder Character column by descending distance
    # note that dataframe with living arrangement data is processed
    # differently to rest of dataframes and regions are not
    # applicable to it.
    if ((input$character != "Property Owned : Property Rented") &
        (input$character != "Living with Family : Living Alone")) {
      df$Character = reorder(df$Character, -df$Average.distance..km.)
    }
    
    # create plot
    # for empty regional selection
    if (!("mel" %in% input$region) & !("vic" %in% input$region) &
        ((input$character != "Property Owned : Property Rented") &
         (input$character != "Living with Family : Living Alone")
        )) {
      chart = ggplot()
    }
    
    # for Greate Melbourne and Regional Victoria
    if (("mel" %in% input$region & "vic" %in% input$region) &
        ((input$character != "Property Owned : Property Rented") &
         (input$character != "Living with Family : Living Alone")
        )) {
      chart = ggplot(data = df,
                     aes(x = Average.distance..km.,
                         y = Character, fill = Region)) +
        geom_col(position = position_dodge2(reverse = TRUE)) +
        geom_text(
          aes(label = Average.distance..km.),
          hjust = -0.2,
          vjust = 0.2,
          color = "black",
          position = position_dodge2(width = 0.9, reverse = T),
          size = 3
        ) +
        scale_fill_manual(values = c("#56b3e9", "#0071b2")) +
        labs(x = "Average Distance (km)", y = input$variable) +
        theme(text = element_text(size = 15))
      # for Greater Melbourne
    } else if (("mel" %in% input$region) &
               !("vic" %in% input$region) &
               ((input$character != "Property Owned : Property Rented") &
                (input$character != "Living with Family : Living Alone")
               )) {
      chart = ggplot(data = df[df$Region == "Greater Melbourne",],
                     aes(x = Average.distance..km.,
                         y = Character, fill = Region)) +
        geom_col() +
        geom_text(
          aes(label = Average.distance..km.),
          hjust = -0.2,
          vjust = 0.2,
          color = "black",
          size = 3
        ) +
        scale_fill_manual(values = c("#56b3e9")) +
        labs(x = "Average Distance(km)", y = input$variable) +
        theme(text = element_text(size = 15))
      # for Regional Victoria
    } else if (!("mel" %in% input$region) &
               ("vic" %in% input$region) &
               ((input$character != "Property Owned : Property Rented") &
                (input$character != "Living with Family : Living Alone")
               )) {
      chart = ggplot(data = df[df$Region == "Regional Victoria",],
                     aes(x = Average.distance..km.,
                         y = Character, fill = Region)) +
        geom_col() +
        geom_text(
          aes(label = Average.distance..km.),
          hjust = -0.2,
          vjust = 0.2,
          color = "black",
          size = 3
        ) +
        scale_fill_manual(values = c("#0071b2")) +
        labs(x = "Average Distance(km)", y = input$variable) +
        theme(text = element_text(size = 15))
      # for ratio of property owned to property rented
    } else if (input$character == "Property Owned : Property Rented") {
      chart = ggplot(data = df, aes(x = Commuting.Distance, y = Owned..Rented)) +
        geom_point(position = "jitter") +
        geom_smooth(method = lm, formula = 'y~x', se=F) +
        annotate(
          "text",
          x = 0.75,
          y = 0.75,
          label = 'Correlation Coefficient',
          color = "blue",
          size = 5
        ) +
        annotate(
          "text",
          x = 0.75,
          y = 0.70,
          label = '0.64',
          color = "blue",
          size = 5
        ) +
        labs(x = "Normalised Average Commuting Distance",
             y = "Normalised Property Owned : Property Rented") +
        theme(text = element_text(size = 15, family = 'TT Arial')) # family changed due to font breaking
      # for ratio of living with family to living alone
    } else if (input$character == "Living with Family : Living Alone") {
      chart = ggplot(data = df, aes(x = Commuting.Distance, y = Family..Alone)) +
        geom_point(position = "jitter") +
        geom_smooth(method = lm, formula = 'y~x', se=F) +
        annotate(
          "text",
          x = 0.75,
          y = 0.75,
          label = 'Correlation Coefficient',
          color = "blue",
          size = 5
        ) +
        annotate(
          "text",
          x = 0.75,
          y = 0.70,
          label = '0.62',
          color = "blue",
          size = 5
        ) +
        labs(x = "Normalised Average Commuting Distance",
             y = "Normalised Living with Family : Living Alone") +
        theme(text = element_text(size = 15, family = 'TT Arial')) # family changed due to font breaking
    }
    # display chart
    chart
  })
  
  # generate hover tooltip
  output$hover_info = renderUI({
    # create dataframe based on work characteristic selection
    if (input$character == "Industry") {
      df = df_ind
      df$Character = df$Industry
    } else if (input$character == "Occupation") {
      df = df_occ
      df$Character = df$Occupation
    } else if (input$character == "Annual Income") {
      df = df_inc
      df$Character = df$Income..AUD.
    } else if (input$character == "Method of Travel") {
      df = df_tra_gre
      df$Character = df$Travel.method
    } else if ((input$character == "Property Owned : Property Rented") |
               (input$character == "Living with Family : Living Alone")) {
      df = df_liv
    }
    
    # reorder dataframe as how it's depicted on ggplot
    # note that for dataframe with living arrangement data,
    # hovering tooltip is performed differently to rest of the dataframes.
    if ((input$character != "Property Owned : Property Rented") &
        (input$character != "Living with Family : Living Alone")) {
      avg = aggregate(df$Average.distance..km. ~ df$Character, FUN = mean)[, 2]
      avg_col = c()
      ind = 1
      for (val in avg) {
        for (j in 1:2) {
          avg_col[ind] = val
          ind = ind + 1
        }
      }
      df = arrange(df, df$Character)
      df$Avg = avg_col
      df = arrange(df, desc(df$Avg))
      rownames(df) = NULL
    }
    
    # load hovering info
    hover = input$plot_hover
    point = nearPoints(df, hover, threshold = 10, maxpoints = 1)
    
    # when not hovering, display to inform about hovering
    if (class(hover$y) != "numeric") {
      return(wellPanel(p(HTML(
        paste0("<b>Hover over to see information</b><br/><br/>")
      ))))
      # for ratio of property owned to rented and ratio of living with family to living alone
    } else if (((input$character == "Property Owned : Property Rented") |
                (input$character == "Living with Family : Living Alone")
    ) &
    (nrow(point) == 0)) {
      return(wellPanel(p(HTML(
        paste0("<b>Hover over to see information</b><br/><br/>")
      ))))
    }
    
    # determine hovering row of the dataframe
    # for Greater Melbourne and Regional Victoria
    if (("mel" %in% input$region & "vic" %in% input$region) &
        (input$character != "Property Owned : Property Rented") &
        (input$character != "Living with Family : Living Alone")) {
      if (hover$y < round(hover$y)) {
        row = round(hover$y) + (round(hover$y))
      } else if (hover$y > round(hover$y)) {
        row = round(hover$y) + (round(hover$y) - 1)
      }
    }
    # for Greater Melbourne
    if (("mel" %in% input$region) & !("vic" %in% input$region) &
        (input$character != "Property Owned : Property Rented") &
        (input$character != "Living with Family : Living Alone")) {
      row = round(hover$y)
      # redefine dataframe for Greater Melbourne
      df = df[df$Region == "Greater Melbourne",]
    }
    # for Regional Victoria
    if (!("mel" %in% input$region) & ("vic" %in% input$region) &
        (input$character != "Property Owned : Property Rented") &
        (input$character != "Living with Family : Living Alone")) {
      row = round(hover$y)
      # redefine dataframe for Regional Victoria
      df = df[df$Region == "Rest of Vic.",]
    }
    
    # create tooltip
    wellPanel(p(HTML(# for data except ratios
      if ((input$character != "Property Owned : Property Rented") &
          (input$character != "Living with Family : Living Alone")) {
        paste0(
          "<b>",
          input$character,
          ": ",
          df[row, 'Character'],
          "<br/>",
          "Average Commuting Distance: ",
          df[row, 'Average.distance..km.'],
          "km",
          "</b>"
        )
        # for ratio of property owned to property rented
      } else if (input$character == "Property Owned : Property Rented") {
        paste0(
          "<b>",
          "Normalised Ratio: ",
          round(point["Owned..Rented"], 2),
          "<br/>",
          "Normalised Average Commuting Distance: ",
          round(point["Commuting.Distance"], 2),
          "</b>"
        )
        # for ratio of living with family and living alone
      } else if (input$character == "Living with Family : Living Alone") {
        paste0(
          "<b>",
          "Normalised Ratio: ",
          round(point["Family..Alone"], 2),
          "<br/>",
          "Normalised Average Commuting Distance: ",
          round(point["Commuting.Distance"], 2),
          "</b>"
        )
      })))
  })
  
  # generate narration
  output$narration = renderText({
    # for Industry
    if (input$character == 'Industry') {
      paste("<b>Effect of Industry on Commuting Distance:<br/>",
            "For industry, the people working in retail trade commute the 
            shortest distances of 13.39km and 13.50km from Greater Melbourne 
            and regional Victoria, meanwhile, the people working in mining 
            commute the longest distances of 21.60km and 32.88km from 
            Greater Melbourne and regional Victoria. And in general, the people 
            living in regional Victoria travel further compared with the people 
            living in Greater Melbourne. However, for agriculture, forestry 
            and fishing industry, the people from Greater Melbourne travel larger 
            distances. This is likely because most farms, forests and ports are 
            located in the rural areas.</b>",sep="<br/>")
      
      # for Occupation
    } else if (input$character == 'Occupation') {
      paste("<b>Effect of Occupation on Commuting Distance:<br/>",
            "For occupation, sales workers commute the least distances of 
            12.79km and 13.87km from the metropolitan area and the regional 
            area. On the other side, machinery operators and drivers commute 
            the greatest distances of 17.33km and 24.07km from the metropolitan 
            and the regional area. And similar to the trend shown in the industry plot
            , the people residing in the regional Victoria show greater average commuting 
            distances than the people residing in the metropolitan area. </b>",sep="<br/>")
      
      # for Annual Income
    } else if (input$character == 'Annual Income') {
      paste("<b>Effect of Annual Income on Commuting Distance:<br/>",
            "The average commuting distance shows a gradual increase along with the growing 
            annual income except for the high-end income range of $156,000 or more. 
            The people earning from $1 to $7,799 per annum travel the shortest 
            average commuting distances of 8.88km and 11.50km from the metropolitan 
            area and the regional area. On the other side, the people earning annual 
            incomes from $104,000 to $155,999 travel the longest average 
            commuting distances of 17.94km and 30.52km from the metropolitan 
            area and the regional area. The workers living in the regional area 
            travel further distances than the workers living in the metropolitan 
            area. And this gap increases as income increases. </b>",sep="<br/>")
      
      # for Method of Travel
    } else if (input$character == 'Method of Travel') {
      paste("<b>Effect of Method of Travel on Commuting Distance:<br/>",
            "Amongst various methods of travel for commuting, the people living in 
            Greater Melbourne and regional Victoria commute the least distances 
            by walking with 3.64km and 7.95km. And the people living in Greater 
            Melbourne commute the largest distance of 20.19km by train, while 
            the people living in regional Victoria commute the greatest distance of
            90.62km by tram, followed by a commuting distance of 82.17km by train. 
            The people residing in the regional area commute further than the people 
            residing in the metropolitan area. Especially, for train and tram,
            the average commuting distances show significant differences of 61.98km 
            and 84.43km between travelling from Greater Melbourne and regional
            Victoria respectively. However, as trams do not operate in the regional 
            zones, large commuting distance by tram from the regional area may have 
            been an error. </b>",sep="<br/>")
      
      # for Property Owned : Property Rented
    } else if (input$character == 'Property Owned : Property Rented') {
      paste("<b>Effect of Property Owned or Rented on Commuting Distance:<br/>",
            "According to the scatter plot shown on the left, 
            there is a positive correlation between the ratio of the workers owning 
            properties to the workers renting properties and the commuting distance.
            The correlation coefficient of 0.64 indicates a moderate correlation 
            and this shows that workers who own their properties tend to travel 
            futher than the workers who rent their properties.</b>",sep="<br/>")
      
      # for Living with Family : Living Alone
    } else if (input$character == 'Living with Family : Living Alone') {
      paste("<b>Effect of Living with Family or Alone on Commuting Distance:<br/>",
            "The scatter plot depicts a positive correlation with a coefficient of 0.62
            between the ratio of the workers living with families to the workers living 
            alone and the commuting distance. This moderate correlation implies that 
            the workers living with families tend to travel further than the workers 
            living alone.</b>",sep="<br/>")
    }
    
  })
})
