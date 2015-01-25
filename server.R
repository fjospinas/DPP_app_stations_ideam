#Libraries
library(shiny)
library(rCharts)
library(googleVis)

shinyServer(function(input, output, session) {
  
  #######################
  # 1. reactive section #
  #######################
  
  #map
  map4 <- reactive({
    input$action
    isolate(createdMap(data,input$var,input$zoom))
    })
  
  #D2 Statistic
  D2 <- reactive({
    calculoD(data[7:ncol(data)],q=0,D=2)
  })
  
  #D3 statistic
  D3 <- reactive({
    calculoD(data[7:ncol(data)],q=0,D=3)
  })
  
  #D2 quantile
  quantD2 <- reactive({
    cuantil.distrib(p = 1 - input$alpha,kernel = "gaussian",D = D2(),n = input$points)
  })
  
  #D3 quantile
  quantD3 <- reactive({
    cuantil.distrib(p = 1 - input$alpha,kernel = "gaussian",D = D3(),n = input$points)
  })
  
  #column vector of D3 outliers
  colOutD3 <-reactive({
    D3() > quantD3()
  }) 
  
  #column vector of D2 outliers
  colOutD2 <- reactive({
    D2() > quantD2()
  })
  
  #global reactive variable to export datatable
  matOutput <-reactive({
    names = colnames(data)
    colOutD3 = ifelse(colOutD3(),"YES","NO" )
    colOutD2 = ifelse(colOutD2(),"YES","NO" )
    strD2 = paste("D2 > ",signif(quantD2(),4),sep = "")
    strD3 = paste("D3 > ",signif(quantD3(),4),sep = "")
    matOutput = cbind(data,D2(),D3(),colOutD2,colOutD3)
    colnames(matOutput) <- c(names,"D2","D3",strD2,strD3)   
    matOutput
  })
  
  ######################
  # 2. outputs section #
  ######################
  
  #output map for the first tab
  output$mymap <- renderMap({
    map4()    
  })
  
  #output charts for de second tabs
  #mychart1: D2 density whith outliers
  #mychart2: D2 density whithout outliers
  #mychart3: D3 density whith outliers
  #mychart4: D3 density whithout outliers
  
  output$mychart1 <- renderGvis({
    createdPlotDens(D = D2(),kernel = "gaussian",type = "D2")
  })
  
  output$mychart2 <- renderGvis({  
    outliers = which(colOutD2() == 1)
    D2 = D2()[-outliers]
    createdPlotDens(D = D2,kernel = "gaussian",type = "D2")
  })
  
  output$mychart3 <- renderGvis({
    createdPlotDens(D = D3(),kernel = "gaussian",type = "D3")
  })
  
  output$mychart4 <- renderGvis({
    outliers = which(colOutD3() == 1)
    D3 = D3()[-outliers]
    createdPlotDens(D = D3,kernel = "gaussian",type = "D3")
  })
  
  #output table for the third tab
  #added to the original table the following variables
  #D2 and D3 statistic, outliers for D2 and D3 variales
  #the header of outliers show D2 and D3 quantiles
  output$mytable <- renderDataTable(matOutput(), options = list(pageLength = 10))
    
  #output download for the third table
  #download datatable created in the previous output
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("DatasetOutliersMarked", '.csv', sep='') 
    },
    content = function(file) {
      write.csv(matOutput(), file,row.names = FALSE)
    }
  )
})
