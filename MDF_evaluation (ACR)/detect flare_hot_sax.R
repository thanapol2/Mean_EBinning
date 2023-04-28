# Load necessary libraries
library(jmotif)
library(profvis)

# Define constants
index_file <- 1
top_discords <- 1
SYMBOLS_SIZE <- 7
BIN_SIZE <- 20
WINDOW_SIZE <- 100
true_postive <- 0

# Extract data from the list of dataframes
temp_df <- data.frame(list_of_dfs[index_file][1])

## HOT-SAX
# Find discords using HOT-SAX algorithm
discords = find_discords_hotsax(temp_df$z_instances, WINDOW_SIZE, BIN_SIZE, SYMBOLS_SIZE,
                                0.01, 10)

# Plot the data
plot(x = temp_df$time_from_peak, y = temp_df$z_instances, type = "l",
     xlab = "Time from flare peak (sec)",
     ylab = "flux",
     col = "black", main = temp_df$file_name[1])

# Add a vertical line at time peak
abline(v = 0, col = "blue", lwd = 1, lty = 2)

# Add a red line for the discord region
lines(x = c(temp_df$time_from_peak[discords[top_discords, 2]:(discords[top_discords, 2] + WINDOW_SIZE)]),
      y = temp_df$z_instances[discords[top_discords, 2]:(discords[top_discords, 2] + WINDOW_SIZE)],
      col = "red")

# Calculate true positive or false negative
alarm_timestamps <- temp_df$time_from_peak[discords[top_discords, 2]:(discords[top_discords, 2] + WINDOW_SIZE)]
print((alarm_timestamps[1] < 0) & (0 < alarm_timestamps[length(alarm_timestamps)]))
