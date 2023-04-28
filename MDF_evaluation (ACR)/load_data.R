# Read CSV file into a dataframe
csv_data <- read.csv("~/lightcurve/MDF_data/flares_list_for_R.csv")

# Define paths and aperture size
aperture_size <- 7
mdf_path="~/lightcurve/MDF_data"

# Create an empty list to store dataframes
list_of_dfs <- list()

# Loop through each row of the CSV dataframe
for (index in seq_along(csv_data$Gaia.ID)) {
  
  # Get file name and peak time for the current row
  file_name <- csv_data$Gaia.ID[index]
  peak_time_mjd <- csv_data$Peak.time[index]
  
  # Get the path for the LC file and MJD file
  lc_file <- file.path(mdf_path, sprintf("lc_flux_catalog_aperture_r%d_txt", 
                                         aperture_size), paste0(file_name, ".txt"))
  mjd_file <- file.path(mdf_path, sprintf("timestamp_flux_catalog_aperture_r%d_txt", 
                                          aperture_size), paste0(file_name, ".txt"))
  
  # Read in the instances and MJD timestamps from the files as numeric vectors
  instances <- as.numeric(readLines(lc_file))
  timestamps_mjd <- as.numeric(readLines(mjd_file))
  
  # z-normalize the vector
  z_instances <- (instances - mean(instances)) / sd(instances)
  
  
  # Calculate the time from peak for each timestamp (second)
  time_from_peak <- (timestamps_mjd - peak_time_mjd) * 86400
  
  # Combine all the data into a new dataframe
  temp_df <- data.frame(file_name, peak_time_mjd, instances, z_instances, 
                        timestamps_mjd, time_from_peak)
  
  # Append the new dataframe to the list
  list_of_dfs <- c(list_of_dfs, list(temp_df))
}
