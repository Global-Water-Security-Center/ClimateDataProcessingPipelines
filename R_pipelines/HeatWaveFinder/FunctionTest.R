#Test the Heatwaves Function
setwd("C:\\Users\\wtpluer\\Desktop\\ERA Daily Data")
library(arrow)
library(ggplot2)
Temp=read_parquet("Temp_southcom_2m.parquet")

Mean_Summary=Heatwaves(Temp,30,3,6)

ggplot(Mean_Summary,aes(x,y, color=HeatwaveDays))+geom_point()+
  scale_color_gradient(low="yellow",high="red")

write_parquet(Mean_Summary,"Mean_Summary.parquet")
write.csv(Mean_Summary,"Mean_Summary.csv")
