#################
# 2. References #
#################

#D2 and D3 statistics documentation
#Jolliffe, I.T.  (2002), Principal Component Analysis - Second Edition, Springer

#Library to create PCA
library(FactoMineR)


#function to calculate D2 and D3 statistics
calculoD = function(Datos,q=0,D=2){
  
  medianas = apply(Datos,2,median,na.rm=T)
  for(i in 1:length(Datos)){
    Datos[,i][is.na(Datos[,i])]=medianas[i]
  }
  #number of columns
  p = ncol(Datos)
  
  #PCA with all dimensions
  acp.cluster = PCA(Datos, scale.unit=TRUE, ncp=p, graph=FALSE)
  coord = acp.cluster$ind$coord
  eig = acp.cluster$eig
  
  #if q = 0 then q is equal to eigenvalues < 1
  if(q == 0){
    q = length(which(acp.cluster$eig[,1] < 1,))
  }
  #calculate de D2
  if(D == 2){
    D_2 = apply(coord,MARGIN=1,FUN = 
                  function(x,eigen.v,q,p){
                    sum(((x[(p-q+1):p])^2)/(eigen.v[,1][(p-q+1):p]))
                    }
                ,eigen.v = eig ,q=q,p=p
                )
    return(as.vector(D_2))
  }else{
    #Calculate de D3
    if(D == 3){
      D_3 = apply(coord,MARGIN=1,FUN = 
                    function(x,eigen.v){
                      sum((x^2)*(eigen.v[,1]))
                    }
                  ,eigen.v = eig
      ) 
      return(as.vector(D_3))
    }
  }
}

#function to calculate D statistic quantile
cuantil.distrib = function(p,kernel,D,n){
  #Calculate dens
  dens = density(x = D,kernel = kernel,n=n)
  
  #function calculates the sum and subtraction p
  h = function(x,p,dens){
    sup = sum(x < dens$x)
    vecY = dens$y[1:(length(dens$y)-sup)]
    ancho =dens$x[2] - dens$x[1]
    sum(vecY * ancho) - p
  }
  
  #Calculate zero of h function
  b=uniroot(f = h,lower = min(D),upper = max(D),p=p,dens=dens)
  b$root
}