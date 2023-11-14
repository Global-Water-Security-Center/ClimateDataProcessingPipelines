
rm(list = ls())
packages <- list("tidyverse","terra","raster","here","arrow","sf")

lapply(packages, require,character.only = T)

source(here("Code","Function.R"))

########### 
### 

############### 
#### anomaly and mean raster 
#########

Temp_anomaly_mean <- terra::rast(here("Datasets",
                                 "era5-daily-t2m-anomalies-2015-12-to-2016-02.nc")) 

############
## max min raster ####
############

Temp_max_min <- terra::rast(here("Datasets",
                                 "era5-daily-t2min-t2max-2015-12-to-2016-02.nc")) 

#################


#####
### Com shapefile ### 
#####

########
# read as sf object 

South_Coms <- sf::read_sf(here("Datasets","Coms_shape","cocoms.shp")) %>%
                        dplyr::filter(cocom == "USSOUTHCOM")




pipeline_function <- function(Temp_anomaly_mean,Temp_max_min,South_Coms) { 
  
  ### convert it to a Spat vector 
  South_Coms <- terra::vect(South_Coms)
  
  #### Mask and reproject ###
  
  Temp_anomaly_mean <- geoRflow_raster_mask(Spatraster = Temp_anomaly_mean,
                                            Spatvect = South_Coms,
                                            project_crs = "EPSG:3857",
                                            projection_method = "bilinear")
  
  
  
  ############################
  ##### Mean temperature extraction ####
  #####################
  
  layer_indices <- 1:91
  
  
  Temp_mean <- geoRflow_netcdf_df(raster_object = Temp_anomaly_mean,
                                  layer_indices = layer_indices) 
  
  
  ## remove the column date from all dataframes in the list 
  
  modified_df_list <- purrr::map(Temp_mean, ~ .x %>% dplyr::select(-date))
  
  ####### 
  
  Temp_mean_2m <- modified_df_list %>% 
    purrr::reduce(inner_join)
  
  
  #### pivoting this to a long table ###
  
  Temp_mean_2m <- Temp_mean_2m %>% 
    tidyr::pivot_longer(cols = mean_t2m_c_1:mean_t2m_c_91,
                        names_to = "days",
                        values_to = "t_mean_2m") %>%
    dplyr::mutate(days = stringr::str_replace_all(days,"mean_t2m_c_",""))
  
  
  
  ####################
  #### Now extract anomaly values ####
  ##############
  
  layer_indices <- 92:182
  
  
  Temp_anomaly <- geoRflow_netcdf_df(raster_object = Temp_anomaly_mean,
                                     layer_indices = layer_indices) 
  
  
  ## remove the column date from all dataframes in the list 
  
  modified_df_list_anomaly <- purrr::map(Temp_anomaly, ~ .x %>% dplyr::select(-date))
  
  ####### 
  
  Temp_anomaly <- modified_df_list_anomaly %>% purrr::reduce(inner_join)
  
  
  #### pivoting this to a long table ###
  
  Temp_anomaly <- Temp_anomaly %>% 
    tidyr::pivot_longer(cols = anom_mean_t2m_c_1:anom_mean_t2m_c_91,
                        names_to = "days",
                        values_to = "t_anom_2m") %>%
    dplyr::mutate(days = stringr::str_replace_all(days,"anom_mean_t2m_c_",""))
  
  
  
  ###############################
  ############### Now extracting maximum and minimum temp ###
  #####
  
  ### 
  
  #### Mask and reproject ###
  
  Temp_max_min <- geoRflow_raster_mask(Spatraster = Temp_max_min,
                                       Spatvect = South_Coms,
                                       project_crs = "EPSG:3857",
                                       projection_method = "bilinear")
  
  
  layer_indices <- 1:91
  
  
  Temp_min <- geoRflow_netcdf_df(raster_object = Temp_max_min,
                                 layer_indices = layer_indices) 
  
  
  ## remove the column date from all dataframes in the list 
  
  modified_df_list_min <- purrr::map(Temp_min, ~ .x %>% dplyr::select(-date))
  
  ####### 
  
  Temp_min <- modified_df_list_min %>% 
    purrr::reduce(inner_join)
  
  
  #### pivoting this to a long table ###
  
  Temp_min <- Temp_min %>% 
    tidyr::pivot_longer(cols = min_t2m_c_1:min_t2m_c_91,
                        names_to = "days",
                        values_to = "t_min_2m") %>%
    dplyr::mutate(days = stringr::str_replace_all(days,"min_t2m_c_",""))
  
  
  
  ####################
  #### Now extract max values ####
  ##############
  
  layer_indices <- 92:182
  
  
  Temp_max <- geoRflow_netcdf_df(raster_object = Temp_max_min,
                                 layer_indices = layer_indices) 
  
  
  ## remove the column date from all dataframes in the list 
  
  modified_df_list_max <- purrr::map(Temp_max, ~ .x %>% dplyr::select(-date))
  
  ####### 
  
  Temp_max <- modified_df_list_max %>% purrr::reduce(inner_join)
  
  
  #### pivoting this to a long table ###
  
  Temp_max <- Temp_max %>% 
    tidyr::pivot_longer(cols = max_t2m_c_1:max_t2m_c_91,
                        names_to = "days",
                        values_to = "t_max_2m") %>%
    dplyr::mutate(days = stringr::str_replace_all(days,"max_t2m_c_",""))
  
  
  
  
  
  ####### Now adding the anomaly, mean, max and min temp in one dataframe ###
  
  Temp_southcom <- list(Temp_max,Temp_min,Temp_mean_2m,Temp_anomaly) %>%
    purrr::reduce(inner_join)
  
  
  ############
  #########
  
  arrow::write_parquet(Temp_southcom,"Temp_southcom_2m.parquet")
  
}

#### execute the pipeline ####
pipeline_function(Temp_anomaly_mean = Temp_anomaly_mean,
                  Temp_max_min = Temp_max_min,
                  South_Coms)






