#' @title Calculate distances between GPS track points
#' @description
#' Calculates the distance between consecutive GPS track points and adds both individual segment
#' distances and cumulative distance to the track points data frame.
#' 
#' @param track_points A data frame containing track points with at least the following columns:
#' \itemize{
#'   \item lon - longitude in decimal degrees
#'   \item lat - latitude in decimal degrees
#' }
#'
#' @return The input data frame with the following additional columns:
#' \itemize{
#'   \item distance - distance to previous point in meters (0 for the first point)
#'   \item cumulative_distance - cumulative distance traveled in kilometers
#' }
#'
#' @details
#' This function uses the Haversine formula to calculate the great-circle distance between
#' consecutive GPS points, accounting for the curvature of the Earth. The first point has
#' a distance of 0, and each subsequent point's distance is measured from the previous point.
#' 
#' @examples
#' \dontrun{
#' # First read a GPX file
#' track_data <- read_gpx_track("path/to/activity.gpx")
#' 
#' # Calculate distances
#' track_data <- calculate_distance(track_data)
#' 
#' # View the distance data
#' head(track_data[, c("lon", "lat", "distance", "cumulative_distance")])
#' }
#' 
#' @importFrom dplyr %>% select
#' @importFrom geosphere distHaversine
#' 
#' @export
calculate_distance <- function(track_points) {
  coords <- track_points %>% select(lon, lat)
  
  # Calculate distance between consecutive points (in meters)
  distances <- c(0, distHaversine(as.matrix(coords[-nrow(coords), ]), 
                                 as.matrix(coords[-1, ])))
  
  track_points$distance <- distances
  track_points$cumulative_distance <- cumsum(distances) / 1000  # Convert to km
  
  return(track_points)
}