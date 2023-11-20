# CMIP6 Climate Data Download Pipeline

## Overview

This R-based pipeline facilitates the efficient downloading of climate data from the CMIP6 (Coupled Model Intercomparison Project Phase 6) dataset at both global and local scale. It is designed to help researchers, climate scientists, and data analysts easily access and organize climate data specific to their needs. The pipeline interfaces with the THREDDS Data Server provided by NASA's NCCS (NASA Center for Climate Simulation) to access the NEX-GDDP-CMIP6 data collection.

## Features

- **Custom Data Retrieval**: Specify climate model, timeframe, ensemble member, and climate variable.
- **Spatial Subsetting**: In addition downloading data based on a geographic bounding box is also possible
- **Year Range Selection**: Focus on specific years to streamline the data collection process.
- **Automated Batch Downloading**: Download multiple files automatically, saving time and effort.
- **Organized Data Storage**: Specify output folders for easy data management and access.
- **User-Friendly**: Simple and clear for users with basic to advanced programming skills.

The `geoRflow_cmip6_data_download` enables the user to download data for the entire spatial extent which the dataset covers (usually global) and the `geoRflow_cmip6_spatial_subset_download` helps the user download the data based on a specific bounding box


## Data Source

The data is sourced from the NEX-GDDP-CMIP6 collection, hosted on NASA's NCCS THREDDS Data Server. This dataset includes global climate simulations under various future scenarios, providing a rich resource for climate change research. More information about the data collection can be found [here](https://www.nccs.nasa.gov/services/data-collections/land-based-products/nex-gddp-cmip6).

## Requirements

- R
- Libraries: `httr`, `stringr`, `XML`, `here`

## Installation

No additional installation is required other than the necessary R libraries. Ensure you have R installed and the above-mentioned libraries available in your environment.

## Usage

To use the pipeline, simply call the function `geoRflow_cmip6_data_download` or `geoRflow_cmip6_spatial_subset_download` with the appropriate parameters:

**model**: Climate model name as a string (e.g., 'ACCESS-ESM1-5')

**timeframe**: Time frame of the data (e.g., 'historical', 'SSP126', 'SSP245').

**ensemble**: Ensemble member (e.g., 'r1i1p1f1').

**climate_variable (str)**: Climate variable as a string(e.g., 'tasmax' for maximum near surface temperature).

**start_year (int)**: bold text Start year of the data range.

**end_year (int)**: End year of the data range.

**output_folder (str)**: Path to the output folder where files will be saved.

**timeout (int)**: An integer specifying the seconds to timeout the download process (the default is 600 seconds)

**north, south, east, west:** Coordinates of the bounding box. (only for `geoRflow_cmip6_spatial_subset_download`)

## For example

To download global data

```{r}

geoRflow_cmip6_data_download(model = "ACCESS-ESM1-5", timeframe = "historical",
                   ensemble = "r1i1p1f1", climate_variable = "tasmax",
                   start_year = 1990, end_year = 1992,
                   output_folder = here("Rasters"),
                   timeout = 600)

```

To download data based on a specific bounding box

```{r}

### defining the north, south, east and west of the bounding box ###

North_latitude <- 40.0
South_latitude <- 12.0
West_longitude <-  25.0
East_longitude <- 60.0



geoRflow_cmip6_spatial_subset_download(model = "ACCESS-ESM1-5", timeframe = "historical",
                                    ensemble = "r1i1p1f1", climate_variable = "tasmax",
                                    start_year = 1990, end_year = 1991,
                                    north = North_latitude, south= South_latitude,
                                    east= East_longitude, west= West_longitude,
                                    output_folder = here("Rasters"),
                                    timeout = 600)

```

## WHAT HAPPENS UNDER THE HOOD (geoRflow_cmip6_data_download function)

### Building the URL to Access Data

- **Creating a Specific Address:**
  - `catalog_url <- paste0(...)`
    - Imagine you're writing a letter and need an exact address. This line creates a precise web address (URL) to reach the data you want, combining different parts like the data model, time frame, etc.

### Getting the Data from the Web

- **Fetching the Data:**
  - `catalog <- httr::GET(catalog_url)`
    - This is like sending out a request to fetch a book from a specific library shelf using the address we just wrote.

- **Checking if We Got the Book:**
  - `if (httr::status_code(catalog) != 200) { stop(...) }`
    - This checks if we successfully got the book. If not, it's like the librarian telling us the book isn't available.

### Reading and Understanding the Book (XML Document)

- **Translating the Book:**
  - `doc <- XML::xmlParse(rawToChar(catalog$content))`
    - This is like translating the book (the data) into a language we can understand.

- **Finding Chapters on Specific Topics:**
  - `urls <- XML::xpathSApply(doc, "//thredds:dataset", XML::xmlGetAttr, "urlPath", namespaces = c(thredds = "..."))`
    - Now, we're looking for specific chapters (datasets) in our book.
    - `//thredds:dataset` is like an instruction to find all chapters labeled 'dataset' under a specific category ('thredds').
    - The `XML::xmlGetAttr` function is like asking for the page number of each chapter.

- **Understanding the Category (Namespace):**
  - `namespaces = c(thredds = "...")`
    - This is like defining what we mean by 'thredds' category. It's a unique identifier that tells us we're looking at the right chapters.
    - The URL `http://www.unidata.ucar.edu/namespaces/thredds/InvCatalog/v1.0` is used to specify this category, ensuring we're looking in the right section of our book.

### Selecting the Right Chapters (Filtering Data)

- **Setting Base for Data Files:**
  - `base_url <- "https://ds.nccs.nasa.gov/thredds/fileServer/"`
    - This sets the base location from where we'll actually pick up the data files.

- **Choosing Chapters from Certain Years:**
  - `pattern <- paste0("_(", paste(start_year:end_year, collapse = "|"), ")\\.nc")`
    - It's like saying, "I want chapters from these specific years only."

- **Applying Our Choice:**
  - `filtered_urls <- urls[stringr::str_detect(urls, pattern)]`
    - This step filters out just the chapters (URLs) we want based on the years we chose.

### Bringing the Chapters Home (Downloading the Data)

- **Setting a Time Limit for Downloads:**
  - `options(timeout = timeout)`
    - This sets a time limit to try and download each chapter, so we don't wait too long.

- **Downloading Each Chapter:**
  - `for (url_path in filtered_urls) {...}`
    - This loop is like going through each selected chapter and bringing it home.

- **Trying Multiple Times if Needed:**
  - `while (!success && attempts < 3) {...}`
    - If a chapter doesn't come home on the first try, we try up to two more times.
