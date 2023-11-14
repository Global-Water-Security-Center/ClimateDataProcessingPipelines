# Climate Data Processing Pipeline

This repository hosts a script designed for the extraction and processing of geospatial climate data. The script facilitates the analysis of temperature anomalies, mean temperatures, as well as maximum and minimum temperatures within the SOUTHCOM (Southern Command) region.

## Overview

The script performs several key operations:

- Reads in anomaly and mean temperature raster data from NetCDF files.
- Processes maximum and minimum temperature raster data.
- Filters a shapefile to target the SOUTHCOM region, converting it to a `SpatVector`.
- Applies a custom pipeline function for raster masking, reprojection, and data extraction.

## Prerequisites

Before running the script, ensure the following packages are installed in R:

- `tidyverse`
- `terra`
- `raster`
- `here`
- `arrow`
- `sf`

These can be installed using the command:

```R
install.packages(c("tidyverse", "terra", "raster", "here", "arrow", "sf"))
```
