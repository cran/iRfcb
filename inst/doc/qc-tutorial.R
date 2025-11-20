## ----eval=FALSE---------------------------------------------------------------
# install.packages("iRfcb")

## ----eval=FALSE---------------------------------------------------------------
# library(iRfcb)

## ----include=FALSE------------------------------------------------------------
library(iRfcb)

## ----include=FALSE------------------------------------------------------------
library(reticulate)

# Define path to virtual environment
env_path <- file.path(tempdir(), "iRfcb") # Or your preferred venv path

# Install python virtual environment
tryCatch({
  ifcb_py_install(envname = env_path)
}, error = function(e) {
  warning("Python environment could not be installed.")
})

## ----echo=FALSE---------------------------------------------------------------
# Check if Python is available
if (!py_available(initialize = TRUE)) {
  knitr::opts_chunk$set(eval = FALSE)
  warning("Python is not available. Skipping vignette evaluation.")
} else {
  # List available packages
  available_packages <- py_list_packages(python = reticulate::py_discover_config()$python)
  
  # Check if pandas and matplotlib are available
  if (!"pandas" %in% available_packages$package ||
      !"matplotlib" %in% available_packages$package) {
    knitr::opts_chunk$set(eval = FALSE)
    warning("Required python modules are not available. Skipping vignette evaluation.")
  }
}

## ----eval=FALSE---------------------------------------------------------------
# # Define data directory
# data_dir <- "data"
# 
# # Download and extract test data in the data folder
# ifcb_download_test_data(
#   dest_dir = data_dir,
#   max_retries = 10,
#   sleep_time = 30,
#   verbose = FALSE
# )

## ----include=FALSE------------------------------------------------------------
# Define data directory
data_dir <- "data"

# Download and extract test data in the data folder
if (!dir.exists(data_dir)) {
  # Download and extract test data if the folder does not exist
  ifcb_download_test_data(
    dest_dir = data_dir,
    max_retries = 10,
    sleep_time = 30,
    verbose = FALSE
  )
}

## ----eval=FALSE---------------------------------------------------------------
# # Define path to virtual environment
# env_path <- "~/.virtualenvs/iRfcb" # Or your preferred venv path
# 
# # Install python virtual environment
# ifcb_py_install(envname = env_path)
# 
# # Run PSD quality control
# psd <- ifcb_psd(
#   feature_folder = "data/features/2023",
#   hdr_folder = "data/data/2023",
#   save_data = FALSE,
#   output_file = NULL,
#   plot_folder = NULL,
#   use_marker = FALSE,
#   start_fit = 10,
#   r_sqr = 0.5,
#   beads = 10 ** 12,
#   bubbles = 150,
#   incomplete = c(1500, 3),
#   missing_cells = 0.7,
#   biomass = 1000,
#   bloom = 5,
#   humidity = 70
# )

## ----include=FALSE------------------------------------------------------------
# Run PSD quality control
psd <- ifcb_psd(
  feature_folder = "data/features/2023",
  hdr_folder = "data/data/2023",
  save_data = FALSE,
  output_file = NULL,
  plot_folder = NULL,
  use_marker = FALSE,
  start_fit = 10,
  r_sqr = 0.5,
  beads = 10 ** 12,
  bubbles = 150,
  incomplete = c(1500, 3),
  missing_cells = 0.7,
  biomass = 1000,
  bloom = 5,
  humidity = 70,
  fea_v = 2, # Use v2 features
)

## -----------------------------------------------------------------------------
# Print output from PSD
head(psd$fits)
head(psd$flags)

# Plot PSD of the first sample
plot <- ifcb_psd_plot(
  sample_name = psd$data$sample[1],
  data = psd$data,
  fits = psd$fits,
  start_fit = 10
)

# Print the plot
print(plot)

## -----------------------------------------------------------------------------
# Read HDR data and extract GPS position (when available)
gps_data <- ifcb_read_hdr_data(
  "data/data/", 
  gps_only = TRUE, 
  verbose = FALSE # Do not print progress bar
)

# Create new column with the results
gps_data$near_land <- ifcb_is_near_land(
  gps_data$gpsLatitude,
  gps_data$gpsLongitude,
  distance = 100, # 100 meters from shore
  shape = NULL # Using the default NE 1:10m Land Polygon
) 

# Print output
head(gps_data)

# Alternatively, you can choose to plot the points on a map
near_land_plot <- ifcb_is_near_land(
  gps_data$gpsLatitude,
  gps_data$gpsLongitude,
  distance = 2500, # 2500 meters from shore
  plot = TRUE,
)

# Print the plot
print(near_land_plot)

## -----------------------------------------------------------------------------
# Define example latitude and longitude vectors
latitudes <- c(55.337, 54.729, 56.311, 57.975)
longitudes <- c(12.674, 14.643, 12.237, 10.637)

# Check in which Baltic sea basin the points are in
points_in_the_baltic <- ifcb_which_basin(latitudes, longitudes, shape_file = NULL)
# Print output
print(points_in_the_baltic)

# Plot the points and the basins
ifcb_which_basin(latitudes, longitudes, plot = TRUE, shape_file = NULL)

## -----------------------------------------------------------------------------
# Define example latitude and longitude vectors
latitudes <- c(55.337, 54.729, 56.311, 57.975)
longitudes <- c(12.674, 14.643, 12.237, 10.637)

# Check if the points are in the Baltic Sea Basin
points_in_the_baltic <- ifcb_is_in_basin(latitudes, longitudes)

# Print results
print(points_in_the_baltic)

# Plot the points and the basin
ifcb_is_in_basin(latitudes, longitudes, plot = TRUE)

## -----------------------------------------------------------------------------
# Print available coordinates from .hdr files
head(gps_data, 4)

# Define path where ferrybox data are located
ferrybox_folder <- "data/ferrybox_data"

# Get GPS position from ferrybox data
positions <- ifcb_get_ferrybox_data(gps_data$timestamp, 
                                    ferrybox_folder)

# Print result
head(positions)

## -----------------------------------------------------------------------------
# Get salinity and temperature from ferrybox data
ferrybox_data <- ifcb_get_ferrybox_data(gps_data$timestamp,
                                        ferrybox_folder,
                                        parameters = c("8180", "8181"))

# Print result
head(ferrybox_data)

## ----include=FALSE------------------------------------------------------------
# Clean up
unlink(data_dir, recursive = TRUE)
unlink(env_path, recursive = TRUE)

## ----echo=FALSE---------------------------------------------------------------
# Print citation
citation("iRfcb")

