## ----include = FALSE----------------------------------------------------------
NOT_CRAN <- identical(Sys.getenv("NOT_CRAN"), "true")
knitr::opts_chunk$set(
  eval = NOT_CRAN
)

## ----eval=FALSE---------------------------------------------------------------
# install.packages("iRfcb")

## -----------------------------------------------------------------------------
library(iRfcb)

## ----message=FALSE------------------------------------------------------------
# Define data directory
data_dir <- "data"

# Download and extract test data in the data folder
ifcb_download_test_data(dest_dir = data_dir)

## -----------------------------------------------------------------------------
# Example sample names
filenames <- list.files("data/data/2023/D20230314", recursive = TRUE)

# Print filenames
print(filenames)

# Convert filenames to timestamps
timestamps <- ifcb_convert_filenames(filenames)

# Print result
print(timestamps)

## -----------------------------------------------------------------------------
# Example sample names
filenames <- list.files("data/png/Alexandrium_pseudogonyaulax_050")

# Print filenames
print(filenames)

# Convert filenames to timestamps
timestamps <- ifcb_convert_filenames(filenames)

# Print result
print(timestamps)

## -----------------------------------------------------------------------------
# Path to HDR file
hdr_file <- "data/data/2023/D20230314/D20230314T001205_IFCB134.hdr"

# Calculate volume analyzed (in ml)
volume_analyzed <- ifcb_volume_analyzed(hdr_file)

# Print result
print(volume_analyzed)

## -----------------------------------------------------------------------------
# Get runtime from HDR-file
run_time <- ifcb_get_runtime(hdr_file)

# Print result
print(run_time)

## -----------------------------------------------------------------------------
# Read feature files from a folder
features <- ifcb_read_features("data/features/2023/",
                               verbose = FALSE) # Do not print progress bar

# Print output from the first sample in the list
print(features[[1]])

# Read only multiblob feature files
multiblob_features <- ifcb_read_features("data/features/2023", 
                                         multiblob = TRUE,
                                         verbose = FALSE)

# Print output from the first sample in the list
print(multiblob_features[[1]])

## -----------------------------------------------------------------------------
# All ROIs in sample
ifcb_extract_pngs(
  "data/data/2023/D20230314/D20230314T001205_IFCB134.roi",
  gamma = 1, # Default gamma value
  scale_bar_um = 5 # Add a 5 micrometer scale bar
) 

## -----------------------------------------------------------------------------
# Only ROI number 2 and 5
ifcb_extract_pngs("data/data/2023/D20230314/D20230314T003836_IFCB134.roi",
                  ROInumbers = c(2, 5))

## ----eval=FALSE---------------------------------------------------------------
# ifcb_classify_models()

## ----eval=FALSE---------------------------------------------------------------
# # Classify all images in a sample
# results <- ifcb_classify_sample(
#   "data/data/2023/D20230314/D20230314T001205_IFCB134.roi",
#   verbose = FALSE
# )
# 
# # Print result
# print(results)

## ----eval=FALSE---------------------------------------------------------------
# # List extracted PNG files
# png_files <- list.files(
#   "data/data/2023/D20230314/D20230314T001205_IFCB134",
#   pattern = "\\.png$",
#   full.names = TRUE
# )
# 
# # Classify images
# results <- ifcb_classify_images(png_files, verbose = FALSE)
# 
# # Print result
# print(results)

## ----eval=FALSE---------------------------------------------------------------
# # HDF5 (default) - IFCB Dashboard v3 format (requires hdf5r package)
# ifcb_save_classification(
#   "data/data/2023/D20230314/D20230314T001205_IFCB134.roi",
#   output_folder = "output"
# )
# # Creates: output/D20230314T001205_IFCB134_class.h5
# 
# # MAT - IFCB Dashboard v1 format (requires Python with scipy)
# ifcb_save_classification(
#   "data/data/2023/D20230314/D20230314T001205_IFCB134.roi",
#   output_folder = "output",
#   format = "mat"
# )
# # Creates: output/D20230314T001205_IFCB134_class_v1.mat
# 
# # CSV - ClassiPyR-compatible format
# ifcb_save_classification(
#   "data/data/2023/D20230314/D20230314T001205_IFCB134.roi",
#   output_folder = "output",
#   format = "csv"
# )
# # Creates: output/D20230314T001205_IFCB134.csv

## -----------------------------------------------------------------------------
# Example taxa names
taxa_names <- c("Alexandrium_pseudogonyaulax", "Guinardia_delicatula")

# Retrieve WoRMS records
worms_records <- ifcb_match_taxa_names(taxa_names, 
                                       verbose = FALSE) # Do not print progress bar

# Print result
print(worms_records)

## -----------------------------------------------------------------------------
# Read class2use file and select five taxa
class2use <- ifcb_get_mat_variable("data/config/class2use.mat")[10:15]

# Create a dataframe with class name and result from `ifcb_is_diatom`
class_list <- data.frame(class2use,
                         is_diatom = ifcb_is_diatom(class2use, verbose = FALSE))

# Print rows 10-15 of result
print(class_list)

## -----------------------------------------------------------------------------
# Example taxa names
taxa_list <- c(
  "Acanthoceras zachariasii",
  "Nodularia spumigena",
  "Acanthoica quattrospina",
  "Noctiluca",
  "Gymnodiniales"
)

# Get trophic type for taxa
trophic_type <- ifcb_get_trophic_type(taxa_list)

# Print result
print(trophic_type)

## -----------------------------------------------------------------------------
# Get column names from example
shark_colnames <- ifcb_get_shark_colnames()

# Print column names
print(shark_colnames)

# Load example stored from `iRfcb`
shark_example <- ifcb_get_shark_example()

# Print the SHARK data submission example
print(shark_example)

## ----echo=FALSE---------------------------------------------------------------
# Print citation
citation("iRfcb")

## ----include=FALSE------------------------------------------------------------
# Clean up
unlink(data_dir, recursive = TRUE)

