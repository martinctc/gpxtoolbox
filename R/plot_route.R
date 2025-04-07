#' @title Plot GPX route visualization
#' @description
#' Creates visualizations of a GPS route, including an elevation profile and a route map.
#' 
#' @param track_points A data frame containing track points with the following required columns:
#' \itemize{
#'   \item lon - longitude in decimal degrees
#'   \item lat - latitude in decimal degrees
#'   \item ele - elevation in meters
#'   \item cumulative_distance - distance in kilometers
#' }
#'
#' @return Plots are displayed in the current graphics device. The function does not return a value.
#'
#' @details
#' This function creates two visualizations:
#' \itemize{
#'   \item An elevation profile showing elevation changes against distance traveled
#'   \item A simple route map showing the geographical path
#' }
#' Both plots are created using ggplot2 with minimal styling.
#' 
#' @examples
#' \dontrun{
#' # First read a GPX file
#' track_data <- read_gpx_track("path/to/activity.gpx")
#' 
#' # Calculate cumulative distance (required for plotting)
#' track_data <- calculate_distance(track_data)
#' 
#' # Plot the route visualizations
#' plot_route(track_data)
#' }
#' 
#' @importFrom ggplot2 ggplot aes geom_line geom_path labs theme_minimal coord_quickmap
#' 
#' @export
plot_route <- function(track_points) {
  # Plot elevation profile
  elevation_plot <- ggplot(track_points, aes(x = cumulative_distance, y = ele)) +
    geom_line() +
    labs(x = "Distance (km)", y = "Elevation (m)", title = "Elevation Profile") +
    theme_minimal()
  
  # Plot route on map (simplified)
  route_plot <- ggplot(track_points, aes(x = lon, y = lat)) +
    geom_path() +
    labs(x = "Longitude", y = "Latitude", title = "Route Map") +
    theme_minimal() +
    coord_quickmap()
  
  # Print both plots
  print(elevation_plot)
  print(route_plot)
}
