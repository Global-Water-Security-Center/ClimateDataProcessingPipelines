

geoRflow_cmip6_climate_data_download <- function(model, timeframe, ensemble, climate_variable, start_year, end_year, output_folder,timeout) {
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
