#' @title Calculate elevation statistics from GPS track points
#' @description
#' Calculates elevation gain and loss between consecutive GPS track points and
#' adds these metrics to the track points data frame.
#' 
#' @param track_points A data frame containing track points with at least the following column:
#' \itemize{
#'   \item ele - elevation in meters
#' }
#'
#' @return The input data frame with the following additional columns:
#' \itemize{
#'   \item ele_gain - elevation gain in meters (0 for flat or downhill segments)
#'   \item ele_loss - elevation loss in meters (0 for flat or uphill segments)
#'   \item cumulative_ele_gain - cumulative elevation gain in meters
#'   \item cumulative_ele_loss - cumulative elevation loss in meters
#' }
#'
#' @details
#' This function calculates the elevation difference between consecutive points.
#' To improve accuracy, it first removes duplicate trackpoints with identical coordinates
#' to reduce over-counting from GPS measurement noise. Positive changes are recorded 
#' as elevation gain, while negative changes are recorded as elevation loss.
#' The function also calculates cumulative metrics to track total elevation change over the entire route.
#' 
#' @examples
#' \dontrun{
#' # First read a GPX file
#' track_data <- read_gpx_track("path/to/activity.gpx")
#' 
#' # Calculate elevation statistics
#' track_data <- calculate_elevation_stats(track_data)
#' 
#' # View the elevation data
#' head(track_data[, c("ele", "ele_gain", "ele_loss", "cumulative_ele_gain")])
#' }
#' 
#' @export
calculate_elevation_stats <- function(track_points) {
  # Remove duplicate trackpoints with identical coordinates to reduce GPS noise
  # This helps avoid over-counting elevation changes from GPS measurement errors
  duplicate_coords <- duplicated(track_points[, c("lat", "lon")])
  clean_track_points <- track_points[!duplicate_coords, ]
  
  # Calculate elevation change between consecutive points using cleaned data
  ele_diff <- c(0, diff(clean_track_points$ele))
  
  # Separate positive (gain) and negative (loss) elevation changes
  clean_track_points$ele_gain <- ifelse(ele_diff > 0, ele_diff, 0)
  clean_track_points$ele_loss <- ifelse(ele_diff < 0, -ele_diff, 0)
  clean_track_points$cumulative_ele_gain <- cumsum(clean_track_points$ele_gain)
  clean_track_points$cumulative_ele_loss <- cumsum(clean_track_points$ele_loss)
  
  # Map the elevation stats back to the original track_points dataframe
  # Initialize all elevation stats to 0 for original dataframe
  track_points$ele_gain <- 0
  track_points$ele_loss <- 0
  track_points$cumulative_ele_gain <- 0
  track_points$cumulative_ele_loss <- 0
  
  # Update stats for non-duplicate points
  track_points[!duplicate_coords, c("ele_gain", "ele_loss", "cumulative_ele_gain", "cumulative_ele_loss")] <- 
    clean_track_points[, c("ele_gain", "ele_loss", "cumulative_ele_gain", "cumulative_ele_loss")]
  
  # Forward-fill cumulative values for duplicate points
  if (any(duplicate_coords)) {
    for (i in 2:nrow(track_points)) {
      if (duplicate_coords[i]) {
        track_points$cumulative_ele_gain[i] <- track_points$cumulative_ele_gain[i-1]
        track_points$cumulative_ele_loss[i] <- track_points$cumulative_ele_loss[i-1]
      }
    }
  }
  
  return(track_points)
}