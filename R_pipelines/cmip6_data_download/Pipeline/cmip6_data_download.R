
library(httr)
library(XML)
library(stringr)  
library(here)



source(here("Pipeline","Functions.R"))

# Example usage
geoRflow_cmip6_climate_data_download(model = "ACCESS-ESM1-5", timeframe = "historical", 
                   ensemble = "r1i1p1f1", climate_variable = "tasmax", 
                   start_year = 1990, end_year = 1991,
                   output_folder = here("Rasters"),
                   timeout = 600) 
