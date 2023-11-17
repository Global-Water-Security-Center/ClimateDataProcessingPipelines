# CMIP6 Climate Data Download Pipeline

## Overview

This Python-based pipeline facilitates the efficient downloading of climate data from the CMIP6 (Coupled Model Intercomparison Project Phase 6) dataset. It is designed to help researchers, climate scientists, and data analysts easily access and organize climate data specific to their needs. The pipeline interfaces with the THREDDS Data Server provided by NASA's NCCS (NASA Center for Climate Simulation) to access the NEX-GDDP-CMIP6 data collection.

## Features

- **Custom Data Retrieval**: Specify climate model, timeframe, ensemble member, and climate variable.
- **Year Range Selection**: Focus on specific years to streamline the data collection process.
- **Automated Batch Downloading**: Download multiple files automatically, saving time and effort.
- **Organized Data Storage**: Specify output folders for easy data management and access.
- **User-Friendly**: Simple and clear for users with basic to advanced programming skills.

## Data Source

The data is sourced from the NEX-GDDP-CMIP6 collection, hosted on NASA's NCCS THREDDS Data Server. This dataset includes global climate simulations under various future scenarios, providing a rich resource for climate change research. More information about the data collection can be found [here](https://www.nccs.nasa.gov/services/data-collections/land-based-products/nex-gddp-cmip6).

## Requirements

- Python 3.x
- Libraries: `requests`, `xml.etree.ElementTree`, `os`, `time`

## Installation

No additional installation is required other than the necessary Python libraries. Ensure you have Python 3.x installed and the above-mentioned libraries available in your environment.

## Usage

To use the pipeline, simply call the function `cmip6_climate_data_download` with the appropriate parameters:

**model**: Climate model name as a string (e.g., 'ACCESS-CM2')

**timeframe**: Time frame of the data (e.g., 'historical', 'SSP126', 'SSP245').

**ensemble**: Ensemble member (e.g., 'r1i1p1f1').

**climate_variable (str)**: Climate variable as a string(e.g., 'pr' for precipitation).

**start_year (int)**: bold text Start year of the data range.

**end_year (int)**: End year of the data range.

**output_folder (str)**: Path to the output folder where files will be saved.

## For example

```python

cmip6_climate_data_download(model = "ACCESS-CM2", timeframe = "historical",
                   ensemble = "r1i1p1f1", climate_variable = "pr",
                   start_year = 1950, end_year = 1952,
                   output_folder = "./output_folder")

```
