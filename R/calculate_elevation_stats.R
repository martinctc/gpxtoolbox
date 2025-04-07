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
#' Positive changes are recorded as elevation gain, while negative changes are recorded as elevation loss.
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
  # Calculate elevation change between consecutive points
  ele_diff <- c(0, diff(track_points$ele))
  
  # Separate positive (gain) and negative (loss) elevation changes
  track_points$ele_gain <- ifelse(ele_diff > 0, ele_diff, 0)
  track_points$ele_loss <- ifelse(ele_diff < 0, -ele_diff, 0)
  track_points$cumulative_ele_gain <- cumsum(track_points$ele_gain)
  track_points$cumulative_ele_loss <- cumsum(track_points$ele_loss)
  
  return(track_points)
}