# Function to Look for Heatwaves in daily ERA5 Temp Data
#Dataframe has columns x, y, days,and the variable for analysis
#Temp_threshold is the temperature that indicates a heatwave
#Day_Threshold is how many days in a row at the Temp_threshold indicates a heatwave
#Variable is the number of the column in the Dataframe that you want to analyze, ie. MaxTemp or MeanTemp

#The function returns a dataframe with columns titled x, y, and HeatwaveDays. 
#x and y are locations from the input Dataframe and HeatwaveDays is the number of days that location was in a heatwave

#Before you run the function you need to set your working directory 
# and read in your dataframe

Heatwaves<-function(Dataframe,Temp_threshold,Day_Threshold,Variable){
  Dataframe$days=as.numeric(Dataframe$days)
  Dataframe$binary=0
  Dataframe$binary[which(Dataframe[,Variable]>=Temp_threshold)]=1
  
  Heatwave=data.frame(x=NA,y=NA,days=NA,streak=NA)
  Heatwave=Heatwave[-1,]
  
  yesterday=Dataframe[which(Dataframe$days==1),c("x","y")]
  yesterday$yest_binary=0
  
  for (i in 1:length(unique(Dataframe$days))){
    today=Dataframe[which(Dataframe$days==i),c("x","y","days","binary")]
    combine=merge(today,yesterday,all=T)
    combine$streak=combine$yest_binary/combine$binary
    combine$streak=combine$streak+1
    combine$streak[is.nan(combine$streak)]=0
    combine$streak[is.infinite(combine$streak)]=0
    Heatwave=rbind(Heatwave,combine[which(combine$streak>=Day_Threshold),c("x","y","days","streak")])
    yesterday=combine[,c("x","y","streak")]
    yesterday$yest_binary=yesterday$streak
  }
  
  #now pull out the total number of days each location was in a heatwave
  Summary=Heatwave[,c(1,2)]
  Summary=Summary[!duplicated(t(apply(Summary,1,sort))),]
  Summary$HeatwaveDays=0
  
  for (i in 1:length(Summary$x)){
    Grab=Heatwave[which(Heatwave$x==Summary$x[i]&Heatwave$y==Summary$y[i]),]
    for(j in 1:length(Grab$x)){
      if(Grab$streak[j]==Day_Threshold){
        Summary$HeatwaveDays[i]=Summary$HeatwaveDays[i]+Day_Threshold
      }else{
        Summary$HeatwaveDays[i]=Summary$HeatwaveDays[i]+1
      }
    }
  }
  return(Summary)
}
