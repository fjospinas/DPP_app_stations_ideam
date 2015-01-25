#Global variables in de APP
source("createdmap.R")
source("outliersD.R")
source("CreatedPlotDens.R")
data = read.csv("data/estation2011.csv")
listVar = list("CE" = 1,"DQO" = 2,"OD"=3,"pH"=4,"SST"=5,"T."=6,"Turb"=7,"NT"=8,"PT"=9)

