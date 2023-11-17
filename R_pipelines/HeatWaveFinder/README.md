This function takes daily ERA5 temperature data and looks for heatwaves. 
Inputs to the function are: Dataframe,Temp_threshold,Day_Threshold,Variable
Dataframe has columns x, y, days,and the variable for analysis
  the days column must start with 1, not a month day year format
Temp_threshold is the temperature that indicates a heatwave
Day_Threshold is how many days in a row at the Temp_threshold indicates a heatwave
Variable is the number of the column in the Dataframe that you want to analyze, ie. MaxTemp or MeanTemp

Before you run the function you need to set your working directory and read in your dataframe
