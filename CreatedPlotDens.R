#Function to create kernel density
createdPlotDens = function(D,kernel,type){
  #created densiti of D statistics
  dens = density(x = D,kernel = "gaussian")
  
  #created var names
  varx =type
  vary = paste("Density ",varx,sep = "")
  
  #created data frame for googlevis chart
  densDat= data.frame(
    varx = dens$x,
    vary = dens$y
  )
  colnames(densDat) <- c(varx,vary)
  
  #Create area chart 
  gvisAreaChart( data=densDat,
                 options = list(width="100%", height="500px",
                                title=paste(type," density estimation",sep = ""),
                                vAxis="{title: 'Density'}",
                                hAxis=paste("{title: '",type,"'}")))
} # End createdPlotDens
