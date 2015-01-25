#libraries
library(shiny)
library(rCharts)

# Define UI navbarPage 
shinyUI(navbarPage("Hydrologic stations IDEAM",id = "nav",
                   
                   
  #Navigation panel
  #Firts tab
  tabPanel("Interactive map",
           #CSS for absolutepanel
           includeCSS("styles.css"),
           
           #show map
           chartOutput("mymap",'leaflet'),
           #show configuraton panel for the map
           absolutePanel(id = "controls", class = "modal", fixed = TRUE, draggable = TRUE,
                         top = 60, left = "auto", right = 20, bottom = "auto",
                         width = 330, height = "auto",
                         
                         h2("Map configuration"),
                         
                         #map controls
                         sliderInput("zoom", label = "Initial zoom", min = 5, 
                                       max = 14, value = 5),
                         #select variable to show
                         selectInput("var",label = "Variable",choices = listVar),
                         #Button to update
                         actionButton("action","Update view"),
                         hr(),
                         helpText(p("CE: electrical conductivity"),
                                  p("DQO: chemical oxygen demand"),
                                  p("OD: dissolved oxygen"),
                                  p("SST: total suspended solids"),
                                  p("T.: temperature"),
                                  p("Turb: turbidity"),
                                  p("NT: total kjeldahl nitrogen"),
                                  p("PT: total phosphorus")
                                  )
                         
           )
           ),
  
  #second panel
  tabPanel("D2/D3 statistics",
           #Parameters for calculate intagral and determine quantile
           strong(h4("Parameters to determine the outliers")),
           fluidRow(
             column(width=3,
                    sliderInput(inputId = "alpha",label = "Alpha",min = 0,
                                max = 1,value = 0.05,step = 0.01)),
             column(width=3,
                    sliderInput(inputId = "points",
                                label = "Points to calculate the integral",
                                min = 2000,max = 30000,value = 10000,))
             
             ),
           
           #D2 statistic plot
           hr(),
           strong(h4("D2 statistic")),
           fluidRow(
             column(width = 6,
                    h5("Statistic with outliers")),
             column(width = 6,
                    h5("Statistic without outliers"))
           ),
           fluidRow(
             column(width=6,
                    htmlOutput("mychart1")),
             column(width=6,
                    htmlOutput("mychart2"))
           ),
           
           #D3 statistic plot
           hr(),
           strong(h4("D3 statistic")),
           fluidRow(
             column(width = 6,
                    h5("Statistic with outliers")),
             column(width = 6,
                    h5("Statistic without outliers"))
           ),
           fluidRow(
             column(width=6,
                    htmlOutput("mychart3")),
             column(width=6,
                    htmlOutput("mychart4"))
           )
           ),
  
  #third panel
  tabPanel("Data table",
           #download datatable
           downloadButton('downloadData', 'Download'),
           #show datatable
           dataTableOutput('mytable')
           
           )
  
)
)
