#' @title Calculate route statistics
#' @description
#' Calculates basic statistics from GPS track data, including distance, elevation, and time metrics.
#' 
#' @param track_points A data frame containing track points with the following required columns:
#' \itemize{
#'   \item cumulative_distance - distance in kilometers
#'   \item ele - elevation in meters
#'   \item ele_gain - elevation gain in meters
#'   \item ele_loss - elevation loss in meters
#'   \item time - timestamps in POSIXct format (optional, for time-based calculations)
#'   \item location - (optional) geographic location of points (e.g., "City, Country")
#' }
#'
#' @return A list containing the following route statistics:
#' \itemize{
#'   \item total_distance_km - total distance in kilometers
#'   \item total_elevation_gain_m - cumulative elevation gain in meters
#'   \item total_elevation_loss_m - cumulative elevation loss in meters
#'   \item max_elevation_m - maximum elevation in meters
#'   \item min_elevation_m - minimum elevation in meters
#'   \item total_time_hours - total activity time in hours (if time data available)
#'   \item avg_speed - average speed in km/h (if time data available)
#'   \item start_point - (optional) location of the starting point
#'   \item end_point - (optional) location of the ending point
#'   \item p25_point - (optional) location at 25% of the route
#'   \item p50_point - (optional) location at 50% of the route
#'   \item p75_point - (optional) location at 75% of the route
#' }
#'
#' @details
#' This function processes track point data to extract key statistics about a GPS route.
#' Time-based statistics are only calculated if the input data contains valid timestamps.
#' All numeric values are rounded to 2 decimal places for readability.
#' 
#' @examples
#' \dontrun{
#' # First read a GPX file
#' track_data <- read_gpx_track("path/to/activity.gpx")
#' 
#' # Calculate distance and elevation changes
#' track_data <- calculate_distance(track_data)
#' 
#' # Calculate route statistics
#' stats <- calculate_route_stats(track_data)
#' 
#' # Print the statistics
#' print(stats)
#' }
#' 
#' @export
calculate_route_stats <- function(track_points) {
  # Only calculate time-based stats if time data is present
  time_stats <- list()
  if (!all(is.na(track_points$time))) {
    total_time_sec <- as.numeric(difftime(max(track_points$time, na.rm = TRUE), 
                                         min(track_points$time, na.rm = TRUE), 
                                         units = "secs"))
    time_stats <- list(
      total_time_hours = round(total_time_sec / 3600, 2),
      avg_speed = round(max(track_points$cumulative_distance, na.rm = TRUE) / 
                         (total_time_sec / 3600), 2)
    )
  }
  
  # Basic stats
  stats <- c(
    list(
      total_distance_km = round(max(track_points$cumulative_distance, na.rm = TRUE), 2),
      total_elevation_gain_m = round(sum(track_points$ele_gain, na.rm = TRUE), 2),
      total_elevation_loss_m = round(sum(track_points$ele_loss, na.rm = TRUE), 2),
      max_elevation_m = round(max(track_points$ele, na.rm = TRUE), 2),
      min_elevation_m = round(min(track_points$ele, na.rm = TRUE), 2)
    ),
    time_stats
  )
  
  # Add start, end, and key points if 'location' column exists
  if ("location" %in% colnames(track_points)) {
    n <- nrow(track_points)
    stats <- c(stats, list(
      start_point = track_points$location[1],
      end_point = track_points$location[n],
      p25_point = track_points$location[floor(n * 0.25)],
      p50_point = track_points$location[floor(n * 0.5)],
      p75_point = track_points$location[floor(n * 0.75)]
    ))
  }
  
  return(stats)
}