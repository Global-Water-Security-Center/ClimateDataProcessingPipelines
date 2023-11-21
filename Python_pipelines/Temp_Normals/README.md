# Earth Engine Climate Data Processing Pipeline

## Overview

This Python-based pipeline is designed for processing and analyzing climate data using Google Earth Engine. It focuses on calculating monthly normals (average values) for a specified band from satellite datasets within a given region of interest (ROI) and time period. The pipeline is tailored for researchers and data analysts working in the fields of climate science, environmental monitoring, and geospatial analysis.

## Features

- **Flexible Data Selection**: Choose specific satellite datasets, timeframes, and bands for analysis.
- **Region of Interest (ROI) Definition**: Process data for custom geographical areas by specifying a shapefile.
- **Monthly Normals Calculation**: Calculate the monthly average values across years for the specified band.
- **GeoTiff Exporting**: Export the monthly averages as GeoTiff files for each month.
- **Automated Geospatial Workflows**: Streamline complex geospatial data processing tasks.
- **User-Friendly**: Accessible to users with varying levels of programming and geospatial analysis skills.

## Data Source

The pipeline utilizes Google Earth Engine for accessing a vast repository of satellite imagery and geospatial datasets. The specific datasets and bands analyzed are defined by the user, catering to a wide range of research and analysis needs.

## Requirements

- Python 3.x
- Libraries: `geopandas`, `ee` (Google Earth Engine API), `pandas`, `os`, `rasterio`, `shapely`, `geemap`

## Installation

Ensure Python 3.x is installed along with the necessary libraries. Google Earth Engine API requires authentication and initialization in your environment.

## Usage

To use the pipeline, execute the `main` function with the appropriate parameters:

- **Shapefile Path**: Path to the shapefile defining the ROI.
- **Dataset**: Name or ID of the satellite image collection in Earth Engine.
- **Start and End Dates**: Time range for the data analysis.
- **Band Name**: Specific band in the satellite dataset to be analyzed.
- **Output Directory**: Directory where the exported GeoTiff files will be saved.
- **Scale**: The scale in meters for the exported images.

Here's an example to illustrate the usage:

```python

def main():
    # Read the shapefile
    gdf = gpd.read_file('/content/drive/MyDrive/COM_shapefiles/cocoms.shp')

    # Transform the GeoDataFrame to EPSG:4326
    gdf = gdf.to_crs(epsg=4326)

    # Load and filter your GeoDataFrame
    filtered_gdf = gdf[gdf['cocom'] == 'USSOUTHCOM']

    # Combine all geometries into a single geometry
    combined_geom = filtered_gdf.geometry.unary_union

    # Get the bounding box of the combined geometry
    minx, miny, maxx, maxy = combined_geom.bounds

    # Create an Earth Engine Geometry for the bounding box
    roi = ee.Geometry.Rectangle([minx, miny, maxx, maxy])

    # Define other parameters for the earth_engine_calculate_normals function
    dataset = 'ECMWF/ERA5/MONTHLY'
    start_date = '1990-01-01' ### Define start date   
    end_date = '2019-12-01' ## Define the end date
    band_name = 'mean_2m_air_temperature' # Define the band of interest
    roi = roi ## region of interest
    output_dir = '/content/drive/MyDrive/ERA_monthly_normals/'
    scale = 27830 ## this is in metres

    # Call the earth_engine_calculate_normals function
    exported_files = earth_engine_calculate_normals(dataset, start_date, end_date, band_name, roi, output_dir, scale)

    # Optionally, do something with the returned list of exported files
    print("Exported files:", exported_files)

# Call the main function
if __name__ == "__main__":
    main()


```
