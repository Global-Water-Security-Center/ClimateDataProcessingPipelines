# -*- coding: utf-8 -*-
"""cmip6_data_download.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1u_0YlF8OKRdYxQk0P7SWQDRkLo7_SmEX

The **cmip6_climate_data_download function** serves as a highly valuable tool in the realm of climate data analysis and research. Its primary utility lies in its ability to streamline the process of accessing and downloading specific subsets of climate data from the CMIP6 (Coupled Model Intercomparison Project Phase 6) dataset. Here are some key points highlighting its utility:

1) **Customized Data Retrieval:** Users can specify various parameters like the climate model, timeframe, ensemble member, and climate variable. This customization allows researchers to target their data acquisition precisely, which is crucial for specific climate studies.

2) **Efficient Year Range Selection:** By enabling users to select a specific range of years, the pipeline provides a focused approach to data acquisition, avoiding the need to manually sort through irrelevant data, saving time and computational resources.

3) **Automated Batch Downloading:** The function automates the tedious process of downloading multiple files, which is particularly beneficial when dealing with large datasets typical in climate research.

4) **Organized Data Storage:** By allowing users to specify an output folder, the pipeline ensures that the downloaded data is well-organized and easily accessible for subsequent analysis.

5) **Ease of Use and Reproducibility:** The function is designed with clarity and ease of use in mind, making it accessible even to those with basic programming knowledge. This ease of use promotes reproducibility in research, as other researchers can replicate the data acquisition process with minimal effort.

6) **Time-Saving and Resource-Efficient:** By automating data download and organization, the pipeline significantly reduces the time and effort required for data preparation, enabling researchers to focus more on analysis and interpretation.

**Installing the modules**
"""

import requests  ### allows us to interact the interface which has the data (sending requests to the portal)
import xml.etree.ElementTree as ET  # For parsing XML
import time  # For adding delays between requests
import os  # For handling file paths and directories

"""**Defining the function**

**Parameters:**

**model**: Climate model name as a string (e.g., 'ACCESS-CM2')

**timeframe**: Time frame of the data (e.g., 'historical', 'SSP126', 'SSP245').

**ensemble:** Ensemble member (e.g., 'r1i1p1f1').

**climate_variable (str)**: Climate variable as a string(e.g., 'pr' for precipitation).

**start_year (int)**: **bold text** Start year of the data range.

**end_year (int)**: End year of the data range.

**output_folder (str)**: Path to the output folder where files will be saved.

"""

def download_climate_data_download(model, timeframe, ensemble, climate_variable, start_year, end_year, output_folder):

    """
    Download climate data files from the CMIP6 dataset.

    This function downloads data for a specified climate model, timeframe,
    ensemble member, and climate variable for a range of years. The files
    are saved in a specified output folder.

    Parameters:
    model (str): Climate model name (e.g., 'ACCESS-CM2').
    timeframe (str): Time frame of the data (e.g., 'historical', 'SSP126', 'SSP245').
    ensemble (str): Ensemble member (e.g., 'r1i1p1f1').
    climate_variable (str): Climate variable (e.g., 'pr' for precipitation).
    start_year (int): Start year of the data range.
    end_year (int): End year of the data range.
    output_folder (str): Path to the output folder where files will be saved.

    Usage:
    cmip6_climate_data("ACCESS-CM2", "historical", "r1i1p1f1", "pr", 1950, 1952, "./output_folder")
    """


    # Ensure the output folder exists, if not, create it
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Construct the catalog URL
    catalog_url = f"https://ds.nccs.nasa.gov/thredds/catalog/AMES/NEX/GDDP-CMIP6/{model}/{timeframe}/{ensemble}/{climate_variable}/catalog.xml"

    # Retrieve the XML catalog
    response = requests.get(catalog_url)
    if response.status_code != 200:
        print(f"Failed to retrieve the catalog. Status code: {response.status_code}")
        return

    # Parse the XML
    root = ET.fromstring(response.content)
    ns = {'thredds': 'http://www.unidata.ucar.edu/namespaces/thredds/InvCatalog/v1.0'}

    # Base URL for file downloads
    base_url = "https://ds.nccs.nasa.gov/thredds/fileServer/"

    # Extract file URLs and filter by year range
    file_urls = []
    for dataset in root.findall(".//thredds:dataset", ns):
        url_path = dataset.attrib.get('urlPath')
        if url_path:
            year = int(url_path.split('_')[-1].split('.')[0])
            if start_year <= year <= end_year:
                file_urls.append(base_url + url_path)

    # Download each file
    for file_url in file_urls:
        file_name = os.path.join(output_folder, file_url.split('/')[-1])
        response = requests.get(file_url)
        if response.status_code == 200:
            with open(file_name, 'wb') as file:
                file.write(response.content)
            print(f"Downloaded {file_name}")
        else:
            print(f"Failed to download {file_name}")

        # Optional: Throttle requests
        # time.sleep(1)

# Example usage
download_climate_data_download(model = "ACCESS-ESM1-5",
                      timeframe = "historical",
                      ensemble = "r1i1p1f1",
                      climate_variable = "tasmax",
                      start_year = 1950,
                      end_year = 1952,
                      output_folder = "/content/drive/MyDrive/CMIP6_data")