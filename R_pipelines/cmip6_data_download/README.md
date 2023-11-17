# CMIP6 Climate Data Download Pipeline

## Overview

This R-based pipeline facilitates the efficient downloading of climate data from the CMIP6 (Coupled Model Intercomparison Project Phase 6) dataset. It is designed to help researchers, climate scientists, and data analysts easily access and organize climate data specific to their needs. The pipeline interfaces with the THREDDS Data Server provided by NASA's NCCS (NASA Center for Climate Simulation) to access the NEX-GDDP-CMIP6 data collection.

## Features

- **Custom Data Retrieval**: Specify climate model, timeframe, ensemble member, and climate variable.
- **Year Range Selection**: Focus on specific years to streamline the data collection process.
- **Automated Batch Downloading**: Download multiple files automatically, saving time and effort.
- **Organized Data Storage**: Specify output folders for easy data management and access.
- **User-Friendly**: Simple and clear for users with basic to advanced programming skills.

## Data Source

The data is sourced from the NEX-GDDP-CMIP6 collection, hosted on NASA's NCCS THREDDS Data Server. This dataset includes global climate simulations under various future scenarios, providing a rich resource for climate change research. More information about the data collection can be found [here](https://www.nccs.nasa.gov/services/data-collections/land-based-products/nex-gddp-cmip6).

## Requirements

- R
- Libraries: `httr`, `stringr`, `XML`, `here`

## Installation

No additional installation is required other than the necessary R libraries. Ensure you have R installed and the above-mentioned libraries available in your environment.

## Usage

To use the pipeline, simply call the function `geoRflow_cmip6_climate_data_download` with the appropriate parameters:

**model**: Climate model name as a string (e.g., 'ACCESS-ESM1-5')

**timeframe**: Time frame of the data (e.g., 'historical', 'SSP126', 'SSP245').

**ensemble**: Ensemble member (e.g., 'r1i1p1f1').

**climate_variable (str)**: Climate variable as a string(e.g., 'tasmax' for maximum near surface temperature).

**start_year (int)**: bold text Start year of the data range.

**end_year (int)**: End year of the data range.

**output_folder (str)**: Path to the output folder where files will be saved.

**timeout (int)**: An integer specifying the seconds to timeout the download process (the default is 600 seconds)

## For example

```{r}

geoRflow_cmip6_climate_data_download(model = "ACCESS-ESM1-5", timeframe = "historical",
                   ensemble = "r1i1p1f1", climate_variable = "tasmax",
                   start_year = 1990, end_year = 1992,
                   output_folder = here("Rasters"),
                   timeout = 600)

```
