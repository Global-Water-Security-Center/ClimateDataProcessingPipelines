
library(httr)
library(XML)
library(stringr)  
library(here)



source(here("Pipeline","Functions.R"))

# Example usage ## Whole world ## or the full spatial extent of the data 
geoRflow_cmip6_data_download(model = "ACCESS-ESM1-5", timeframe = "historical", 
                   ensemble = "r1i1p1f1", climate_variable = "tasmax", 
                   start_year = 1990, end_year = 1991,
                   output_folder = here("Rasters"),
                   timeout = 600) 




##### Example usage ### A spatial subset given by a region of interest bounding box ##

### defining the north, south, east and west of the bounding box ###

North_latitude <- 40.0
South_latitude <- 12.0 
West_longitude <-  25.0 
East_longitude <- 60.0 



geoRflow_cmip6_spatial_subset_download(model = "CNRM-ESM2-1", timeframe = "historical", 
                                    ensemble = "r1i1p1f2", climate_variable = "tasmax", 
                                    start_year = 1990, end_year = 1991,
                                    north = North_latitude, south= South_latitude, 
                                    east= East_longitude, west= West_longitude,
                                    output_folder = here("Rasters"),
                                    timeout = 600)




list.files(here("Rasters"))
library(terra)
raster <- terra::rast(here("Rasters","CNRM-ESM2-1_tasmax_1991.nc"))
terra::plot(raster)

########### 
library(sf)

Koppen <- sf::st_read(here('MiddleEast.gdb'), layer = "ME_Cyprus_Koppen3Zones")

masked <- terra::mask(raster,terra::vect(Koppen))

terra::plot(masked)




