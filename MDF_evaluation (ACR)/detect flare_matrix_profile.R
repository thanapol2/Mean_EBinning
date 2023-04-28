library(tsmp)

# Define constants
index_file <- 1
WINDOW_SIZE <- 100
top_discords <- 1

# Extract data from the list of dataframes
temp_df <- data.frame(list_of_dfs[index_file][1])


mp <- tsmp(temp_df$z_instances, window_size = WINDOW_SIZE, verbose = 0)
discords_data <- discords(mp)

# get top discord
top_discord_index = discords_data$discord$discord_idx[top_discords][[1]]
# Plot the data
plot(x = temp_df$time_from_peak, y = temp_df$z_instances, type = "l",
     xlab = "Time from flare peak (sec)",
     ylab = "flux",
     col = "black", main = temp_df$file_name[1])

# Add a vertical line at time peak
abline(v = 0, col = "blue", lwd = 1, lty = 2)

# Add a red line for the discord region
lines(x = c(temp_df$time_from_peak[top_discord_index:(top_discord_index + WINDOW_SIZE)]),
      y = temp_df$z_instances[temp_df$time_from_peak[top_discord_index:(top_discord_index + WINDOW_SIZE)]],
      col = "red")

