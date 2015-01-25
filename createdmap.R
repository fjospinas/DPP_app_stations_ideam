#Library for use  Leaflet maps
library(rCharts)

#Function to create map
createdMap = function(data,var,zoom){
  #coordinates columns
  colLat = 5
  colLong = 4
  
  #Name var selected
  nameVar = names(listVar[as.numeric(var)])
  
  #exctract data
  varPop = data[,nameVar]
  
  #Templates for de string in the popup
  strLeft = "<p> "
  strRight = " </p>"
  
  #Created map with center in Colombia
  map3 <- Leaflet$new()
  map3$setView(c(4.014976, -73.199565), zoom = zoom)
  
  #Put the markers in the map 
  for(i in 1:nrow(data)){
    #construct message in the popup
    strPopup = paste(strLeft,"ID point: ",data[i,1],"<br/>Estation: ",data[i,2],"<br/> Date: ",data[i,3],
                     "<br/>",nameVar," = ",varPop[i],strRight,sep = "")    
    map3$marker(c(data[i,colLat], data[i,colLong]), bindPopup = strPopup)
  }# End for
  map3  
}# End createdMap



