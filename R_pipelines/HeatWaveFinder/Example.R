#Test the Heatwaves Function
#Here's an example of how to use the Heatwaves Function

#set your working directory
setwd("C:\\Users\\wtpluer\\Desktop\\ERA Daily Data")

#I need arrow to pull in a parquet file and ggplot2 to plot the outputs in this example
#you don't need them to run the function 
library(arrow)
library(ggplot2)

#read in your Dataset
Temp=read_parquet("Temp_southcom_2m.parquet")

#here is where you would do any format adjustments before running the function

#run the Heatwaves function and save the outputs to a dataframe called Mean_Summary
#Name the outputs whatever you want
#Here I am running the function on a dataframe titled Temp that I pulled in earlier in the script
#I am using 30 degrees C as my temperature threshold,3 days as my days threshold, and 
#I want to analyze the 6th column in the Temp dataframe which is mean temp values
Mean_Summary=Heatwaves(Temp,30,3,6)
#it will likely take a few minutes to run 
#the function returns a dataframe with column headers x, y, and HeatwaveDays. x and y are the locations in your initial dataset
#HeatwaveDays is the number of days that that location was in a heatwave during your time period of interest

#Optional, plot the output, here we use ggplot2 and put x and y on their respective axes and the color of the point 
#indicates how many days that location was in a heatwave
ggplot(Mean_Summary,aes(x,y, color=HeatwaveDays))+geom_point()+
  scale_color_gradient(low="yellow",high="red")

#write your output file to either a parquet file or a csv
write_parquet(Mean_Summary,"Mean_Summary.parquet")
write.csv(Mean_Summary,"Mean_Summary.csv")
