## ----eval=FALSE---------------------------------------------------------------
# # install.packages("remotes")
# remotes::install_github("EuropeanIFCBGroup/iRfcb")

## ----eval=FALSE---------------------------------------------------------------
# library(iRfcb)

## ----include=FALSE------------------------------------------------------------
library(iRfcb)

## ----eval=FALSE---------------------------------------------------------------
# # Define data directory
# data_dir <- "data"
# 
# # Download and extract test data in the data folder
# ifcb_download_test_data(dest_dir = data_dir,
#                         max_retries = 10,
#                         sleep_time = 30,
#                         verbose = FALSE)

## ----include=FALSE------------------------------------------------------------
# Define data directory
data_dir <- "data"

# Download and extract test data in the data folder
if (!dir.exists(data_dir)) {
  # Download and extract test data if the folder does not exist
  ifcb_download_test_data(dest_dir = data_dir,
                          max_retries = 10,
                          sleep_time = 30,
                          verbose = FALSE)
}

## -----------------------------------------------------------------------------
# Extract .png images
ifcb_extract_annotated_images(manual_folder = "data/manual",
                              class2use_file = "data/config/class2use.mat",
                              roi_folders = "data/data",
                              out_folder = "data/extracted_images",
                              skip_class = 1, # or "unclassified"
                              verbose = FALSE) # Do not print messages

## -----------------------------------------------------------------------------
# Create zip-archive
ifcb_zip_pngs(png_folder = "data/extracted_images",
              zip_filename = "data/zip/ifcb_annotated_images_corrected.zip",
              readme_file = system.file("exdata/README-template.md", 
                                        package = "iRfcb"), # Template icluded in `iRfcb`
              email_address = "tutorial@test.com",
              version = "1.1",
              print_progress = FALSE)

## -----------------------------------------------------------------------------
# Create zip-archive
ifcb_zip_matlab(manual_folder = "data/manual",
                features_folder = "data/features",
                class2use_file = "data/config/class2use.mat",
                zip_filename = "data/zip/ifcb_matlab_files_corrected.zip",
                data_folder = "data/data",
                readme_file = system.file("exdata/README-template.md", 
                                          package = "iRfcb"), # Template icluded in `iRfcb`
                matlab_readme_file = system.file("exdata/MATLAB-template.md", 
                                                 package = "iRfcb"), # Template icluded in `iRfcb`
                email_address = "tutorial@test.com",
                version = "1.1",
                print_progress = FALSE)

## -----------------------------------------------------------------------------
# Create MANIFEST.txt of the zip folder content
ifcb_create_manifest("data/zip")

## ----eval=FALSE---------------------------------------------------------------
# # Define data directories
# skagerrak_kattegat_dir <- "data_skagerrak_kattegat"
# tangesund_dir <- "data_tangesund"
# merged_dir <- "data_skagerrak_kattegat_tangesund_merged"
# 
# # Download and extract Skagerrak-Kattegat data in the data folder
# ifcb_download_test_data(dest_dir = skagerrak_kattegat_dir,
#                         figshare_article = "48158725")
# 
# # Download and extract Tångesund data in the data folder
# ifcb_download_test_data(dest_dir = tangesund_dir,
#                         figshare_article = "48158731")
# 
# # Initialize the python session if not already set up
# env_path <- file.path(tempdir(), "iRfcb") # Or your preferred venv path
# ifcb_py_install(envname = env_path)
# 
# # Merge Skagerrak-Kattegat and Tångesund to a single dataset
# ifcb_merge_manual(
#   class2use_file_base = file.path(skagerrak_kattegat_dir, "config/class2use.mat"),
#   class2use_file_additions = file.path(tangesund_dir, "config/class2use.mat"),
#   class2use_file_output = file.path(merged_dir, "config/class2use.mat"),
#   manual_folder_base = file.path(skagerrak_kattegat_dir, "manual"),
#   manual_folder_additions = file.path(tangesund_dir, "manual"),
#   manual_folder_output = file.path(merged_dir, "manual"))

## ----echo=FALSE---------------------------------------------------------------
# Print citation
citation("iRfcb")

## ----include=FALSE------------------------------------------------------------
# Clean up
unlink(file.path(data_dir, "extracted_images"), recursive = TRUE)
unlink(file.path(data_dir, "zip"), recursive = TRUE)

