

geoRflow_cmip6_data_download <- function(model, timeframe, ensemble, climate_variable, start_year, end_year, output_folder,timeout) {
  # Ensure the output directory exists
  if (!dir.exists(output_folder)) {
    dir.create(output_folder, recursive = TRUE)
  }
  
  # Construct the catalog URL to access the data
  catalog_url <- paste0("https://ds.nccs.nasa.gov/thredds/catalog/AMES/NEX/GDDP-CMIP6/", model, "/", timeframe, "/", ensemble, "/", climate_variable, "/catalog.xml")
  
  # Retrieve the XML catalog 
  ## this step also stops the function if the link is broken
  catalog <- httr::GET(catalog_url)
  if (httr::status_code(catalog) != 200) {
    stop("Failed to retrieve the catalog.")
  }
  
  # Parse the XML
  
  ### this step translates the raw content of catalog into a format that the computer can read (the result is a parsed XML document)
  doc <- XML::xmlParse(rawToChar(catalog$content))  
  
  ### This searches the entire translated/parsed XML document and unearths //thredds:dataset. This is relevant to THREDDS
  urls <- XML::xpathSApply(doc, "//thredds:dataset", XML::xmlGetAttr, "urlPath", namespaces = c(thredds = "http://www.unidata.ucar.edu/namespaces/thredds/InvCatalog/v1.0"))
  
  #### All information is coerced into characters
  urls <- as.character(urls)  # Coerce to character vector
  
  # Filter URLs by year range
  base_url <- "https://ds.nccs.nasa.gov/thredds/fileServer/"
  
  ## construcing patterns for each file to be downloaded
  pattern <- paste0("_(", paste(start_year:end_year, collapse = "|"), ")\\.nc")
  
  filtered_urls <- urls[stringr::str_detect(urls, pattern)]
  
  # Download each file
  ## tries 3 times to download a file 
  options(timeout = timeout)  # Increase timeout to 10 minutes
  for (url_path in filtered_urls) {
    file_url <- paste0(base_url, url_path)
    file_name <- basename(file_url)
    file_path <- file.path(output_folder, file_name)
    
    success <- FALSE
    attempts <- 0
    while (!success && attempts < 3) {
      try({
        download.file(file_url, file_path, mode = "wb")
        success <- TRUE
      }, silent = TRUE)
      attempts <- attempts + 1
    }
    if (success) {
      cat("Downloaded", file_name, "\n")
    } else {
      cat("Failed to download", file_name, "\n")
    }
  }
}




geoRflow_cmip6_spatial_subset_download <- function(model, timeframe, ensemble, climate_variable, start_year, end_year, north, south, east, west, output_folder, timeout) {
  # Ensure the output directory exists
  if (!dir.exists(output_folder)) {
    dir.create(output_folder, recursive = TRUE)
  }
  
  # Base URL for the NetCDF Subset Service (NCSS)
  ncss_base_url <- paste0("https://ds.nccs.nasa.gov/thredds/ncss/grid/AMES/NEX/GDDP-CMIP6/", model, "/", timeframe, "/", ensemble, "/", climate_variable, "/")
  
  # Spatial subset and time parameters
  spatial_params <- paste0("?var=", climate_variable, "&north=", north, "&south=", south, "&east=", east, "&west=", west, "&horizStride=1")
  time_params <- "&time_start=<YEAR>-01-01T00:00:00Z&time_end=<YEAR>-12-31T23:59:59Z"
  format_params <- "&accept=netcdf3&addLatLon=true"
  
  # Loop through years and construct the URL for each file
  for (year in start_year:end_year) {
    # Replace <YEAR> with the actual year in the time parameters
    year_time_params <- gsub("<YEAR>", year, time_params)
    
    # Construct the final URL
    ncss_url <- paste0(ncss_base_url, climate_variable, "_day_", model, "_", timeframe, "_", ensemble, "_gn_", year, ".nc", spatial_params, year_time_params, format_params)
    
    # Download the file
    file_name <- paste0(model, "_", climate_variable, "_", year, ".nc")
    file_path <- file.path(output_folder, file_name)
    download_file(ncss_url, file_path, timeout)
  }
}

download_file <- function(url, path, timeout) {
  options(timeout = timeout)
  tryCatch({
    download.file(url, path, mode = "wb")
    message("Downloaded: ", path)
  }, error = function(e) {
    message("Failed to download: ", path, "\nError: ", e$message)
  })
}
