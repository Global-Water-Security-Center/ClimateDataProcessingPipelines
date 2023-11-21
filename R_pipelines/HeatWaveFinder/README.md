# Heatwave Finder Function

This repository hosts a script designed to analyze ERA5 daily temperature data for the identification of heatwaves. This repository also hosts a script which provides an annotated example of the functions use. 

## Overview
Before running the function you must set your working directory and read in your dataset

The function requires a number of inputs:

- Dataframe: has columns x, y, days, and the variable for analysis. The days column must start with 1, not a month day year format
- Temp_threshold is the temperature that indicates a heatwave
- Day_Threshold is how many days in a row at the Temp_threshold indicates a heatwave
- Variable is the number of the column in the Dataframe that you want to analyze, ie. MaxTemp or MeanTemp

The function returns a dataframe with columns titled x, y, and HeatwaveDays

- x and y are locations from the input Dataframe
- HeatwaveDays indicates the number of days that location was in a heatwave

## Prerequisites

The function does have any prerequisites.

Before running the annotated example script, ensure the following packages are installed in R:

- `ggplot2`
- `arrow`

These can be installed using the command:

```R
install.packages(c("ggplot2", "arrow"))
```
