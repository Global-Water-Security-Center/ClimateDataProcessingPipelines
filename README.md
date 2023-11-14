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

- `Code`: This folder contains all the script files necessary for the data processing pipeline.
  - `Netcdf_to_table`: A script that processes NetCDF files to extract and tabulate temperature data. [Link to Netcdf_to_table](path/to/Netcdf_to_table). This script is essential for converting complex NetCDF climate data into a more accessible table format, facilitating further analysis.
  - _Many more scripts to come..._

- `Datasets`: Place your climate data files in this folder. It is set up to store datasets that the scripts in the `Code` folder will process.

### Prerequisites

Before you begin, ensure you have the following installed:
- [R](https://www.r-project.org/)
- Necessary R packages: `terra`, `sf`, `dplyr`, `tidyr`, `purrr`, `stringr`.

Each script in the `Code` folder may have specific requirements and instructions, which are detailed within the script files themselves.

### Installation

Clone this repository to your local machine using:

```bash
git clone https://github.com/your_username/Geospatial-Climate-Analysis.git
``` 
