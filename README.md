# Geospatial Data Extraction and Processing for Climate Analysis

This repository contains a suite of tools and scripts focused on data extraction and processing pipelines for geospatial data, specifically tailored to facilitate climate analysis. It's designed to streamline the handling of climate datasets, applying geospatial techniques for a comprehensive understanding of climatic trends and patterns.

## Features

- Extraction of climate data from various sources.
- Reprojection and spatial manipulation of geospatial data.
- Data processing pipelines to convert raw data into actionable insights.
- Tools to analyze and visualize climate trends.

## Getting Started

### Repository Structure

This repository is organized into several key folders:

- `R_pipelines`: This folder contains all the script files necessary for the data processing pipeline.
  - `Netcdf_to_table`: This folder contains the script that processes NetCDF files to extract and tabulate temperature data and a folder to store the dataset that the scripts will process. [Link to Netcdf_to_table](https://github.com/Global-Water-Security-Center/ClimateDataProcessingPipelines/tree/main/R_pipelines/Netcdf_to_table).
     - `Pipeline`: This folder contains the actual scripts. The scripts are essential for converting complex NetCDF climate data into a more accessible table format, facilitating further analysis.
     - `Datasets`: **Place** your climate data files in this folder. It is set up to store datasets that the scripts in the folder will process
- `Python_pipelines`:
  - `cmip6_data_download`: This folder contains the Python script cmip6_climate_data.py, which contains the function for downloading climate data from the CMIP6 dataset. This script is designed to interface with the THREDDS Data Server, allowing users to specify parameters like climate model, timeframe, ensemble member, and desired climate variables, along with a year range for focused data retrieval. The folder may also include a README file providing detailed instructions and information about the usage and features of the script. [Link to cmip6_climate_data.py](https://github.com/Global-Water-Security-Center/ClimateDataProcessingPipelines/tree/main/Python_pipelines/cmip6_data_download/Pipeline)
      - `Pipeline` : This folder contains the actual Python script


### Prerequisites for R pipelines

Before you begin, ensure you have the following installed:
- [R](https://www.r-project.org/)
- Necessary R packages: `terra`, `sf`, `dplyr`, `tidyr`, `purrr`, `stringr`.


### Prerequisites for Python pipelines

Make sure you have the latest version of Python installed (https://www.python.org/downloads/) along with an IDE (Spyder, VS Code, PyCharm etc)

### Installation

Clone this repository to your local machine using:

```bash
git clone https://github.com/your_username/Geospatial-Climate-Analysis.git
```

#### Maintainers

- Sambadi Majumder (smajumder1@ua.edu)
